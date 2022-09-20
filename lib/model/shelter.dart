import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart';

class Shelter {
  //final String id;
  final String name;
  //final LatLng location;
  final String phone;
  final String description;
  final bool status;
  final List<dynamic> benefit;

  Shelter(
      { //required this.id,
      required this.name,
      //required this.location,
      required this.phone,
      required this.description,
      required this.status,
      required this.benefit});

  factory Shelter.fromMap(Map<String, dynamic> data) {
    return Shelter(
        //id: data['id'],
        name: data['name'],
        //location: data['location'],
        phone: data['phone'],
        description: data['description'],
        status: data['status'],
        benefit: data['benefit']);
  }
}
