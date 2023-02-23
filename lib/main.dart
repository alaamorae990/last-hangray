import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:hangry/consts/firebase_consts.dart';

import 'package:hangry/providers/dark_theme_provider.dart';
import 'package:hangry/providers/orders_provider.dart';
import 'package:hangry/providers/products_provider.dart';
import 'package:hangry/providers/viewed_prod_provider.dart';
import 'package:hangry/screens/auth/global_phone.dart';
import 'package:hangry/screens/cart/backup_del_.dart';

import 'package:hangry/screens/categories.dart';
import 'package:hangry/screens/maps/map_page.dart';
import 'package:hangry/screens/payment/make_payment.dart';
import 'package:hangry/screens/payment/swich.dart';
import 'package:hangry/screens/user.dart';
import 'package:hangry/screens/viewed_recently/viewed_recently.dart';
import 'package:hangry/services/location.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'consts/theme_data.dart';
import 'fetch_screen.dart';
import 'inner_screens/cat_screen.dart';
import 'inner_screens/feeds_screen.dart';
import 'inner_screens/on_sale_screen.dart';
import 'inner_screens/product_details.dart';
import 'providers/cart_provider.dart';
import 'providers/wishlist_provider.dart';
import 'screens/auth/forget_pass.dart';
import 'screens/auth/login.dart';
import 'screens/auth/register.dart';
import 'screens/auth/register_phone.dart';
import 'screens/btm_bar.dart';
import 'screens/orders/orders_screen.dart';
import 'screens/wishlist/wishlist_screen.dart';
import 'package:location/location.dart' as loc;
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_swish_payment/flutter_swish_payment.dart';
import 'package:http/http.dart' as http;
Future< void> main()  async{
 WidgetsFlutterBinding.ensureInitialized();
 
   Stripe.publishableKey =
      "pk_live_51Lps03L2H1LDQxk1tgGrsQ5jSmqFTmlR0hbW1NJ7926QU8NdefzDdpRXlkYdhKifp8L3zDPvmWUwqfLIKdluRScA00FslAjpbK";
  Stripe.instance.applySettings();
  // SharedPreferences.getInstance().then((instance){
    // language=instance.getString('language')!;
     ByteData cert = await rootBundle.load(
    'assets/Swish_Merchant_TestCertificate_1234679304.pem',
  );
  ByteData key = await rootBundle.load(
    'assets/Swish_Merchant_TestCertificate_1234679304.key',
  );
    String credential = "swish";
     SwishAgent swishAgent = SwishAgent.initializeAgent(
    key: key,
    cert: cert,
    credential: credential,
  );

  SwishClient swishClient = SwishClient(
    swishAgent: swishAgent,
  );
  
  runApp( MyApp(
    swishClient: swishClient,
  ));

  
}

class MyApp extends StatefulWidget {
  final SwishClient swishClient;
   const MyApp({Key? key, required this.swishClient}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
  
}

class _MyAppState extends State<MyApp> {

  DarkThemeProvider themeChangeProvider = DarkThemeProvider();
  

  


  void getCurrentAppTheme() async {
    themeChangeProvider.setDarkTheme =
        await themeChangeProvider.darkThemePrefs.getTheme();
  }


  @override
  void initState() {
    
    getCurrentAppTheme();
    super.initState();
  }

