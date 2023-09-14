import 'package:amazon_clone/common/data/constants.dart';
import 'package:amazon_clone/components/authentication/logic/blocs/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class GreetBar extends StatelessWidget {
  const GreetBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var user =
        (BlocProvider.of<UserBloc>(context).state as UserAuthenticatedState)
            .user;

    return Container(
      decoration: BoxDecoration(
        color: Constants.selectedColor,
      ),
      padding: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Row(
          children: [
            RichText(
              text: TextSpan(
                text: 'Hello, ',
                style: GoogleFonts.leagueSpartan(
                  fontSize: 24,
                  fontWeight: FontWeight.normal,
                ),
                children: [
                  TextSpan(
                    text: user.name,
                    style: GoogleFonts.leagueSpartan(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
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
