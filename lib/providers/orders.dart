import 'package:flutter/material.dart';
import 'package:shopping/providers/product.dart';
import 'cart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'
    '';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  List<OrderItem> get orders {
    return [..._orders];
  }

  final String authToken;
  final String userId;
  Orders(this.authToken, this._orders, this.userId);

  Future<void> fetchAndSetOrders() async {
    final url = Uri.parse(
        'https://shopappudemy-757ee-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken');
    List<OrderItem> loadedOrders = []; // helper list!!!
    final response = await http.get(url);
    final extractedData = jsonDecode(response.body) as Map<String, dynamic>;

    /// calling .forEach on null will throw an error so we need to check this
    /// first
    if (extractedData == null) {
      return;
    }

    /// we can have many orders (with different id's). Each id have different orderData
    /// (amount: dateTime: product:)
    /// we have to return list of OrderItems
    /// orderData is a Map!!! You idiot!!:)))
    /// THIS CODE IS VERY IMPORTANT TO UNDERSTAND
    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(
        OrderItem(
          id: orderId,
          amount: orderData['amount'],
          dateTime: DateTime.parse(
            orderData['dateTime'],
          ),
          products: (orderData['product'] as List<dynamic>)
              .map(
                (item) => CartItem(
                  id: item['id'],
                  title: item['title'],
                  quantity: item['quantity'],
                  price: double.parse(item['price'].toString()),
                ),
              )
              .toList(),
        ),
      );
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProducts, double amount) async {
    final url = Uri.parse(
        'https://shopappudemy-757ee-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken');
    final timestamp = DateTime.now();

    /// This one is created for the server (Firebase in this case)
    final response = await http.post(
      url,
      body: json.encode({
        'amount': amount,
        'dateTime': timestamp.toIso8601String(),

        /// cartProducts is a list of CartItems (objects) but
        /// 'products': cartProducts, is not an option, we need to convert
        /// each CartItems object to a map

        'product': cartProducts
            .map((cartProduct) => {
                  'id': cartProduct.id,
                  'title': cartProduct.title,
                  'quantity': cartProduct.quantity,
                  'price': cartProduct.price,
                })
            .toList(),
      }),
    );
    _orders.insert(
      0,

      /// This one is created for the local memory
      /// response.body is a instance of a map with unique id sent by Firebase
      ///  response.body['name'] is unique id for that response
      OrderItem(
        id: json.decode(response.body)['name'],
        amount: amount,
        products: cartProducts,
        dateTime: timestamp,
      ),
    );
    notifyListeners();
  }
}
