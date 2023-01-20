import 'package:cloud_firestore/cloud_firestore.dart';

class Victim {
  final String userId;
  final String name;
  final String numberOfVictim;
  final String description;
  final String phoneNumb;
  final String imageUrl;
  final bool status;
  final Timestamp time;

  final GeoPoint location;

  const Victim({
    required this.userId,
    required this.name,
    required this.numberOfVictim,
    required this.description,
    required this.phoneNumb,
    required this.imageUrl,
    required this.status,
    required this.time,
    required this.location,
  });

  factory Victim.fromMap(Map<dynamic, dynamic> map) {
    return Victim(
      userId: map['userid'] ?? '',
      name: map['name'] ?? '',
      numberOfVictim: map['numberOfVictim'] ?? '',
      description: map['description'] ?? '',
      phoneNumb: map['phoneNumb'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      status: map['status'] ?? '',
      time: map['time'] ?? '',
      location: map['location'] ?? '',
    );
  }
}
