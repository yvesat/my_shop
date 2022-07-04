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
            title: Text(''),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: FaIcon(FontAwesomeIcons.shop),
            title: Text('Shop'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          ListTile(
            leading: FaIcon(FontAwesomeIcons.creditCard),
            title: Text('Orders'),
            onTap: () {
              Navigator.of(context).pushNamed('/orders');
            },
          ),
          ListTile(
            leading: FaIcon(FontAwesomeIcons.box),
            title: Text('Manage Products'),
            onTap: () {
              Navigator.of(context).pushNamed('/userProducts');
            },
          ),
        ],
      ),
    );
  }
}
