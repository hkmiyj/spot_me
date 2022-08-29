import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spot_me/route/route.dart' as route;
//import 'package:spot_me/view/login.dart';

// scrcpy

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SpotMe',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      onGenerateRoute: route.controller,
      initialRoute: route.login,
      debugShowCheckedModeBanner: false,
      //home: map()
      //home: LoginPage()
    );
  }
}
