import 'package:ecommerce_max_app/Providers/Cart.dart' as card;
import 'package:ecommerce_max_app/widgets/CartItem.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Providers/Orders.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
  bool isLoading ;
}

class _CartScreenState extends State<CartScreen> {

  @override
  void initState() {
    // TODO: implement initState
    widget.isLoading=false;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<card.Cart>(context);

    print(widget.isLoading);
    final order = Provider.of<Orders>(
      context,
      listen: false,
    );
    double totalPrice = cart.getTotalPrice();
    return Scaffold(
      appBar: AppBar(
        title: Text("Your cart"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.all(
              15,
            ),
            child: Card(
              child: Row(
                children: [
                  Text(
                    "Total",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                    ),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$$totalPrice',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  TextButton(
                      onPressed: totalPrice <= 0
                          ? null
                          : () async {
                        setState(() {
                          widget.isLoading = true;
                        });
                              await order
                                  .addOrderItem(
                                      DateTime.now(),
                                      cart.carts.values.toList(),
                                      cart.getTotalPrice())
                                  .then((_) => setState(() {
                                        widget.isLoading = false;
                                      }));

                              cart.clearCarts();
                            },
                      child: widget.isLoading
                          ? CircularProgressIndicator()
                          : Text(
                              "Order now",
                              style: TextStyle(
                                color: totalPrice <= 0
                                    ? Colors.black.withOpacity(.5)
                                    : Theme.of(context).primaryColor,
                              ),
                            ))
                ],
              ),
            ),
          ),
          Expanded(
              child: ListView.builder(
            itemBuilder: (context, pos) {
              return CartItem(
                id: cart.carts.values.toList()[pos].id,
                title: cart.carts.values.toList()[pos].title,
                price: cart.carts.values.toList()[pos].price,
                quantity: cart.carts.values.toList()[pos].quantity,
                proudctId: cart.carts.keys.toList()[pos],
                total: totalPrice,
              );
            },
            itemCount: cart.carts.length,
          ))
        ],
      ),
    );
  }
}
