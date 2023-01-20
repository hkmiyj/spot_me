class User {
  final String userId;
  final String nickname;
  final String email;
  final int phoneNumb;

  const User({
    required this.userId,
    required this.nickname,
    required this.email,
    required this.phoneNumb,
  });

  factory User.fromMap(Map<dynamic, dynamic> map) {
    return User(
      userId: map['userid'] ?? '',
      nickname: map['name'] ?? '',
      email: map['numberOfVictim'] ?? '',
      phoneNumb: map['phoneNumb'] ?? '',
    );
  }
}
