import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: const Text(''),
            automaticallyImplyLeading: false,
          ),
          const Divider(),
          ListTile(
            leading: const FaIcon(FontAwesomeIcons.shop),
            title: const Text('Shop'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          ListTile(
            leading: const FaIcon(FontAwesomeIcons.creditCard),
            title: const Text('Orders'),
            onTap: () {
              Navigator.of(context).pushNamed('/orders');
            },
          ),
          ListTile(
            leading: const FaIcon(FontAwesomeIcons.box),
            title: const Text('Manage Products'),
            onTap: () {
              Navigator.of(context).pushNamed('/userProducts');
            },
          ),
        ],
      ),
    );
  }
}
