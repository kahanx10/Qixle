import 'dart:convert';

import 'package:amazon_clone/common/data/constants.dart';
import 'package:amazon_clone/common/data/services/message_service.dart';
import 'package:amazon_clone/components/authentication/data/models/user_model.dart';
import 'package:amazon_clone/components/authentication/data/services/auth_token_service.dart';
import 'package:amazon_clone/components/authentication/logic/blocs/auth_bloc.dart';
import 'package:amazon_clone/components/orders/data/models/order_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';

class OrderService {
  static Future<void> placeOrder({
    required BuildContext context,
    required List<dynamic> cart,
    required String address,
    required double totalSum,
  }) async {
    if (cart.isEmpty) {
      MessageService.showSnackBar(context, message: 'Cart is empty!');
      return;
    }

    var token = await AuthTokenService.getToken();

    if (token != null) {
      var res = await post(
        Uri.parse('${Constants.host}/place-order'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'authToken': token,
        },
        body: jsonEncode({
          'cart': cart,
          'address': address,
          'totalPrice': totalSum,
        }),
      );

      if (res.statusCode == 200) {
        context.read<UserBloc>().add(
              UpdateUser(
                User.fromJson(res.body),
              ),
            );

        MessageService.showSnackBar(
          context,
          message: 'Order placed! Open account page to view it.',
        );
      } else {
        throw Exception('Could\'nt place order, please try again!');
      }
    } else {
      MessageService.showSnackBar(
        context,
        message: 'Session expired, please log-in again!',
      );
    }
  }

  static Future<List<Order>> fetchMyOrders(BuildContext context) async {
    var token = await AuthTokenService.getToken();

    var orders = <Order>[];

    if (token != null) {
      var res = await post(
        Uri.parse('${Constants.host}/fetch-my-orders'),
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
    }
    return orders;
  }
}
