import 'package:amazon_clone/components/account/presentation/widgets/account_app_bar.dart';
import 'package:amazon_clone/components/authentication/logic/blocs/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountPage extends StatefulWidget {
  static const String routeName = '/home_route';

  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    var user =
        (BlocProvider.of<AuthBloc>(context).state as UserAuthenticatedState)
            .user;

    return SafeArea(
      child: Scaffold(
        appBar: AccountAppBar(
          title: const Text('Qixle'),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.notifications_none_rounded),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.search),
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
