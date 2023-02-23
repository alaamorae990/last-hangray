import 'dart:convert';
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_swish_payment/flutter_swish_payment.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hangry/screens/payment/payment.dart';
import 'package:hangry/screens/payment/payment_delivery.dart';
import 'package:hangry/screens/payment/swich.dart';
import 'package:hangry/screens/payment/swich_delivery.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
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
import '../cart/cart2/cart_show.dart';
import '../cart/cart_screen.dart';

class MakePaymentDeliv extends StatefulWidget {
  final SwishClient swishClient;
  static const routeName = '/MakePaymentDeliv';

  const MakePaymentDeliv({Key? key, required this.swishClient})
      : super(key: key);

  @override
  _MakePaymentDelivState createState() => _MakePaymentDelivState();
}

// final loc.Location location = loc.Location();

class _MakePaymentDelivState extends State<MakePaymentDeliv> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final detailOrder = TextEditingController();
    @override
    void dispose() {
      detailOrder.dispose();
      super.dispose();
    }

    User? user = authInstance.currentUser;
    final Color color = Utils(context).color;
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
    String mok = "";
    String delivery = "";
    final de = productProvider.getTax;
    de.map((e) => mok = e.tax).toList();
    de.map((e) => delivery = e.deliveryValue).toList();

    double totalPricev = double.parse(mok) + double.parse(delivery) + total;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        key: _scaffoldKey,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: primary,
        ),
        body: Column(
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
                      text: '$mok', color: color, textSize: 18, isTitle: true),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextWidget(
                      text: 'delivery is',
                      color: color,
                      textSize: 18,
                      isTitle: true),
                  TextWidget(
                      text: '', color: color, textSize: 18, isTitle: true),
                  TextWidget(
                      text: '$delivery',
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
                if (value!.isEmpty) {
                  return "Nothing";
                } else {
                  return null;
                }
              },
              style: const TextStyle(color: Colors.black),
              decoration: const InputDecoration(
                hintText:
                    'Enter any details that you want EX: no onion for my burger',
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
                    color: Color.fromARGB(255, 156, 147, 147).withOpacity(0.2)),
                width: 300,
                height: 200,
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    RaisedButton(
                      onPressed: () async {
                        try {
                          await initPayment(
                              amount: totalPricev * 100,
                              context: context,
                              email: user!.email ?? '');
                        } catch (error) {
                          return;
                        }

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CartShow(
                                    detiles: detailOrder.text,
                                  )),
                        );
                        // make PayPal payment
                        // Navigator.of(context).push(
                        //   MaterialPageRoute(
                        //     builder: (BuildContext context) => PaypalPaymentDelivery(
                        //       total: totalPricev,
                        //       details:detailOrder.text,
                        //       onFinish: (number) async {
                        //         // payment done
                        //         print('order id: ' + number);

                        //       },
                        //     ),
                        //   ),
                        // );
                      },
                      child: Text(
                        'Pay with Credit Card ',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    RaisedButton(
                      onPressed: () {
                        // make PayPal payment
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                PaypalPaymentDelivery(
                              total: totalPricev,
                              details: detailOrder.text,
                              onFinish: (number) async {
                                // payment done
                                print('order id: ' + number);
                              },
                            ),
                          ),
                        );
                      },
                      child: Text(
                        'Pay with Paypal ',
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
                            builder: (BuildContext context) => HomePageDelivery(
                              name: totalPricev.toString(),
                              details: detailOrder.text,
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
    );
  }


  Future<void> initPayment(
      {required String email,
      required double amount,
      required BuildContext context}) async {
    try {
      // 1. Create a payment intent on the server
      final response = await http.post(
          Uri.parse(
              'https://us-central1-hangry-94bea.cloudfunctions.net/stripePaymentIntentRequest'),
          body: {
            'email': email,
            'amount': amount.toString(),
          });

      final jsonResponse = jsonDecode(response.body);
      print(jsonResponse.toString());
      if (jsonResponse['success'] == false) {
        GlobalMethods.errorDialog(
            subtitle: jsonResponse['error'], context: context);
            throw jsonResponse['error'];
      }
      // 2. Initialize the payment sheet
      
      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: jsonResponse['paymentIntent'],
        merchantDisplayName: 'HANGRIGA',
        customerId: jsonResponse['customer'],
        customerEphemeralKeySecret: jsonResponse['ephemeralKey'],
        // merchantCountryCode: 'SG',
      ));
      await Stripe.instance.presentPaymentSheet();
    
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Payment is successful'),
        ),
      );
    } catch (errorr) {
      if (errorr is StripeException) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An error occured ${errorr.error.localizedMessage}'),
          ),
        );
       
      } 
      else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An error occured $errorr'),
          ),
        );
        
      } throw '$errorr';
    }
  }
}
