///
/// author: Simon Chen
/// since: 2018/09/13
/// fork by Dylan Wu
///
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef DateChangedCallback(dynamic data);

const double _kDatePickerHeight = 210.0;
const double _kDatePickerTitleHeight = 44.0;
const double _kDatePickerItemHeight = 36.0;
const double _kDatePickerFontSize = 18.0;

class DataPicker {
  static void showDatePicker(
    BuildContext context, {
    bool showTitleActions: true,
    @required List<dynamic> datas,
    int selectedIndex: 0,
    DateChangedCallback onChanged,
    DateChangedCallback onConfirm,
    prefix: '',
    suffix: '',
    title: '',
    locale: 'zh',
    dataStyle: const TextStyle(color: Color(0xFF000046), fontSize: _kDatePickerFontSize),
  }) {
    Navigator.push(
        context,
        new _DatePickerRoute(
          showTitleActions: showTitleActions,
          initialData: selectedIndex,
          datas: datas,
          onChanged: onChanged,
          onConfirm: onConfirm,
          locale: locale,
          prefix: prefix,
          suffix: suffix,
          title: title,
          theme: Theme.of(context, shadowThemeOnly: true),
          dataStyle: dataStyle,
          barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
        ));
  }
}

class _DatePickerRoute<T> extends PopupRoute<T> {
  _DatePickerRoute({
    this.showTitleActions,
    this.datas,
    this.initialData,
    this.onChanged,
    this.onConfirm,
    this.theme,
    this.barrierLabel,
    this.locale,
    this.prefix,
    this.suffix,
    this.title,
    this.dataStyle,
    RouteSettings settings,
  }) : super(settings: settings);

  final List<dynamic> datas;
  final bool showTitleActions;
  final int initialData;
  final DateChangedCallback onChanged;
  final DateChangedCallback onConfirm;
  final ThemeData theme;
  final String locale;
  final String prefix;
  final String suffix;
  final String title;
  final TextStyle dataStyle;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 200);

  @override
  bool get barrierDismissible => true;

  @override
  final String barrierLabel;

  @override
  Color get barrierColor => Colors.black54;

  AnimationController _animationController;

  @override
  AnimationController createAnimationController() {
    assert(_animationController == null);
    _animationController = BottomSheet.createAnimationController(navigator.overlay);
    return _animationController;
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    Widget bottomSheet = new MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: _DataPickerComponent(
        initialData: initialData,
        datas: datas,
        onChanged: onChanged,
        locale: locale,
        prefix: prefix,
        suffix: suffix,
        title: title,
        dataStyle: dataStyle,
        route: this,
      ),
    );
    if (theme != null) {
      bottomSheet = new Theme(data: theme, child: bottomSheet);
    }
    return bottomSheet;
  }
}

class _DataPickerComponent extends StatefulWidget {
  _DataPickerComponent({
    Key key,
    @required this.route,
    this.initialData: 0,
    this.datas,
    this.onChanged,
    this.locale,
    this.prefix,
    this.suffix,
    this.title,
    this.dataStyle,
  });

  final DateChangedCallback onChanged;
  final int initialData;
  final List<dynamic> datas;

  final _DatePickerRoute route;

  final String locale;
  final String prefix;
  final String suffix;
  final String title;

  final TextStyle dataStyle;

  @override
  State<StatefulWidget> createState() => _DatePickerState(this.initialData);
}

class _DatePickerState extends State<_DataPickerComponent> {
  int _initialIndex;
  int _selectedColorIndex = 0;
  FixedExtentScrollController dataScrollCtrl;

