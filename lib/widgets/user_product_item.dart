import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../providers/products_provider.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  const UserProductItem({
    Key? key,
    required this.id,
    required this.title,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
        backgroundColor: Colors.transparent,
      ),
      title: Text(title),
      // ignore: sized_box_for_whitespace
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/editProductScreen', arguments: id);
              },
              icon: FaIcon(
                FontAwesomeIcons.penToSquare,
                color: Theme.of(context).primaryColor,
              ),
            ),
            IconButton(
              onPressed: () async {
                try {
                  Provider.of<ProductsProvider>(context, listen: false).deleteProduct(id);
                } catch (e) {
                  // ScaffoldMessenger.of(context).hideCurrentSnackBar();

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Deleting failed!'),
                      duration: const Duration(seconds: 2),
                      action: SnackBarAction(
                        label: 'UNDO',
                        onPressed: () {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        },
                      ),
                    ),
                  );
                }
              },
              icon: FaIcon(
                FontAwesomeIcons.trashCan,
                color: Theme.of(context).errorColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
