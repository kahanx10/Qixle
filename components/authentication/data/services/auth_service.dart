// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:amazon_clone/common/data/constants.dart';
import 'package:amazon_clone/components/authentication/data/models/user_model.dart';
import 'package:amazon_clone/components/authentication/data/services/auth_token_service.dart';
import 'package:http/http.dart' as http;

class AuthService {
  http.Client client;

  AuthService({
    required this.client,
  });

  Future<http.Response?> userSignUpAuthentication({
    required String name,
    required String username,
    required String password,
  }) async {
    try {
      print('entered handling userSignUpAuthentication() in auth_service.dart');
      // make api call(s) to database
      var res = await client.post(
        Uri.parse('${Constants.host}${Constants.signUpPath}'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
          {
            'name': name,
            'username': username,
            'password': password,
          },
        ),
      );

      return res;
    } catch (e) {
      print(
        '---> Error in auth_service.dart:\n$e <---',
      );
      return null;
    } finally {
      print('exited handling userSignUpAuthentication() in auth_service.dart');
    }
  }

  Future<http.Response?> userSignInAuthentication({
    required String username,
    required String password,
  }) async {
    try {
      print('entered handling userSignInAuthentication() in auth_service.dart');
      // make api call(s) to database
      var res = await client.post(
        Uri.parse('${Constants.host}${Constants.signInPath}'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
          {
            'username': username,
            'password': password,
          },
        ),
      );

      return res;
    } catch (e) {
      print(
        '---> Error in auth_service.dart:\n$e <---',
      );
      return null;
    } finally {
      print('exited handling userSignInAuthentication() in auth_service.dart');
    }
  }

  Future<User?> verifyUserToken() async {
    try {
      var token = await AuthTokenService.getToken();

      if (token == null) {
        return null;
      }

      var res = await client.get(
        Uri.parse('${Constants.host}/'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'authToken': token,
        },
      );

      switch (res.statusCode) {
        case 200:
          var user = User.fromJson(res.body);
          return user;
        case 400 || 401:
          throw Exception(jsonDecode(res.body)['msg']);
        case 500:
          throw Exception(jsonDecode(res.body)['error']);
      }

      // token is tampered with, clear it to let user sign in again
      await AuthTokenService.clearToken();
      return null;
    } catch (e) {
      rethrow;
    }
  }
}
