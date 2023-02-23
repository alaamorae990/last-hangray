import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hangry/consts/theme_data.dart';
import 'package:hangry/screens/cart/backup_del_.dart';
import 'package:hangry/widgets/auth_button.dart';

import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../../providers/cart_provider.dart';
import '../../../providers/orders_provider.dart';
import '../../../providers/products_provider.dart';
import '../../../services/global_methods.dart';
import '../../../services/utils.dart';
import '../../../widgets/empty_screen.dart';
import '../../../widgets/text_widget.dart';
import 'cart_show_backup_widget.dart';
import 'cart_show_widger.dart';

import 'package:location/location.dart' as loc;

class CartShowBackup extends StatefulWidget {
  const CartShowBackup({Key? key, required this.detiles}) : super(key: key);
final String detiles;
  @override
  State<CartShowBackup> createState() => _CartShowBackupState();
}

final loc.Location location = loc.Location();
String? phoneNumber;

class _CartShowBackupState extends State<CartShowBackup> {
  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    Size size = Utils(context).getScreenSize;
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItemsList =
        cartProvider.getCartItems.values.toList().reversed.toList();
    final productProvider = Provider.of<ProductsProvider>(context);
    final ordersProvider = Provider.of<OrdersProvider>(context);
    double total = 0.0;
    cartProvider.getCartItems.forEach((key, value) {
      final getCurrProduct = productProvider.findProdById(value.productId);
      total += (getCurrProduct.isOnSale
              ? getCurrProduct.salePrice
              : getCurrProduct.price) *
          value.quantity;
    });
    return cartItemsList.isEmpty
        ? const EmptyScreen(
            title: 'Your cart is empty',
            subtitle: 'Add something and make me happy :)',
            buttonText: 'Shop now',
            imagePath: 'assets/images/cart.png',
          )
        : Scaffold(
            body: Column(
              children: [
                // _checkout(ctx: context),
                Expanded(
                  child: SizedBox(
                    height: 200.0,
                    child: ListView.builder(
                    
                      itemCount: cartItemsList.length,
                      itemBuilder: (ctx, index) {
                        return ChangeNotifierProvider.value(
                            value: cartItemsList[index],
                            child: CartShowBackupWidget(
                              q: cartItemsList[index].quantity,
                              details: widget.detiles,

                            ));
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
  }

}
