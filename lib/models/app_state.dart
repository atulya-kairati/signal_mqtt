import 'package:flutter/foundation.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'contants_and_utils.dart';

class AppState extends ChangeNotifier {
  List<Map<String, String>> _brokerData = [];

  List<Map<String, String>> get brokerData => _brokerData;

  Set<String> _brokerNames = {};
  // TODO : when broker name is changed its not updated in here
  Set<String> get brokerNames => _brokerNames;

  void saveBrokerData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('brokers', jsonEncode(brokerData));
  }

  void initData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String data = sharedPreferences.getString('brokers');
    // since the jsonDecode(data) gives out dynamic obj
    // it has to be proccessed like this
    for (var obj in jsonDecode(data)) {
      _brokerData.add(Map.castFrom(obj));
    }

    // Init Broker Names
    _brokerData.forEach((element) {
      _brokerNames.add(element['name']);
    });
    print(brokerNames);
    print(brokerData);

    // init widget data

    data = sharedPreferences.getString('widgets');

    var tempData = Map.castFrom(jsonDecode(data));
    // print(tempData.runtimeType);
    // print(tempData.keys);
    for (String key in tempData.keys) {
      // print(List.castFrom(tempData[key]));
      List<Map<String, String>> tempList = [];
      for (var obj in List.castFrom(tempData[key])) {
        tempList.add(Map.castFrom(obj));
      }
      // print(tempList.runtimeType);
      _allWidgetData[key] = tempList;
    }
    print(allWidgetData);

    notifyListeners();
  }

  void updateBrokerData(Map<String, String> data, {int index}) {
    if (index == -1) {
      // incoming data has to be added in the list
      _brokerData.add(data);
      _brokerNames.add(data['name']);
    } else {
      // incoming data has to be updated oat the given index in the list
      _brokerData[index] = data;
    }

    print(jsonEncode(brokerData));
    print(_brokerNames);
    saveBrokerData(); // save in sharedPrefrences
    notifyListeners();
  }

  void deleteBrokerData(int index) {
    _allWidgetData.remove('widgetsOf${brokerData[index]['name']}');
    _brokerNames
        .removeWhere((element) => (element == _brokerData[index]['name']));
    _brokerData.removeAt(index);
    print(jsonEncode(brokerData));
    print(_allWidgetData);
    print(brokerNames);
    saveBrokerData();
    saveWidgetData();
    notifyListeners();
  }

  //---------------WIDGET DATA---------------//
  Map<String, List<Map<String, String>>> _allWidgetData = {};

  Map<String, List<Map<String, String>>> get allWidgetData => _allWidgetData;

  List<Map<String, String>> getWidgetData(int bindex) {
    return _allWidgetData['widgetsOf${brokerData[bindex]['name']}'] ?? [];
  }

  void updateAllWidgetData(Map<String, String> data,
      {@required int bindex, int windex}) {
    if (windex != null) {
      _allWidgetData['widgetsOf${brokerData[bindex]['name']}'][windex] = data;
      print('widgetData edited');
    } else {
      if (_allWidgetData['widgetsOf${brokerData[bindex]['name']}'] == null)
        _allWidgetData['widgetsOf${brokerData[bindex]['name']}'] = [];

      _allWidgetData['widgetsOf${brokerData[bindex]['name']}'].add(data);
      print('>>> widgetData updated');
    }

    print(jsonEncode(_allWidgetData));
    saveWidgetData(); // save in sharedPrefrences
    notifyListeners();
  }

  void deleteWidgetData({@required int bindex, @required int windex}) {
    _allWidgetData['widgetsOf${brokerData[bindex]['name']}'].removeAt(windex);

    print(jsonEncode(_allWidgetData));
    saveWidgetData(); // save in sharedPrefrences
    notifyListeners();
  }

  void saveWidgetData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('widgets', jsonEncode(allWidgetData));
  }

  //_________----------ConnectionState----------_________//

  MqttConnectionState _mqttConnectionState = MqttConnectionState.disconnected;
  MqttConnectionState get mqttConnectionState => _mqttConnectionState;

  void updateConnectionState(MqttConnectionState newConnectionState,
      {bool flag = true}) {
    _mqttConnectionState = newConnectionState;
    print(
        '>>>>>>>> Connection State ---> $_mqttConnectionState ; notify: $flag');

    if (flag) notifyListeners();
  }

  //_________----------Mqtt topic Data----------_________//

  Map<String, List<Payload>> _topicData = {};

  Map<String, List<Payload>> get topicData => _topicData;

  void updateTopicData({String topic, String data}) {
    print('updateTopicData() called in appState');
    // if (data == null) {
    //   _topicData[topic] = <Payload>[];
    //   print(topicData);
    //   return;
    // }
    if (topicData[topic] == null) topicData[topic] = [];
    _topicData[topic].add(Payload(message: data));
    print('___ $topicData');
    notifyListeners();
  }
}
