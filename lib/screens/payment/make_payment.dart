import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_swish_payment/flutter_swish_payment.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hangry/screens/payment/payment.dart';
import 'package:hangry/screens/payment/swich.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../consts/firebase_consts.dart';
import '../../consts/theme_data.dart';
import '../../fetch_screen.dart';
import '../../providers/cart_provider.dart';
import '../../providers/orders_provider.dart';
import '../../providers/products_provider.dart';
import '../../services/global_methods.dart';
import '../../services/utils.dart';
import '../../widgets/back_widget.dart';
import '../../widgets/text_widget.dart';
import '../cart/cart_screen.dart';
import 'package:location/location.dart' as loc;

class makePayment extends StatefulWidget {
  final SwishClient swishClient;
  static const routeName = '/makePayment';

  const makePayment({Key? key, required this.swishClient}) : super(key: key);

  @override
  _makePaymentState createState() => _makePaymentState();
}

final loc.Location location = loc.Location();

class _makePaymentState extends State<makePayment> {
  TextStyle style = TextStyle(fontFamily: 'Open Sans', fontSize: 15.0);
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final detailOrder = TextEditingController();
    @override
    void dispose() {
      detailOrder.dispose();
      super.dispose();
    }

    final Color color = Utils(context).color;
    final cartProvider = Provider.of<CartProvider>(context);
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
    String mok = "";
    final de = productProvider.getTax;
    de.map((e) => mok = e.tax).toList();