  final Future<FirebaseApp> _firebaseInitialization = Firebase.initializeApp();
  
  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
        future: _firebaseInitialization,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                  body: Center(
                child: CircularProgressIndicator(),
              )),
            );
          } else if (snapshot.hasError) {
            const MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                  body: Center(
                child: Text('An error occured'),
              )),
            );
          }
          return MultiProvider(
            providers: [
                      Provider<FirebaseAuthMethods>(
          create: (_) => FirebaseAuthMethods(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) => context.read<FirebaseAuthMethods>().authState,
          initialData: null,
        ),
        
              ChangeNotifierProvider(create: (_) {
                return themeChangeProvider;
              }),

              ChangeNotifierProvider(
                create: (_) => ProductsProvider(),
              ),
              ChangeNotifierProvider(
                create: (_) => CartProvider(),
              ),
              ChangeNotifierProvider(
                create: (_) => WishlistProvider(),
              ),
              ChangeNotifierProvider(
                create: (_) => ViewedProdProvider(),
              ),
              ChangeNotifierProvider(
                create: (_) => OrdersProvider(),
              ),
              
              
            ],
            
            child: Consumer<DarkThemeProvider>(
                builder: (context, themeProvider, child) {
              return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: 'Flutter Demo',
                  theme: Styles.themeData(themeProvider.getDarkTheme, context),
                  home:    
                  // MapPage(),
                  FetchScreen(),
                  routes: {
                    OnSaleScreen.routeName: (ctx) => const OnSaleScreen(),
                    FeedsScreen.routeName: (ctx) => const FeedsScreen(),
                    ProductDetails.routeName: (ctx) => const ProductDetails(),
                    WishlistScreen.routeName: (ctx) => const WishlistScreen(),
                    OrdersScreen.routeName: (ctx) => const OrdersScreen(),
                    ViewedRecentlyScreen.routeName: (ctx) =>
                        const ViewedRecentlyScreen(),
                    RegisterScreen.routeName: (ctx) => const RegisterScreen(),
                    LoginScreen.routeName: (ctx) => const LoginScreen(),
                    ForgetPasswordScreen.routeName: (ctx) =>
                        const ForgetPasswordScreen(),
                    CategoryScreen.routeName: (ctx) => const CategoryScreen(),
                    CategoriesScreen.routeName: (ctx) =>  CategoriesScreen(),
                  // HomePage.routeName: (ctx) =>  HomePage(swishClient:widget.swishClient,),
                    // PhoneScreen.routeName: (ctx) =>  PhoneScreen(),
                     makePayment.routeName: (ctx) =>  makePayment(swishClient: widget.swishClient,),
                     BackupOrDel.routeName: (ctx) =>  BackupOrDel(swishClient: widget.swishClient,),
                  });
            }),
          );
        }
        );
  }
}
// class PaymentDemo extends StatelessWidget {
//   const PaymentDemo({Key? key}) : super(key: key);
//   Future<void> initPayment(
//       {required String email,
//       required double amount,
//       required BuildContext context}) async {
//     try {
//       // 1. Create a payment intent on the server
//       final response = await http.post(
//           Uri.parse(
//               'https://us-central1-hangry-94bea.cloudfunctions.net/stripePaymentIntentRequest'),
//           body: {
//             'email': email,
//             'amount': amount.toString(),
//           });

//       final jsonResponse = jsonDecode(response.body);
//       print(jsonResponse.toString());
//       // 2. Initialize the payment sheet
//       await Stripe.instance.initPaymentSheet(
//           paymentSheetParameters: SetupPaymentSheetParameters(
//         paymentIntentClientSecret: jsonResponse['paymentIntent'],
//         merchantDisplayName: 'Grocery Flutter course',
//         customerId: jsonResponse['customer'],
//         customerEphemeralKeySecret: jsonResponse['ephemeralKey'],
        
//         // testEnv: true,
//         // merchantCountryCode: 'SG',
//       ));
//       await Stripe.instance.presentPaymentSheet();
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Payment is successful'),
//         ),
//       );
//     } catch (errorr) {
//       if (errorr is StripeException) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('An error occured ${errorr.error.localizedMessage}'),
//           ),
//         );
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('An error occured $errorr'),
//           ),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//           child: ElevatedButton(
//         child: const Text('Pay 20\$'),
//         onPressed: () async {
//           await initPayment(
//               amount: 300.00, context: context, email: 'email@test.com');
//         },
//       )),
//     );
//   }
// }
