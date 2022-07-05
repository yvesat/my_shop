import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_shop/widgets/custom_grid_tile_bar.dart';
import '../providers/cart.dart';
import '../screens/product_detail.dart';
import 'package:provider/provider.dart';
import '../providers/product.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Stack(
        children: <Widget>[
          GridTile(
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(ProductDetailScreen.routeName, arguments: product.id);
              },
              child: Image.network(product.imageUrl, fit: BoxFit.cover),
            ),
            footer: GridTileBar2(
              title: Text(
                product.title,
                textAlign: TextAlign.center,
              ),
              backgroundColor: Colors.black54,
              trailing: IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    cart.addItem(product.id!, product.imageUrl, product.price, product.title);
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Added item do cart!'),
                        duration: const Duration(seconds: 2),
                        action: SnackBarAction(
                          label: 'UNDO',
                          onPressed: () {
                            cart.subtractQuantity(product.id!);
                          },
                        ),
                      ),
                    );
                  },
                  icon: FaIcon(FontAwesomeIcons.cartShopping, size: 16, color: Theme.of(context).colorScheme.secondary)),
            ),
          ),
          Positioned(
            right: 0,
            child: Consumer<Product>(
              builder: (ctx, product, _) => InkWell(
                child: ClipRRect(
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10)),
                  child: Container(
                    color: Colors.black54,
                    padding: const EdgeInsets.all(8),
                    child: FaIcon(product.isFavorite ? FontAwesomeIcons.solidHeart : FontAwesomeIcons.heart, size: 16, color: Colors.orangeAccent),
                  ),
                ),
                onTap: () {
                  product.toggleFavorite();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