    double totalPricev = double.parse(mok) + total;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        key: _scaffoldKey,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: primary,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextWidget(
                        text: 'Food Bill is',
                        color: color,
                        textSize: 18,
                        isTitle: true),
                    TextWidget(
                        text: '', color: color, textSize: 18, isTitle: true),
                    TextWidget(
                        text: '$total',
                        color: color,
                        textSize: 18,
                        isTitle: true),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextWidget(
                        text: 'Skatter is',
                        color: color,
                        textSize: 18,
                        isTitle: true),
                    TextWidget(
                        text: '', color: color, textSize: 18, isTitle: true),
                    TextWidget(
                        text: '$mok',
                        color: color,
                        textSize: 18,
                        isTitle: true),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextWidget(
                        text: 'Total bill is ',
                        color: color,
                        textSize: 18,
                        isTitle: true),
                    TextWidget(
                        text: '', color: color, textSize: 18, isTitle: true),
                    TextWidget(
                        text: '$totalPricev',
                        color: color,
                        textSize: 18,
                        isTitle: true),
                  ],
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              const Divider(thickness: 5, color: primary),
                                      TextFormField(
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.text,
                          maxLines: 2,
                          controller: detailOrder,
                          validator: (value) {
                            if (value!.isEmpty ) {
                              return "Nothing";
                            } else {
                              return null;
                            }
                          },
                          style: const TextStyle(color: Colors.black),
                          decoration: const InputDecoration(
                            hintText: 'Enter any details that you want EX: no onion for my burger',
                            hintStyle: TextStyle(color: Color.fromARGB(255, 90, 82, 82)),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            errorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                            ),
                          ),
                        ),
              const SizedBox(
                height: 50,
              ),
              // _checkout(ctx: context),
              TextWidget(
                  text: "Choose Payment Method",
                  color: color,
                  textSize: 20,
                  isTitle: true),
              SizedBox(
                height: 20,
              ),
              Center(
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color:
                          Color.fromARGB(255, 156, 147, 147).withOpacity(0.2)),
                  width: 300,
                  height: 200,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      RaisedButton(
                        onPressed: () {
                          // make PayPal payment
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) => PaypalPayment(
                                total: totalPricev,
                                details:detailOrder.text,
                                onFinish: (number) async {
                                  // payment done
                                  print('order id: ' + number);
                                },
                              ),
                            ),
                          );
                        },
                        child: Text(
                          'Pay with Paypal or Credit Card',
                          textAlign: TextAlign.center,
                        ),
                      ),
                      RaisedButton(
                        onPressed: () {
                          //           // make PayPal payment
                          //  Navigator.pushNamed(context, HomePage.routeName,
                          //    arguments: totalPricev);
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) => HomePage(
                                name: totalPricev.toString(),
                                details:detailOrder.text,
                                swishClient: widget.swishClient,
                              ),
                            ),
                          );
                        },
                        child: Text(
                          'Pay with Swish',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget _checkout({required BuildContext ctx}) {
  //   final Color color = Utils(ctx).color;
  //   Size size = Utils(ctx).getScreenSize;

  //   final cartProvider = Provider.of<CartProvider>(ctx);
  //   final productProvider = Provider.of<ProductsProvider>(ctx);
  //   final ordersProvider = Provider.of<OrdersProvider>(ctx);
  //   double total = 0.0;
  //   cartProvider.getCartItems.forEach((key, value) {
  //     final getCurrProduct = productProvider.findProdById(value.productId);
  //     total += (getCurrProduct.isOnSale
  //             ? getCurrProduct.salePrice
  //             : getCurrProduct.price) *
  //         value.quantity;
  //   });
  //   double mok = 0.5;
  //   double delivery = 5;
  //   double totalPricev = mok + delivery + total;
  //   return SizedBox(
  //     width: double.infinity,
  //     height: size.height * 0.1,
  //     // color: ,
  //     child: Padding(
  //       padding: const EdgeInsets.symmetric(horizontal: 12),
  //       child: Row(children: [
  //         Material(
  //           color: Colors.green,
  //           borderRadius: BorderRadius.circular(10),
  //           child: InkWell(
  //             borderRadius: BorderRadius.circular(10),
  //             onTap: () async {
  //               GlobalMethods.DeliveryOrBackup(
  //                 title:
  //                     'Do you want us tp delivery or you well take your meal by yourself?',
  //                 subtitle: 'choose one!',
  //                 fct2: () async {
  //                   User? user = authInstance.currentUser;
  //                   final orderId = const Uuid().v4();
  //                   final productProvider =
  //                       Provider.of<ProductsProvider>(ctx, listen: false);

  //                   cartProvider.getCartItems.forEach((key, value) async {
  //                     final getCurrProduct = productProvider.findProdById(
  //                       value.productId,
  //                     );
  //                     final loc.LocationData _locationResult =
  //                         await location.getLocation();

  //                     try {
  //                       final DocumentSnapshot userDoc = await FirebaseFirestore
  //                           .instance
  //                           .collection('users')
  //                           .doc(user!.uid)
  //                           .get();
  //                       phoneNumber = userDoc.get('phoneNumber');
  //                       await FirebaseFirestore.instance
  //                           .collection('orders')
  //                           .doc(orderId)
  //                           .set({
  //                         'orderId': orderId,
  //                         'userId': user.uid,
  //                         'productId': value.productId,
  //                         'price': (getCurrProduct.isOnSale
  //                                 ? getCurrProduct.salePrice
  //                                 : getCurrProduct.price) *
  //                             value.quantity,
  //                         'totalPrice': total,
  //                         'quantity': value.quantity,
  //                         'imageUrl': getCurrProduct.imageUrl,
  //                         'userName': user.displayName,
  //                         'latitude': _locationResult.latitude,
  //                         'longitude': _locationResult.longitude,
  //                         'orderDate': Timestamp.now(),
  //                         'phoneNumber': phoneNumber,
  //                         'productCategoryName':
  //                             getCurrProduct.productCategoryName,
  //                         'title': getCurrProduct.title,
  //                         'details': getCurrProduct.detiles
  //                       });
  //                       //payment fun is here with delivery
  //                       await cartProvider.clearOnlineCart();
  //                       cartProvider.clearLocalCart();
  //                       ordersProvider.fetchOrders();
  //                       await Fluttertoast.showToast(
  //                         msg:
  //                             "Your order has been placed and it need 20 min to be ready",
  //                         toastLength: Toast.LENGTH_LONG,
  //                         gravity: ToastGravity.CENTER,
  //                       );
  //                     } catch (error) {
  //                       GlobalMethods.errorDialog(
  //                           subtitle: error.toString(), context: ctx);
  //                     } finally {}
  //                   });
  //                 },
  //                 fct: () async {
  //                   User? user = authInstance.currentUser;
  //                   final orderId = const Uuid().v4();
  //                   final productProvider =
  //                       Provider.of<ProductsProvider>(ctx, listen: false);

  //                   cartProvider.getCartItems.forEach((key, value) async {
  //                     final getCurrProduct = productProvider.findProdById(
  //                       value.productId,
  //                     );

  //                     try {
  //                       // final loc.LocationData _locationResult = await location.getLocation();

  //                       final DocumentSnapshot userDoc = await FirebaseFirestore
  //                           .instance
  //                           .collection('users')
  //                           .doc(user!.uid)
  //                           .get();
  //                       phoneNumber = userDoc.get('phoneNumber');
  //                       await FirebaseFirestore.instance
  //                           .collection('ordersBackup')
  //                           .doc(orderId)
  //                           .set({
  //                         'orderId': orderId,
  //                         'userId': user.uid,
  //                         'productId': value.productId,
  //                         'price': (getCurrProduct.isOnSale
  //                                 ? getCurrProduct.salePrice
  //                                 : getCurrProduct.price) *
  //                             value.quantity,
  //                         'totalPrice': total,
  //                         'quantity': value.quantity,
  //                         'imageUrl': getCurrProduct.imageUrl,
  //                         'userName': user.displayName,
  //                         // 'latitude': _locationResult.latitude,
  //                         // 'longitude': _locationResult.longitude,
  //                         'orderDate': Timestamp.now(),
  //                         'phoneNumber': phoneNumber,
  //                         'productCategoryName':
  //                             getCurrProduct.productCategoryName,
  //                         'title': getCurrProduct.title,
  //                       });
  //                       //payment fun is here without delivery
  //                       await cartProvider.clearOnlineCart();
  //                       cartProvider.clearLocalCart();
  //                       ordersProvider.fetchOrders();
  //                       await Fluttertoast.showToast(
  //                         msg:
  //                             "You can go to the resturnat and backup your delivery ",
  //                         toastLength: Toast.LENGTH_LONG,
  //                         gravity: ToastGravity.CENTER,
  //                       );
  //                     } catch (error) {
  //                       GlobalMethods.errorDialog(
  //                           subtitle: error.toString(), context: ctx);
  //                     } finally {}
  //                   });
  //                 },
  //                 context: context,
  //               );
  //             },
  //             child: Padding(
  //               padding: const EdgeInsets.all(8.0),
  //               child: TextWidget(
  //                 text: 'Order Now',
  //                 textSize: 20,
  //                 color: Colors.white,
  //               ),
  //             ),
  //           ),
  //         ),
  //         const Spacer(),
  //         FittedBox(
  //           child: TextWidget(
  //             text: 'Total: \$${total.toStringAsFixed(2)}',
  //             color: color,
  //             textSize: 18,
  //             isTitle: true,
  //           ),
  //         ),
  //       ]),
  //     ),
  //   );
  // }
}
