
import 'package:flutter/material.dart';
import 'package:flutter_swish_payment/flutter_swish_payment.dart';
import 'package:location/location.dart' as loc;
import '../../consts/theme_data.dart';
import '../../services/utils.dart';
import '../../widgets/back_widget.dart';
import '../../widgets/text_widget.dart';
import '../payment/make_payment.dart';
import '../payment/make_payment_delivery.dart';
class BackupOrDel extends StatefulWidget {
    static const routeName = '/BackupOrDel';
      final SwishClient swishClient;
  const BackupOrDel({Key? key, required this.swishClient}) : super(key: key);

  @override
  State<BackupOrDel> createState() => _BackupOrDelState();
}

class _BackupOrDelState extends State<BackupOrDel> {
  @override
  Widget build(BuildContext context) {
        final Color color = Utils(context).color;
    return Scaffold(
       appBar: AppBar(

          elevation: 0,
          backgroundColor: primary,
        ),
          body: Stack(children:<Widget> [
            Center(child: Image.asset('assets/images/cart.png',fit: BoxFit.fitHeight,)),
            Container(
              color: Theme.of(context).cardColor,
            ),
             SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(
                  height: 80,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(child: TextWidget(text:'Vill du att vi levererar eller så tar du din måltid själv?', color: color, textSize: 18,isTitle: true)),
                ),
          
                SizedBox(
                  height: 60,
                ),
                Center(
                  child: Container(
                  
                    width: double.infinity,
                    height: 350,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        RaisedButton(
                          color: Color.fromARGB(255, 255, 200, 0).withOpacity(0.7),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                          onPressed: () async {
                            // make PayPal payment
                    final loc.LocationData _locationResult =
                          await location.getLocation();
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (BuildContext context) => MakePaymentDeliv(
                                  
                                   swishClient: widget.swishClient,
                                ),
                              ),
                            );
                          },
                          child: TextWidget(
                            text: 'Leverans',
                            color: color,
                            textSize: 20,
                            isTitle: true,
                          ),
                        ),
                //         SizedBox(
                //   width: 60,
                // ),
                        //backup
                        RaisedButton(
                          color: Color.fromARGB(255, 255, 200, 0).withOpacity(0.7),
                     shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                          onPressed: () {
          
                           Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (BuildContext context) => makePayment(
                                  swishClient : widget.swishClient,
                                  
                                ),
                              ),
                            );
                          },
                          child: TextWidget(
                            text: 'ta din måltid själv',
                            color: color,
                            textSize: 20,
                            isTitle: true,
                          ),
                        ),
                        
                      ],
                    ),
                  ),
                ),
              ],
            ),
                  ),
          ],
          ),
    );
  }
}
// Vill du att vi levererar eller så tar du din måltid själv?
// // User? user = authInstance.currentUser;
//                     final orderId = const Uuid().v4();
//                     final productProvider =
//                         Provider.of<ProductsProvider>(context, listen: false);

//                     cartProvider.getCartItems.forEach((key, value) async {
//                       final getCurrProduct = productProvider.findProdById(
//                         value.productId,
//                       );

//                       try {
//                         // final loc.LocationData _locationResult = await location.getLocation();

//                         final DocumentSnapshot userDoc = await FirebaseFirestore
//                             .instance
//                             .collection('users')
//                             .doc(user!.uid)
//                             .get();
//                         phoneNumber = userDoc.get('phoneNumber');
//                         await FirebaseFirestore.instance
//                             .collection('ordersBackup')
//                             .doc(orderId)
//                             .set({
//                           'orderId': orderId,
//                           'userId': user.uid,
//                           'productId': value.productId,
//                           'price': (getCurrProduct.isOnSale
//                                   ? getCurrProduct.salePrice
//                                   : getCurrProduct.price) *
//                               value.quantity,
//                           'totalPrice': total,
//                           'quantity': value.quantity,
//                           'imageUrl': getCurrProduct.imageUrl,
//                           'userName': user.displayName,
//                           // 'latitude': _locationResult.latitude,
//                           // 'longitude': _locationResult.longitude,
//                           'orderDate': Timestamp.now(),
//                           'phoneNumber': phoneNumber,
//                           'productCategoryName':
//                               getCurrProduct.productCategoryName,
//                           'title': getCurrProduct.title,
//                         });
//                         //payment fun is here without delivery
//                         await cartProvider.clearOnlineCart();
//                         cartProvider.clearLocalCart();
//                         ordersProvider.fetchOrders();
//                         await Fluttertoast.showToast(
//                           msg:
//                               "Du kan gå till restaurangen och hämta din leverans ",
//                           toastLength: Toast.LENGTH_LONG,
//                           gravity: ToastGravity.CENTER,
//                         );
//                          Navigator.push(
//                          context,
//                          MaterialPageRoute(builder: (context) => const FetchScreen()),
//                                    );
//                       } catch (error) {
//                         GlobalMethods.errorDialog(
//                             subtitle: error.toString(), context: context);
//                       } finally {}
//                     });
//                   },