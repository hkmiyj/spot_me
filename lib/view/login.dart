import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sign_button/sign_button.dart';
import 'package:spot_me/route/route.dart' as route;
import 'package:spot_me/service/firebase_authentication.dart';
import 'package:spot_me/view/registration.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _form = GlobalKey<FormState>();

  void loginUser() {
    // FirebaseAuthMethods(FirebaseAuth.instance).loginWithEmail
    if (_form.currentState!.validate()) {
      context.read<FirebaseAuthMethods>().loginWithEmail(
            email: emailController.text,
            password: passwordController.text,
            context: context,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
          child: Form(
        key: _form,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 100,
            ),
            Center(
              child: Container(
                  width: 200,
                  height: 150,
                  child: Image.asset('asset/images/logo.png')),
            ),
            Text(
              "Sign in to continue",
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w400,
                  fontFamily: "WorkSansMedium"),
            ),
            Container(
              padding:
                  EdgeInsets.only(left: 15.0, right: 15.0, top: 15, bottom: 0),
              child: Column(
                children: [
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    },
                    controller: emailController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.account_circle_rounded,
                        color: Color(0xFF666666),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      labelText: 'Email',
                      hintText: '',
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter password email';
                      }
                      return null;
                    },
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.lock_outline,
                          color: Color(0xFF666666),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        labelText: 'Password',
                        hintText: ''),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            GestureDetector(
              child: const Text('Forgot Password?',
                  style: TextStyle(color: Colors.grey)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ),
                );
              },
            ),
            SizedBox(
              height: 15,
            ),
            ElevatedButton(
              onPressed: loginUser,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Background color
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 42.0),
                child: Text(
                  "Sign In",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.0,
                      fontFamily: "WorkSansBold"),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      gradient: new LinearGradient(
                          colors: [
                            Colors.black12,
                            Colors.black54,
                          ],
                          begin: const FractionalOffset(0.0, 0.0),
                          end: const FractionalOffset(1.0, 1.0),
                          stops: [0.0, 1.0],
                          tileMode: TileMode.clamp),
                    ),
                    width: 100.0,
                    height: 1.0,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 15.0, right: 15.0),
                    child: Text(
                      "Or",
                      style: TextStyle(
                          color: Color(0xFF2c2b2b),
                          fontSize: 16.0,
                          fontFamily: "WorkSansMedium"),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: new LinearGradient(
                          colors: [
                            Colors.black54,
                            Colors.black12,
                          ],
                          begin: const FractionalOffset(0.0, 0.0),
                          end: const FractionalOffset(1.0, 1.0),
                          stops: [0.0, 1.0],
                          tileMode: TileMode.clamp),
                    ),
                    width: 100.0,
                    height: 1.0,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Don't Have An Account?",
                    style: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 16.0,
                        fontFamily: "WorkSansMedium"),
                  ),
                  GestureDetector(
                    child: const Text(' Sign up here',
                        style: TextStyle(
                            color: Color.fromARGB(255, 255, 10, 10),
                            fontSize: 16.0)),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const registrationPage()),
                      );
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }
}
