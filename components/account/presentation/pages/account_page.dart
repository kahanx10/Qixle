import 'package:amazon_clone/common/data/constants.dart';
import 'package:amazon_clone/components/account/presentation/widgets/buttons_panel.dart';
import 'package:amazon_clone/components/account/presentation/widgets/greet_bar.dart';
import 'package:amazon_clone/components/orders/presentation/widgets/orders_panel.dart';
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
    return const SafeArea(
      child: Scaffold(
        backgroundColor: Constants.backgroundColor,
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 40,
            ),
            GreetBar(),
            ButtonsPanel(),
            OrdersPanel(),
          ],
        ),
      ),
    );
  }
}
