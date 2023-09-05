import 'dart:convert';

import 'package:amazon_clone/common/data/constants.dart';
import 'package:amazon_clone/common/data/services/message_service.dart';
import 'package:amazon_clone/common/logic/cubits/ui_feedback_cubit.dart';
import 'package:amazon_clone/components/admin/data/models/product_model.dart';
import 'package:amazon_clone/components/authentication/data/models/user_model.dart';
import 'package:amazon_clone/components/authentication/data/services/auth_token_service.dart';
import 'package:amazon_clone/components/authentication/logic/blocs/auth_bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

class CartService {
  static void addToCart({
    required Product product,
    required BuildContext context,
  }) async {
    var authBloc = context.read<UserBloc>();
    var uiFeedbackCubit = context.read<UiFeedbackCubit>();

    var token = await AuthTokenService.getToken();

    if (token != null) {
      var res = await http.post(
        Uri.parse('${Constants.host}/cart/add'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'authToken': token,
        },
        body: jsonEncode({'product': product.toMap()}),
      );

      if (res.statusCode == 200) {
        var user = User.fromJson(res.body);

        user.token = token;

        authBloc.add(UpdateUser(user));

        MessageService.showSnackBar(context, message: 'Added product to cart!');
      } else {
        print(jsonDecode(res.body));
        uiFeedbackCubit.showSnackbar(
          'Couldn\'t add to cart, please try again!',
        );
      }
    }
  }

  static void removeFromCart({
    required String productId,
    required BuildContext context,
  }) async {
    var authBloc = context.read<UserBloc>();
    var uiFeedbackCubit = context.read<UiFeedbackCubit>();

    var token = await AuthTokenService.getToken();

    if (token != null) {
      var res = await http.post(
        Uri.parse('${Constants.host}/cart/remove'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'authToken': token,
        },
        body: jsonEncode({'productId': productId}),
      );

      if (res.statusCode == 200) {
        var user = User.fromJson(res.body);

        user.token = token;

        authBloc.add(UpdateUser(user));
      } else {
        uiFeedbackCubit.showSnackbar(
          'Couldn\'t remove from cart, please try again!',
        );
      }
    }
  }
}
