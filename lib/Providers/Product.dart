import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String discription;
  final String imageUrl;
  final double price;
  bool isFivarites = false;

  Product({
    @required this.id,
    @required this.title,
    @required this.discription,
    @required this.price,
    @required this.imageUrl,
    this.isFivarites = false,
  });
//8b5f6409b4065b8e9ee94b3c7cb05fe1581043ee
  Future<void> changeStatusFevarites(String IdToken,String userId) async {
    isFivarites = !isFivarites;
    final isf = isFivarites;
    notifyListeners();
    final url =  'https://fire-base-test1-c4791.firebaseio.com/UserFavorites$userId/$id.json?auth=$IdToken';

    // Map<String,dynamic> map = {
    //   "isFivarites":isf,
    // };
    try {

  await  http.put(url,body: json.encode(isf));

// in patch and delete there is no error showed else if you check the status code if status code >=400 then u have error

    }catch(e){
      print(e.toString());
    }
  }

}
