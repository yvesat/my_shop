import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../providers/cart.dart';
import 'package:provider/provider.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final String imageUrl;
  final double price;
  final int quantity;
  final String title;

  const CartItem({
    Key? key,
    required this.id,
    required this.productId,
    required this.imageUrl,
    required this.price,
    required this.quantity,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double totalPrice = quantity * price;

    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(productId);
      },
      // ignore: sized_box_for_whitespace
      child: Container(
        height: 90,
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(imageUrl),
                      backgroundColor: Colors.transparent,
                    ),
                    title: Text(title),
                    subtitle: Row(
                      children: [
                        Text('$quantity x $price'),
                        const Spacer(),
                        Text('Total: ${totalPrice.toStringAsFixed(2)}'),
                      ],
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: IconButton(
                        iconSize: 20,
                        icon: FaIcon(FontAwesomeIcons.squarePlus, color: Theme.of(context).colorScheme.primary),
                        onPressed: () {
                          Provider.of<Cart>(context, listen: false).addQuantity(productId);
                        },
                      ),
                    ),
                    Expanded(
                      child: IconButton(
                        iconSize: 20,
                        icon: FaIcon(FontAwesomeIcons.squareMinus, color: Theme.of(context).colorScheme.error),
                        onPressed: () {
                          Provider.of<Cart>(context, listen: false).subtractQuantity(productId);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
