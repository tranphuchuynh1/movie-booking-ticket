
import 'package:json_annotation/json_annotation.dart';
part 'register_model.g.dart';

@JsonSerializable()
class RegisterModel {
  final String userName;

  final String email;

  final String password;

  final String confirmPassword;

  RegisterModel({
   required this.userName,
    required this.email,
    required this.password,
    required this.confirmPassword
});

  factory RegisterModel.fromJson(Map<String, dynamic>json) => _$RegisterModelFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterModelToJson(this);

}