[![pub package](https://img.shields.io/badge/pub-0.8.1-brightgreen.svg)](https://pub.dartlang.org/packages/flutter_cupertino_data_picker)

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

## Use this package as a library
1. Depend on it
Add this to your package's pubspec.yaml file:

```
dependencies:
  flutter_cupertino_data_picker: ^0.8.1
```

2. Install it
You can install packages from the command line:

with Flutter:

```
$ flutter packages get
```

Alternatively, your editor might support flutter packages get. Check the docs for your editor to learn more.

3. Import it
Now in your Dart code, you can use:

```
import 'package:flutter_cupertino_data_picker/flutter_cupertino_data_picker.dart';
```

Fork by https://github.com/wuzhendev/flutter-cupertino-date-picker
