import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:simple_ripple_animation/simple_ripple_animation.dart';
import 'package:spot_me/service/firebase_authentication.dart';
import 'package:spot_me/service/location.dart';
import 'package:spot_me/view/map.dart';
import 'package:spot_me/widget/showMap.dart';
import 'package:spot_me/widget/showSnackBar.dart';
import 'package:spot_me/model/userLocation.dart';

class helpForm extends StatefulWidget {
  const helpForm({super.key});

  @override
  State<helpForm> createState() => _helpFormState();
}

class _helpFormState extends State<helpForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _description = TextEditingController();
  final TextEditingController _numberOfVictims = TextEditingController();
  final TextEditingController _address = TextEditingController();
  late String _name;
  late LatLng _location;
  late int _phoneNumber;
  bool _status = true;

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
          FirebaseFirestore.instance.collection("victims").add({
            'description': _description.text,
            'name': user.displayName,
            'userid': user.uid,
            'phoneNumb': user.phoneNumber,
            'status': true,
            'numberOfVictim': _numberOfVictims.text,
            'location': GeoPoint(userLocation.latitude, userLocation.longitude),
            'time': Timestamp.now(),
          });
          showSuccessSnackBar(context, "Your Request Has Been Sent");
          Navigator.pop(context);
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
            controller: scrollController,
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
                              return 'Please enter your shelter name';
                            }
                            return null;
                          }),
                      SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                          controller: _numberOfVictims,
                          maxLines: 1,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'How many People with you?',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your shelter name';
                            }
                            return null;
                          }),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          showAlertDialogSubmit(context, userLocation);
                        },
                        child: Text("Submit Your Request"),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50), // NEW
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

  @override
  Widget build(BuildContext context) {
    final _user = context.read<FirebaseAuthMethods>().user;
    var userLocation = Provider.of<UserLocation>(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Request Help'),
          centerTitle: true,
        ),
        body: Stack(
          children: [Map(context), bottomsheet(_user, userLocation)],
        ));
  }
}
