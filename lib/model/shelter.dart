import 'package:cloud_firestore/cloud_firestore.dart';

class Shelter {
  final String userid;
  final String shelterId;
  final String name;
  final GeoPoint location;
  final String phone;
  final String description;
  late final bool status;

  final List<dynamic> benefit;

  Shelter({
    required this.userid,
    required this.shelterId,
    required this.name,
    required this.location,
    required this.phone,
    required this.description,
    required this.status,
    required this.benefit,
  });

  factory Shelter.fromDocument(QueryDocumentSnapshot doc) {
    return Shelter(
      userid: doc.data().toString().contains('userid') ? doc.get('userid') : '',
      shelterId: doc.data().toString().contains('shelterId')
          ? doc.get('shelterId')
          : '',
      name: doc.data().toString().contains('name') ? doc.get('name') : '',
      location:
          doc.data().toString().contains('location') ? doc.get('location') : '',
      phone: doc.data().toString().contains('phone') ? doc.get('phone') : '',
      description: doc.data().toString().contains('description')
          ? doc.get('description')
          : '',
      status: doc.data().toString().contains('status') ? doc.get('status') : '',
      benefit:
          doc.data().toString().contains('benefit') ? doc.get('benefit') : '',
    );
  }

  Map<String, dynamic> toMap(context) {
    return {
      'userid': userid,
      'shelterId': shelterId,
      'name': name,
      'location': location,
      'phone': phone,
      'description': description,
      'status': status,
      'benefit': benefit,
    };
  }
}
