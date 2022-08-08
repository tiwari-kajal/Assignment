import 'package:assignment/model/trending_products.dart';
import 'package:assignment/service/base_service.dart';
import 'package:assignment/service/trending_products_service.dart';

class TrendingProductsRepository {
  final BaseService _trendingProductsService = TrendingProductsService();

  Future<TrendingProducts> fetchTrendingProducts(Map<String, dynamic> data) async {
   dynamic response = await _trendingProductsService.getResponse(data);
   return TrendingProducts.fromJson(response);
  }
}