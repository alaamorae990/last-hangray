import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:hangry/models/tax_model.dart';

import '../models/orders_model.dart';
import '../models/products_model.dart';
import '../models/res_model.dart';

class ProductsProvider with ChangeNotifier {
  static List<ResModel> _resturantsList = [];
  static List<ProductModel> _productsList = [];
  static List<OrderModel> _orderList = [];
  static List<TaxModel> _TaxList = [];

  List<TaxModel> get getTax {
    return _TaxList;
  }

  List<OrderModel> get getorder {
    return _orderList;
  }

  List<ProductModel> get getProducts {
    return _productsList;
  }

  List<ResModel> get getResturants {
    return _resturantsList;
  }

  List<ProductModel> get getOnSaleProducts {
    return _productsList.where((element) => element.isOnSale).toList();
  }

  List<ResModel> get getOnSaleRes {
    return _resturantsList.where((element) => element.isOnSale).toList();
  }

  Future<void> fetchOrder() async {
    await FirebaseFirestore.instance
        .collection('orders')
        .get()
        .then((QuerySnapshot resturantSnapshot) {
      _orderList = [];
      resturantSnapshot.docs.forEach((element) {
        _orderList.insert(
            0,
            OrderModel(
                imageUrl:  element.get('imageUrl'),
                lati:  element.get('latitude'),
                long:  element.get('longitude'),
                orderDate:  element.get('orderDate'),
                orderId:  element.get('orderId'),
                price:  element.get('price'),
                productId:  element.get('productId'),
                quantity:  element.get('quantity'),
                userId:  element.get('userId'),
                userName:  element.get('userName'),
                ));
      });
    });
    notifyListeners();
  }

  Future<void> fetchTax() async {
    await FirebaseFirestore.instance
        .collection('driverTax')
        .get()
        .then((QuerySnapshot resturantSnapshot) {
      _TaxList = [];
      resturantSnapshot.docs.forEach((element) {
        _TaxList.insert(
            0,
            TaxModel(
              tax: element.get('Tax'),
              deliveryValue: element.get('deliveryValue'),
            ));
      });
    });
    notifyListeners();
  }

  Future<void> fetchResturant() async {
    await FirebaseFirestore.instance
        .collection('resturants')
        .get()
        .then((QuerySnapshot resturantSnapshot) {
      _resturantsList = [];
      resturantSnapshot.docs.forEach((element) {
        _resturantsList.insert(
            0,
            ResModel(
              title: element.get('title'),
              imageUrl: element.get('imageUrl'),
              isOnSale: element.get('isOnSale'),
            ));
      });
    });
    notifyListeners();
  }

  Future<void> fetchProducts() async {
    await FirebaseFirestore.instance
        .collection('products')
        .get()
        .then((QuerySnapshot productSnapshot) {
      _productsList = [];
      // _productsList.clear();
      productSnapshot.docs.forEach((element) {
        _productsList.insert(
            0,
            ProductModel(
              id: element.get('id'),
              title: element.get('title'),
              imageUrl: element.get('imageUrl'),
              productCategoryName: element.get('productCategoryName'),
              price: double.parse(
                element.get('price'),
              ),
              salePrice: element.get('salePrice'),
              isOnSale: element.get('isOnSale'),
              isPiece: element.get('isPiece'),
              detiles: element.get("title"),
            ));
      });
    });
    notifyListeners();
  }

  ProductModel findProdById(String productId) {
    return _productsList.firstWhere((element) => element.id == productId);
  }

  List<ProductModel> findByCategory(String categoryName) {
    List<ProductModel> _categoryList = _productsList
        .where((element) => element.productCategoryName
            .toLowerCase()
            .contains(categoryName.toLowerCase()))
        .toList();
    return _categoryList;
  }

  List<ProductModel> searchQuery(String searchText) {
    List<ProductModel> _searchList = _productsList
        .where(
          (element) => element.title.toLowerCase().contains(
                searchText.toLowerCase(),
              ),
        )
        .toList();
    return _searchList;
  }
}
