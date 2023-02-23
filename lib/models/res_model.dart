
import 'package:flutter/cupertino.dart';


class ResModel with ChangeNotifier{
  final String  title, imageUrl;
final bool isOnSale;
 

  ResModel(
      {
      required this.title,
      required this.isOnSale,
      required this.imageUrl,
      });
}
