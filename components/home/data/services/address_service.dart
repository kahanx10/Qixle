// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:amazon_clone/common/data/constants.dart';
import 'package:amazon_clone/common/data/services/message_service.dart';
import 'package:amazon_clone/components/authentication/data/models/user_model.dart';
import 'package:amazon_clone/components/authentication/data/services/auth_token_service.dart';
import 'package:amazon_clone/components/authentication/logic/blocs/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';

class AddressService {
  static Future<void> saveUserAddress(BuildContext context,
      {required String address}) async {
    var token = await AuthTokenService.getToken();

    if (token != null) {
      var res = await post(
        Uri.parse('${Constants.host}/address/save'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'authToken': token,
        },
        body: jsonEncode({'address': address}),
      );

      if (res.statusCode == 200) {
        context.read<UserBloc>().add(UpdateUser(User.fromJson(res.body)));
      } else {
        throw Exception('Could\'nt update address, please try again!');
      }
    } else {
      MessageService.showSnackBar(
        context,
        message: 'Session expired, please log-in again!',
      );
    }
  }
}
