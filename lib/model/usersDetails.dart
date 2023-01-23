import 'package:cloud_firestore/cloud_firestore.dart';

class usersDetails {
  final String userId;
  final String nickname;
  final String email;
  final int phoneNumb;

  usersDetails({
    required this.userId,
    required this.nickname,
    required this.email,
    required this.phoneNumb,
  });

  factory usersDetails.fromDocument(QueryDocumentSnapshot doc) {
    return usersDetails(
      userId: doc.data().toString().contains('userId') ? doc.get('userId') : '',
      nickname:
          doc.data().toString().contains('nickname') ? doc.get('nickname') : '',
      email: doc.data().toString().contains('email') ? doc.get('email') : '',
      phoneNumb: doc.data().toString().contains('phoneNumb')
          ? doc.get('phoneNumb')
          : '',
    );
  }

  Map<String, dynamic> toMap(context) {
    return {
      'email': email,
      'userId': userId,
      'nickname': nickname,
      'phoneNumb': phoneNumb,
    };
  }
}
