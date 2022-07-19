import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../providers/products_provider.dart';
import '../widgets/user_product_item.dart';
import '../widgets/app_drawer.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/userProducts';

  Future<void> _refreshProducts(BuildContext context) async {
    Provider.of<ProductsProvider>(context, listen: false).fetchAndSetProducts();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductsProvider>(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: <Widget>[
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.plus),
            onPressed: () {
              Navigator.of(context).pushNamed('/editProductScreen');
            },
          )
        ],
      ),
      drawer: const AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _refreshProducts(context),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListView.builder(
            itemCount: productsData.items.length,
            itemBuilder: (context, index) => Column(
              children: [
                UserProductItem(
                  id: productsData.items[index].id!,
                  title: productsData.items[index].title,
                  imageUrl: productsData.items[index].imageUrl,
                ),
                const Divider(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
