import 'package:flutter/material.dart';
import 'package:signal_final/widgets/custom_textfield.dart';
import 'package:signal_final/models/app_state.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

class InfoPage extends StatelessWidget {
  final TextEditingController nameTextController = TextEditingController();
  final TextEditingController hostTextController = TextEditingController();
  final TextEditingController userTextController = TextEditingController();
  final TextEditingController authkeyTextController = TextEditingController();
  final TextEditingController uIDTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    int index = ModalRoute.of(context).settings.arguments ?? -1;
    if (index != -1) {
      nameTextController.text =
          Provider.of<AppState>(context).brokerData[index]['name'];
      hostTextController.text =
          Provider.of<AppState>(context).brokerData[index]['host'];
      userTextController.text =
          Provider.of<AppState>(context).brokerData[index]['username'];
      authkeyTextController.text =
          Provider.of<AppState>(context).brokerData[index]['authKey'];
      uIDTextController.text =
          Provider.of<AppState>(context).brokerData[index]['uID'];
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Fill Information'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CustomTextField(
                hintText: 'Name (required)',
                onChanged: (value) {},
                controller: nameTextController,
              ),
              CustomTextField(
                hintText: 'Host (required)',
                onChanged: (value) {},
                controller: hostTextController,
              ),
              CustomTextField(
                hintText: 'Username(only if required)',
                onChanged: (value) {},
                controller: userTextController,
              ),
              CustomTextField(
                hintText: 'Authentication Key (only if required)',
                onChanged: (value) {},
                controller: authkeyTextController,
              ),
              CustomTextField(
                hintText: 'uID (should be unique)',
                onChanged: (value) {},
                controller: uIDTextController,
              ),
              SizedBox(height: 32),
              RaisedButton(
                padding: EdgeInsets.symmetric(vertical: 16),
                onPressed: () {
                  if (nameTextController.text.isEmpty ||
                      hostTextController.text.isEmpty ||
                      uIDTextController.text.isEmpty) {
                    Toast.show(
                      "Fill the required values",
                      context,
                      duration: Toast.LENGTH_SHORT,
                      gravity: Toast.TOP,
                    );
                    return;
                  }

                  if (Provider.of<AppState>(context, listen: false)
                          .brokerNames
                          .contains(nameTextController.text) &&
                      index == -1) {
                    Toast.show(
                      "Choose diffrent name, Broker with same name is present",
                      context,
                      duration: Toast.LENGTH_LONG,
                      gravity: Toast.TOP,
                    );
                    return;
                  }

                  var data = {
                    'name': nameTextController.text,
                    'host': hostTextController.text,
                    'username': userTextController.text,
                    'authKey': authkeyTextController.text,
                    'uID': uIDTextController.text,
                  };
                  Provider.of<AppState>(context, listen: false)
                      .updateBrokerData(data, index: index);

                  Navigator.pop(context);
                },
                child: Text('Save'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
