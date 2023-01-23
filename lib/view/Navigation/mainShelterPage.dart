import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:spot_me/view/Navigation/ShelterManage.dart';
import 'package:spot_me/view/Navigation/shelter_list.dart';
import 'package:spot_me/view/Navigation/shelter_page.dart';
import 'package:spot_me/view/bottomNav/map2.dart';

class ShelterMenu extends StatefulWidget {
  const ShelterMenu({super.key});

  @override
  State<ShelterMenu> createState() => _ShelterMenuState();
}

class _ShelterMenuState extends State<ShelterMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Shelter Menu'),
          centerTitle: true,
        ),
        body: ListView(
          padding: EdgeInsets.zero,
          children: [
            ListTile(
              leading: Icon(Icons.map),
              title: Text('Find Shelter On Map'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => mapPg()),
              ),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.add_box),
              title: Text('Add Your Own Shelter'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => shelter_page()),
              ),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.near_me),
              title: Text('Find Nearest Shelter'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => shelterList()),
              ),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.manage_accounts),
              title: Text('Shelter Management'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => shelterManager()),
              ),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
            Divider(),
          ],
        ));
  }
}
