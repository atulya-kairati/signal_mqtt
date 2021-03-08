import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:provider/provider.dart';
import 'package:signal_final/models/app_state.dart';
import 'package:signal_final/models/contants_and_utils.dart';
import 'package:signal_final/widgets/custom_listTile.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isDarkModeEnabled = true;

  @override
  Widget build(BuildContext context) {
    print(MediaQuery.of(context).size);
    return Scaffold(
      appBar: AppBar(
        title: Text('Signal MQTT'),
        actions: [],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, rInfoPage);
        },
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'SIGNAL',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 4,
                    color: Theme.of(context).accentColor,
                  ),
                ),
                Text(
                  'MQTT',
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 7,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Consumer(
                  // Provider.of<ListData>(context, listen: false) --> brokerData
                  builder: (context, AppState appState, child) {
                return ListView.builder(
                  itemBuilder: (context, index) {
                    return CustomListTile1(
                      index: index,
                      // title: Data.tasks[index].name,
                    );
                  },
                  itemCount: appState.brokerData.length,
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
