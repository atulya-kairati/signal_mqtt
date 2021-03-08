import 'package:flutter/material.dart';
import 'package:signal_final/widgets/custom_textfield.dart';
import 'package:toast/toast.dart';
import 'package:signal_final/models/contants_and_utils.dart';
import 'package:provider/provider.dart';
import 'package:signal_final/models/app_state.dart';
import 'package:signal_final/widgets/my_icon_picker.dart';
import 'package:signal_final/widgets/color_picker.dart';

class WidgetInfoForm extends StatelessWidget {
  const WidgetInfoForm({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Signal MQTT'),
        ),
        body: Container(
          margin: EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: getForm(ModalRoute.of(context).settings.arguments),
          ),
        ),
      ),
    );
  }

  Widget getForm(Map data) {
    //data = [id, bindex]
    String id = data['id'];
    switch (id) {
      case kSingleValueButtonId:
        return SingleValueButtonForm(
          bindex: data['bindex'],
          windex: data['windex'],
        );

      case kDoubleValueButtonId:
        return DoubleValueButtonForm(
            bindex: data['bindex'], windex: data['windex']);

      case kIconButtonId:
        return IconButtonForm(bindex: data['bindex'], windex: data['windex']);

      case kTextTerminalId:
        return TextTerminalForm(bindex: data['bindex'], windex: data['windex']);

      case kGuageId:
        return GuageForm(bindex: data['bindex'], windex: data['windex']);

      case kGraphId:
        return GraphForm(bindex: data['bindex'], windex: data['windex']);

      case kBarGraphId:
        return BarGraphForm(bindex: data['bindex'], windex: data['windex']);

      case kPictureFrame:
        return PictureFrameForm(bindex: data['bindex'], windex: data['windex']);

      default:
        return Text('Form not found');
    }
  }
}

class PictureFrameForm extends StatelessWidget {
  PictureFrameForm({Key key, @required int bindex, this.windex})
      : bindex = bindex,
        super(key: key);

  final int bindex, windex;
  final TextEditingController nameTextController = TextEditingController();
  // final TextEditingController minValueTextController = TextEditingController();
  // final TextEditingController maxValueTextController = TextEditingController();
  final TextEditingController topicTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String colorCode = getColorRGB(Theme.of(context).buttonColor);
    if (windex != null) {
      var tempData = Provider.of<AppState>(context, listen: false)
          .getWidgetData(bindex)[windex];
      nameTextController.text = tempData['name'];
      topicTextController.text = tempData['topic'];
      colorCode = tempData['color'];
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CustomTextField(
          onChanged: (text) {},
          controller: nameTextController,
          hintText: 'Enter Widget Name',
        ),
        // Row(
        //   children: [
        //     Expanded(
        //       child: CustomTextField(
        //         onChanged: (text) {},
        //         controller: minValueTextController,
        //         hintText: 'Minimum value',
        //       ),
        //     ),
        //     SizedBox(width: 4),
        //     Expanded(
        //       child: CustomTextField(
        //         onChanged: (text) {},
        //         controller: maxValueTextController,
        //         hintText: 'Maximum value',
        //       ),
        //     ),
        //   ],
        // ),
        CustomTextField(
          onChanged: (text) {},
          controller: topicTextController,
          hintText: 'Enter Topic',
        ),
        MyColorPicker(
          initColor: Color.fromARGB(
            255,
            int.parse(colorCode.split(',')[0]),
            int.parse(colorCode.split(',')[1]),
            int.parse(colorCode.split(',')[2]),
          ),
          onColorSelection: (String name) {
            colorCode = name;
            print(name.split(','));
          },
        ),
        SizedBox(height: 24),
        RaisedButton(
          padding: EdgeInsets.symmetric(vertical: 16),
          onPressed: () {
            if (nameTextController.text.isEmpty ||
                topicTextController.text.isEmpty) {
              Toast.show(
                "Fill the required values",
                context,
                duration: Toast.LENGTH_SHORT,
                gravity: Toast.TOP,
              );
              return;
            }

            // if (double.tryParse(minValueTextController.text) == null ||
            //     double.tryParse(maxValueTextController.text) == null) {
            //   Toast.show(
            //     "Maximum and Minimum should be numeric",
            //     context,
            //     duration: Toast.LENGTH_SHORT,
            //     gravity: Toast.TOP,
            //   );
            //   return;
            // }

            // if (double.tryParse(minValueTextController.text) >=
            //     double.tryParse(maxValueTextController.text)) {
            //   Toast.show(
            //     "Maximum should be greater than Minimum",
            //     context,
            //     duration: Toast.LENGTH_SHORT,
            //     gravity: Toast.TOP,
            //   );
            //   return;
            // }

            var data = {
              'id': kPictureFrame,
              'name': nameTextController.text,
              'topic': topicTextController.text,
              'color': colorCode,
            };
            print('>> $data');
            print('>> $bindex, $windex');
            Provider.of<AppState>(context, listen: false)
                .updateAllWidgetData(data, bindex: bindex, windex: windex);

            Navigator.pop(context);
          },
          child: Text('Save'),
        )
      ],
    );
  }
}

