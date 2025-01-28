import 'package:dio/dio.dart';
import 'package:dio_refresh/dio_refresh.dart';

class AuthService {
  static final dio = Dio(BaseOptions(
    baseUrl: 'https://kene.pythonanywhere.com/api/v1',
    validateStatus: (status) => status != 401,
  ))
    ..interceptors.addAll([
      DioRefreshInterceptor(
        tokenManager: TokenManager.instance,
        authHeader: (tokenStore) {
          if (tokenStore.accessToken == null) return {};
          return {'Authorization': 'Bearer ${tokenStore.accessToken}'};
        },
        shouldRefresh: (response) {
          return response?.statusCode == 401;
        },
        onRefresh: (dio, tokenStore) async {
          final response = await dio.post('/auth/refresh');
          return TokenStore(
            accessToken: response.data['access_token'],
            refreshToken: response.data['refresh_token'],
          );
        },
      ),
    ]);
}
