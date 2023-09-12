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
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(
                0.125,
              ), // subtle shadow
              blurRadius: 10, // soften the shadow
              spreadRadius:
                  1, // extent of shadow, negative values can also be used
              offset: const Offset(
                0,
                -5,
              ), // Move to bottom-left by 4 units
            ),
          ],
          color: Constants.selectedColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          child: Stack(
            children: [
              GNav(
                iconSize: 24,
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                backgroundColor: Constants.selectedColor,
                rippleColor: Colors.grey.shade500,
                textStyle: GoogleFonts.leagueSpartan(
                  fontSize: 14,
                  color: Constants.backgroundColor,
                  fontWeight: FontWeight.w600,
                ),
                activeColor: Constants.backgroundColor,
                color: Constants.backgroundColor,
                // tabActiveBorder: Border.all(
                //   color: Constants.backgroundColor,
                // ),
                gap: 8,
                onTabChange: (index) {
                  setState(() {
                    _page = index;
                  });
                },
                tabs: [
                  GButton(
                    icon: _page == 0 ? Icons.home_rounded : Icons.home_outlined,
                    text: 'Home',
                  ),
                  GButton(
                    icon: _page == 1 ? Icons.person : Icons.person_outlined,
                    text: 'Account',
                  ),
                  GButton(
                    icon: _page == 2
                        ? Icons.shopping_bag
                        : Icons.shopping_bag_outlined,
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
