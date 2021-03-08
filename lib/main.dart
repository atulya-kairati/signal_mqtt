import 'models/app_state.dart';
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'models/contants_and_utils.dart';
import 'screens/info_page.dart';
import 'package:provider/provider.dart';
import 'screens/dash_board_page.dart';
import 'package:signal_final/screens/widget_info_form.dart';
//--

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => AppState(),
    child: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void getSavedData(BuildContext context) async {
    Provider.of<AppState>(context, listen: false).initData();
  }

  @override
  void initState() {
    super.initState();
    getSavedData(context);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData myDarkTheme = ThemeData.dark().copyWith(
      primaryColor: Color(0xffbb86fc),
      primaryColorBrightness: Brightness.dark,
      primaryColorLight: Color(0xffbb86fc),
      primaryColorDark: Colors.black,
      accentColor: Color(0xff6e38e7),
      accentColorBrightness: Brightness.dark,
      canvasColor: Colors.black,
      scaffoldBackgroundColor: Color(0xff101010),
      bottomAppBarColor: Color(0xff242424),
      cardColor: Color(0xff231f29),
      dividerColor: Color(0x1f000000),
      highlightColor: Color(0x66bcbcbc),
      splashColor: Color(0x66c8c8c8),
      buttonColor: Color(0xffbb86fc),
      buttonTheme: ButtonThemeData(
        buttonColor: Color(0xffbb86fc),
      ),
      appBarTheme: AppBarTheme(
        color: Color(0xff1a181e),
        elevation: 8,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Color(0xff6e38e7),
        elevation: 8,
      ),
    );
    return MaterialApp(
      title: 'Flutter Demo',
      theme: myDarkTheme,
      initialRoute: rHome,
      routes: {
        rHome: (context) => HomeScreen(),
        rInfoPage: (context) => InfoPage(),
        rMqttPage: (context) => MQTTpage(),
        rWidgetInfoForm: (context) => WidgetInfoForm(),
      },
    );
  }
}

// ThemeData myDarkTheme = ThemeData.dark().copyWith(
//   primaryColor: Color(0xffbb86fc),
//   primaryColorBrightness: Brightness.dark,
//   primaryColorLight: Color(0xffbb86fc),
//   primaryColorDark: Color(0xff3700b3),
//   accentColor: Color(0xff03dac6),
//   accentColorBrightness: Brightness.dark,
//   canvasColor: Colors.black,
//   scaffoldBackgroundColor: Color(0xff101010),
//   bottomAppBarColor: Color(0xff242424),
//   cardColor: Color(0xff1d1d1d),
//   dividerColor: Color(0x1f000000),
//   highlightColor: Color(0x66bcbcbc),
//   splashColor: Color(0x66c8c8c8),
//   buttonColor: Color(0xffbb86fc),
//   appBarTheme: AppBarTheme(
//     color: Color(0xff1f1f1f),
//     elevation: 8,
//   ),
//   floatingActionButtonTheme: FloatingActionButtonThemeData(
//       // // backgroundColor: Color(0xff03dac6),
//       // focusColor: Color(0xff03dac6),
//       ),
// );
