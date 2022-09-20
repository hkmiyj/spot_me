import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class helpForm extends StatefulWidget {
  const helpForm({super.key});

  @override
  State<helpForm> createState() => _helpFormState();
}

class _helpFormState extends State<helpForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneNumber = TextEditingController();
  final TextEditingController _username = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Request Help'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _username,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'id',
                    ),
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextFormField(
                    controller: _phoneNumber,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Description',
                    ),
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        // Validate returns true if the form is valid, or false otherwise.
                        if (_formKey.currentState!.validate()) {
                          FirebaseFirestore.instance.collection("users").add({
                            'name': _username.text,
                            'phone': _phoneNumber.text,
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Processing Data')),
                          );
                        }
                      },
                      child: const Text('Submit'),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
