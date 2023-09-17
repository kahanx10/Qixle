import 'dart:convert';

import 'package:amazon_clone/common/data/constants.dart';
import 'package:amazon_clone/common/data/services/message_service.dart';
import 'package:amazon_clone/components/admin/logic/blocs/products_bloc.dart';
import 'package:amazon_clone/components/authentication/data/models/user_model.dart';
import 'package:amazon_clone/components/authentication/data/services/auth_token_service.dart';
import 'package:amazon_clone/components/authentication/logic/blocs/auth_bloc.dart';
import 'package:amazon_clone/components/orders/data/models/order_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';

class OrderService {
  static Future<Map<String, dynamic>?> finalizeCart(
    BuildContext context, {
    required List<dynamic> cart,
  }) async {
    try {
      var token = await AuthTokenService.getToken();

      if (token != null) {
        var res = await post(
          Uri.parse('${Constants.host}/finalize-cart'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'authToken': token,
          },
          body: jsonEncode({
            'cart': cart,
          }),
        );

        if (res.statusCode == 200) {
          return {
            'products': jsonDecode(res.body)['products'],
            'totalPrice': jsonDecode(res.body)['totalPrice'],
          };
        } else {
          throw Exception(jsonDecode(res.body)['message']);
        }
      } else {
        throw Exception('Session expired, please log-in again!');
      }
    } catch (e) {
      MessageService.showSnackBar(
        context,
        message: e.toString(),
      );

      return null;
    }
  }

  static Future<bool?> checkAvailability(
    BuildContext context, {
    required String productId,
  }) async {
    try {
      var token = await AuthTokenService.getToken();

      if (token != null) {
        var res = await post(
          Uri.parse('${Constants.host}/check-availability'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'authToken': token,
          },
          body: jsonEncode(
            {
              'productId': productId,
            },
          ),
        );

        if (res.statusCode == 200) {
          return jsonDecode(res.body)['isAvailable'];
        } else {
          throw Exception(jsonDecode(res.body)['message']);
        }
      } else {
        throw Exception('Session expired, please log-in again!');
      }
    } catch (e) {
      MessageService.showSnackBar(
        context,
        message: e.toString(),
      );

      return null;
    }
  }

  static Future<Order> placeOrder({
    required BuildContext context,
    required List<dynamic> products,
    required String address,
    required double totalPrice,
  }) async {
    if (products.isEmpty) {
      throw Exception('No products are available!');
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
          'products': products,
          'address': address,
          'totalPrice': totalPrice,
        }),
      );

      if (res.statusCode == 200) {
        context.read<UserBloc>().add(
              UpdateUser(
                User.fromMap(
                  jsonDecode(res.body)['user'],
                ),
              ),
            );

        context.read<ProductBloc>().add(
              FetchProductsEvent(),
            );

        return Order.fromMap(jsonDecode(res.body)['order']);
      } else {
        throw Exception('Could\'nt place order, please try again!');
      }
    } else {
      throw Exception('Session expired, please log-in again!');
    }
  }

  static Future<List<Order>> fetchMyOrders(BuildContext context) async {
    var token = await AuthTokenService.getToken();

    var orders = <Order>[];

    if (token != null) {
      var res = await get(
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
