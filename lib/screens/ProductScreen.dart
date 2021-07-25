import 'package:ecommerce_max_app/Providers/Cart.dart';
import 'package:ecommerce_max_app/Providers/Product.dart' as pr;
import 'package:ecommerce_max_app/Providers/Products.dart';
import 'package:ecommerce_max_app/Providers/auth.dart';
import 'package:ecommerce_max_app/screens/CartScreen.dart';
import 'package:ecommerce_max_app/screens/DetailsScreen.dart';
import 'package:ecommerce_max_app/screens/OrderScreen.dart';
import 'package:ecommerce_max_app/screens/ProductUser.dart';
import 'package:ecommerce_max_app/widgets/ProductItem.dart';
import 'package:ecommerce_max_app/widgets/badge.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum SelectedOptions {
  All,
  Favorites,
}

class ProductScreen extends StatefulWidget {
  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  var isFaverites = false;
  var isInit = true;
  var isLoading = false;
  //
  // @override
  // void initState() {
  //   // TODO: implement initState
  //
  //   Future.delayed(Duration.zero)
  //       .then((value) => Provider.of<Products>(context,listen: false).fetchDataAndGet());
  //   super.initState();
  // }

  @override
  void didChangeDependencies() {
    if (isInit) {
      setState(() {
        isLoading = true;
      });
      Provider.of<Products>(context, listen: false)
          .fetchDataAndGet()
          .then((value) => setState(() {
                isLoading = false;
              }));
    }
    isInit = false;
    super.didChangeDependencies();
  }


  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<Products>(context, listen: true);
    return Scaffold(
      drawer: MyDrawer(context),
      appBar: AppBar(
        actions: [
          Consumer<Cart>(
            builder: (_, cart, ch) {
              return Badge(
                child: ch,
                color: Colors.deepOrangeAccent,
                value: cart.cartLenght().toString(),
              );
            },
            child: IconButton(
              icon: Icon(Icons.shopping_cart_outlined),
              color: Colors.white,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) => CartScreen(),
                    ));
              },
            ),
          ),
          options_menu(),
        ],
        title: Text("Products"),
      ),
      body: !isLoading
          ? GridScreens(
              context, isFaverites ? provider.favorites : provider.products)
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  Drawer MyDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          SizedBox(
            height: 100,
          ),
          ListTile(
            leading: Icon(
              Icons.card_giftcard,
            ),
            title: Text("Cards"),
            trailing: Icon(
              Icons.arrow_forward_ios_outlined,
              color: Colors.black,
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                return CartScreen();
              }));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.border_all_rounded,
            ),
            title: Text("Order"),
            trailing: Icon(
              Icons.arrow_forward_ios_outlined,
              color: Colors.black,
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                return OrderScreen();
              }));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.control_camera_outlined,
            ),
            title: Text("Products control"),
            trailing: Icon(
              Icons.arrow_forward_ios_outlined,
              color: Colors.black,
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                return ProductUser();
              }));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.exit_to_app,
            ),
            title: Text("Logout"),
            trailing: Icon(
              Icons.arrow_forward_ios_outlined,
              color: Colors.black,
            ),
            onTap: () {

              Provider.of<Auth>(context,listen: false).logout();
            },
          )
        ],
      ),
    );
  }

  PopupMenuButton<SelectedOptions> options_menu() {
    return PopupMenuButton(
        icon: Icon(
          Icons.more_vert,
          color: Colors.white,
        ),
        itemBuilder: (_) => [
              PopupMenuItem(
                child: Text("Show all"),
                value: SelectedOptions.All,
              ),
              PopupMenuItem(
                child: Text("Show Fevarites"),
                value: SelectedOptions.Favorites,
              ),
            ],
        onSelected: (SelectedOptions value) {
          setState(() {
            if (value == SelectedOptions.All) {
              isFaverites = false;
            } else if (value == SelectedOptions.Favorites) {
              isFaverites = true;
            }
          });
        });
  }

  Widget GridScreens(
    BuildContext context,
    List<pr.Product> products,
  ) {
    return
        GridView.builder(
            itemBuilder: (ctx, pos) => GestureDetector(
              onTap: () {
                print(products.length.toString());
                Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                  return DetailsScreen(products[pos].id);
                }));
              },
              child: ChangeNotifierProvider.value(
                value: products[pos],
                child: ProductItem(),
              ),
            ),
            itemCount: products.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 3 / 2,
            ),
            padding: EdgeInsets.all(10),
          );
       // : Center(
         //   child: Text("No items found"),
         // );
  }
}
