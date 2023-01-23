import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spot_me/model/shelter.dart';
import 'package:spot_me/model/victims.dart';
import 'package:spot_me/service/firebase_authentication.dart';
import 'package:intl/intl.dart';
import 'package:spot_me/widget/showSnackBar.dart';

class shelterManager extends StatefulWidget {
  const shelterManager({super.key});

  @override
  State<shelterManager> createState() => _shelterManagerState();
}

calcTime(DateTime timestamp) {
  DateTime currentTime = DateTime.now();
  Duration difference = currentTime.difference(timestamp);
  var sformat = DateFormat('yyyy/MM/dd hh:mm a');
  var time = sformat.format(timestamp);

  if (difference.inSeconds < 60) {
    return difference.inSeconds.toString() + " Seconds ago";
  } else if (difference.inMinutes < 60) {
    return difference.inMinutes.toString() + " Minutes Ago";
  } else if (difference.inHours < 24) {
    return difference.inHours.toString() + " Hour Ago";
  } else if (difference.inDays < 7) {
    return difference.inDays.toString() + " Days Ago";
  } else
    return time;
}

class _shelterManagerState extends State<shelterManager> {
  @override
  Widget build(BuildContext context) {
    final _shelters = Provider.of<List<Shelter>>(context);
    final user = context.read<FirebaseAuthMethods>().user;
    return Scaffold(
      appBar: AppBar(
        title: Text("Shelter Manager"),
      ),
      body: SafeArea(
          child: Center(
        child: ListView(
          children: [
            Card(
                child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("You can control your shelter to open or close"),
                ),
                for (var shelter in _shelters)
                  if (user.uid == shelter.userid)
                    ListTile(
                      title: Text(shelter.name),
                      trailing: LayoutBuilder(
                        builder:
                            (BuildContext context, BoxConstraints constraints) {
                          return Button(shelter);
                        },
                      ),
                    ),
              ],
            )),
          ],
        ),
      )),
    );
  }

  Button(Shelter shelter) {
    if (shelter.status == true) {
      return ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.green),
          ),
          onPressed: () {
            close(shelter);
          },
          child: Text("Open"));
    } else {
      return ElevatedButton(
          onPressed: () {
            open(shelter);
          },
          child: Text("Close"));
    }
  }

  void open(Shelter shelter) {
    FirebaseFirestore.instance
        .collection('shelters')
        .doc(shelter.shelterId)
        .update({"status": true}).then(
            (value) => showSuccessSnackBar(
                context, "Your Shelter is now available at the map"),
            onError: (e) => print("Error Update: $e"));
  }

  void close(Shelter shelter) {
    FirebaseFirestore.instance
        .collection('shelters')
        .doc(shelter.shelterId)
        .update({"status": false}).then(
            (value) => showSnackBar(context, "Your Shelter is currently close"),
            onError: (e) => print("Error Update: $e"));
  }
}
