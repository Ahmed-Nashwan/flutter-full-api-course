import 'package:ecommerce_max_app/Providers/Products.dart';
import 'package:ecommerce_max_app/screens/AddProductScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductUserItem extends StatelessWidget {
  final String id;
  final String title;
  final String image_url;
  final String disc;
  final String price;

  ProductUserItem({
    @required this.id,
    @required this.title,
    @required this.image_url,
    @required this.disc,
    @required this.price,
  });

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Products>(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: image_url.isEmpty
                ? AssetImage("assets/images/image.jpg")
                : NetworkImage(
                    image_url,
                  ),
          ),
          SizedBox(
            width: 20,
          ),
          Text(
            title,
            style: TextStyle(color: Colors.black, fontSize: 25),
          ),
          Spacer(),
          IconButton(
              icon: Icon(
                Icons.mode_edit,
                color: Colors.teal,
              ),
              onPressed: () {
                //.. edit the product
                Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                  return AddProductScreen(
                    isEditing: true,
                    disc: disc,
                    title: title,
                    id: id,
                    price: price,
                  );
                }));
              }),
          SizedBox(
            width: 20,
          ),
          IconButton(
              icon: Icon(
                Icons.delete,
                color: Colors.teal,
              ),
              onPressed: () async {
                //... delete the product
                await product.deleteProduct(id);
              }),
        ],
      ),
    );
  }
}
