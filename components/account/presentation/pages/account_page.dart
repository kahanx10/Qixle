import 'package:amazon_clone/components/account/presentation/widgets/account_app_bar.dart';
import 'package:amazon_clone/components/account/presentation/widgets/buttons_panel.dart';
import 'package:amazon_clone/components/account/presentation/widgets/greet_bar.dart';
import 'package:flutter/material.dart';

class AccountPage extends StatefulWidget {
  static const String routeName = '/home_route';

  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
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
        body: const Column(
          children: [
            GreetBar(),
            ButtonsPanel(),
          ],
        ),
      ),
    );
  }
}
