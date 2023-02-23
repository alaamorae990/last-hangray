import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:hangry/consts/theme_data.dart';
import 'package:hangry/widgets/text_widget.dart';

import 'package:provider/provider.dart';

import '../consts/firebase_consts.dart';
import '../inner_screens/cat_screen.dart';
import '../inner_screens/on_sale_screen.dart';
import '../inner_screens/product_details.dart';
import '../models/products_model.dart';
import '../models/res_model.dart';
import '../providers/cart_provider.dart';
import '../providers/wishlist_provider.dart';
import '../services/global_methods.dart';
import '../services/helper.dart';
import '../services/utils.dart';
import 'heart_btn.dart';
import 'price_widget.dart';

class OnSaleResWidget extends StatefulWidget {
  const OnSaleResWidget({Key? key}) : super(key: key);

  @override
  State<OnSaleResWidget> createState() => _OnSaleResWidgetState();
}

class _OnSaleResWidgetState extends State<OnSaleResWidget> {
  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    final productModel = Provider.of<ResModel>(context);
    final theme = Utils(context).getTheme;
    Size size = Utils(context).getScreenSize;
    // final cartProvider = Provider.of<CartProvider>(context);
    // bool? _isInCart = cartProvider.getCartItems.containsKey(productModel.id);
    // final wishlistProvider = Provider.of<WishlistProvider>(context);
    // bool? _isInWishlist =
    //     wishlistProvider.getWishlistItems.containsKey(productModel.id);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(

        color: Color.fromARGB(181, 253, 214, 230).withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        child: InkWell(

          borderRadius: BorderRadius.circular(12),
          onTap: () {
             Navigator.pushNamed(context, CategoryScreen.routeName,
             arguments: productModel.title);
          },
          child:
           Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      
                      FancyShimmerImage(
                        imageUrl: productModel.imageUrl,
                         height: size.width * 0.28,
                         width: size.width*0.85 ,
                        boxFit: BoxFit.fill,
                      ),
                      Column(
                        children: const [
                          // TextWidget(
                          //   text: productModel.isPiece ? '1Piece' : '1KG',
                          //   color: color,
                          //   textSize: 22,
                          //   isTitle: true,
                          // ),
                          SizedBox(
                            height: 12,
                          ),
                          // Row(
                          //   children: [
                          //     GestureDetector(
                          //       onTap: _isInCart
                          //           ? null
                          //           : () async {
                          //               final User? user =
                          //                   authInstance.currentUser;

                          //               if (user == null) {
                          //                 GlobalMethods.errorDialog(
                          //                     subtitle:
                          //                         'No user found, Please login first',
                          //                     context: context);
                          //                 return;
                          //               }
                          //               await GlobalMethods.addToCart(
                          //                   productId: productModel.id,
                          //                   quantity: 1,
                          //                   context: context);
                          //               await cartProvider.fetchCart();
                          //               // cartProvider.addProductsToCart(
                          //               //     productId: productModel.id,
                          //               //     quantity: 1);
                          //             },
                          //       child: Icon(
                          //         _isInCart
                          //             ? IconlyBold.bag2
                          //             : IconlyLight.bag2,
                          //         size: 22,
                          //         color: _isInCart ? Colors.green : color,
                          //       ),
                          //     ),
                          //     HeartBTN(
                          //       productId: productModel.id,
                          //       isInWishlist: _isInWishlist,
                          //     )
                          //   ],
                          // ),
                        ],
                      )
                    ],
                  ),
                  // PriceWidget(
                  //   salePrice: productModel.salePrice,
                  //   price: productModel.price,
                  //   textPrice: '1',
                  //   isOnSale: true,
                  // ),
                  const SizedBox(height: 5),
                  TextWidget(
                    text: productModel.title,
                    color: color.withOpacity(0.7),
                    textSize: 20,
                    isTitle: true,
                    
                  ),
                  const SizedBox(height: 5),
                ]),
          ),
        ),
      ),
    );
  }
}
// class RestaurantCard extends StatelessWidget {
//   const RestaurantCard({
//     required Key key,
//     required String name,
//     required Image image,
//   })  : _image = image,
//         _name = name,
//         super(key: key);

//   final String _name;
//   final Image _image;

//   @override
//   Widget build(BuildContext context) {
//     return 
//     SizedBox(
//       height: 270,
//       width: double.infinity,
//       child: Column(
//         children: [
//           SizedBox(height: 200, width: double.infinity, child: _image),
//           SizedBox(
//             height: 10,
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(
//               horizontal: 20,
//             ),
//             child: Column(
//               children: [
//                 Row(
//                   children: [
//                     Text(
//                       _name,
//                       style: Helper.getTheme(context).headline3,
//                     ),
//                   ],
//                 ),
//                 SizedBox(
//                   height: 5,
//                 ),
//                 Row(
//                   children: [
//                     Image.asset(
//                       Helper.getAssetName("star_filled.png", "virtual"),
//                     ),
//                     SizedBox(
//                       width: 5,
//                     ),
//                     Text(
//                       "4.9",
//                       style: TextStyle(
//                         color: primary,
//                       ),
//                     ),
//                     SizedBox(
//                       width: 5,
//                     ),
//                     Text("(124 ratings)"),
//                     SizedBox(
//                       width: 5,
//                     ),
//                     Text("Cafe"),
//                     SizedBox(
//                       width: 5,
//                     ),
//                     const Padding(
//                       padding: EdgeInsets.only(bottom: 5.0),
//                       child: Text(
//                         ".",
//                         style: TextStyle(
//                           color: primary,
//                           fontWeight: FontWeight.w900,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(
//                       width: 5,
//                     ),
//                     Text("Western Food"),
//                   ],
//                 ),
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }