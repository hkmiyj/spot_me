import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:simple_ripple_animation/simple_ripple_animation.dart';
import 'package:spot_me/route/route.dart' as route;
import 'package:spot_me/service/firebase_authentication.dart';
import 'package:spot_me/view/login.dart';

class registrationPage extends StatefulWidget {
  const registrationPage({Key? key}) : super(key: key);

  @override
  State<registrationPage> createState() => _registrationPageState();
}

class _registrationPageState extends State<registrationPage> {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _passConfirm = TextEditingController();
  final TextEditingController _phoneNumber = TextEditingController();

  void signUpUser() async {
    if (_form.currentState!.validate()) {
      context
          .read<FirebaseAuthMethods>()
          .signUpWithEmail(
            username: _pass.text,
            email: _emailController.text,
            password: _pass.text,
            context: context,
          )
          .then((value) => successBox());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.red,
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          centerTitle: true,
        ),
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: Column(children: [
                Text(
                  "Create Account",
                  style: TextStyle(
                      fontSize: 40.0,
                      fontWeight: FontWeight.w400,
                      fontFamily: "WorkSansMedium"),
                ),
                firstStep(),
                Container(
                  height: 35,
                  width: 230,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    color: Color.fromARGB(255, 235, 24, 24),
                  ),
                  child: MaterialButton(
                    onPressed: signUpUser,
                    highlightColor: Colors.transparent,
                    splashColor: Color.fromARGB(255, 238, 134, 134),
                    //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
                    child: Text(
                      "Register Now",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.0,
                          fontFamily: "WorkSansBold"),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Already have an account?",
                          style: TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontSize: 16.0,
                              fontFamily: "WorkSansMedium"),
                        ),
                        GestureDetector(
                          child: const Text(' Sign in here',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 255, 10, 10),
                                  fontSize: 16.0)),
                          onTap: () {
                            Navigator.pop(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginPage()),
                            );
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ));
  }

  firstStep() {
    return Form(
      key: _form,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email address';
                }
                return null;
              },
              controller: _emailController,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.alternate_email,
                  color: Color(0xFF666666),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                labelText: 'Email',
                hintText: 'john@gmail.com',
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your phone number';
                }
                return null;
              },
              controller: _phoneNumber,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.phone,
                  color: Color(0xFF666666),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                hintText: '0112347680',
                labelText: 'Phone Number',
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                } else if (value.length == 6)
                  return 'Please enter your more than 6 character';
                return null;
              },
              controller: _pass,
              obscureText: true,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.lock_outline,
                  color: Color(0xFF666666),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                hintText: 'Password',
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              validator: (val) {
                if (val!.isEmpty) return 'Please enter your confirmation';
                if (val != _pass.text) return 'Not Match';
                return null;
              },
              controller: _passConfirm,
              obscureText: true,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.lock_outline,
                  color: Color(0xFF666666),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                hintText: 'Confirm Password',
              ),
            ),
            SizedBox(height: 15),
            Text(
              "By Signing up you agree to our Terms Condistions & Privacy Policy",
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w400,
                  fontFamily: "WorkSansMedium"),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  successBox() {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Icon(
          size: 50,
          Icons.check_circle,
          color: Colors.green,
        ),
        content: Text(
          "Register is Completed",
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          Center(
            child: TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                Navigator.pop(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ),
                );
              },
              style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.red)))),
              child: const Text(
                "Okay",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.0,
                    fontFamily: "WorkSansBold"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
