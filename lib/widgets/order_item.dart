import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../providers/orders.dart' as ord;
import 'package:intl/intl.dart';
import 'dart:math';

class OrderItem extends StatefulWidget {
  final ord.OrderItem order;

  const OrderItem(this.order, {Key? key}) : super(key: key);

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          ListTile(
            leading: const FaIcon(FontAwesomeIcons.clipboardList, color: Colors.teal),
            title: Text('\$ ${widget.order.amount.toStringAsFixed(2)}'),
            subtitle: Text(DateFormat('dd/MM/yyyy hh:mm').format(widget.order.dateTime)),
            trailing: IconButton(
              icon: FaIcon(_expanded ? FontAwesomeIcons.angleUp : FontAwesomeIcons.angleDown),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          if (_expanded)
            // ignore: sized_box_for_whitespace
            Container(
              height: min(widget.order.products.length * 25 + 15, 150),
              child: ListView.builder(
                itemCount: widget.order.products.length,
                itemBuilder: (ctx, index) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        widget.order.products[index].title,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${widget.order.products[index].quantity} x ${widget.order.products[index].price}',
                        style: const TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}
