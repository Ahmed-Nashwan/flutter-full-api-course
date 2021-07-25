import 'package:ecommerce_max_app/Providers/Products.dart';
import 'package:ecommerce_max_app/screens/AddProductScreen.dart';
import 'package:ecommerce_max_app/widgets/ProductUserItem.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductUser extends StatelessWidget {
  Future<void> refreshData(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchDataAndGet();
  }

  @override
  Widget build(BuildContext context) {
    // final products = Provider.of<Products>(context);
    // final list = products.products;
    print("rebiulding");
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                  return AddProductScreen();
                }));
              }),
        ],
        title: Text("Product control"),
      ),
      body: FutureBuilder(
        future: refreshData(context),
        builder: (ctx, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? Center(
                child: CircularProgressIndicator(),
              )
            : RefreshIndicator(
                onRefresh: () => refreshData(context),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Consumer<Products>(
                    builder: (ctx, products, _) => ListView.builder(
                      itemBuilder: (ctx, pos) {
                        return Column(
                          children: [
                            ProductUserItem(
                              id: products.products[pos].id,
                              title: products.products[pos].title,
                              image_url: products.products[pos].imageUrl,
                              disc: products.products[pos].discription,
                              price: products.products[pos].price.toString(),
                            ),
                            Divider(),
                          ],
                        );
                      },
                      itemCount: products.products.length,
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
