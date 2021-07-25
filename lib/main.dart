import 'package:ecommerce_max_app/Providers/Orders.dart';
import 'package:ecommerce_max_app/Providers/Products.dart';
import 'package:ecommerce_max_app/screens/ProductScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Providers/Cart.dart';
import 'Providers/auth.dart';
import 'screens/auth_screen.dart';

void main() {
  runApp(MyApp());
  //a test comment to push a new rebo to github
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          update: (ctx, auth, previusProduct) => Products(
            auth.token,
            previusProduct==null?[]:previusProduct.products  ,
            auth.userId,
          ),
        ),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          update: (ctx, authData, proviusOrders) => Orders(
            authData.token,
            proviusOrders == null ? [] : proviusOrders.orders,
            authData.userId,
          ),
        ),
      ],
      child: Consumer<Auth>(
          builder: (ctx, authData, _) => MaterialApp(
                title: 'Flutter Demo',
                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                  fontFamily: "Lato",
                  primarySwatch: Colors.teal,
                  // visualDensity: VisualDensity.adaptivePlatformDensity,
                  accentColor: Colors.yellow.shade900,
                ),
                home: authData.isAuth
                    ? ProductScreen()
                    : FutureBuilder(
                        future: authData.tryToLogin(),
                        builder: (ctx, data) =>
                            data.connectionState == ConnectionState.waiting
                                ? Scaffold(
                                  body: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                )
                                : AuthScreen()),
              )),
    );
  }
}
