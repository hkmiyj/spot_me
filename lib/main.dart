import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spot_me/route/route.dart' as route;
//import 'package:spot_me/view/login.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      title: 'SpotMe',
      theme:ThemeData(
           primarySwatch: Colors.red,
      ),
      onGenerateRoute: route.controller,
      initialRoute: route.home,
      debugShowCheckedModeBanner: false,
      //home: registrationPage()
      //home: LoginPage()
    );
  }
}