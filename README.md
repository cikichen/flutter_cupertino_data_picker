[![pub package](https://img.shields.io/badge/pub-0.8.6-brightgreen.svg)](https://pub.dartlang.org/packages/flutter_cupertino_data_picker)

![flutter_cupertino_data_picker](https://socialify.git.ci/cikichen/flutter_cupertino_data_picker/image?description=1&descriptionEditable=flutter%E6%95%B0%E6%8D%AE%E9%80%89%E6%8B%A9%E5%99%A8&font=Inter&forks=1&language=1&owner=1&pulls=1&stargazers=1&theme=Light)

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
         datas: ['dog', 'cat'],
         title: 'select',
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
  flutter_cupertino_data_picker: ^0.8.6
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
