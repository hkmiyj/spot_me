import 'package:flutter/material.dart';

// Define Routes
import 'package:spot_me/view/login.dart';
import 'package:spot_me/view/registration.dart';
import 'package:spot_me/view/home.dart';

// Route Names
const String login = 'login';
const String registration = 'registration';
const String home = 'home';

// Control our page route flow
Route<dynamic> controller(RouteSettings settings) {
  switch (settings.name) {
    case login:
      return MaterialPageRoute(builder: (context) => LoginPage());
    case registration:
      return MaterialPageRoute(builder: (context) => registrationPage());
    case home:
      return MaterialPageRoute(builder: (context) => homepage());
    default:
      throw ('This route name does not exit');
  }
}
