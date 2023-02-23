import 'package:flutter/material.dart';
import 'package:hangry/widgets/text_widget.dart';


import '../services/utils.dart';

class PriceWidget extends StatelessWidget {
  const PriceWidget({
    Key? key,
    required this.salePrice,
    required this.price,
    required this.textPrice,
    required this.isOnSale,
  }) : super(key: key);
  final double salePrice, price;
  final String textPrice;
  final bool isOnSale;
  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    double userPrice = isOnSale? salePrice : price;
    return FittedBox(
        child: Row(
      children: [
        TextWidget(
          text: '\Kr ${(userPrice * int.parse(textPrice)).toStringAsFixed(2)}',
          color: Color.fromARGB(255, 8, 8, 0),
          textSize: 18,
          isTitle: true,
        ),
        const SizedBox(
          width: 5,
        ),
        Visibility(
          visible: isOnSale? true :false,
          child: Text(
            '\Kr ${(price * int.parse(textPrice)).toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 15,
              color: Color.fromARGB(255, 201, 16, 16),
              decoration: TextDecoration.lineThrough,
            ),
          ),
        ),
      ],
    ));
  }
}
