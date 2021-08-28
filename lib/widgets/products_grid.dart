import 'package:flutter/material.dart';
import 'package:shopping/providers/products.dart';
import 'package:shopping/widgets/product_item.dart';
import 'package:provider/provider.dart';

class ProductsGrid extends StatelessWidget {
  final bool isFavorite;

  ProductsGrid(this.isFavorite);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products =
        isFavorite ? productsData.favoriteItems : productsData.items;
    return GridView.builder(
        padding: EdgeInsets.all(10),
        itemCount: products.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (context, index) {
          return ChangeNotifierProvider.value(
            // create: (ctx) => products[index],
            value: products[index],
            child: ProductItem(
                // id: products[index].id,
                // title: products[index].title,
                // imageUrl: products[index].imageUrl,
                ),
          );
        });
  }
}
