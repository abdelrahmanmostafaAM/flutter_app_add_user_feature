import 'package:dio/dio.dart';

/// Interceptor لإضافة Authentication Token
/// سيتم تفعيله لاحقاً عند الحاجة
class AuthInterceptor extends Interceptor {
  // يمكن إضافة token هنا لاحقاً
  // String? _token;
  
  // void setToken(String token) {
  //   _token = token;
  // }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // إضافة token للـ headers
    // if (_token != null) {
    //   options.headers['Authorization'] = 'Bearer $_token';
    // }
    super.onRequest(options, handler);
  }
}

