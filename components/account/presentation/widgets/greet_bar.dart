import 'package:amazon_clone/common/data/constants.dart';
import 'package:amazon_clone/components/authentication/logic/blocs/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GreetBar extends StatelessWidget {
  const GreetBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var user =
        (BlocProvider.of<UserBloc>(context).state as UserAuthenticatedState)
            .user;

    return Container(
      decoration: const BoxDecoration(
        gradient: Constants.appBarGradient,
      ),
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Row(
          children: [
            RichText(
              text: TextSpan(
                text: 'Hello, ',
                style: const TextStyle(
                  fontSize: 22,
                  color: Colors.black,
                ),
                children: [
                  TextSpan(
                    text: user.name,
                    style: const TextStyle(
                      fontSize: 22,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
