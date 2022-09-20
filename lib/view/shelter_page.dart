import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:latlong2/latlong.dart';

class shelter_page extends StatefulWidget {
  const shelter_page({super.key});

  @override
  State<shelter_page> createState() => _shelter_pageState();
}

class _shelter_pageState extends State<shelter_page> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _shelterName = TextEditingController();
  final TextEditingController _latitude = TextEditingController();
  final TextEditingController _longitude = TextEditingController();
  final TextEditingController _phoneNumber = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final List<String> benefit = [];
  final TextEditingController _location = TextEditingController();
  bool _isMeals = false;
  bool _isClothing = false;
  bool _isMedicine = false;

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
          _latitude.clear();
          _longitude.clear();
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
        // Validate returns true if the form is valid, or false otherwise.
        if (_formKey.currentState!.validate()) {
          FirebaseFirestore.instance.collection("shelters").add({
            'name': _shelterName.text,
            'phone': _phoneNumber.text,
            'description': _description.text,
            'benefit': benefit,
            'status': false,
            'location': GeoPoint(1, 2),
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Processing Data')),
          );
        }
        Navigator.pop(context);
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Register Your Shelter'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Form(
                key: _formKey,
                child: Column(
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
                    TextFormField(
                      controller: _location,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Address',
                      ),
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your shelter location';
                        }
                        return null;
                      },
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
                      keyboardType: TextInputType.multiline,
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
                          child: const Text('Submit'),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            showAlertDialogCancel(context);
                          },
                          child: const Text('Cancel'),
                        ),
                      ],
                    ),
                  ],
                )),
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
