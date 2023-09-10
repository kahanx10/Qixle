// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:amazon_clone/common/data/constants.dart';
import 'package:amazon_clone/common/data/services/message_service.dart';
import 'package:amazon_clone/common/presentation/widgets/single_product.dart';
import 'package:amazon_clone/components/authentication/data/services/auth_token_service.dart';
import 'package:amazon_clone/components/orders/data/models/order_model.dart';
import 'package:amazon_clone/components/orders/presentation/pages/order_details_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  Future<List<Order>> fetchAllOrders() async {
    var orders = <Order>[];

    try {
      var token = await AuthTokenService.getToken();

      if (token != null) {
        var res = await get(
          Uri.parse('${Constants.host}/fetch-all-orders'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'authToken': token,
          },
        );

        if (res.statusCode == 200) {
          var ordersList = jsonDecode(res.body);

          for (var order in ordersList) {
            order as Map<String, dynamic>;
            orders.add(Order.fromMap(order));
          }
        } else {
          MessageService.showSnackBar(
            context,
            message: 'Error while fetching orders!',
          );
        }
      } else {
        MessageService.showSnackBar(
          context,
          message: 'Session expired, please log-in again!',
        );
      }
    } catch (e) {
      MessageService.showSnackBar(
        context,
        message: e.toString(),
      );
    }
    return orders;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fetchAllOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text('Error Displaying Orders'),
            );
          }

          var orders = snapshot.data!;

          return GridView.builder(
            itemCount: orders.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2),
            itemBuilder: (context, index) {
              final order = orders[index];
              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    OrderDetailsPage.routeName,
                    arguments: order,
                  );
                },
                child: SizedBox(
                  height: 140,
                  child: SingleProduct(
                    imageUrl: orders[index].products[0]['product']['images'][0],
                  ),
                ),
              );
            },
          );
        });
  }
}