  _DatePickerState(this._initialIndex) {
    if (this._initialIndex < 0) {
      this._initialIndex = 0;
    }
    dataScrollCtrl = new FixedExtentScrollController(initialItem: _selectedColorIndex);
  }

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      child: new AnimatedBuilder(
        animation: widget.route.animation,
        builder: (BuildContext context, Widget child) {
          return new ClipRect(
            child: new CustomSingleChildLayout(
              delegate: new _BottomPickerLayout(widget.route.animation.value, showTitleActions: widget.route.showTitleActions),
              child: new GestureDetector(
                child: Material(
                  color: Colors.transparent,
                  child: _renderPickerView(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _setData(int index) {
    if (_initialIndex != index) {
      _initialIndex = index;
      setState(() {});
      _notifyDateChanged();
    }
  }

  void _notifyDateChanged() {
    if (widget.onChanged != null) {
      widget.onChanged(widget.datas[_initialIndex]);
    }
  }

  Widget _renderPickerView() {
    Widget itemView = _renderItemView();
    if (widget.route.showTitleActions) {
      return Column(
        children: <Widget>[
          _renderTitleActionsView(),
          itemView,
        ],
      );
    }
    return itemView;
  }

  Widget _renderDataPickerComponent(String prefixAppend, String suffixAppend, TextStyle dataStyle) {
    return new Expanded(
      flex: 1,
      child: Container(
          padding: EdgeInsets.all(8.0),
          height: _kDatePickerHeight,
          decoration: BoxDecoration(color: Colors.white),
          child: CupertinoPicker(
            backgroundColor: Colors.white,
            scrollController: dataScrollCtrl,
            itemExtent: _kDatePickerItemHeight,
            onSelectedItemChanged: (int index) {
              _setData(index);
            },
            children: List.generate(widget.datas.length, (int index) {
              return Container(
                height: _kDatePickerItemHeight,
                alignment: Alignment.center,
                child: Row(
                  children: <Widget>[
                    new Expanded(
                        child: Text(
                      '$prefixAppend${widget.datas[index]}$suffixAppend',
                      style: dataStyle,
                      textAlign: TextAlign.center,
                      softWrap: false,
                      overflow: TextOverflow.fade,
                    ))
                  ],
                ),
              );
            }),
          )),
    );
  }

  Widget _renderItemView() {
    return _renderDataPickerComponent(widget.prefix, widget.suffix, widget.dataStyle);
  }

  // Title View
  Widget _renderTitleActionsView() {
    String done = _localeDone();
    String cancel = _localeCancel();

    return Container(
      height: _kDatePickerTitleHeight,
      decoration: BoxDecoration(color: Colors.white),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            height: _kDatePickerTitleHeight,
            child: FlatButton(
              child: Text(
                '$cancel',
                style: TextStyle(
                  color: Theme.of(context).unselectedWidgetColor,
                  fontSize: 16.0,
                ),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          Container(
            alignment: Alignment.center,
            height: _kDatePickerTitleHeight,
            child: Text(
              widget.title,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16.0,
              ),
            ),
          ),
          Container(
            height: _kDatePickerTitleHeight,
            child: FlatButton(
              child: Text(
                '$done',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 16.0,
                ),
              ),
              onPressed: () {
                if (widget.route.onConfirm != null) {
                  widget.route.onConfirm(widget.datas[_initialIndex]);
                }
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  String _localeDone() {
    if (widget.locale == null) {
      return 'Done';
    }

    String lang = widget.locale.split('_').first;

    switch (lang) {
      case 'en':
        return 'Done';
        break;

      case 'zh':
        return '确定';
        break;

      default:
        return '';
        break;
    }
  }

  String _localeCancel() {
    if (widget.locale == null) {
      return 'Cancel';
    }

    String lang = widget.locale.split('_').first;

    switch (lang) {
      case 'en':
        return 'Cancel';
        break;

      case 'zh':
        return '取消';
        break;

      default:
        return '';
        break;
    }
  }
}

class _BottomPickerLayout extends SingleChildLayoutDelegate {
  _BottomPickerLayout(this.progress, {this.itemCount, this.showTitleActions});

  final double progress;
  final int itemCount;
  final bool showTitleActions;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    double maxHeight = _kDatePickerHeight;
    if (showTitleActions) {
      maxHeight += _kDatePickerTitleHeight;
    }

    return new BoxConstraints(minWidth: constraints.maxWidth, maxWidth: constraints.maxWidth, minHeight: 0.0, maxHeight: maxHeight);
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    double height = size.height - childSize.height * progress;
    return new Offset(0.0, height);
  }

  @override
  bool shouldRelayout(_BottomPickerLayout oldDelegate) {
    return progress != oldDelegate.progress;
  }
}
