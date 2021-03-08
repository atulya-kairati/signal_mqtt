import 'package:flutter/cupertino.dart';
import 'package:mqtt_client/mqtt_client.dart';
// import 'package:flutter_mqtt_app/mqtt/state/MQTTAppState.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:signal_final/models/app_state.dart';

class MQTTManager {
  // Private instance of client
  // Constructor
  MQTTManager({
    @required String host,
    @required String identifier,
    @required AppState appState,
  })  : _identifier = identifier,
        _host = host,
        _appState = appState;

  MqttServerClient _client;
  final String _identifier;
  final String _host;
  final AppState _appState;

  void initializeMQTTClient() {
    print('initializeMQTTClient() in MQTTManager called');
    _client = MqttServerClient(_host, _identifier);
    _client.port = 1883;
    _client.keepAlivePeriod = 20;
    _client.autoReconnect = true;
    _client.resubscribeOnAutoReconnect = true;

    // _client.
    //_client.secure = false;
    _client.logging(on: true);

    /// Add the successful connection callback
    _client.onConnected = onConnected;
    _client.onSubscribed = onSubscribed;
    _client.onDisconnected = onDisconnected;
    _client.onAutoReconnect = onAutoReconnect;
    _client.onAutoReconnected = onAutoReconnected;
    // _client.connectionStatus
    // _client.

    final MqttConnectMessage connMess = MqttConnectMessage()
        .withClientIdentifier(_identifier)
        .withWillTopic(
            'willtopic') // If you set this you must set a will message
        .withWillMessage('My Will message')
        .startClean() // Non persistent session for testing
        .withWillQos(MqttQos.atLeastOnce);
    print('EXAMPLE::Mosquitto client connecting....');
    _client.connectionMessage = connMess;
  }

  // Connect to the host
  // ignore: avoid_void_async
  void connect() async {
    print('connect() in MQTTManager called');
    _appState.updateConnectionState(MqttConnectionState.connecting);

    assert(_client != null);
    try {
      print('EXAMPLE::Mosquitto start client connecting....');
      // _currentState.setAppConnectionState(MQTTAppConnectionState.connecting);
      await _client.connect();
    } on Exception catch (e) {
      print('EXAMPLE::client exception - $e');
      disconnect();
    }
  }

  void publish({@required String message, @required String topic}) {
    print('publish() in MQTTManager called');
    // _appState.updateTopicData(topic: topic, data: message);

    // TODO :
    // if (_client.connectionStatus.returnCode ==
    //     MqttConnectReturnCode.brokerUnavailable) {
    //   print('>>>>>>>>>>>>>>>> broker unavailable');
    //   return;
    // }
    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.addString(message);
    _client.publishMessage(topic, MqttQos.atLeastOnce, builder.payload);
  }

  void subscribe(String topic) {
    print('subscribe() in MQTTManager called');

    // if ((_appState.topicData?.keys ?? []).contains(topic)) return;

    _client.subscribe(topic, MqttQos.atLeastOnce);

    // _appState.updateTopicData(
    //   topic: topic,
    //   data: null,
    // ); // so that topics are added
  }

  get connectionStat => _client.connectionStatus.state;

  /// The subscribed callback
  void onSubscribed(String topic) {
    print('onSubscribed() in MQTTManager called');
    print('EXAMPLE::Subscription confirmed for topic $topic');
  }

  bool disconnectionNotifyFlag = true;
  void disconnect() {
    print('dicconnect() in MQTTManager called');
    print('Disconnected');
    try {
      _appState.updateConnectionState(MqttConnectionState.disconnecting,
          flag: disconnectionNotifyFlag);
    } catch (e) {
      print(e);
    }
    _client.disconnect();
  }

  /// The unsolicited disconnect callback
  void onDisconnected() {
    print('onDisconnect() in MQTTManager called');
    try {
      _appState.updateConnectionState(MqttConnectionState.disconnected,
          flag: disconnectionNotifyFlag);
    } catch (e) {
      print(e);
    }

    print('EXAMPLE::OnDisconnected client callback - Client disconnection');
    if (_client.connectionStatus.returnCode ==
        MqttConnectReturnCode.brokerUnavailable) {
      print('EXAMPLE::OnDisconnected callback is solicited, this is correct');
    }
    // _currentState.setAppConnectionState(MQTTAppConnectionState.disconnected);
  }

  /// The successful connect callback
  void onConnected() {
    print('onConnect() in MQTTManager called');
    _appState.updateConnectionState(MqttConnectionState.connected);
    print('EXAMPLE::Mosquitto client connected....');

    _client.updates
        .listen((List<MqttReceivedMessage<MqttMessage>> receivedPayload) {
      final MqttPublishMessage recMess = receivedPayload[0].payload;
      final String pt =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      // _currentState.setReceivedText(pt);

      /// The above may seem a little convoluted for users only interested in the
      /// payload, some users however may be interested in the received publish message,
      /// lets not constrain ourselves yet until the package has been in the wild
      /// for a while.
      /// The payload is a byte buffer, this will be specific to the topic
      _appState.updateTopicData(topic: receivedPayload[0].topic, data: pt);
      print(
          'EXAMPLE::Change notification:: topic is <${receivedPayload[0].topic}>, payload is <-- $pt -->');
      print('');
    });
    print(
        'EXAMPLE::OnConnected client callback - Client connection was sucessful');
  }

  void onAutoReconnect() {
    print('onAutoReconnect() called');
  }

  void onAutoReconnected() {
    print('onAutoReconnected() called');
  }
}
