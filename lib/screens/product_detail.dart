import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product-detail';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final loadedProduct = Provider.of<ProductsProvider>(context, listen: false).findById(productId);

    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              height: 300,
              width: double.infinity,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(loadedProduct.imageUrl, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 10),
            Text('\$ ${loadedProduct.price}', style: const TextStyle(color: Colors.grey, fontSize: 20)),
            const SizedBox(height: 10),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(loadedProduct.description, textAlign: TextAlign.center, softWrap: true),
            ),
          ],
        ),
      ),
    );
  }
}
