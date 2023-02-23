import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swish_payment/flutter_swish_payment.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hangry/screens/cart/cart_screen.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:location/location.dart' as loc;
import '../../consts/firebase_consts.dart';
import '../../fetch_screen.dart';
import '../../providers/cart_provider.dart';
import '../../providers/dark_theme_provider.dart';
import '../../providers/orders_provider.dart';
import '../../providers/products_provider.dart';
import '../../services/global_methods.dart';
import '../../services/utils.dart';
import '../../widgets/text_widget.dart';
import '../cart/cart2/cart_show.dart';
class HomePageDelivery extends StatefulWidget {
   static const routeName = "/HomePage";
   HomePageDelivery({
    Key? key,
    required this.swishClient,  
    required this.name,
    required this.details,
  })
: super(key: key);
  final SwishClient swishClient;
  final String details;
     String name;
   
  @override
  _HomePageDeliveryState createState() => _HomePageDeliveryState();
  
}

class _HomePageDeliveryState extends State<HomePageDelivery> {
//  @override
//   void initState(){
//         _name = widget.name;
//    var f =_name;
// // _selectedCategory=HomePage.payment.toString();
// print(_name);
// super.initState();
//  }   //  static String get _name=> name;
// static  var _name;
      //  static String get name => name;
    

//  late String _selectedCategory ;
 

  // static String get d =>f;

    
   //    void initState() {
  //   selectedCategory = widget.totalPricev;
  //   super.initState();
  // }
// late String myTest;
//   HomePage(){
//     late  String myTest=widget.totalPricev;
//   }
  // @override
  //  initState() {
  // _price=widget.totalPricev;
  
  // }  
  // Create the payment data that should be paid and sent to the end Swish user.


  bool isWaiting = false;
  
  //  SwishPaymentData swishPaymentData =   SwishPaymentData(
    
  //   payeeAlias: '1231181189',
  //   amount: totalPricev.toString() ,
  //   currency: 'SEK',
  //   callbackUrl: 'https://mss.cpc.getswish.net/swish-cpcapi/api/v1/paymentrequests/',
  //   message: '',
  // );
 
  //  String price="";
// _price=_selectedCategory;
  
