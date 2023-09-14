import 'package:amazon_clone/common/data/constants.dart';
import 'package:amazon_clone/common/presentation/widgets/app_button.dart';
import 'package:amazon_clone/common/presentation/widgets/my_app_bar.dart';
import 'package:amazon_clone/common/presentation/widgets/my_textfield.dart';
import 'package:amazon_clone/components/authentication/logic/blocs/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

enum Auth { signUp, signIn }

class AuthPage extends StatefulWidget {
  static const String routeName = '/auth_route';

  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  var _authVal = Auth.signUp;
  final _signUpFormKey = GlobalKey<FormState>();
  final _signInFormKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  final registerScrollController = ScrollController();
  final loginScrollController = ScrollController();

  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    registerScrollController.dispose();
    loginScrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Constants.backgroundColor,
      ),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Constants.backgroundColor,
          appBar: MyAppBar(
            title: Text(
              'Login',
              style: GoogleFonts.leagueSpartan(
                fontSize: 24,
                color: Constants.selectedColor,
                fontWeight: FontWeight.normal,
                letterSpacing: 0.025,
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.only(
              left: 15,
              right: 15,
              bottom: 15,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 250,
                    width: 250,
                    child: Lottie.asset(
                      'assets/lottie/person.json',
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Column(
                    children: [
                      Column(
                        children: [
                          RadioListTile(
                            contentPadding: const EdgeInsets.only(left: 60),
                            activeColor: Constants.selectedColor,
                            tileColor: Colors.transparent,
                            title: Text(
                              'Create Account',
                              style: GoogleFonts.leagueSpartan(
                                fontSize: 20,
                                color: _authVal == Auth.signUp
                                    ? Constants.selectedColor
                                    : Constants.unselectedColor,
                                letterSpacing: 0.1,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            value: Auth.signUp,
                            groupValue: _authVal,
                            onChanged: (val) {
                              setState(
                                () {
                                  _authVal = val!;
                                },
                              );
                            },
                          ),
                          AnimatedContainer(
                            decoration: BoxDecoration(
                              color: Constants.selectedColor,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            duration: const Duration(milliseconds: 500),
                            height: 2.5,
                            width: _authVal == Auth.signUp ? 150 : 0,
                          ),
                          SizedBox(
                            height: _authVal == Auth.signUp ? 8 : 0,
                          ),
                        ],
                      ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        height: _authVal == Auth.signUp ? 350 : 0,
                        key: const ValueKey('signUp'),
                        color: Constants.backgroundColor,
                        padding: const EdgeInsets.all(8),
                        child: Scrollbar(
                          controller: registerScrollController,
                          child: SingleChildScrollView(
                            controller: registerScrollController,
                            child: Form(
                              key: _signUpFormKey,
                              child: Column(
                                children: [
                                  MyTextField(
                                    obscureText: false,
                                    controller: _nameController,
                                    hintText: 'Name',
                                    validator: (val) {
                                      if (val!.isNotEmpty) {
                                        return null;
                                      } else {
                                        return 'Please enter a valid name!';
                                      }
                                    },
                                  ),
                                  const SizedBox(height: 12),
                                  MyTextField(
                                    obscureText: false,
                                    controller: _usernameController,
                                    hintText: 'Username',
                                    validator: (val) {
                                      if (val!.isNotEmpty &&
                                          !val.contains(' ')) {
                                        return null;
                                      } else {
                                        return 'Please enter a valid username!';
                                      }
                                    },
                                  ),
                                  const SizedBox(height: 12),
                                  MyTextField(
                                    obscureText: true,
                                    controller: _passwordController,
                                    hintText: 'Password',
                                    validator: (val) {
                                      if (val!.isNotEmpty &&
                                          !val.contains(' ') &&
                                          val.length >= 8) {
                                        return null;
                                      } else {
                                        return 'Please enter a valid password!';
                                      }
                                    },
                                  ),
                                  const SizedBox(height: 24),
                                  MyButton(
                                    width: MediaQuery.of(context).size.width,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Constants.selectedColor,
                                      foregroundColor:
                                          Constants.backgroundColor,
                                    ),
                                    onPressed: () {
                                      signUpUser(context);
                                    },
                                    text: 'Register',
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Column(
                        children: [
                          RadioListTile(
                            contentPadding: const EdgeInsets.only(left: 60),
                            activeColor: Constants.selectedColor,
                            tileColor: Constants.backgroundColor,
                            title: Text(
                              'Existing Account',
                              style: GoogleFonts.leagueSpartan(
                                fontSize: 20,
                                color: _authVal == Auth.signIn
                                    ? Constants.selectedColor
                                    : Constants.unselectedColor,
                                letterSpacing: 0.1,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            value: Auth.signIn,
                            groupValue: _authVal,
                            onChanged: (val) {
                              setState(
                                () {
                                  _authVal = val!;
                                },
                              );
                            },
                          ),
                          AnimatedContainer(
                            decoration: BoxDecoration(
                              color: Constants.selectedColor,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            duration: const Duration(milliseconds: 500),
                            height: 2.5,
                            width: _authVal == Auth.signIn ? 150 : 0,
                          ),
                          SizedBox(
                            height: _authVal == Auth.signIn ? 8 : 0,
                          ),
                        ],
                      ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        height: _authVal == Auth.signIn ? 300 : 0,
                        key: const ValueKey('signIn'),
                        color: Constants.backgroundColor,
                        padding: const EdgeInsets.all(8),
                        child: Scrollbar(
                          controller: loginScrollController,
                          child: SingleChildScrollView(
                            controller: loginScrollController,
                            child: Form(
                              key: _signInFormKey,
                              child: Column(
                                children: [
                                  MyTextField(
                                    obscureText: false,
                                    controller: _usernameController,
                                    hintText: 'Username',
                                    validator: (val) {
                                      if (val!.isNotEmpty &&
                                          !val.contains(' ')) {
                                        return null;
                                      } else {
                                        return 'Please enter a valid username!';
                                      }
                                    },
                                  ),
                                  const SizedBox(height: 12),
                                  MyTextField(
                                    obscureText: true,
                                    controller: _passwordController,
                                    hintText: 'Password',
                                    validator: (val) {
                                      if (val!.isNotEmpty &&
                                          !val.contains(' ')) {
                                        return null;
                                      } else {
                                        return 'Please enter a valid password!';
                                      }
                                    },
                                  ),
                                  const SizedBox(height: 24),
                                  MyButton(
                                    width: MediaQuery.of(context).size.width,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Constants.selectedColor,
                                      foregroundColor:
                                          Constants.backgroundColor,
                                    ),
                                    onPressed: () {
                                      signInUser(context);
                                    },
                                    text: 'Log In',
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void signUpUser(BuildContext context) {
    if (_signUpFormKey.currentState!.validate()) {
      BlocProvider.of<UserBloc>(context).add(
        SignUpUser(
          name: _nameController.text,
          userName: _usernameController.text.toLowerCase(),
          password: _passwordController.text,
        ),
      );
    }
  }

  void signInUser(BuildContext context) {
    if (_signInFormKey.currentState!.validate()) {
      BlocProvider.of<UserBloc>(context).add(
        SignInUser(
          userName: _usernameController.text.toLowerCase(),
          password: _passwordController.text,
        ),
      );
    }
  }
}
