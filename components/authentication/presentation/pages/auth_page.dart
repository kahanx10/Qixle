import 'package:amazon_clone/common/data/constant_data.dart';
import 'package:amazon_clone/common/presentation/widgets/app_button.dart';
import 'package:amazon_clone/components/authentication/logic/blocs/auth_bloc.dart';
import 'package:amazon_clone/components/home/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ConstantData.greyBackgroundColor,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: ConstantData.selectedColor,
                  ),
                ),
                RadioListTile(
                  tileColor: _authVal == Auth.signUp
                      ? ConstantData.backgroundColor
                      : ConstantData.greyBackgroundColor,
                  title: const Text('Create Account'),
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
                if (_authVal == Auth.signUp)
                  Container(
                    color: ConstantData.backgroundColor,
                    padding: const EdgeInsets.all(8),
                    child: Form(
                      key: _signUpFormKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _nameController,
                            decoration: const InputDecoration(
                              hintText: 'Name',
                            ),
                            validator: (val) {
                              if (val!.isNotEmpty) {
                                return null;
                              } else {
                                return 'Please enter a valid name!';
                              }
                            },
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _usernameController,
                            decoration: const InputDecoration(
                              hintText: 'Username',
                            ),
                            validator: (val) {
                              if (val!.isNotEmpty && !val.contains(' ')) {
                                return null;
                              } else {
                                return 'Please enter a valid username!';
                              }
                            },
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              hintText: 'Password',
                            ),
                            validator: (val) {
                              if (val!.isNotEmpty && !val.contains(' ')) {
                                return null;
                              } else {
                                return 'Please enter a valid password!';
                              }
                            },
                          ),
                          const SizedBox(height: 10),
                          AppButton(
                            width: double.infinity,
                            isExpanded: false,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ConstantData.selectedColor,
                              foregroundColor: ConstantData.backgroundColor,
                            ),
                            onPressed: () {
                              signUpUser(context);
                            },
                            label: 'Sign Up',
                          ),
                        ],
                      ),
                    ),
                  ),
                RadioListTile(
                  tileColor: _authVal == Auth.signIn
                      ? ConstantData.backgroundColor
                      : ConstantData.greyBackgroundColor,
                  title: const Text('Already have an account?'),
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
                if (_authVal == Auth.signIn)
                  Container(
                    color: ConstantData.backgroundColor,
                    padding: const EdgeInsets.all(8),
                    child: Form(
                      key: _signInFormKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _usernameController,
                            decoration: const InputDecoration(
                              hintText: 'Username',
                            ),
                            validator: (val) {
                              if (val!.isNotEmpty && !val.contains(' ')) {
                                return null;
                              } else {
                                return 'Please enter a valid username!';
                              }
                            },
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              hintText: 'Password',
                            ),
                            validator: (val) {
                              if (val!.isNotEmpty && !val.contains(' ')) {
                                return null;
                              } else {
                                return 'Please enter a valid password!';
                              }
                            },
                          ),
                          const SizedBox(height: 10),
                          AppButton(
                            width: double.infinity,
                            isExpanded: false,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ConstantData.selectedColor,
                              foregroundColor: ConstantData.backgroundColor,
                            ),
                            onPressed: () {
                              signInUser(context);
                            },
                            label: 'Sign In',
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void signUpUser(BuildContext context) {
    BlocProvider.of<AuthBloc>(context).add(
      SignUpUser(
        name: _nameController.text,
        userName: _usernameController.text.toLowerCase(),
        password: _passwordController.text,
      ),
    );
  }

  void signInUser(BuildContext context) {
    BlocProvider.of<AuthBloc>(context).add(
      SignInUser(
        userName: _usernameController.text.toLowerCase(),
        password: _passwordController.text,
      ),
    );
  }

  void pushUserToHomePage(BuildContext context) {
    Navigator.of(context).pushReplacementNamed(HomePage.routeName);
  }
}
