import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {

  final String? userId;

  final String? userName;

  final String? email;

  final String? fullName;

  final String? avatarUrl;

  final String? phoneNumber;

  final String? jwtToken;

  final String? expireTime;

  UserModel({
   this.userId,
    this.userName,
    this.email,
    this.fullName,
    this.avatarUrl,
    this.phoneNumber,
    this.jwtToken,
    this.expireTime,
  });

  factory UserModel.fromJson(Map<String, dynamic>json) => _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  bool get isTokenValid {
    if (expireTime == null || jwtToken == null) return false;

    final expireDate = DateTime.parse(expireTime!);
    return expireDate.isAfter(DateTime.now());
  }
}