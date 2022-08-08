import 'package:assignment/model/trending_products.dart';
import 'package:assignment/repository/trending_products_repo.dart';

import '../service/apiresponse.dart';

class TrendingProductsViewModel {
  static final TrendingProductsViewModel _singleton = TrendingProductsViewModel._internal();
  factory TrendingProductsViewModel() {
    return _singleton;
  }
  TrendingProductsViewModel._internal();

  ApiResponse _apiResponse = ApiResponse.initial('Empty Data');

  ApiResponse get response => _apiResponse;

  Future<ApiResponse> fetchTrendingProductsViewModel(Map<String, dynamic> data) async {
    try {
      TrendingProducts trendingProducts = await TrendingProductsRepository().fetchTrendingProducts(data);
      _apiResponse = ApiResponse.completed(trendingProducts);
    } on Exception catch (e) {
      _apiResponse = ApiResponse.error(e.toString());
    }
    return _apiResponse;
  }
}