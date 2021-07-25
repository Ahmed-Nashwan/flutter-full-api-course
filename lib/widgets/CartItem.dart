import 'package:ecommerce_max_app/Providers/Cart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String title;
  final double price;
  final int quantity;
  final double total;
  final String proudctId;

  CartItem({
    @required this.id,
    @required this.title,
    @required this.price,
    @required this.quantity,
    @required this.total,
    @required this.proudctId,
  });

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: false);
    return Dismissible(
      child: MyCart(context),
      key: ValueKey(id),
      background: Container(
        margin: EdgeInsets.symmetric(
          vertical: 13,
          horizontal: 5,
        ),
        color: Colors.pink,
        alignment: Alignment.centerRight,
        child: Icon(
          Icons.delete,
          size: 35,
          color: Colors.white,
        ),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (di) {
        cart.deleteCatItem(proudctId);
      },
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                title: Text("Alert!"),
                content: Text("Are you sure to delete this item ?"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: Text("No"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: Text("Yes"),
                  ),
                ],
              );
            });
      },
    );
  }

  Card MyCart(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(15),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor,
          child: FittedBox(
            child: Text(
              price.toString(),
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
        ),
        subtitle: Text(
          "Total $total",
          style: TextStyle(
            color: Colors.black.withOpacity(.5),
            fontSize: 13,
          ),
        ),
        trailing: Text(
          '$quantity x',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