class BarGraphForm extends StatelessWidget {
  BarGraphForm({Key key, @required int bindex, this.windex})
      : bindex = bindex,
        super(key: key);

  final int bindex, windex;
  final TextEditingController nameTextController = TextEditingController();
  // final TextEditingController minValueTextController = TextEditingController();
  // final TextEditingController maxValueTextController = TextEditingController();
  final TextEditingController topicTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String colorCode = getColorRGB(Theme.of(context).buttonColor);
    if (windex != null) {
      var tempData = Provider.of<AppState>(context, listen: false)
          .getWidgetData(bindex)[windex];
      nameTextController.text = tempData['name'];
      topicTextController.text = tempData['topic'];
      colorCode = tempData['color'];
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CustomTextField(
          onChanged: (text) {},
          controller: nameTextController,
          hintText: 'Enter Widget Name',
        ),
        CustomTextField(
          onChanged: (text) {},
          controller: topicTextController,
          hintText: 'Enter Topic',
        ),
        MyColorPicker(
          initColor: Color.fromARGB(
            255,
            int.parse(colorCode.split(',')[0]),
            int.parse(colorCode.split(',')[1]),
            int.parse(colorCode.split(',')[2]),
          ),
          onColorSelection: (String name) {
            colorCode = name;
            print(name.split(','));
          },
        ),
        SizedBox(height: 24),
        RaisedButton(
          padding: EdgeInsets.symmetric(vertical: 16),
          onPressed: () {
            if (nameTextController.text.isEmpty ||
                topicTextController.text.isEmpty) {
              Toast.show(
                "Fill the required values",
                context,
                duration: Toast.LENGTH_SHORT,
                gravity: Toast.TOP,
              );
              return;
            }

            var data = {
              'id': kBarGraphId,
              'name': nameTextController.text,
              'topic': topicTextController.text,
              'color': colorCode,
            };

            print('>> $data');
            print('>> $bindex, $windex');

            Provider.of<AppState>(context, listen: false)
                .updateAllWidgetData(data, bindex: bindex, windex: windex);

            Navigator.pop(context);
          },
          child: Text('Save'),
        )
      ],
    );
  }
}

class GraphForm extends StatelessWidget {
  GraphForm({Key key, @required int bindex, this.windex})
      : bindex = bindex,
        super(key: key);

