import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:spot_me/model/shelter.dart';

class shelterList extends StatefulWidget {
  const shelterList({super.key});

  @override
  State<shelterList> createState() => _shelterListState();
}

class _shelterListState extends State<shelterList> {
  @override
  Widget build(BuildContext context) {
    final _shelters = Provider.of<List<Shelter>>(context);
    if (_shelters == []) {
      return Center(child: CircularProgressIndicator());
    }
    return Scaffold(
        appBar: AppBar(
          title: Text('List Of Shelter'),
          centerTitle: true,
        ),
        body: Container(
          child: ListView(children: <Widget>[
            for (var shelter in _shelters)
              Card(
                child: ListTile(
                  leading: FlutterLogo(),
                  title: Text(shelter.name),
                  subtitle: Text(shelter.phone),
                ),
              ),
          ]
              /*child: Column(
              children: [
                for (var shelter in _shelters)
                  Text("Shelter Name: " + shelter.name + shelter.phone),
              ],
            ),*/
              ),
        ));
  }
}
