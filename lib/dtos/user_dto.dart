import '../models/user.dart';

class UserDto {
  final String uid;
  final String fullName;
  final String emailAddress;

  UserDto({
    required this.uid,
    required this.fullName,
    required this.emailAddress,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) => UserDto(
    uid: json['uid'] as String,
    fullName: json['full_name'] as String,
    emailAddress: json['email_address'] as String,
  );

  User toModel() => User(id: uid, name: fullName, email: emailAddress);
}