  final int bindex, windex;
  final TextEditingController nameTextController = TextEditingController();
  // final TextEditingController minValueTextController = TextEditingController();
  // final TextEditingController maxValueTextController = TextEditingController();
  final TextEditingController topicTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String colorCode = getColorRGB(Theme.of(context).buttonColor);
    if (windex != null) {
      var tempData = Provider.of<AppState>(context, listen: false)
          .getWidgetData(bindex)[windex];
      nameTextController.text = tempData['name'];
      topicTextController.text = tempData['topic'];
      colorCode = tempData['color'];
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CustomTextField(
          onChanged: (text) {},
          controller: nameTextController,
          hintText: 'Enter Widget Name',
        ),
        // Row(
        //   children: [
        //     Expanded(
        //       child: CustomTextField(
        //         onChanged: (text) {},
        //         controller: minValueTextController,
        //         hintText: 'Minimum value',
        //       ),
        //     ),
        //     SizedBox(width: 4),
        //     Expanded(
        //       child: CustomTextField(
        //         onChanged: (text) {},
        //         controller: maxValueTextController,
        //         hintText: 'Maximum value',
        //       ),
        //     ),
        //   ],
        // ),
        CustomTextField(
          onChanged: (text) {},
          controller: topicTextController,
          hintText: 'Enter Topic',
        ),
        MyColorPicker(
          initColor: Color.fromARGB(
            255,
            int.parse(colorCode.split(',')[0]),
            int.parse(colorCode.split(',')[1]),
            int.parse(colorCode.split(',')[2]),
          ),
          onColorSelection: (String name) {
            colorCode = name;
            print(name.split(','));
          },
        ),
        SizedBox(height: 24),
        RaisedButton(
          padding: EdgeInsets.symmetric(vertical: 16),
          onPressed: () {
            if (nameTextController.text.isEmpty ||
                topicTextController.text.isEmpty) {
              Toast.show(
                "Fill the required values",
                context,
                duration: Toast.LENGTH_SHORT,
                gravity: Toast.TOP,
              );
              return;
            }

            // if (double.tryParse(minValueTextController.text) == null ||
            //     double.tryParse(maxValueTextController.text) == null) {
            //   Toast.show(
            //     "Maximum and Minimum should be numeric",
            //     context,
            //     duration: Toast.LENGTH_SHORT,
            //     gravity: Toast.TOP,
            //   );
            //   return;
            // }

            // if (double.tryParse(minValueTextController.text) >=
            //     double.tryParse(maxValueTextController.text)) {
            //   Toast.show(
            //     "Maximum should be greater than Minimum",
            //     context,
            //     duration: Toast.LENGTH_SHORT,
            //     gravity: Toast.TOP,
            //   );
            //   return;
            // }

            var data = {
              'id': kGraphId,
              'name': nameTextController.text,
              'topic': topicTextController.text,
              'color': colorCode,
            };

            Provider.of<AppState>(context, listen: false)
                .updateAllWidgetData(data, bindex: bindex, windex: windex);

            Navigator.pop(context);
          },
          child: Text('Save'),
        )
      ],
    );
  }
}

// TODO: make it impossible to edit topic in forms

class GuageForm extends StatelessWidget {
  GuageForm({Key key, @required int bindex, this.windex})
      : bindex = bindex,
        super(key: key);

