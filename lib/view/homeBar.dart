import 'package:flutter/material.dart';
import 'package:spot_me/view/list.dart';
import 'package:spot_me/view/map.dart';
import "package:spot_me/view/discover.dart";

import 'map2.dart';

class homepage extends StatefulWidget {
  const homepage({Key? key}) : super(key: key);

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    discoverPage(),
    //shelterList(),
    mapPg(),
    //map(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (_widgetOptions.elementAt(_selectedIndex)),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
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
                Icons.home,
                color: Color.fromARGB(255, 255, 0, 0),
              ),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map_sharp),
            label: '',
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
                color: Color.fromARGB(255, 255, 0, 0),
              ),
            ),
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
