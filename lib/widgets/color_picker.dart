import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:signal_final/models/contants_and_utils.dart';

class MyColorPicker extends StatefulWidget {
  final Null Function(String name) onColorSelection;
  final Color initColor;

  const MyColorPicker(
      {Key key,
      @required this.onColorSelection,
      this.initColor = Colors.blueAccent})
      : super(key: key);

  @override
  _MyColorPickerState createState() => _MyColorPickerState();
}

class _MyColorPickerState extends State<MyColorPicker> {
  Color _mainColor, _tempMainColor;

  @override
  void initState() {
    super.initState();
    _mainColor = widget.initColor;
  }

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: _openMainColorPicker,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Pick Color:'),
          Icon(
            Icons.brightness_1,
            color: _mainColor,
            size: 32,
          ),
        ],
      ),
    );
  }

  void _openMainColorPicker() async {
    openDialog(
      context: context,
      title: "Text Color",
      content: MaterialColorPicker(
        selectedColor: _mainColor,
        allowShades: false,
        colors: fullMaterialColors,
        onMainColorChange: (color) => setState(() => _tempMainColor = color),
      ),
      actionWidgetList: [
        FlatButton(
          child: Text('CANCEL'),
          onPressed: Navigator.of(context).pop,
        ),
        FlatButton(
          child: Text('SUBMIT'),
          onPressed: () {
            widget.onColorSelection(getColorRGB(_tempMainColor));
            Navigator.of(context).pop();
            setState(() => _mainColor = _tempMainColor);
          },
        ),
      ],
    );
  }
}
