import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spot_me/model/shelter.dart';
import 'package:spot_me/model/victims.dart';
import 'package:spot_me/service/firebase_authentication.dart';
import 'package:spot_me/service/location.dart';
import 'package:spot_me/view/login.dart';
import 'package:spot_me/view/homeBar.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:spot_me/service/map_configuration.dart';

import 'model/userLocation.dart';
//import 'package:spot_me/view/login.dart';
// scrcpy
// scrcpy --turn-screen-off

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
    // Shelter provider

    final _victim = FirebaseFirestore.instance
        .collection("victims")
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Victim.fromMap(doc.data());
      }).toList();
    });

    // Shelter provider
    final _shelterCollection =
        FirebaseFirestore.instance.collection('shelters');
    final _shelter = _shelterCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Shelter.fromDocument(doc);
      }).toList();
    });

    mapConfiguration().UserLocation();

    return MultiProvider(
      providers: [
        StreamProvider<UserLocation>(
            create: (context) => LocationService().locationStream,
            initialData: UserLocation(latitude: 1, longitude: 2)),
        StreamProvider<List<Victim>>(
          create: (context) => _victim,
          initialData: [],
        ),
        StreamProvider<List<Shelter>>(
          create: (context) => _shelter,
          initialData: [],
        ),
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
          backgroundColor: Color.fromARGB(255, 107, 106, 106),
          primarySwatch: Colors.red,
        ),
        home: const AuthWrapper(),
        debugShowCheckedModeBanner: false,
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
