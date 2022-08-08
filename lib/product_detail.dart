import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'model/trending_products.dart';

class ProductDetail extends StatefulWidget {
  late List<Products> productList;
  late int index;

  ProductDetail({Key? key, required this.productList, required this.index})
      : super(key: key);

  @override
  State<ProductDetail> createState() => ProductDetailState();
}

class ProductDetailState extends State<ProductDetail> {
  var isFavourite = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Product Detail'),
        ),
      body: SafeArea(
        child: Column(
          children: [
            header(),
            hero(),
            Expanded(child: section()),
          ],
        ),
      ),
    );
  }

  Widget header() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.productList[widget.index].brand!,
                    style: const TextStyle(fontWeight: FontWeight.w100, fontSize: 16)),
                Text(widget.productList[widget.index].title!,
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 22), maxLines: 1,
                  overflow: TextOverflow.ellipsis,)
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget hero() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          SizedBox(
            height: 200,
            width: double.infinity,
            child: Image.network(widget.productList.elementAt(widget.index).thumbnail!),
          ),
          Positioned(
            bottom: 10,
              right: 20,
              child: FloatingActionButton(
                backgroundColor: Colors.white,
                onPressed: () {
                  setState(() {
                    isFavourite = !isFavourite;
                  });
                },
                child: Icon(
                  isFavourite ? Icons.favorite : Icons.favorite_border,
                  color: Colors.grey[700],
                  size: 34,
                ),
              ))
        ],
      ),
    );
  }

  Widget section() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              widget.productList[widget.index].description!,
              textAlign: TextAlign.justify,
              style: const TextStyle(
                  color: Color(0xFF6F8398), fontSize: 14, height: 1.5),
              maxLines: 4,
            ),
          ),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text('Rating', style: TextStyle(color: Colors.grey, fontSize: 10.0),)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RatingBar.builder(
                initialRating:
                    widget.productList[widget.index].rating!.toDouble(),
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemSize: 30.0,
                /*itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),*/
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.blueAccent,
                ),
                onRatingUpdate: (rating) {
                  print(rating);
                },
              ),
              Text('\$${widget.productList[widget.index].price!}',
                  style: const TextStyle(
                      fontWeight: FontWeight.w400, fontSize: 28)),
            ],
          ),
        ],
      ),
    );
  }
}
