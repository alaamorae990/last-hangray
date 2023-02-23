import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:hangry/consts/firebase_consts.dart';


import '../models/orders_model.dart';

class OrdersProvider with ChangeNotifier {
  static List<OrderModel> _orders = [];
  List<OrderModel> get getOrders {
    return _orders;
  }
  void clearLocalOrder(){
   _orders.clear();
   notifyListeners();
  }

  Future<void> fetchOrders() async {
    // User ?user=authInstance.currentUser;
    // print(user!.uid);
    await FirebaseFirestore.instance
        .collection('orders')
        .get()
        .then((QuerySnapshot ordersSnapshot) {
      _orders = [];
      // _orders.clear();
      ordersSnapshot.docs.forEach((element) {
        _orders.insert(
          0,
          OrderModel(
            long:element.get('longitude'),
            lati: element.get('latitude'),
            orderId: element.get('title'),
            userId: element.get('title'),
            productId: element.get('title'),
            userName: element.get('title'),
            price: element.get('title'),
            imageUrl: element.get('title'),
            quantity: element.get('quantity').toString(),
            orderDate: element.get('orderDate'),
          ),
        );
      });
    }
    );
    notifyListeners();
  }
}
