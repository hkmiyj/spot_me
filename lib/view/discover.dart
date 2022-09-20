import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:spot_me/route/route.dart' as route;
import 'package:spot_me/view/help_page.dart';
import 'package:spot_me/view/list.dart';
import 'package:spot_me/view/shelter_page.dart';

import '../service/firebase_authentication.dart';

class discoverPage extends StatefulWidget {
  const discoverPage({Key? key}) : super(key: key);

  @override
  State<discoverPage> createState() => _discoverPageState();
}

class _discoverPageState extends State<discoverPage> {
  final double iconwidth = 25;
  @override
  Widget build(BuildContext context) {
    final user = context.read<FirebaseAuthMethods>().user;
    return Scaffold(
        appBar: AppBar(
          title: const Text('SpotMe'),
          centerTitle: true,
          backgroundColor: Colors.red,
          actions: [
            IconButton(
              icon: Icon(
                Icons.logout,
                color: Colors.white,
              ),
              onPressed: () {
                FirebaseAuthMethods(FirebaseAuth.instance).signOut(context);
              },
            ),
          ],
        ),
        body: SafeArea(
          child: Container(
              child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              children: <Widget>[
                SizedBox(),
                Container(
                  child: Row(children: <Widget>[
                    Text("Hello " + user.email!,
                        style: TextStyle(fontSize: 20, color: Colors.black)),
                  ]),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 16.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey,
                            blurRadius: 15.0,
                            offset: Offset(0, 15))
                      ]),
                  height: 90,
                  child: Center(
                    child: Row(
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons
                                  .handshake), //Image.asset('assets/icons/wallet.png'),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const helpForm()),
                                );
                              },
                            ),
                            Text(
                              'Help',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        SizedBox(width: iconwidth),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons
                                  .add_location_sharp), //Image.asset('assets/icons/wallet.png'),
                              onPressed: () {},
                            ),
                            Text(
                              'Rescue',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        SizedBox(width: iconwidth),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(
                                Icons.home,
                                color: Colors.red,
                              ), //Image.asset('assets/icons/wallet.png'),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const shelterList()),
                                );
                              },
                            ),
                            Text(
                              'Find Shelter',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        SizedBox(width: iconwidth),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(
                                Icons.home_work,
                                color: Colors.red,
                              ), //Image.asset('assets/icons/wallet.png'),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const shelter_page()),
                                );
                              },
                            ),
                            Text(
                              'Open Shelter',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: 175,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.red,
                      ),
                      child: Center(
                          child: Text(
                        "Shelter Status",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      )),
                    ),
                    SizedBox(width: 5),
                    Container(
                      width: 175,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    Container(
                      width: 175,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.red,
                      ),
                    ),
                    SizedBox(width: 5),
                    Container(
                      width: 175,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )),
        ));
  }
}
