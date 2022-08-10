import 'package:flutter/material.dart';
import 'package:spot_me/route/route.dart' as route;

class registrationPage extends StatefulWidget {
  const registrationPage({Key? key}) : super(key: key);

  @override
  State<registrationPage> createState() => _registrationPageState();
}

class _registrationPageState extends State<registrationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Create Account"),
        ),
        body:Container(
          padding: EdgeInsets.only(left: 20, right: 20, top: 35, bottom: 30),
          width: double.infinity,
          height: double.infinity,
          color: Colors.white70,
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Center(
                child: Container(
                    width: 200,
                    height: 100,
                    child: Image.asset('asset/images/logo.png')),
              ),
            ),
            inputForm(),
            signUpBut(),
          ]),
        ));
  }
}

class inputForm extends StatefulWidget {
  const inputForm({Key? key}) : super(key: key);

  @override
  State<inputForm> createState() => _inputFormState();
}

class _inputFormState extends State<inputForm> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.account_circle_rounded,
                  color: Color(0xFF666666),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                hintText: 'Username',
              ),
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.alternate_email,
                  color: Color(0xFF666666),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                hintText: 'Email',
              ),
            ),
            SizedBox(height: 10),
            TextField(
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
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class signUpBut extends StatefulWidget {
  const signUpBut({Key? key}) : super(key: key);

  @override
  State<signUpBut> createState() => _signUpButState();
}

class _signUpButState extends State<signUpBut> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      width: 230,
      decoration: new BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        color: Color.fromARGB(255, 235, 24, 24),
      ),
      child: MaterialButton(
          highlightColor: Colors.transparent,
          splashColor: Color.fromARGB(255, 238, 134, 134),
          //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 42.0),
            child: Text(
              "Sign Up",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.0,
                  fontFamily: "WorkSansBold"),
            ),
          ),
          onPressed: () => {}),
    );
  }
}
