import 'package:amazon_clone/common/data/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

enum Auth { signUp, signIn }

class NoInternetPage extends StatefulWidget {
  static const String routeName = '/auth_route';

  const NoInternetPage({super.key});

  @override
  State<NoInternetPage> createState() => _NoInternetPageState();
}

class _NoInternetPageState extends State<NoInternetPage> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.black,
      ),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.black,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset('assets/lottie/cat.json', height: 270, width: 270),
                Transform.translate(
                  offset: const Offset(0, -55),
                  child: Text(
                    'Whoops :(',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.leagueSpartan(
                      fontSize: 24,
                      color: Colors.yellow.shade700.withOpacity(0.8),
                      letterSpacing: 0.1,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Transform.translate(
                  offset: const Offset(0, -40),
                  child: Text(
                    'Slow or no internet connection.\nPlease check your internet settings.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.leagueSpartan(
                      fontSize: 18,
                      color: Constants.backgroundColor,
                      letterSpacing: 0.1,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
