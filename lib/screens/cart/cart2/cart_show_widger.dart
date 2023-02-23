import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hangry/consts/theme_data.dart';
import 'package:hangry/screens/user.dart';
import 'package:location/location.dart' as loc;
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../../consts/firebase_consts.dart';
import '../../../fetch_screen.dart';
import '../../../inner_screens/product_details.dart';
import '../../../models/cart_model.dart';
import '../../../providers/cart_provider.dart';
import '../../../providers/orders_provider.dart';
import '../../../providers/products_provider.dart';
import '../../../providers/wishlist_provider.dart';
import '../../../services/global_methods.dart';
import '../../../services/utils.dart';
import '../../../widgets/back_widget.dart';
import '../../../widgets/heart_btn.dart';
import '../../../widgets/text_widget.dart';

class CartShowWidget extends StatefulWidget {
  const CartShowWidget({Key? key, required this.q, required this.details})
      : super(key: key);
  final int q;
  final String details;
  @override
  State<CartShowWidget> createState() => _CartShowWidgetState();
}

class _CartShowWidgetState extends State<CartShowWidget> {
  final _quantityTextController = TextEditingController();
  @override
  void initState() {
    _quantityTextController.text = widget.q.toString();
    super.initState();
  }

  @override
  void dispose() {
    _quantityTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
        Size size = Utils(context).getScreenSize;
    final Color color = Utils(context).color;
    // Size size = Utils(context).getScreenSize;
    final productProvider = Provider.of<ProductsProvider>(context);
    final cartModel = Provider.of<CartModel>(context);
    final getCurrProduct = productProvider.findProdById(cartModel.productId);
        final cartProvider = Provider.of<CartProvider>(context);
        cartProvider.getCartItems.forEach((key, value) {
      final getCurrProduct = productProvider.findProdById(value.productId);});
    // double usedPrice = getCurrProduct.isOnSale
    //     ? getCurrProduct.salePrice
    //     : getCurrProduct.price;
    // final cartProvider = Provider.of<CartProvider>(context);
    // _checkout();
    _checkout();
      return GestureDetector(
      onTap: () {
            // cartProvider.clearOnlineCart();
            // cartProvider.clearLocalCart();
            // ordersProvider.fetchOrders();
  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (BuildContext context) => const FetchScreen()));
      },
      
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: 
              
                Row(
                  children: [
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Container(
                                       decoration: BoxDecoration(
                            color: primary.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            // crossAxisAlignment: CrossAxisAlignment.,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                           Padding(
                             padding: const EdgeInsets.all(8.0),
                             child: 
                              
                               
                           TextWidget(
                                      text:  'Your order '+'${getCurrProduct.title}',
                                      color: color,
                                      textSize: 16,
                                      isTitle: true,
                               ),
                               
                               
                               
                             
                           ),
                              Icon(Icons.check_circle_outline),
                              // TextWidget(text: "Your order has been placed and it need 20 min to be ready tap here to return to home page", color: color, textSize: 18),
                              // TextWidget(text: "Your order has been placed and it need 20 min to be ready tap here to return to home page", color: color, textSize: 18),
                            ],
                          ),
                      ),
                    )
                    )
                  ],
                ),
                   
                              
             
          ),
           Center(child: TextWidget(text: " has been placed and it need 20 min to be ready tap here to return to home page", color: color, textSize: 18,isTitle: true,)),
        ],
      ),
    );
  }

  Future<Widget> _checkout() async {
    User? user = authInstance.currentUser;
    final orderId = const Uuid().v4();
    String? phoneNumber;

    final ordersProvider = Provider.of<OrdersProvider>(context);
    final loc.Location location = loc.Location();
    Size size = Utils(context).getScreenSize;
    final productProvider = Provider.of<ProductsProvider>(context);
    final cartModel = Provider.of<CartModel>(context);
    final getCurrProduct3 = productProvider.findProdById(cartModel.productId);
    final cartProvider = Provider.of<CartProvider>(context);
    double total = 0.0;
    String spacing = "*********";
    String quantityOfOrders = '';
    String namesOfOrders = " ";
    cartProvider.getCartItems.forEach((key, value) {
      final getCurrProduct = productProvider.findProdById(value.productId);
      total += (getCurrProduct.isOnSale
              ? getCurrProduct.salePrice
              : getCurrProduct.price) *
          value.quantity;
      namesOfOrders = (namesOfOrders + spacing + getCurrProduct.title);
      quantityOfOrders =
          (quantityOfOrders + spacing + value.quantity.toString());
    });
    final loc.LocationData _locationResult = await location.getLocation();
    cartProvider.getCartItems.forEach((key, value) async {
      // final getCurrProduct2 = productProvider.findProdById(
      //   value.productId,
      // );
      // final loc.LocationData _locationResult =
      //     await location.getLocation();
      final ProductDetails details = new ProductDetails();

      try {
        final DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .get();
        phoneNumber = userDoc.get('phoneNumber');
        await FirebaseFirestore.instance.collection('orders').doc(orderId).set({
          'orderId': orderId,
          'userId': user.uid,
          'productId': value.productId,
          'price': (getCurrProduct3.isOnSale
                  ? getCurrProduct3.salePrice
                  : getCurrProduct3.price) *
              value.quantity,
          'totalPrice': total,
          'quantity': quantityOfOrders,
          // 'imageUrl': getCurrProduct.imageUrl,
          'userName': user.displayName,
          'latitude': _locationResult.latitude,
          'longitude': _locationResult.longitude,
          'orderDate': Timestamp.now(),
          'phoneNumber': phoneNumber,
          'productCategoryName': getCurrProduct3.productCategoryName,
          'title': namesOfOrders,
          'details': widget.details
        });
        //payment fun is here with delivery
        await
            // cartProvider.clearOnlineCart();
            // cartProvider.clearLocalCart();
            // ordersProvider.fetchOrders();
            await Fluttertoast.showToast(
          msg: "Your order has been placed and it need 20 min to be ready",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
        );
      } catch (error) {
        GlobalMethods.errorDialog(subtitle: error.toString(), context: context);
      } finally {}
    });
    return Text("data");
  }
}
