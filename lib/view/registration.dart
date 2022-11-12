import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spot_me/route/route.dart' as route;
import 'package:spot_me/service/firebase_authentication.dart';

class registrationPage extends StatefulWidget {
  const registrationPage({Key? key}) : super(key: key);

  @override
  State<registrationPage> createState() => _registrationPageState();
}

class _registrationPageState extends State<registrationPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void signUpUser() async {
    context.read<FirebaseAuthMethods>().signUpWithEmail(
          username: _passwordController.text,
          email: _emailController.text,
          password: _passwordController.text,
          context: context,
        );
    Navigator.pushNamed(context, secondStep());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Create Account"),
        ),
        body: SingleChildScrollView(
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
            Form(child: firstStep()),
            SizedBox(height: 10),
            Container(
              height: 35,
              width: 230,
              decoration: new BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                color: Color.fromARGB(255, 235, 24, 24),
              ),
              child: MaterialButton(
                onPressed: signUpUser,
                highlightColor: Colors.transparent,
                splashColor: Color.fromARGB(255, 238, 134, 134),
                //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 42.0),
                  child: Text(
                    "Next",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.0,
                        fontFamily: "WorkSansBold"),
                  ),
                ),
              ),
            ),
          ]),
        ));
  }

  firstStep() {
    return Container(
      height: 300,
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          TextFormField(
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
            controller: _passwordController,
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
        ],
      ),
    );
  }

  secondStep() {
    return Container(
      child: Form(
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.alternate_email,
                  color: Color(0xFF666666),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                labelText: 'Your Name',
                hintText: 'john@gmail.com',
              ),
            ),
            TextFormField(
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.alternate_email,
                  color: Color(0xFF666666),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                labelText: 'Phone Number',
                hintText: '0126555980',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
