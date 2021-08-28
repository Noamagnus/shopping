import 'package:flutter/material.dart';
import 'package:shopping/providers/orders.dart';
import 'package:provider/provider.dart';
import 'package:shopping/widgets/app_drawer.dart';
import 'package:shopping/widgets/order_item.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  Future _ordersFuture;

  Future<void> _obtainOrdersFuture() {
    return Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
  }

  /// we're doing this approach because we don't want this call fetchAndSetOrders()
  /// every time when build method fires!!! In our case is unnecessary but this is a
  /// good approach to follow in general
  @override
  void initState() {
    _ordersFuture = _obtainOrdersFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final ordersData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Orders',
        ),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _ordersFuture,

        /// this will be triggered every time when build fires and we don't want this
        // future: Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (dataSnapshot.hasError) {
            return Text('Something is wrong');
          } else {
            return Consumer<Orders>(
              builder: (ctx, ordersData, _) => ListView.builder(
                itemCount: ordersData.orders.length,
                itemBuilder: (ctx, i) => OrderItemWidget(
                  ordersData.orders[i],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

/// This is solution with StateFul widget, above is the on with FutureBuilder

// class OrdersScreen extends StatefulWidget {
//   static const routeName = '/orders';
//
//   @override
//   _OrdersScreenState createState() => _OrdersScreenState();
// }
//
// class _OrdersScreenState extends State<OrdersScreen> {
//   var _isInit = true;
//   bool _isLoading = true;
//
//   @override
//   void didChangeDependencies() {
//     if (_isInit) {
//       Provider.of<Orders>(context, listen: false).fetchAndSetOrders().then((_) {
//         setState(() {
//           _isLoading = false;
//         });
//       });
//     }
//     _isInit = false;
//     super.didChangeDependencies();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final ordersData = Provider.of<Orders>(context);
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Orders',
//         ),
//       ),
//       drawer: AppDrawer(),
//       body: _isLoading
//           ? Center(child: CircularProgressIndicator())
//           : ListView.builder(
//         itemCount: ordersData.orders.length,
//         itemBuilder: (ctx, i) => OrderItemWidget(
//           ordersData.orders[i],
//         ),
//       ),
//     );
//   }
// }
