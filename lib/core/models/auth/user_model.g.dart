// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  userId: json['userId'] as String?,
  userName: json['userName'] as String?,
  email: json['email'] as String?,
  fullName: json['fullName'] as String?,
  avatarUrl: json['avatarUrl'] as String?,
  phoneNumber: json['phoneNumber'] as String?,
  jwtToken: json['jwtToken'] as String?,
  expireTime: json['expireTime'] as String?,
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'userId': instance.userId,
  'userName': instance.userName,
  'email': instance.email,
  'fullName': instance.fullName,
  'avatarUrl': instance.avatarUrl,
  'phoneNumber': instance.phoneNumber,
  'jwtToken': instance.jwtToken,
  'expireTime': instance.expireTime,
};
