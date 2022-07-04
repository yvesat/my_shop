import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart' show Cart;
import '../widgets/cart_item.dart';
import '../providers/orders.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Your Cart')),
      body: Column(
        children: <Widget>[
          Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Total', style: TextStyle(fontSize: 20)),
                  Spacer(),
                  Chip(
                    label: Text('\$${cart.totalAmount.toStringAsFixed(2)}', style: TextStyle(color: Colors.white)),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  TextButton(
                    child: Text('ORDER NOW'),
                    onPressed: () {
                      var cartItemsList = cart.items.values.toList();
                      bool validOrder = true;
                      cartItemsList.length > 0 ? Provider.of<Orders>(context, listen: false).addOrder(cartItemsList, cart.totalAmount) : validOrder = false;
                      cart.clear();
                      showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: Text(
                            validOrder ? 'Order Successful' : 'Empty Cart',
                            textAlign: TextAlign.center,
                          ),
                          content: Text(
                            validOrder ? 'Your order has been placed.' : 'You cart is empty! \n Add any product to place an order.',
                            textAlign: TextAlign.center,
                          ),
                          actions: <Widget>[
                            Center(
                              child: Column(
                                children: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, 'OK'),
                                    child: const Text('OK'),
                                  ),
                                  if (validOrder)
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pushNamed('/orders'),
                                      child: const Text('See my orders'),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
              child: ListView.builder(
            itemCount: cart.itemCount,
            itemBuilder: (context, index) => CartItem(
              id: cart.items.values.toList()[index].id,
              productId: cart.items.keys.toList()[index],
              imageUrl: cart.items.values.toList()[index].imageUrl,
              title: cart.items.values.toList()[index].title,
              quantity: cart.items.values.toList()[index].quantity,
              price: cart.items.values.toList()[index].price,
            ),
          ))
        ],
      ),
    );
  }
}
