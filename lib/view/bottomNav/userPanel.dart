import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spot_me/model/shelter.dart';
import 'package:spot_me/model/victims.dart';
import 'package:spot_me/service/firebase_authentication.dart';
import 'package:intl/intl.dart';

class userPanel extends StatefulWidget {
  const userPanel({super.key});

  @override
  State<userPanel> createState() => _userPanelState();
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

class _userPanelState extends State<userPanel> {
  @override
  Widget build(BuildContext context) {
    final _shelters = Provider.of<List<Shelter>>(context);
    final _victims = Provider.of<List<Victim>>(context);
    final user = context.read<FirebaseAuthMethods>().user;
    return Scaffold(
      appBar: AppBar(
        title:
            Text("SpotMe", style: TextStyle(fontSize: 30, color: Colors.white)),
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
                  child: Text("Shelter"),
                ),
                for (var shelter in _shelters)
                  if (user.uid == shelter.userid)
                    ListTile(
                      title: Text(shelter.name),
                      trailing: Switch(
                          activeColor: Colors.green,
                          value: shelter.status,
                          onChanged: (value) {
                            setState(() {
                              shelter.status == value;
                            });
                          }),
                    ),
              ],
            )),
          ],
        ),
      )),
    );
  }
}
