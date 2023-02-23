import 'package:flutter/cupertino.dart';

class CartModel with ChangeNotifier {
  final String id, productId,details;
  final int quantity;


  CartModel({
    required this .details,
    required this.id,
    required this.productId,
    required this.quantity,
  });
}
