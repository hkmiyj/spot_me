import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:spot_me/service/firebase_authentication.dart';
import 'package:spot_me/view/discover.dart';

class profile extends StatefulWidget {
  const profile({Key? key}) : super(key: key);

  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {
  final TextEditingController _displayName = TextEditingController();
  final TextEditingController _phoneNumber = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final user = context.read<FirebaseAuthMethods>().user;
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Create Account"),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Form(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextFormField(
                    controller: _displayName,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.person,
                        color: Color(0xFF666666),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      labelText: 'Nickname',
                      hintText: 'Johnson',
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _phoneNumber,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.phone,
                        color: Color(0xFF666666),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      labelText: 'Phone Number',
                      hintText: '012345678',
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    height: 35,
                    width: 230,
                    decoration: new BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      color: Color.fromARGB(255, 235, 24, 24),
                    ),
                    child: MaterialButton(
                      onPressed: () {
                        user.updateDisplayName(_displayName.text);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const discoverPage()),
                        );
                      },
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
                ],
              ),
            ),
          ),
        ));
  }
}
