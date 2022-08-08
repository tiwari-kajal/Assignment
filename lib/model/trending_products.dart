class TrendingProducts {
  List<Products>? products;
  num? total;
  String? skip;
  num? limit;

  TrendingProducts({this.products, this.total, this.skip, this.limit});

  TrendingProducts.fromJson(Map<String, dynamic> json) {
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(Products.fromJson(v));
      });
    }
    total = json['total'];
    skip = json['skip'];
    limit = json['limit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (products != null) {
      data['products'] = products!.map((v) => v.toJson()).toList();
    }
    data['total'] = total;
    data['skip'] = skip;
    data['limit'] = limit;
    return data;
  }
}

class Products {
  num? id;
  String? title;
  String? description;
  num? price;
  num? rating;
  String? brand;
  String? category;
  String? thumbnail;

  Products(
      {this.id,
        this.title,
        this.description,
        this.price,
        this.rating,
        this.brand,
        this.category,
        this.thumbnail});

  Products.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    price = json['price'];
    rating = json['rating'];
    brand = json['brand'];
    category = json['category'];
    thumbnail = json['thumbnail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['price'] = price;
    data['rating'] = rating;
    data['brand'] = brand;
    data['category'] = category;
    data['thumbnail'] = thumbnail;
    return data;
  }
}
