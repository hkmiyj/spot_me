import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spot_me/service/firebase_authentication.dart';
import 'package:spot_me/view/login.dart';
import 'package:spot_me/view/home.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:spot_me/service/map_configuration.dart';
//import 'package:spot_me/view/login.dart';
// scrcpy

late SharedPreferences sharedPreferences;

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedPreferences = await SharedPreferences.getInstance();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    mapConfiguration().UserLocation();
    return MultiProvider(
      providers: [
        Provider<FirebaseAuthMethods>(
          create: (_) => FirebaseAuthMethods(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) => context.read<FirebaseAuthMethods>().authState,
          initialData: null,
        ),
      ],
      child: MaterialApp(
        title: 'SpotMe',
        theme: ThemeData(
          primarySwatch: Colors.red,
        ),
        home: const AuthWrapper(),
        debugShowCheckedModeBanner: false,
        //home: map()
        //home: LoginPage()
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();

    if (firebaseUser != null) {
      return const homepage();
    }
    return const LoginPage();
  }
}