  @override
  Widget build(BuildContext context) {
        final cartProvider = Provider.of<CartProvider>(context);
        
    final productProvider = Provider.of<ProductsProvider>(context);
    final ordersProvider = Provider.of<OrdersProvider>(context);
        final cartItemsList =
        cartProvider.getCartItems.values.toList().reversed.toList();
    double total = 0.0;
    cartProvider.getCartItems.forEach((key, value) {
      final getCurrProduct = productProvider.findProdById(value.productId);
      total += (getCurrProduct.isOnSale
              ? getCurrProduct.salePrice
              : getCurrProduct.price) *
          value.quantity;
    });
    Provider.of<DarkThemeProvider>(context, listen: false);
        double mok=0.5;
    double delivery=5;
    double totalPricev=mok+delivery+total;
    String f=totalPricev.toString();
      //  print(name);
    return Scaffold(
      body: isWaiting
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text('Loading....'),
                  SizedBox(
                    height: 12.0,
                  ),
                  CircularProgressIndicator(),
                ],
              ),
            )
          : Center(
              child: SizedBox(
                width: 200,
                height: 75,
                child: SwishButton.secondaryElevatedButton(
                  onPressed: () async {
                    try {
                      Provider.of<DarkThemeProvider>(context, listen: false);
                      print(totalPricev);
                         SwishPaymentData swishPaymentData =   SwishPaymentData(
    
                           payeeAlias: '1231181189',
                            amount: f ,
                           currency: 'SEK',
                            callbackUrl: 'https://mss.cpc.getswish.net/swish-cpcapi/api/v1/paymentrequests/',
                              message: '',
                               );
                      // Create the payment requst
                      SwishPaymentRequest swishPaymentRequest =
                          await widget.swishClient.createPaymentRequest(
                        swishPaymentData: swishPaymentData,
                      );
                      // Ensure that the payment request is valid.
                      if (swishPaymentRequest.errorCode != null) {
                        throw Exception(swishPaymentRequest.errorMessage);
                      }
                      setState(() {
                        isWaiting = true;
                      });
                      // Wait until the Swish user receives the payment request and
                      // decides to either pay it or decline it. A timeout is also
                      // possible (the user does nothing).
                      swishPaymentRequest =
                          await widget.swishClient.waitForPaymentRequest(
                        location: swishPaymentRequest.location!,
                      );
                      setState(() {
                        isWaiting = false;
                      });
                      // The payment is now done (or failed).
                     Navigator.push(
                         context,
                         MaterialPageRoute(builder: (context) =>  CartShow(
                          detiles: widget.details,
                         )),
                                   );
                    // User? user = authInstance.currentUser;
                    // final orderId = const Uuid().v4();
                    // final productProvider =
                    //     Provider.of<ProductsProvider>(context, listen: false);
                    // cartProvider.getCartItems.forEach((key, value) async {
                    //   final getCurrProduct = productProvider.findProdById(
                    //     value.productId,
                    //   );
                    //   // final loc.LocationData _locationResult =
                    //   //     await location.getLocation();
                      
                    //   try {
                        
                    //     final DocumentSnapshot userDoc = await FirebaseFirestore
                    //         .instance
                    //         .collection('users')
                    //         .doc(user!.uid)
                    //         .get();
                    //     phoneNumber = userDoc.get('phoneNumber');
                    //     await FirebaseFirestore.instance
                    //         .collection('orders')
                    //         .doc(orderId)
                    //         .set({
                    //       'orderId': orderId,
                    //       'userId': user.uid,
                    //       'productId': value.productId,
                    //       'price': (getCurrProduct.isOnSale
                    //               ? getCurrProduct.salePrice
                    //               : getCurrProduct.price) *
                    //           value.quantity,
                    //       'totalPrice': total,
                    //       'quantity': value.quantity,
                    //       'imageUrl': getCurrProduct.imageUrl,
                    //       'userName': user.displayName,
                    //       // 'latitude': _locationResult.latitude,
                    //       // 'longitude': _locationResult.longitude,
                    //       'orderDate': Timestamp.now(),
                    //       'phoneNumber': phoneNumber,
                    //       'productCategoryName':
                    //           getCurrProduct.productCategoryName,
                    //       'title': getCurrProduct.title,
                    //       'details': getCurrProduct.detiles
                    //     });
                    //     //payment fun is here with delivery
                    //     await cartProvider.clearOnlineCart();
                    //     cartProvider.clearLocalCart();
                    //     ordersProvider.fetchOrders();
                    //     await Fluttertoast.showToast(
                    //       msg:
                    //           "Your order has been placed and it need 20 min to be ready",
                    //       toastLength: Toast.LENGTH_LONG,
                    //       gravity: ToastGravity.CENTER,
                    //     );
                    //       Navigator.push(
                    //      context,
                    //      MaterialPageRoute(builder: (context) => const FetchScreen()),
                    //                );
                    //   } catch (error) {
                    //     GlobalMethods.errorDialog(
                    //         subtitle: error.toString(), context: context);
                    //   } finally {}
                    // });
 
                      // ignore: avoid_print
                      print(
                        swishPaymentRequest.toString(),
                      );
                      
                    } catch (error) {
                      // ignore: avoid_print
                      print(
                        error.toString(),
                      );
                    }
                  },
                ),
              ),
            ),
            
    );
     
  }
  
}
        // User? user = authInstance.currentUser;
        //             final orderId = const Uuid().v4();
        //             final productProvider =
        //                 Provider.of<ProductsProvider>(context, listen: false);

        //             cartProvider.getCartItems.forEach((key, value) async {
        //               final getCurrProduct = productProvider.findProdById(
        //                 value.productId,
        //               );

        //               try {
        //                 // final loc.LocationData _locationResult = await location.getLocation();

        //                 final DocumentSnapshot userDoc = await FirebaseFirestore
        //                     .instance
        //                     .collection('users')
        //                     .doc(user!.uid)
        //                     .get();
        //                 phoneNumber = userDoc.get('phoneNumber');
        //                 await FirebaseFirestore.instance
        //                     .collection('ordersBackup')
        //                     .doc(orderId)
        //                     .set({
        //                   'orderId': orderId,
        //                   'userId': user.uid,
        //                   'productId': value.productId,
        //                   'price': (getCurrProduct.isOnSale
        //                           ? getCurrProduct.salePrice
        //                           : getCurrProduct.price) *
        //                       value.quantity,
        //                   'totalPrice': widget.total,
        //                   'quantity': value.quantity,
        //                   'imageUrl': getCurrProduct.imageUrl,
        //                   'userName': user.displayName,
        //                   // 'latitude': _locationResult.latitude,
        //                   // 'longitude': _locationResult.longitude,
        //                   'orderDate': Timestamp.now(),
        //                   'phoneNumber': phoneNumber,
        //                   'productCategoryName':
        //                       getCurrProduct.productCategoryName,
        //                   'title': getCurrProduct.title,
        //                 });
        //                 //payment fun is here without delivery
        //                 await cartProvider.clearOnlineCart();
        //                 cartProvider.clearLocalCart();
        //                 ordersProvider.fetchOrders();
        //                 await Fluttertoast.showToast(
        //                   msg:
        //                       "Du kan gå till restaurangen och hämta din leverans ",
        //                   toastLength: Toast.LENGTH_LONG,
        //                   gravity: ToastGravity.CENTER,
        //                 );
        //                  Navigator.push(
        //                  context,
        //                  MaterialPageRoute(builder: (context) => const FetchScreen()),
        //                            );
        //               } catch (error) {
        //                 GlobalMethods.errorDialog(
        //                     subtitle: error.toString(), context: context);
        //               } finally {}
        //             });