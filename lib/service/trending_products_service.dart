import 'dart:convert';

import 'package:assignment/service/base_service.dart';
import 'package:http/http.dart' as http;

class TrendingProductsService extends BaseService{
  @override
  Future getResponse([data]) async {
    dynamic responseJson;

    try {
      Map<String, dynamic> mapData = <String, dynamic>{};
      mapData = data as Map<String, dynamic>;

      print("dadadad: ${Uri.https(baseUrl, '/products', {'skip': '${mapData['skip']}', 'limit': '${mapData['limit']}'})}");
      var uri = Uri.https(baseUrl, '/products', {'skip': '${mapData['skip']}', 'limit': '${mapData['limit']}'});
      var response = await http.get(uri);
      responseJson = jsonDecode(response.body);
    } on Exception catch (e) {
      throw (e.toString());
    }
    return responseJson;
  }

}