  final int bindex, windex;
  final TextEditingController nameTextController = TextEditingController();
  final TextEditingController minValueTextController = TextEditingController();
  final TextEditingController maxValueTextController = TextEditingController();
  final TextEditingController topicTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String colorCode = getColorRGB(Theme.of(context).buttonColor);
    if (windex != null) {
      var tempData = Provider.of<AppState>(context, listen: false)
          .getWidgetData(bindex)[windex];
      nameTextController.text = tempData['name'];
      minValueTextController.text = tempData['min'];
      maxValueTextController.text = tempData['max'];
      topicTextController.text = tempData['topic'];
      colorCode = tempData['color'];
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CustomTextField(
          onChanged: (text) {},
          controller: nameTextController,
          hintText: 'Enter Widget Name',
        ),
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                onChanged: (text) {},
                controller: minValueTextController,
                hintText: 'Minimum value',
              ),
            ),
            SizedBox(width: 4),
            Expanded(
              child: CustomTextField(
                onChanged: (text) {},
                controller: maxValueTextController,
                hintText: 'Maximum value',
              ),
            ),
          ],
        ),
        CustomTextField(
          onChanged: (text) {},
          controller: topicTextController,
          hintText: 'Enter Topic',
        ),
        MyColorPicker(
          initColor: Color.fromARGB(
            255,
            int.parse(colorCode.split(',')[0]),
            int.parse(colorCode.split(',')[1]),
            int.parse(colorCode.split(',')[2]),
          ),
          onColorSelection: (String name) {
            colorCode = name;
            print(name.split(','));
          },
        ),
        SizedBox(height: 24),
        RaisedButton(
          padding: EdgeInsets.symmetric(vertical: 16),
          onPressed: () {
            if (nameTextController.text.isEmpty ||
                minValueTextController.text.isEmpty ||
                maxValueTextController.text.isEmpty ||
                topicTextController.text.isEmpty) {
              Toast.show(
                "Fill the required values",
                context,
                duration: Toast.LENGTH_SHORT,
                gravity: Toast.TOP,
              );
              return;
            }

            if (double.tryParse(minValueTextController.text) == null ||
                double.tryParse(maxValueTextController.text) == null) {
              Toast.show(
                "Maximum and Minimum should be numeric",
                context,
                duration: Toast.LENGTH_SHORT,
                gravity: Toast.TOP,
              );
              return;
            }

            if (double.tryParse(minValueTextController.text) >=
                double.tryParse(maxValueTextController.text)) {
              Toast.show(
                "Maximum should be greater than Minimum",
                context,
                duration: Toast.LENGTH_SHORT,
                gravity: Toast.TOP,
              );
              return;
            }

            var data = {
              'id': kGuageId,
              'name': nameTextController.text,
              'min': minValueTextController.text,
              'max': maxValueTextController.text,
              'topic': topicTextController.text,
              'color': colorCode,
            };

            Provider.of<AppState>(context, listen: false)
                .updateAllWidgetData(data, bindex: bindex, windex: windex);

            Navigator.pop(context);
          },
          child: Text('Save'),
        )
      ],
    );
  }
}

class IconButtonForm extends StatelessWidget {
  IconButtonForm({Key key, @required int bindex, this.windex})
      : bindex = bindex,
        super(key: key);

  final int bindex, windex;
  final TextEditingController nameTextController = TextEditingController();
  final TextEditingController valueTextController = TextEditingController();
  final TextEditingController topicTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String iconName;
    String colorCode = getColorRGB(Theme.of(context).buttonColor);
    if (windex != null) {
      var tempData = Provider.of<AppState>(context, listen: false)
          .getWidgetData(bindex)[windex];
      nameTextController.text = tempData['name'];
      valueTextController.text = tempData['value'];
      topicTextController.text = tempData['topic'];
      iconName = tempData['icon'];
      colorCode = tempData['color'];
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CustomTextField(
          onChanged: (text) {},
          controller: nameTextController,
          hintText: 'Enter Widget Name',
        ),
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                onChanged: (text) {},
                controller: valueTextController,
                hintText: 'Value',
              ),
            ),
            SizedBox(width: 4),
            Expanded(
              child: MyIconPicker(
                onIconSelection: (name) {
                  iconName = name;
                },
              ),
            ),
          ],
        ),
        CustomTextField(
          onChanged: (text) {},
          controller: topicTextController,
          hintText: 'Enter Topic',
        ),
        MyColorPicker(
          initColor: Color.fromARGB(
            255,
            int.parse(colorCode.split(',')[0]),
            int.parse(colorCode.split(',')[1]),
            int.parse(colorCode.split(',')[2]),
          ),
          onColorSelection: (String name) {
            colorCode = name;
            print(name.split(','));
          },
        ),
        SizedBox(height: 24),
        RaisedButton(
          padding: EdgeInsets.symmetric(vertical: 16),
          onPressed: () {
            if (nameTextController.text.isEmpty ||
                valueTextController.text.isEmpty ||
                topicTextController.text.isEmpty) {
              Toast.show(
                "Fill the required values",
                context,
                duration: Toast.LENGTH_SHORT,
                gravity: Toast.TOP,
              );
              return;
            }

            if (iconName == null) {
              Toast.show(
                "Select the Icon",
                context,
                duration: Toast.LENGTH_SHORT,
                gravity: Toast.TOP,
              );
              return;
            }

            var data = {
              'id': kIconButtonId,
              'name': nameTextController.text,
              'value': valueTextController.text,
              'topic': topicTextController.text,
              'icon': iconName,
              'color': colorCode,
            };

            Provider.of<AppState>(context, listen: false)
                .updateAllWidgetData(data, bindex: bindex, windex: windex);

            Navigator.pop(context);
          },
          child: Text('Save'),
        )
      ],
    );
  }
}

