import 'package:ecommerce_max_app/Providers/Product.dart';
import 'package:ecommerce_max_app/Providers/Products.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailsScreen extends StatelessWidget {
  final String id;

  DetailsScreen(this.id);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<Products>(context);
    Product product = provider.findProduct(id);
    return Scaffold(
    body:  Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Column(children: [
            Expanded(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Hero(
                    tag: id,
                    child: Image.network(
                      product.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    product.title,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 28,
                    ),
                  ),
                  Text(
                    product.discription,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black.withOpacity(.7),
                      fontSize: 22,
                    ),
                  ),
                ],
              ),
            ),
          ]),
      ),
    );
  }
}
