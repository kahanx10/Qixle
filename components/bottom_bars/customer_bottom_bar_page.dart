import 'package:amazon_clone/common/data/constants.dart';
import 'package:amazon_clone/components/account/presentation/pages/account_page.dart';
import 'package:amazon_clone/components/authentication/logic/blocs/auth_bloc.dart';
import 'package:amazon_clone/components/cart/presentation/pages/cart_page.dart';
import 'package:amazon_clone/components/home/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';

class CustomerBottomBarPage extends StatefulWidget {
  static const String routeName = '/bottom_bar_route';
  const CustomerBottomBarPage({Key? key}) : super(key: key);

  @override
  State<CustomerBottomBarPage> createState() => _CustomerBottomBarPageState();
}

class _CustomerBottomBarPageState extends State<CustomerBottomBarPage> {
  int _page = 0;
  double bottomBarWidth = 42;
  double bottomBarBorderWidth = 5;

  List<Widget> pages = [
    const HomePage(),
    const AccountPage(),
    const CartPage(),
  ];

  void updatePage(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_page],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: Stack(
            children: [
              GNav(
                iconSize: 28,
                padding: const EdgeInsets.all(16),
                backgroundColor: Constants.selectedColor,
                rippleColor: Colors.grey.shade500,
                textStyle: GoogleFonts.leagueSpartan(
                  fontSize: 14,
                  color: Constants.backgroundColor,
                  fontWeight: FontWeight.w600,
                ),
                activeColor: Constants.backgroundColor,
                color: Constants.backgroundColor,
                tabActiveBorder: Border.all(
                  color: Constants.backgroundColor,
                ),
                gap: 8,
                onTabChange: (index) {
                  setState(() {
                    _page = index;
                  });
                },
                tabs: const [
                  GButton(
                    icon: LineIcons.home,
                    text: 'Home',
                  ),
                  GButton(
                    icon: Icons.person,
                    text: 'Account',
                  ),
                  GButton(
                    icon: LineIcons.shoppingBasket,
                    text: 'Cart',
                  ),
                ],
              ),
              Positioned(
                right: 10,
                child: BlocBuilder<UserBloc, UserState>(
                  buildWhen: (previous, current) {
                    return previous.runtimeType == UserAuthenticatedState;
                  },
                  builder: (context, state) {
                    var user = (BlocProvider.of<UserBloc>(context).state
                            as UserAuthenticatedState)
                        .user;

                    return user.cart.isNotEmpty
                        ? Badge(
                            backgroundColor: Constants.backgroundColor,
                            label: Text(user.cart.length.toString()),
                            textColor: Constants.selectedColor,
                            child: const Icon(
                              LineIcons.shoppingBasket,
                            ),
                          )
                        : const SizedBox(
                            width: 0,
                            height: 0,
                          );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
