import 'package:dio/dio.dart';

String errorMessage(Object error) {
  if (error is DioException) {
    final data = error.response?.data;
    if (data is Map && data['error'] != null) {
      return data['error'].toString();
    }
    return 'Network error, please try again';
  }
  return 'Something went wrong';
}
