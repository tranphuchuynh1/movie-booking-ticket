import 'package:json_annotation/json_annotation.dart';
part 'base_response.g.dart';

@JsonSerializable(
  genericArgumentFactories: true,
  explicitToJson: true
)

class BaseResponse<T> {
  final bool? success;
  final String? message;
  final String? error;
  final int? page;
  final int? pageSize;
  final int? totalCount;
  final int? totalPages;
  final T? data;

  BaseResponse({
    required this.success,
    required this.message,
    required this.error,
    required this.page,
    required this.pageSize,
    required this.totalCount,
    required this.totalPages,
    required this.data
  });

  factory BaseResponse.fromJson(
      Map<String, dynamic> json,
      T Function(Object? json) fromJsonT) => _$BaseResponseFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object Function(T value) toJsonT) => _$BaseResponseToJson(this, toJsonT);

}
