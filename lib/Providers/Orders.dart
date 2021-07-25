import 'dart:convert';

import 'package:ecommerce_max_app/Providers/Cart.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Order {
  final String id;
  final double total;
  final DateTime date;
  final List<CartItem> carts;

  Order({
    @required this.id,
    @required this.total,
    @required this.date,
    @required this.carts,
  });
}

class Orders with ChangeNotifier {
  Orders(
    this.tokenId,
    this._orders,
    this.userId,
  );

  List<Order> _orders = [];
  final String tokenId;

  final String userId;

  List<Order> get orders {
    return [..._orders];
  }

  Future<void> addOrderItem(
      DateTime dateTime, List<CartItem> carts, double total) async {
    final url =
        'https://fire-base-test1-c4791.firebaseio.com/orders/$userId.json?auth=$tokenId';
    String time = dateTime.toIso8601String();
    _orders = [];
    print("add order");
    try {
      var res = await http.post(url,
          body: json.encode({
            "id": time,
            "total": total,
            "date": time,
            "carts": carts
                .map((cart) => {
                      "id": cart.id,
                      "title": cart.title,
                      "quantity": cart.quantity,
                      "price": cart.price,
                    })
                .toList(),
          }));
      String id = json.decode(res.body)["name"];
      final url2 =
          'https://fire-base-test1-c4791.firebaseio.com/orders/$userId/$id.json';

      await http.patch(url2,
          body: json.encode({
            "id": json.decode(res.body)["name"],
          }));

      _orders.add(Order(
          id: json.decode(res.body)["name"],
          total: total,
          date: dateTime,
          carts: carts));
      notifyListeners();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> fetchDataOrders() async {
    final url =
        'https://fire-base-test1-c4791.firebaseio.com/orders/$userId.json?auth=$tokenId';
    final response = await http.get(url);
    //  Map<String, dynamic> orders = {};
    Map<String, dynamic> orders =
        json.decode(response.body) as Map<String, dynamic>;

    if (orders == null) {
      return;
    }

    List<Order> ordersList = [];
    orders.forEach((key, order) {
      ordersList.add(Order(
          id: key,
          total: order["total"],
          date: DateTime.parse(order["date"]),
          carts: (order["carts"] as List<dynamic>)
              .map((cart) => CartItem(
                  id: cart["id"],
                  title: cart["title"],
                  price: cart["price"],
                  quantity: cart["quantity"]))
              .toList()));
    });

    _orders = ordersList.reversed.toList();
    notifyListeners();
  }
}
