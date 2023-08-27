import 'package:amazon_clone/components/authentication/logic/blocs/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/home_route';

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    var user =
        (BlocProvider.of<AuthBloc>(context).state as UserAuthenticatedState)
            .user;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () {
                BlocProvider.of<AuthBloc>(context).add(SignOutUser());
              },
              icon: const Icon(Icons.logout_rounded),
            )
          ],
        ),
        body: Center(
          child: Text(user.name),
        ),
      ),
    );
  }
}
