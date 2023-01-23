import 'package:cloud_firestore/cloud_firestore.dart';

class Contact {
  final String contactId;
  final String name;
  final String phoneNumber;

  const Contact({
    required this.contactId,
    required this.name,
    required this.phoneNumber,
  });

  factory Contact.fromDocument(QueryDocumentSnapshot doc) {
    return Contact(
      contactId: doc.data().toString().contains('contactId')
          ? doc.get('contactId')
          : '',
      name: doc.data().toString().contains('name') ? doc.get('name') : '',
      phoneNumber: doc.data().toString().contains('phoneNumber')
          ? doc.get('phoneNumber')
          : '',
    );
  }

  Map<String, dynamic> toMap(context) {
    return {
      'contactId': contactId,
      'name': name,
      'phoneNumber': phoneNumber,
    };
  }
}
