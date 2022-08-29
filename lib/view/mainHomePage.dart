import 'package:flutter/material.dart';
import 'package:spot_me/route/route.dart' as route;
import 'package:spot_me/view/information.dart';
import 'package:spot_me/view/map.dart';
import "package:spot_me/view/discover.dart";
import "package:spot_me/view/login.dart";
import "package:spot_me/view/registration.dart";
import "package:spot_me/view/profile.dart";

class homepage extends StatefulWidget {
  const homepage({Key? key}) : super(key: key);

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    discoverPage(),
    map(),
    info(),
    profile()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      )),
      bottomNavigationBar: Theme(
        data: ThemeData(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          showSelectedLabels: false,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
          enableFeedback: true,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: '',
              tooltip: 'Discover',
              activeIcon: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                        color:
                            Color.fromARGB(255, 255, 255, 255).withOpacity(0.3),
                        offset: Offset(0, 4),
                        blurRadius: 20),
                  ],
                ),
                child:
                    Icon(Icons.home, color: Color.fromARGB(255, 255, 255, 255)),
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.map_sharp),
              label: '',
              tooltip: 'Map',
              activeIcon: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                        color:
                            Color.fromARGB(255, 255, 255, 255).withOpacity(0.3),
                        offset: Offset(0, 4),
                        blurRadius: 20),
                  ],
                ),
                child: Icon(
                  Icons.map_sharp,
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.info_sharp),
              label: '',
              tooltip: 'Info',
              activeIcon: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                        color:
                            Color.fromARGB(255, 255, 255, 255).withOpacity(0.3),
                        offset: Offset(0, 4),
                        blurRadius: 20),
                  ],
                ),
                child: Icon(
                  Icons.info_sharp,
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_rounded),
              label: '',
              tooltip: 'Profile',
              activeIcon: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                        color:
                            Color.fromARGB(255, 255, 255, 255).withOpacity(0.3),
                        offset: Offset(0, 4),
                        blurRadius: 20),
                  ],
                ),
                child: Icon(
                  Icons.account_circle_rounded,
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
              ),
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Color.fromARGB(255, 241, 71, 28),
          onTap: _onItemTapped,
          backgroundColor: Color.fromARGB(255, 238, 10, 10),
        ),
      ),
    );
  }
}
