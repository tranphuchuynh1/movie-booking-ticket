import '../core/models/base_response.dart';

T handleResponse<T>(BaseResponse<T> response) {
  if (response.success ?? false) {
    if (null is T) {
      return response.data as T;
    }
    if (response.data == null) {
      throw Exception("Expect response.data is not null");
    }
    return response.data!;
  } else {
    final error = response.error;
    if (error != null) {
      throw Exception(error);
    } else {
      throw Exception("Expect response.error is not null");
    }
  }
}
