import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:spot_me/service/firebase_authentication.dart';
import 'package:spot_me/view/map.dart';
import 'package:spot_me/widget/showMap.dart';
import 'package:spot_me/widget/showSnackBar.dart';

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
  final int _timestamp = DateTime.now().millisecondsSinceEpoch;

  bottomsheet(_user) {
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
              Center(
                  child: MaterialButton(
                onPressed: () {},
                height: 5,
                color: Color.fromARGB(255, 241, 240, 240),
                elevation: 0.5,
              )),
              Padding(
                padding: EdgeInsets.all(16),
                child: Form(
                  child: Column(
                    children: [
                      TextFormField(
                        enabled: false,
                        controller: _address,
                        maxLines: 1,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Address',
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
                          hintText: 'Describe your situation or your location',
                        ),
                      ),
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
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        onPressed: () {},
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
    return Scaffold(
        appBar: AppBar(
          title: const Text('Request Help'),
          centerTitle: true,
        ),
        body: Stack(
          children: [Map(context), bottomsheet(_user)],
        ));
  }
}
