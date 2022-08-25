import 'dart:async';

import 'package:assignment/product_detail.dart';
import 'package:assignment/service/apiresponse.dart';
import 'package:assignment/utils/check_network.dart';
import 'package:assignment/viewmodel/trending_products_viewmodel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'model/trending_products.dart';
import 'utils/database_helper.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() {
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<MyHomePage> {
  int _page = 0;
  final int _limit = 10;
  bool _hasNextPage = true;
  bool _isFirstLoadRunning = false;
  bool _isLoadMoreRunning = false;
  late List<Products> _products;
  late ScrollController _controller;
  TrendingProductsViewModel trendingProductViewModel =
      TrendingProductsViewModel();
  late ApiResponse _apiResponse;
  Map<String, dynamic> mapData = <String, dynamic>{};
  final dbHelper = DatabaseHelper.instance;
  bool isConnected = false;

  @override
  void initState() {
    super.initState();
    Timer timer = Timer.periodic(Duration(seconds: 5), (timer) {
      NetworkCheck().check().then((value) {
        if(value){
          isConnected = true;
        } else {
          isConnected = false;
        }
      });
    });
    setState((){
      timer;
    });
    _firstLoad();
    _controller = ScrollController()..addListener(_loadMore);

  }

  @override
  void dispose() {
    _controller.removeListener(_loadMore);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assignment'),
      ),
      body: _isFirstLoadRunning
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FutureBuilder(
                      future: dbHelper.getProductList(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData || isConnected == true) {
                          List<Products> productList =
                              snapshot.data as List<Products>;
                          if(productList != null){
                            return ListView.builder(
                              controller: _controller,
                              itemCount: productList.length,
                              itemBuilder: (_, index) {
                                return Card(
                                  child: ListTile(
                                    onTap: (() {
                                      Navigator.push(
                                        context,
                                        PageRouteBuilder(
                                          transitionsBuilder: (context, animation,
                                              secondaryAnimation, child) {
                                            return ScaleTransition(
                                              alignment: Alignment.center,
                                              scale: Tween<double>(
                                                  begin: 0.1, end: 1)
                                                  .animate(
                                                CurvedAnimation(
                                                  parent: animation,
                                                  curve: Curves.bounceIn,
                                                ),
                                              ),
                                              child: child,
                                            );
                                          },
                                          transitionDuration:
                                          const Duration(seconds: 1),
                                          pageBuilder: (BuildContext context,
                                              Animation<double> animation,
                                              Animation<double>
                                              secondaryAnimation) {
                                            return ProductDetail(
                                              productList: productList,
                                              index: index,
                                            );
                                          },
                                        ),
                                      );
                                    }),
                                    leading: SizedBox(
                                        height: 100,
                                        width: 100,
                                        child: CachedNetworkImage(
                                            placeholder: (context, url) {
                                              return const SizedBox(
                                                  height: 10.0,
                                                  width: 10.0,
                                                  child: CircularProgressIndicator());
                                            },
                                            errorWidget: (context, url, error) => const Icon(Icons.error),
                                            imageUrl: productList[index].thumbnail!)),
                                    title: Text(productList[index].title!),
                                    subtitle: Text(
                                        productList[index].description!,
                                        maxLines: 2),
                                    trailing: Text(
                                      '\$${productList[index].price!}',
                                      textScaleFactor: 1.5,
                                      style: const TextStyle(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                          else {
                           return const SizedBox.shrink();
                          }
                        } else {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: const [
                              Icon(Icons.wifi_off_outlined, size: 24),
                              SizedBox(width: 20.0,),
                              Expanded(
                                child: Text("You are not connected to internet. Failed to load data"),
                              ),
                            ],
                          );
                        }
                      },
                    ),
                  ),
                ),
                if (_isLoadMoreRunning == true)
                  const Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 40),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                if (_hasNextPage == false)
                  Container(
                    padding: const EdgeInsets.only(top: 20, bottom: 20),
                    color: Colors.blue,
                    child: const Center(
                      child: Text(
                        'You have fetched all of the content',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
              ],
            ),
    );
  }

  void _firstLoad() async {
    setState(() {
      _isFirstLoadRunning = true;
    });
    try {
      mapData['limit'] = 100;
      mapData['skip'] = _page;
      _apiResponse = await trendingProductViewModel
          .fetchTrendingProductsViewModel(mapData);

      TrendingProducts trendingProducts = _apiResponse.data;

      setState(() {
        _products = trendingProducts.products!;
      });
      for (int i = 0; i < _products.length; i++) {
        Products product = Products(
            id: _products[i].id,
            title: _products[i].title,
            description: _products[i].description,
            price: _products[i].price,
            rating: _products[i].rating,
            brand: _products[i].brand,
            category: _products[i].category,
            thumbnail: _products[i].thumbnail);
        dbHelper.insertProduct(product);
      }

    } catch (err) {
      if (kDebugMode) {
        print('Something went wrong');
      }
    }

    setState(() {
      _isFirstLoadRunning = false;
    });
  }

  void _loadMore() async {
    if (_hasNextPage == true &&
        _isFirstLoadRunning == false &&
        _isLoadMoreRunning == false &&
        _controller.position.extentAfter < 300) {
      setState(() {
        _isLoadMoreRunning = true;
      });
      try {
        mapData['limit'] = _limit;
        _page += 10;
        mapData['skip'] = _page;
        _apiResponse = await trendingProductViewModel
            .fetchTrendingProductsViewModel(mapData);

        TrendingProducts trendingProducts = _apiResponse.data;

        final List<Products> fetchedPosts = trendingProducts.products!;
        if (fetchedPosts.isNotEmpty) {
          setState(() {
            _products.addAll(fetchedPosts);
          });
        } else {
          setState(() {
            _hasNextPage = false;
            for (int i = 0; i < _products.length; i++) {
              Products product = Products(
                  id: _products[i].id,
                  title: _products[i].title,
                  description: _products[i].description,
                  price: _products[i].price,
                  rating: _products[i].rating,
                  brand: _products[i].brand,
                  category: _products[i].category,
                  thumbnail: _products[i].thumbnail);
              dbHelper.insertProduct(product);
            }
          });
        }
      } catch (err) {
        if (kDebugMode) {
          print('Something went wrong!');
        }
      }
      setState(() {
        _isLoadMoreRunning = false;
      });
    }
    _query();
  }

  void _query() async {
    final allRows = await dbHelper.queryAllRows();
    print('query all rows:');
    allRows.forEach(print);
  }

  void _deleteAll() async {
    final rowsDeleted = await dbHelper.deleteAllProducts();
    print('deleted $rowsDeleted');
  }
}
