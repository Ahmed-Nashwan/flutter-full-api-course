import 'package:ecommerce_max_app/Providers/Product.dart' as pr;
import 'package:ecommerce_max_app/Providers/Products.dart';
import 'package:ecommerce_max_app/screens/ProductScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddProductScreen extends StatefulWidget {
  @override
  _AddProductScreenState createState() => _AddProductScreenState();
  bool isEditing;
  final String id;
  final String title;
  final String disc;
  final String price;
  var isLoading = false;

  AddProductScreen({
    this.isEditing = false,
    @required this.id,
    @required this.title,
    @required this.price,
    @required this.disc,
  });
}

class _AddProductScreenState extends State<AddProductScreen> {

  final price_focus_node = FocusNode();
  final description_focus_node = FocusNode();
  final form_key = GlobalKey<FormState>();

  var editing_proecut = pr.Product(
    id: DateTime.now().toString(),
    title: "",
    discription: "",
    price: 0.0,
    imageUrl: "",
    isFivarites: false,
  );
  var textFieldValue = {};

  bool saveForm() {
    if (form_key.currentState.validate()) {
      form_key.currentState.save();
      return true;
    } else {
      return false;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    print(DateTime.now().toString());
    // widget.isEditing = false;
    if (widget.isEditing) {
      textFieldValue = {
        'title': widget.title,
        'id': widget.id,
        'disc': widget.disc,
        'price': widget.price,
      };
    } else {
      textFieldValue = {
        'title': '',
        'id': '',
        'disc': '',
        'price': '',
      };
    }

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose

    price_focus_node.dispose();

    description_focus_node.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Products>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Product"),
      ),
      body: widget.isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : TheForm(context, product),
    );
  }

  Form TheForm(BuildContext context, Products product) {
    return Form(
      key: form_key,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        child: ListView(
          children: [
            TextFormTitle(context),
            TextFormPrice(context),
            TextFormDiscription(product),
            SizedBox(
              height: 30,
            ),
            SubmitedButton(product, context),
          ],
        ),
      ),
    );
  }

  ElevatedButton SubmitedButton(Products product, BuildContext context)  {
    return ElevatedButton(
      onPressed: () async {
        if (widget.isEditing) {
          if (saveForm()) {
            print(widget.id);
            print(widget.title);
            print(widget.price);
           await product.updateProduct(widget.id, editing_proecut);
            Navigator.pop(context);
          } else {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text("Invalid editing")));
          }
        } else {
          if (saveForm()) {

            setState(() {
              widget.isLoading = true;
              print("is loading true");
            });

            try {
              await product.addProduct(editing_proecut);
            } catch (e) {

             showDialog(
                  context: context,
                  builder: (ctx) {
                    return AlertDialog(
                      title: Text("Error happened !"),
                      content: Text(
                          "Something went wrong .. this is becouse no internet or another error."),
                      actions: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(ctx).pop();
                            setState(() {
                              widget.isLoading = false;
                              print("is loading true");
                            });
                          },
                          child: Text("done"),
                        )
                      ],
                    );
                  });
            } finally {
              setState(() {
                widget.isLoading = false;

              });


            }
          } else {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text("Invalid added")));
          }
        }
      },
      child: widget.isEditing
          ? Text(
              "Edit product",
              style: TextStyle(
                color: Colors.white,
              ),
            )
          : Text(
              "Save product",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
    );
  }

  TextFormField TextFormDiscription(Products product) {
    return TextFormField(
      decoration: InputDecoration(labelText: "Description"),
      initialValue: textFieldValue['disc'],
      maxLines: 3,
      keyboardType: TextInputType.multiline,
      focusNode: description_focus_node,
      onSaved: (desc) {
        editing_proecut = pr.Product(
            id: editing_proecut.id,
            title: editing_proecut.title,
            discription: desc,
            price: editing_proecut.price,
            imageUrl: editing_proecut.imageUrl,
            isFivarites: editing_proecut.isFivarites);
      },
      onFieldSubmitted: (_) {
        saveForm();
        product.addProduct(editing_proecut);
      },
      validator: (value) {
        if (value.isEmpty) {
          return 'please enter a description';
        }
        return null;
      },
    );
  }

  TextFormField TextFormPrice(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(labelText: "Price"),
      initialValue: textFieldValue['price'],
      textInputAction: TextInputAction.next,
      focusNode: price_focus_node,
      keyboardType: TextInputType.number,
      onSaved: (price) {
        FocusScope.of(context).requestFocus(description_focus_node);

        editing_proecut = pr.Product(
            id: editing_proecut.id,
            title: editing_proecut.title,
            discription: editing_proecut.discription,
            price: double.parse(price),
            imageUrl: editing_proecut.imageUrl,
            isFivarites: editing_proecut.isFivarites);
      },
      validator: (value) {
        if (value.isEmpty) {
          return 'please enter a price';
        } else if (double.tryParse(value) == null) {
          return 'Enter a valid number';
        }
        return null;
      },
    );
  }

  TextFormField TextFormTitle(BuildContext context) {
    return TextFormField(
      initialValue: textFieldValue['title'],
      decoration: InputDecoration(labelText: "Title"),
      textInputAction: TextInputAction.next,
      onSaved: (title) {
        FocusScope.of(context).requestFocus(price_focus_node);

        editing_proecut = pr.Product(
            id:  editing_proecut.id,
            title: title,
            discription: editing_proecut.discription,
            price: editing_proecut.price,
            imageUrl: editing_proecut.imageUrl,
            isFivarites: editing_proecut.isFivarites);
      },
      validator: (value) {
        if (value.isEmpty) {
          return 'please enter a value';
        } else if (value.length <= 2) {
          return 'this name is too short';
        }
        return null;
      },
    );
  }
}
