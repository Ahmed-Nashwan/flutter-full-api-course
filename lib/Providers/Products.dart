import 'dart:convert';
import 'package:ecommerce_max_app/Providers/Product.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  final String tokenId;
  final String userId;



  Products(this.tokenId,this._products,this.userId);
  List<Product> _products = [

    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   discription: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //     id: 'p2',
    //     title: 'Trousers',
    //     discription: 'A nice pair of trousers.',
    //     price: 59.99,
    //     imageUrl:
    //         'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg')

  ];

  List<Product> get products {
    return [..._products];
    //this is a test commit1
    //this is a test commit2

  }



  List<Product> get favorites {
    return _products.where((element) => element.isFivarites).toList();
  }

  Future<void> fetchDataAndGet() async {
    final url =
        'https://fire-base-test1-c4791.firebaseio.com/products.json?auth=$tokenId&orderBy="userId"&equalTo="$userId"';
    try {
      var res = await http.get(url);
      List<Product> products = [];
      final map = json.decode(res.body) as Map<String, dynamic>;

      if (map == null) {
        return;
      }

      final url2 =  'https://fire-base-test1-c4791.firebaseio.com/UserFavorites$userId/.json?auth=$tokenId';

      var res2 =  await http.get(url2);

      final fiveritsData = json.decode(res2.body);

      map.forEach((key, value) {
        products.add(Product(
          id: key,
          title: value["title"],
          discription: value["discription"],
          price: value["price"],
          imageUrl: value["imageUrl"],
          isFivarites: fiveritsData==null ? false:fiveritsData[key]?? false,
        ));
      });

      _products = products;
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> addProduct(Product product) async {
    //  _products.add(value);
    try {
      final url = 'https://fire-base-test1-c4791.firebaseio.com/products.json?auth=$tokenId';

      var res = await http.post(url,
          body: json.encode({
            'id': product.id,
            'title': product.title,
            'discription': product.discription,
            'imageUrl': product.imageUrl,
            'isFivarites': product.isFivarites,
            'price': product.price,
            'userId':userId,
          }));

      product = Product(
        id: json.decode(res.body)["name"],
        title: product.title,
        discription: product.discription,
        imageUrl: product.imageUrl,
        price: product.price,
        isFivarites: product.isFivarites,
      );
      final url2 =
          'https://fire-base-test1-c4791.firebaseio.com/products/${product.id}.json?auth=$tokenId';
      await http.patch(url2,
          body: json.encode({
            'id': product.id,
          }));
      _products.add(product);
      notifyListeners();
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> updateProduct(String productId, Product newProduct) async {
    print(productId);
    if (productId != null) {
      final url =
          'https://fire-base-test1-c4791.firebaseio.com/products/$productId.json?auth=$tokenId';
      //final index = _products.indexWhere((element) => element.id == productId);

      print(url);
      await http.patch(url,
          body: json.encode({
            'id': newProduct.id,
            'title': newProduct.title,
            'price': newProduct.price,
          }));
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String productId) async {
    _products.removeWhere((element) => element.id == productId);
    final url =
        'https://fire-base-test1-c4791.firebaseio.com/products/$productId.json?auth=$tokenId';
    print(productId);
    if (productId != null) {
      await http.delete(
        url,
      );
      notifyListeners();
    }
  }

  Product findProduct(String id) {
    return _products.firstWhere((element) => element.id == id);
  }
}
