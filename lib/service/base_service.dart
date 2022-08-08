abstract class BaseService {
  String baseUrl = 'dummyjson.com';
  Future<dynamic> getResponse([dynamic data]);
}