import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:spot_me/service/firebase_authentication.dart';
import 'package:spot_me/service/location.dart';
import '../../model/userLocation.dart';
import '../../widget/showSnackBar.dart';
import 'package:geolocator/geolocator.dart';

class shelter_page extends StatefulWidget {
  const shelter_page({super.key});

  @override
  State<shelter_page> createState() => _shelter_pageState();
}

class _shelter_pageState extends State<shelter_page> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _shelterName = TextEditingController();
  final TextEditingController _location = TextEditingController();
  final TextEditingController _phoneNumber = TextEditingController();
  final TextEditingController _description = TextEditingController();
  late double _latitude;
  late double _longitude;
  final List<String> benefit = [];
  bool _isMeals = false;
  bool _isClothing = false;
  bool _isMedicine = false;
  String _output = '';

  List<CheckBoxListTileModel> checkBoxListTileModel =
      CheckBoxListTileModel.getUsers();

  spaceBox() {
    return SizedBox(
      height: 9,
    );
  }

  void itemChange(bool val, int index) {
    setState(() {
      checkBoxListTileModel[index].isCheck = val;
    });
  }

  showAlertDialogCancel(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
        print(benefit);
      },
    );
    Widget continueButton = TextButton(
      child: Text("Continue"),
      onPressed: () {
        setState(() {
          _shelterName.clear();
          _phoneNumber.clear();
          _description.clear();
          _isMeals = false;
          _isClothing = false;
          _isMedicine = false;
          Navigator.pop(context);
        });
        Navigator.pop(context);
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Back To Homepage"),
      content: Text("Are you sure you want to leave this page without save?"),
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

  showAlertDialogSubmit(BuildContext context) {
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
        final userid = context.read<FirebaseAuthMethods>().user.uid;
        if (_formKey.currentState!.validate()) {
          FirebaseFirestore.instance.collection("shelters").add({
            'userid': userid,
            'name': _shelterName.text,
            'phone': _phoneNumber.text,
            'description': _description.text,
            'benefit': benefit,
            'status': true,
            'address': true,
            'location': GeoPoint(_latitude, _longitude),
          });
          showSuccessSnackBar(context, "Successfully Add Shelter");
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

  @override
  Widget build(BuildContext context) {
    var userLocation = Provider.of<UserLocation>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Register Shelter'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.close_sharp,
              color: Colors.white,
            ),
            onPressed: () {
              showAlertDialogCancel(context);
            },
          )
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Container(
                padding: EdgeInsets.all(15.0),
                child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        TextFormField(
                          controller: _shelterName,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            label: Text('Name'),
                            hintText: 'Your Shelter Name',
                          ),
                          // The validator receives the text that the user has entered.
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your shelter name';
                            }
                            return null;
                          },
                        ),
                        spaceBox(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: TextFormField(
                                controller: _location,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  label: Text('Address'),
                                  hintText: 'Address',
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your shelter name';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Container(
                              height: 55,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                  color: Color.fromARGB(255, 161, 161, 161),
                                ),
                              ),
                              child: IconButton(
                                icon: Icon(
                                  Icons.my_location,
                                  color: Color.fromARGB(255, 99, 99, 99),
                                ),
                                onPressed: () async {
                                  final address = await getCoordinateToAddress(
                                      userLocation.latitude,
                                      userLocation.longitude);

                                  setState(() {
                                    _latitude = userLocation.latitude;
                                    _longitude = userLocation.longitude;
                                    print(_latitude);
                                    print(_longitude);
                                    _location.text = address;
                                  });
                                },
                              ),
                            )
                          ],
                        ),
                        spaceBox(),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                          ],
                          controller: _phoneNumber,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Phone Number',
                          ),
                          // The validator receives the text that the user has entered.
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your phone number';
                            }
                            return null;
                          },
                        ),
                        spaceBox(),
                        TextFormField(
                          controller: _description,

                          minLines: 1, //Normal textInputField will be displayed
                          maxLines: 5,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Description',
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          child: Column(
                            children: [
                              Text("What Your Shelther Provide?"),
                              CheckboxListTile(
                                  title: Text('Meals'),
                                  value: this._isMeals,
                                  onChanged: (value) {
                                    setState(() => _isMeals = value!);
                                    value == true
                                        ? benefit.add("Meals")
                                        : benefit.remove("Meals");
                                  }),
                              CheckboxListTile(
                                  title: Text('Clothing'),
                                  value: this._isClothing,
                                  onChanged: (value) {
                                    setState(() => _isClothing = value!);
                                    value == true
                                        ? benefit.add("Clothing")
                                        : benefit.remove("Clothing");
                                  }),
                              CheckboxListTile(
                                  title: Text('Medicine'),
                                  value: this._isMedicine,
                                  onChanged: (value) {
                                    setState(() => _isMedicine = value!);
                                    value == true
                                        ? benefit.add("Medicine")
                                        : benefit.remove("Medicine");
                                  })
                            ],
                          ),
                        ),
                        spaceBox(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                showAlertDialogSubmit(context);
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 123.0),
                                child: Text(
                                  "Confirm",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15.0,
                                      fontFamily: "WorkSansBold"),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CheckBoxListTileModel {
  int userId;
  String img;
  String title;
  bool isCheck;

  CheckBoxListTileModel(
      {required this.userId,
      required this.img,
      required this.title,
      required this.isCheck});

  static List<CheckBoxListTileModel> getUsers() {
    return <CheckBoxListTileModel>[
      CheckBoxListTileModel(
          userId: 1,
          img: 'assets/images/android_img.png',
          title: "Android",
          isCheck: true),
      CheckBoxListTileModel(
          userId: 2,
          img: 'assets/images/flutter.jpeg',
          title: "Flutter",
          isCheck: false),
      CheckBoxListTileModel(
          userId: 3,
          img: 'assets/images/ios_img.webp',
          title: "IOS",
          isCheck: false),
      CheckBoxListTileModel(
          userId: 4,
          img: 'assets/images/php_img.png',
          title: "PHP",
          isCheck: false),
      CheckBoxListTileModel(
          userId: 5,
          img: 'assets/images/node_img.png',
          title: "Node",
          isCheck: false),
    ];
  }
}
