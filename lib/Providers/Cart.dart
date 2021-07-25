import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    @required this.id,
    @required this.title,
    @required this.price,
    @required this.quantity,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _carts = {};

  Map<String, CartItem> get carts {
    return {..._carts};
  }

  void add_cart(String productId, String title, double price) {
    if (_carts.containsKey(productId)) {
      //update quntity
      _carts.update(
          productId,
          (currentItem) => CartItem(
                id: currentItem.id,
                title: currentItem.title,
                price: currentItem.price,
                quantity: currentItem.quantity + 1,
              ));
    } else {
      _carts.putIfAbsent(
          productId,
          () => CartItem(
                id: DateTime.now().toString(),
                title: title,
                price: price,
                quantity: 1,
              ));
    }
    notifyListeners();
  }

  double getTotalPrice() {
    double total = 0;
    _carts.forEach((key, cartItem) {
      total += (cartItem.price * cartItem.quantity);
    });

    return total;
  }

  int cartLenght() {
    return _carts.length;
  }

  void deleteCatItem(String productId) {
    _carts.remove(productId);
    notifyListeners();
  }

  void clearCarts() {
    _carts = {};
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_carts.containsKey(productId)) {
      return;
    } else if (_carts[productId].quantity > 1) {
      print("more than 1");
      _carts.update(
          productId,
          (item) => CartItem(
                id: item.id,
                title: item.title,
                price: item.price,
                quantity: item.quantity - 1,
              ));
    } else if (_carts[productId].quantity == 1) {
      _carts.remove(productId);
    }

    notifyListeners();
  }
}
