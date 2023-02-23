
import 'package:flutter/cupertino.dart';


class TaxModel with ChangeNotifier{
  final String  tax, deliveryValue;
 

  TaxModel(
      {
      required this.tax,
      required this.deliveryValue,
      });
}
