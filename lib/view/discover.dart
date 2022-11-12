import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:spot_me/route/route.dart' as route;
import 'package:spot_me/service/twitter_apii.dart';
import 'package:spot_me/view/help_page.dart';
import 'package:spot_me/view/list.dart';
import 'package:spot_me/view/locate.dart';
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
          title: Text("SpotMe",
              style: TextStyle(fontSize: 30, color: Colors.white)),
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
                height: 100.0,
                decoration: BoxDecoration(
                  color: Colors.red,
                ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.account_circle,
                        color: Colors.white,
                        size: 50.0,
                      ),
                      Container(
                        child: Text(user.displayName!,
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
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
                                      builder: (context) => const helpForm()),
                                );
                              },
                              icon: const Icon(
                                Icons.handshake,
                                color: Colors.red,
                                size: 35,
                              ),
                            ),
                            Text(
                              'Ask Help',
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
                                      builder: (context) => const locatePage()),
                                );
                              },
                              icon: const Icon(
                                Icons.add_location_sharp,
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
                                      builder: (context) =>
                                          const shelter_page()),
                                );
                              },
                              icon: const Icon(
                                Icons.other_houses_rounded,
                                color: Colors.red,
                                size: 35,
                              ),
                            ),
                            Text(
                              'Add Shelter',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            SizedBox(
                              height: 10,
                            )
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const shelterList()),
                                );
                              },
                              icon: const Icon(
                                Icons.house_siding,
                                color: Colors.red,
                                size: 35,
                              ),
                            ),
                            Text(
                              'Find Shelter',
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
              Text(
                "News",
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              Flexible(
                flex: 1,
                child: FutureBuilder(
                  future: twitterApi().getTwitNews(),
                  builder: (BuildContext context, AsyncSnapshot tweetPost) {
                    if (tweetPost.hasData) {
                      return tweetPost.data;
                    } else {
                      return CircularProgressIndicator();
                    }
                  },
                ),
              )
            ],
          ),
        )));
  }
}