class TextTerminalForm extends StatelessWidget {
  TextTerminalForm({Key key, @required int bindex, this.windex})
      : bindex = bindex,
        super(key: key);

  final int bindex, windex;
  final TextEditingController nameTextController = TextEditingController();
  final TextEditingController topicTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String colorCode = getColorRGB(Theme.of(context).buttonColor);
    if (windex != null) {
      var tempData = Provider.of<AppState>(context, listen: false)
          .getWidgetData(bindex)[windex];
      nameTextController.text = tempData['name'];
      topicTextController.text = tempData['topic'];
      colorCode = tempData['color'];
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CustomTextField(
          onChanged: (text) {},
          controller: nameTextController,
          hintText: 'Enter Widget Name',
        ),
        CustomTextField(
          onChanged: (text) {},
          controller: topicTextController,
          hintText: 'Enter Topic',
        ),
        MyColorPicker(
          initColor: Color.fromARGB(
            255,
            int.parse(colorCode.split(',')[0]),
            int.parse(colorCode.split(',')[1]),
            int.parse(colorCode.split(',')[2]),
          ),
          onColorSelection: (String name) {
            colorCode = name;
            print(name.split(','));
          },
        ),
        SizedBox(height: 24),
        RaisedButton(
          padding: EdgeInsets.symmetric(vertical: 16),
          onPressed: () {
            if (nameTextController.text.isEmpty ||
                topicTextController.text.isEmpty) {
              Toast.show(
                "Fill the required values",
                context,
                duration: Toast.LENGTH_SHORT,
                gravity: Toast.TOP,
              );
              return;
            }

            var data = {
              'id': kTextTerminalId,
              'name': nameTextController.text,
              'topic': topicTextController.text,
              'color': colorCode,
            };
            Provider.of<AppState>(context, listen: false)
                .updateAllWidgetData(data, bindex: bindex, windex: windex);

            Navigator.pop(context);
          },
          child: Text('Save'),
        )
      ],
    );
  }
}

class DoubleValueButtonForm extends StatelessWidget {
  DoubleValueButtonForm({Key key, @required int bindex, this.windex})
      : bindex = bindex,
        super(key: key);

