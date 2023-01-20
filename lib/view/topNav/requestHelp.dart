import 'dart:core';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:simple_ripple_animation/simple_ripple_animation.dart';
import 'package:spot_me/model/victims.dart';
import 'package:spot_me/service/firebase_authentication.dart';
import 'package:spot_me/service/firebase_storage.dart';
import 'package:spot_me/service/location.dart';
import 'package:spot_me/view/topNav/shelter_list.dart';
import 'package:spot_me/widget/showMap.dart';
import 'package:spot_me/widget/showSnackBar.dart';
import 'package:spot_me/model/userLocation.dart';
import 'package:intl/intl.dart';

class helpForm extends StatefulWidget {
  const helpForm({super.key});

  @override
  State<helpForm> createState() => _helpFormState();
}

class _helpFormState extends State<helpForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _description = TextEditingController();
  final TextEditingController _numberOfVictims = TextEditingController();
  String imageUrl = '';
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

  showAlertDialogSubmit(BuildContext context, userLocation) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("NO"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    Widget continueButton = TextButton(
      child: Text("YES"),
      onPressed: () {
        final user = context.read<FirebaseAuthMethods>().user;
        if (_formKey.currentState!.validate()) {
          final users =
              FirebaseFirestore.instance.collection('/victims').doc(user.uid);
          var myJSONObj = {
            'description': _description.text,
            'name': user.displayName,
            'userid': user.uid,
            'phoneNumb': user.phoneNumber,
            'status': true,
            'numberOfVictim': _numberOfVictims.text,
            'location': GeoPoint(userLocation.latitude, userLocation.longitude),
            'time': Timestamp.now(),
            'imageUrl': imageUrl,
          };
          users
              .set(myJSONObj)
              .whenComplete(() => bottomsheet(user, userLocation));

          /*FirebaseFirestore.instance.collection("victims").add({
            'description': _description.text,
            'name': user.displayName,
            'userid': user.uid,
            'phoneNumb': user.phoneNumber,
            'status': true,
            'numberOfVictim': _numberOfVictims.text,
            'location': GeoPoint(userLocation.latitude, userLocation.longitude),
            'time': Timestamp.now(),
          }).whenComplete(() => bottomsheet(user, userLocation));*/
          showSuccessSnackBar(context, "Your Request Has Been Sent");
          Navigator.pop(context);
        }
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Please Confirm"),
      content: Text("Are you sure you want to continue?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  bottomsheet(_user, userLocation) {
    return DraggableScrollableSheet(
      initialChildSize: 0.45,
      minChildSize: 0.09,
      maxChildSize: 0.45,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          color: Colors.white,
          child: ListView(
            children: [
              Padding(
                padding: EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Container(
                        child: ListTile(
                          leading: RippleAnimation(
                              repeat: true,
                              color: Colors.blue,
                              minRadius: 15,
                              ripplesCount: 6,
                              child: Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.accessibility_new_rounded,
                                  color: Colors.red,
                                ),
                              )),
                          title: Text('Your Current Location',
                              style: TextStyle(fontWeight: FontWeight.w500)),
                          subtitle: FutureBuilder<String>(
                            future: getCoordinateToAddress(
                                userLocation.latitude, userLocation.longitude),
                            builder: (BuildContext context,
                                AsyncSnapshot<String> address) {
                              if (address.hasData) {
                                return Text('${address.data}');
                              } else {
                                return Text('No Location Found');
                              }
                            },
                          ),
                          trailing: FloatingActionButton.small(
                            elevation: 0,
                            onPressed: () async {
                              ImagePicker imagePicker = ImagePicker();
                              XFile? file = await imagePicker.pickImage(
                                  source: ImageSource.camera);
                              print('${file?.path}');

                              if (file == null) return;
                              //Import dart:core
                              String uniqueFileName = DateTime.now()
                                  .millisecondsSinceEpoch
                                  .toString();

                              /*Step 2: Upload to Firebase storage*/
                              //Install firebase_storage
                              //Import the library

                              //Get a reference to storage root
                              Reference referenceRoot =
                                  FirebaseStorage.instance.ref();
                              Reference referenceDirImages =
                                  referenceRoot.child('victims');

                              //Create a reference for the image to be stored
                              Reference referenceImageToUpload =
                                  referenceDirImages.child('${file.name}');

                              //Handle errors/success

                              try {
                                //Store the file
                                EasyLoading.showInfo('Uploading Image')
                                    .then((value) => null);
                                await referenceImageToUpload
                                    .putFile(File(file!.path));
                                //Success: get the download URL
                                imageUrl = await referenceImageToUpload
                                    .getDownloadURL();
                                print(imageUrl);
                                EasyLoading.showSuccess(
                                    'Image Succesfully Upload');
                              } catch (error) {
                                EasyLoading.showError('Fail to Upload Image');
                              }
                            },
                            child: Icon(Icons.open_in_browser),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                          controller: _description,
                          keyboardType: TextInputType.multiline,
                          minLines: 1,
                          maxLines: 5,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText:
                                'Describe your situation or your location',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please describe any description';
                            }
                            return null;
                          }),
                      SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                          keyboardType: TextInputType.number,
                          controller: _numberOfVictims,
                          maxLines: 1,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'How many People with you?',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter a number';
                            }
                            return null;
                          }),
                      SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          showAlertDialogSubmit(context, userLocation);
                          //bottomSheet();
                        },
                        child: Text("Submit Your Request"),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  secondBottomSheet(user, userLocation, _victim) {
    return DraggableScrollableSheet(
      initialChildSize: 0.45,
      minChildSize: 0.09,
      maxChildSize: 0.45,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: [
                Column(
                  children: [
                    Text('You Request For Help',
                        style: TextStyle(fontWeight: FontWeight.w500)),
                    Container(
                      child: ListTile(
                        leading: RippleAnimation(
                            repeat: true,
                            color: Colors.blue,
                            minRadius: 15,
                            ripplesCount: 6,
                            child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 255, 255, 255),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.accessibility_new_rounded,
                                color: Colors.red,
                              ),
                            )),
                        title: Text(user.displayName.toString().toUpperCase(),
                            style: TextStyle(fontWeight: FontWeight.w500)),
                        subtitle: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FutureBuilder<
                                DocumentSnapshot<Map<String, dynamic>>>(
                              future: FirebaseFirestore.instance
                                  .collection('victims')
                                  .doc(user.uid)
                                  .get(),
                              builder: (_, snapshot) {
                                if (snapshot.hasData) {
                                  var data = snapshot.data!.data();
                                  Timestamp time = data!['time'];
                                  return Text(calcTime(time.toDate()));
                                }
                                return Text("No Description");
                              },
                            ),
                            FutureBuilder<String>(
                              future: getCoordinateToAddress(
                                  userLocation.latitude,
                                  userLocation.longitude),
                              builder: (BuildContext context,
                                  AsyncSnapshot<String> address) {
                                if (address.hasData) {
                                  return Text('${address.data}');
                                } else {
                                  return Text('No Location Found');
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Card(
                        child: Column(children: [
                      ListTile(
                        title: Text(
                          "Description",
                        ),
                        subtitle: FutureBuilder<
                            DocumentSnapshot<Map<String, dynamic>>>(
                          future: FirebaseFirestore.instance
                              .collection('victims')
                              .doc(user.uid)
                              .get(),
                          builder: (_, snapshot) {
                            if (snapshot.hasData) {
                              var data = snapshot.data!.data();
                              var description = data!['description'];
                              return Text(description);
                            }
                            return Text("No Description");
                          },
                        ),
                      ),
                      ListTile(
                        title: Text(
                          "Phone Number",
                        ),
                        subtitle: FutureBuilder<String>(
                          future: null,
                          builder: (BuildContext context,
                              AsyncSnapshot<String> snapshot) {
                            return Text(
                              'Phone Not Found',
                            );
                          },
                        ),
                      ),
                    ])),
                    ElevatedButton(
                      onPressed: () {
                        FirebaseFirestore.instance
                            .collection('victims')
                            .doc(user.uid)
                            .update({'status': false});
                      },
                      child: Text("Already Safe"),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<FirebaseAuthMethods>().user;
    final _victims = Provider.of<List<Victim>>(context);
    var userLocation = Provider.of<UserLocation>(context);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Need Help'),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return SizedBox(
                  height: constraints.maxHeight / 1.8,
                  child: showMap(context),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(
                          context,
                          MaterialPageRoute(
                              builder: (context) => shelterList()),
                        );
                      },
                      child: Text("Find Nearest Shelter")),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        onPressed: () {}, child: Text("Turn On Live Location")),
                  )
                ],
              ),
            ),
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                for (var victim in _victims) {
                  if (victim.userId == user.uid) {
                    if (victim.status == true) {
                      return secondBottomSheet(user, userLocation, _victims);
                    }
                  }
                  return bottomsheet(user, userLocation);
                }
                ;
                return bottomsheet(user, userLocation);
              },
            ),
          ],
        ));
  }
}
