import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:spot_me/route/route.dart' as route;

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 60.0),
            child: Center(
              child: Container(
                  width: 200,
                  height: 150,
                  child: Image.asset('asset/images/logo.png')),
            ),
          ),
          const Padding(
            padding:
                EdgeInsets.only(left: 15.0, right: 15.0, top: 10, bottom: 0),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.account_circle_rounded,
                  color: Color(0xFF666666),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                labelText: 'Email Or Phone Number',
                hintText: '',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 15.0, right: 15.0, top: 15, bottom: 0),
            child: TextField(
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
          const SignInButt(),
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
          Padding(
            // Even Padding On All Sides
            padding: EdgeInsets.all(10.0),
            child: SignInButton(
              Buttons.GoogleDark,
              padding: const EdgeInsets.all(8.0),
              text: "Connect With Google",
              onPressed: () {},
            ),
          ),
          SizedBox(
            height: 130,
          ),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, route.registration),
            child: const Text(
              "Don't Have An account?",
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            )),
          )
        ],
      )),
    );
  }
}

class SignInButt extends StatelessWidget {
  const SignInButt({Key? key}) : super(key: key);

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
              "Sign In",
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
