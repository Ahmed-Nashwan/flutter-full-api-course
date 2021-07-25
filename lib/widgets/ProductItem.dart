import 'package:ecommerce_max_app/Providers/Cart.dart';
import 'package:ecommerce_max_app/Providers/Product.dart';
import 'package:ecommerce_max_app/Providers/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String discription;
  // final String image_url;
  // ProductItem({this.id});

  @override
  Widget build(BuildContext context) {
    // final provider =  Provider.of<Products>(context,listen: false);
    // Product product =   provider.findProduct(id);

    final product_provider = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final auth = Provider.of<Auth>(context, listen: false);

    // Product product =   provider.findProduct(id);
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: GridTile(
        child: Hero(
          tag: product_provider.id,
          child: FadeInImage(
            image: NetworkImage(
              product_provider.imageUrl,
            ),
            placeholder: AssetImage("assets/images/placeholder.png"),
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          leading: Consumer<Product>(
            builder: (ctx, product_provider, child) => IconButton(
              icon: Icon(
                product_provider.isFivarites
                    ? Icons.favorite
                    : Icons.favorite_border,
              ),
              color: Theme.of(context).accentColor,
              onPressed: () async {
                await product_provider.changeStatusFevarites(
                    auth.token, auth.userId);
              },
            ),
          ),
          trailing: IconButton(
            color: Theme.of(context).accentColor,
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              cart.add_cart(product_provider.id, product_provider.title,
                  product_provider.price);
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Cart Added successfully"),
                duration: Duration(seconds: 2),
                action: SnackBarAction(
                  label: "UNDO",
                  textColor: Colors.deepOrange,
                  onPressed: () {
                    cart.removeSingleItem(product_provider.id);
                  },
                ),
              ));
            },
          ),
          backgroundColor: Colors.black45,
          title: Text(
            product_provider.title,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
