# flutter_cupertino_data_picker

flutter cupertino data_picker.

## Getting Started

![Screenshot](screenshots/demo.png)

## Usage

```  
void _showDataPicker() {
       final bool showTitleActions = true;
       DataPicker.showDatePicker(
         context,
         showTitleActions: showTitleActions,
         locale: 'zh',
         datas: ['男', '女'],
         title: '选择性别',
         onChanged: (data) {
           print('onChanged date: $data');
         },
         onConfirm: (data) {
           print('onConfirm date: $data');
         },
       );
     }
```


Fork by https://github.com/wuzhendev/flutter-cupertino-date-picker
