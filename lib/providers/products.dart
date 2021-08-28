// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:shopping/providers/http_exeption.dart';
import 'package:shopping/providers/product.dart';
import 'product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Products with ChangeNotifier {
  List<Product> _items = [
    //  This one was dummy data and we were using them before start working with a firebase
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  var _showFavorites = false;
  final String authToken;
  final String userId;
  Products(this.authToken, this._items, this.userId);

  List<Product> get items {
    /// Ovako bi bilo da smo hteli da nam se podaci menjaju u celoj aplikaciji
    /// ali mi hocemo da nam se menjaju samo u ProductOverview widget-u
    // if (_showFavorites) {
    //   return _items
    //       .where((productElement) => productElement.isFavorite)
    //       .toList();
    // }
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((element) => element.isFavorite).toList();
  }

  // void showFavoritesOnly() {
  //   _showFavorites = true;
  //   notifyListeners();
  // }
  //
  // void showAll() {
  //   _showFavorites = false;
  //   notifyListeners();
  // }

  Product findById(productId) {
    return _items.firstWhere(
      (prod) => prod.id == productId,
    );
  }

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    final filterString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';

    /// order by user is server side task, that means its done by the server
    /// end of this url means that filter all products and show products where creatorId id equal to userId
    var url = Uri.parse(
        'https://shopappudemy-757ee-default-rtdb.firebaseio.com/products.json?auth=$authToken&$filterString');
    final response = await http.get(url);
    final extractedData = jsonDecode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return;
    }
    final favoriteUrl = Uri.parse(
        'https://shopappudemy-757ee-default-rtdb.firebaseio.com/userFavorites/$userId.json?auth=$authToken');
    final favoriteResponse = await http.get(favoriteUrl);
    final favoriteData = json.decode(favoriteResponse.body);
    final List<Product> loadedProducts = [];
    extractedData.forEach((prodId, prodData) {
      loadedProducts.add(Product(
        id: prodId,
        title: prodData['title'],
        description: prodData['description'],
        price: prodData['price'],
        imageUrl: prodData['imageUrl'],

        /// last code snippet means if prodId is null (not entry for that data)then its also going to be false
        isFavorite:
            favoriteData == null ? false : favoriteData[prodId] ?? false,
      ));
    });
    _items = loadedProducts;
    notifyListeners();
  }

  ///Once you add async for addProduct function everything inside its body is wrapped in Future
  ///that means that we don't have to return anything because Future'll be returned automatically

  Future<void> addProduct(Product product) async {
    final url = Uri.parse(
        'https://shopappudemy-757ee-default-rtdb.firebaseio.com/products.json?auth=$authToken ');

    /// body should use json data and for that we'll use decoder/encoder
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'id': product.id,
          'title': product.title,
          'description': product.description,
          'price': product.price,
          'imageUrl': product.imageUrl,
          'creatorId': userId,
          // 'isFavorite': product.isFavorite,
        }),
      );

      /// This code is "invisibly" wrapped in a .then() method

      var newProduct = Product(
        id: jsonDecode(response.body)['name'],
        title: product.title,
        price: product.price,
        description: product.description,
        imageUrl: product.imageUrl,
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    // final prodId = _items.where((product) => product.id == newProduct.id);
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url = Uri.parse(
          'https://shopappudemy-757ee-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken');

      /// This part of code update data on Firebase
      await http.patch(url,
          body: jsonEncode({
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price,
          }));

      /// This code snippet update Products in local memory
      _items[prodIndex] = newProduct;
    } else {
      print('...');
    }
    notifyListeners();
  }

  Future<void> deleteProducts(String id) async {
    final url = Uri.parse(
        'https://shopappudemy-757ee-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken');

    /// This is called optimistic updating. We're storing existingProduct in local memory
    /// before deleting it to check if there is no error. If error happens we'll add it back to
    /// _items and delete it only if there is no error with .then() block of code
    var existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();

    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product.');
    } else {
      existingProduct = null;
    }
  }

  // Future<void> toggleFavoriteStatus(String id, Product product) async {
  //   final prodIndex = _items.indexWhere((prod) => prod.id == id);
  //   final url = Uri.parse(
  //       'https://shopappudemy-757ee-default-rtdb.firebaseio.com/products/$id.json');
  //
  //   await http.patch(url,
  //       body: jsonEncode({
  //         'isFavorite': product.isFavorite,
  //       }));
  //   _items[prodIndex] = product;
  //   notifyListeners();
  // }
}

//     .catchError((_) {
// _items.insert(existingProductIndex, existingProduct);
// notifyListeners();
// });

// Future<void> addProduct(Product product) {
//   final url = Uri.parse(
//       'https://shopappudemy-757ee-default-rtdb.firebaseio.com/products.json');
//
//   /// body should use json data and for that we'll use decoder/encoder
//   return http
//       .post(
//     url,
//     body: json.encode({
//       'id': product.id,
//       'title': product.title,
//       'description': product.description,
//       'price': product.price,
//       'imageUrl': product.imageUrl,
//       'isFavorite': product.isFavorite,
//     }),
//   )
//       .then((response) {
//     print(jsonDecode(response.body));
//     var newProduct = Product(
//       id: jsonDecode(response.body)['name'],
//       title: product.title,
//       price: product.price,
//       description: product.description,
//       imageUrl: product.imageUrl,
//     );
//     _items.add(newProduct);
//     notifyListeners();
//   }).catchError((error) {
//     print(error);
//
//     /// throw means that we'll forward it to the next catchError block to handle it
//     /// e.g. to pop some error snack bar or something else.
//     /// we'll do it in editProductScreen
//     throw error;
//   });
// }