  final int bindex, windex;
  final TextEditingController nameTextController = TextEditingController();
  final TextEditingController onValueTextController = TextEditingController();
  final TextEditingController offValueTextController = TextEditingController();
  final TextEditingController topicTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String colorCode = getColorRGB(Theme.of(context).buttonColor);
    if (windex != null) {
      var tempData = Provider.of<AppState>(context, listen: false)
          .getWidgetData(bindex)[windex];
      nameTextController.text = tempData['name'];
      onValueTextController.text = tempData['onValue'];
      offValueTextController.text = tempData['offValue'];
      topicTextController.text = tempData['topic'];
      colorCode = tempData['color'];
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CustomTextField(
          onChanged: (text) {},
          controller: nameTextController,
          hintText: 'Enter Widget Name',
        ),
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                onChanged: (text) {},
                controller: offValueTextController,
                hintText: 'OFF value',
              ),
            ),
            SizedBox(width: 4),
            Expanded(
              child: CustomTextField(
                onChanged: (text) {},
                controller: onValueTextController,
                hintText: 'ON value',
              ),
            ),
          ],
        ),
        CustomTextField(
          onChanged: (text) {},
          controller: topicTextController,
          hintText: 'Enter Topic',
        ),
        MyColorPicker(
          initColor: Color.fromARGB(
            255,
            int.parse(colorCode.split(',')[0]),
            int.parse(colorCode.split(',')[1]),
            int.parse(colorCode.split(',')[2]),
          ),
          onColorSelection: (String name) {
            colorCode = name;
            print(name.split(','));
          },
        ),
        SizedBox(height: 24),
        RaisedButton(
          padding: EdgeInsets.symmetric(vertical: 16),
          onPressed: () {
            if (nameTextController.text.isEmpty ||
                onValueTextController.text.isEmpty ||
                offValueTextController.text.isEmpty ||
                topicTextController.text.isEmpty) {
              Toast.show(
                "Fill the required values",
                context,
                duration: Toast.LENGTH_SHORT,
                gravity: Toast.TOP,
              );
              return;
            }

            var data = {
              'id': kDoubleValueButtonId,
              'name': nameTextController.text,
              'onValue': onValueTextController.text,
              'offValue': offValueTextController.text,
              'topic': topicTextController.text,
              'color': colorCode,
            };

            Provider.of<AppState>(context, listen: false)
                .updateAllWidgetData(data, bindex: bindex, windex: windex);

            Navigator.pop(context);
          },
          child: Text('Save'),
        )
      ],
    );
  }
}

class SingleValueButtonForm extends StatelessWidget {
  SingleValueButtonForm({Key key, @required int bindex, this.windex})
      : bindex = bindex,
        super(key: key);

  final int bindex, windex;
  final TextEditingController nameTextController = TextEditingController();
  final TextEditingController valueTextController = TextEditingController();
  final TextEditingController topicTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String colorCode = getColorRGB(Theme.of(context).buttonColor);
    if (windex != null) {
      var tempData = Provider.of<AppState>(context, listen: false)
          .getWidgetData(bindex)[windex];
      nameTextController.text = tempData['name'];
      valueTextController.text = tempData['value'];
      topicTextController.text = tempData['topic'];
      colorCode = tempData['color'];
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CustomTextField(
          onChanged: (text) {},
          controller: nameTextController,
          hintText: 'Enter Widget Name',
        ),
        CustomTextField(
          onChanged: (text) {},
          controller: valueTextController,
          hintText: 'Enter Value',
        ),
        CustomTextField(
          onChanged: (text) {},
          controller: topicTextController,
          hintText: 'Enter Topic',
        ),
        MyColorPicker(
          initColor: Color.fromARGB(
            255,
            int.parse(colorCode.split(',')[0]),
            int.parse(colorCode.split(',')[1]),
            int.parse(colorCode.split(',')[2]),
          ),
          onColorSelection: (String name) {
            colorCode = name;
            print(name.split(','));
          },
        ),
        SizedBox(height: 24),
        RaisedButton(
          padding: EdgeInsets.symmetric(vertical: 16),
          onPressed: () {
            if (nameTextController.text.isEmpty ||
                valueTextController.text.isEmpty ||
                topicTextController.text.isEmpty) {
              Toast.show(
                "Fill the required values",
                context,
                duration: Toast.LENGTH_SHORT,
                gravity: Toast.TOP,
              );
              return;
            }

            var data = {
              'id': kSingleValueButtonId,
              'name': nameTextController.text,
              'value': valueTextController.text,
              'topic': topicTextController.text,
              'color': colorCode,
            };

            Provider.of<AppState>(context, listen: false)
                .updateAllWidgetData(data, bindex: bindex, windex: windex);

            Navigator.pop(context);
          },
          child: Text('Save'),
        )
      ],
    );
  }
}
