import 'package:ecommerce_max_app/Providers/Orders.dart';
import 'package:ecommerce_max_app/widgets/OrderItem.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Providers/Orders.dart';

class OrderScreen extends StatefulWidget {
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  @override
  Widget build(BuildContext context) {
    //  final order = Provider.of<Orders>(context, listen: false);
    // Provider.of<Orders>(
    //   context,
    //   listen: false,
    // ).fetchDataOrders();

    return Scaffold(
        appBar: AppBar(
          title: Text("Order"),
        ),
        body: FutureBuilder(
          future: Provider.of<Orders>(
            context,
            listen: false,
          ).fetchDataOrders(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.error != null) {
              return Center(child: Text("an error on fetching data"));
            } else {
              return Consumer<Orders>(builder: (ctx, order, child) {
                return ListView.builder(
                  itemCount: order.orders.length,
                  itemBuilder: (ctx, pos) {
                    Order item = order.orders[pos];
                    return OrderItem(
                      total: item.total,
                      date: item.date.toString(),
                      carts: item.carts,
                    );
                  },
                );
              });
            }
          },
        ));
  }
}
