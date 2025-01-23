import 'package:dio/dio.dart';

final dioService = Dio(BaseOptions(
  baseUrl: 'https://kene.pythonanywhere.com/api/v1',
))
  ..interceptors.add(
    InterceptorsWrapper(onRequest: _handleUserTokenOnRequest),
  );

String? token;

void _handleUserTokenOnRequest(
  RequestOptions options,
  RequestInterceptorHandler handler,
) {
  if (token?.isNotEmpty ?? false) {
    options.headers['AUTHORIZATION'] = 'Bearer $token';
  }
  return handler.next(options);
}
