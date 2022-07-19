import 'package:flutter/material.dart';
import '../screens/cart_screen.dart';
import '../screens/user_products_screen.dart';
import 'package:provider/provider.dart';

import './screens/products_overview.dart';
import './screens/product_detail.dart';
import './screens/order_screen.dart';
import './screens/user_products_screen.dart';
import './screens/edit_product_screen.dart';
import './providers/products_provider.dart';
import './providers/cart.dart';
import './providers/orders.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => ProductsProvider()),
        ChangeNotifierProvider(create: (ctx) => Cart()),
        ChangeNotifierProvider(create: (ctx) => Orders()),
      ],
      child: MaterialApp(
        title: 'MyShop',
        theme: ThemeData(
          primaryColor: const Color(0xff189AB4),
          scaffoldBackgroundColor: const Color(0xffe8f7fa),
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: const Color(0xff189AB4),
            secondary: const Color(0xff75E6DA),
          ),
          fontFamily: 'Roboto',
        ),
        home: const ProductsOverViewScreen(),
        routes: {
          ProductDetailScreen.routeName: (context) => ProductDetailScreen(),
          CartScreen.routeName: (context) => CartScreen(),
          OrderScreen.routeName: (context) => OrderScreen(),
          UserProductsScreen.routeName: (context) => UserProductsScreen(),
          EditProductScreen.routeName: (context) => EditProductScreen(),
        },
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyShop'),
      ),
      body: const Center(
        child: Text('Let\'s build a shop!'),
      ),
    );
  }
}




    // Product(
    //   id: "1",
    //   title: "Mouse",
    //   description: "Mouse for computers",
    //   price: 99.99,
    //   imageUrl: "https://cdn.pixabay.com/photo/2017/05/24/21/33/workplace-2341642__340.jpg",
    // ),
    // Product(
    //   id: "2",
    //   title: "Keyboard",
    //   description: "Keyboard for computers",
    //   price: 199.99,
    //   imageUrl: "https://cdn.pixabay.com/photo/2015/12/15/19/35/keyboard-1094833__340.jpg",
    // ),
    // Product(
    //   id: "3",
    //   title: "iPad",
    //   description: "Last generation iPad",
    //   price: 499.99,
    //   imageUrl: "https://cdn.pixabay.com/photo/2019/10/07/10/40/ipad-4532326_960_720.jpg",
    // ),
    // Product(
    //   id: "4",
    //   title: "MacBook",
    //   description: "Last generation MacBook",
    //   price: 1999.99,
    //   imageUrl: "https://cdn.pixabay.com/photo/2016/10/11/09/26/office-1730940__340.jpg",
    // ),