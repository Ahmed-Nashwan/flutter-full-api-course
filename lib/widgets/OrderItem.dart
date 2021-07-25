import 'package:ecommerce_max_app/Providers/Cart.dart';
import 'package:flutter/material.dart';

class OrderItem extends StatelessWidget {
  final double total;
  final String date;
  final List<CartItem> carts;

  // final int quntity;
  // final double price;

  OrderItem(
      {@required this.total,
      @required this.date,
      // @required this.price,
      // @required this.quntity,
      @required this.carts});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
          margin: EdgeInsets.all(15),
          child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 15,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(total.toString()+"\$"),
                  Text(date),
                  Column(
                    children: carts
                        .map((e) => Row(
                              children: [
                                Text(e.title),
                                Spacer(),
                                Text('${e.quantity}* \$${e.price}'),
                              ],
                            ))
                        .toList(),
                  ),
                ],
              ))),
    );
  }
}
//
// Card(
// margin: EdgeInsets.all(15),
// child: Padding(
// padding: EdgeInsets.symmetric(horizontal: 10),
// child:
