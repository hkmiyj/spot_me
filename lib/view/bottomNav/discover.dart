import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spot_me/model/victims.dart';
import 'package:spot_me/service/twitter_apii.dart';
import 'package:spot_me/view/Navigation/emergency.dart';
import 'package:spot_me/view/Navigation/mainShelterPage.dart';
import 'package:spot_me/view/bottomNav/map.dart';
import 'package:spot_me/view/Navigation/requestHelp.dart';
import 'package:spot_me/view/Navigation/shelter_list.dart';
import 'package:spot_me/view/Navigation/locate.dart';
import 'package:spot_me/view/Navigation/shelter_page.dart';
import '../../service/firebase_authentication.dart';

class discoverPage extends StatefulWidget {
  const discoverPage({Key? key}) : super(key: key);

  @override
  State<discoverPage> createState() => _discoverPageState();
}

class _discoverPageState extends State<discoverPage> {
  final double iconwidth = 25;
  @override
  Widget build(BuildContext context) {
    final _victims = Provider.of<List<Victim>>(context);
    final user = context.read<FirebaseAuthMethods>().user;
    return Scaffold(
        appBar: AppBar(
          title: Text("SpotMe",
              style: TextStyle(fontSize: 30, color: Colors.white)),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              tooltip: 'LogOut ',
              onPressed: () {
                FirebaseAuthMethods(FirebaseAuth.instance).signOut(context);
              },
            ),
          ],
        ),
        body: Container(
            child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            children: <Widget>[
              SizedBox(),
              Container(
                width: 500.0,
                decoration: BoxDecoration(
                  color: Colors.red,
                ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Container(
                          child: FutureBuilder<String>(
                            future: null,
                            builder: (BuildContext context,
                                AsyncSnapshot<String> snapshot) {
                              if (user.displayName!.isNotEmpty) {
                                return Text("Welcome " + user.displayName!,
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold));
                                //return Text('${time.data}');
                              } else {
                                return Text('Welcome',
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold));
                              }
                            },
                          ),
                        ),
                      ),
                    ]),
              ),
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                  color: Colors.white,
                ),
                child: Center(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => helpForm()),
                                );
                              },
                              icon: const Icon(
                                Icons.handshake,
                                color: Colors.red,
                                size: 35,
                              ),
                            ),
                            Text(
                              'Help',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            SizedBox(
                              height: 10,
                            )
                          ],
                        ),
                        Column(
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => locatePage()),
                                );
                              },
                              icon: const Icon(
                                Icons.radar,
                                color: Colors.red,
                                size: 35,
                              ),
                            ),
                            Text(
                              'Locate Victim',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            SizedBox(
                              height: 10,
                            )
                          ],
                        ),
                        Column(
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ShelterMenu()),
                                );
                              },
                              icon: const Icon(
                                Icons.night_shelter,
                                color: Colors.red,
                                size: 35,
                              ),
                            ),
                            Text(
                              'Shelter',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            SizedBox(
                              height: 10,
                            )
                          ],
                        ),
                        Column(
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EmergencyContact()),
                                );
                              },
                              icon: const Icon(
                                Icons.contact_phone,
                                color: Colors.red,
                                size: 35,
                              ),
                            ),
                            Text(
                              'Contact',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            SizedBox(
                              height: 10,
                            )
                          ],
                        ),
                      ]),
                ),
              ),
              SizedBox(height: 5),
              Flexible(
                flex: 1,
                child: FutureBuilder(
                  future: twitterApi().getTwitNews(),
                  builder: (BuildContext context, AsyncSnapshot tweetPost) {
                    if (tweetPost.hasData) {
                      return tweetPost.data;
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              )
            ],
          ),
        )));
  }
}
