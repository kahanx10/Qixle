import 'package:amazon_clone/common/data/constants.dart';
import 'package:amazon_clone/components/account/presentation/pages/account_page.dart';
import 'package:amazon_clone/components/home/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

// import 'package:amazon_clone/components/authentication/logic/blocs/auth_bloc.dart';
// import 'package:amazon_clone/components/cart/presentation/pages/cart_page.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';

class CustomerBottomBarPage extends StatefulWidget {
  static const String routeName = '/bottom_bar_route';
  const CustomerBottomBarPage({Key? key}) : super(key: key);

  @override
  State<CustomerBottomBarPage> createState() => _CustomerBottomBarPageState();
}

class _CustomerBottomBarPageState extends State<CustomerBottomBarPage> {
  // @override
  // Widget build(BuildContext context) {
  //   return HiddenDrawerMenu(
  //     contentCornerRadius: 25,
  //     slidePercent: 50,
  //     withShadow: false,
  //     actionsAppBar: [
  //       Padding(
  //         padding: const EdgeInsets.only(
  //           right: 30.0,
  //           bottom: 5.0,
  //         ),
  //         child: GestureDetector(
  //           onTap: () {
  //             Navigator.of(context).pushNamed(CartPage.routeName);
  //           },
  //           child: Stack(
  //             children: [
  //               Container(
  //                 width: 35.0,
  //                 height: 35.0,
  //                 alignment: Alignment.center,
  //                 decoration: BoxDecoration(
  //                   border: Border.all(color: Colors.grey.shade100, width: 2),
  //                   borderRadius: BorderRadius.circular(100.0),
  //                   color: Constants.backgroundColor,
  //                 ),
  //                 child: const Icon(
  //                   Icons.shopping_bag_outlined,
  //                   size: 18.0,
  //                 ),
  //               ),
  //               Positioned(
  //                 top: 0,
  //                 right: 0,
  //                 child: BlocBuilder<UserBloc, UserState>(
  //                   buildWhen: (previous, current) {
  //                     return previous.runtimeType == UserAuthenticatedState;
  //                   },
  //                   builder: (context, state) {
  //                     var user = (BlocProvider.of<UserBloc>(context).state
  //                             as UserAuthenticatedState)
  //                         .user;

  //                     return user.cart.isNotEmpty
  //                         ? Badge(
  //                             backgroundColor: Constants.selectedColor,
  //                             label: Text(
  //                               '${user.cart.length}',
  //                               style: GoogleFonts.leagueSpartan(
  //                                 fontSize: 10,
  //                                 color: Constants.backgroundColor,
  //                                 fontWeight: FontWeight.w600,
  //                               ),
  //                             ),
  //                           )
  //                         : const SizedBox(
  //                             width: 0,
  //                             height: 0,
  //                           );
  //                   },
  //                 ),
  //               )
  //             ],
  //           ),
  //         ),
  //       )
  //     ],
  //     isDraggable: true,
  //     backgroundColorAppBar: Colors.white,
  //     elevationAppBar: 0,
  //     styleAutoTittleName: GoogleFonts.leagueSpartan(
  //       fontSize: 24,
  //       color: Constants.selectedColor,
  //       fontWeight: FontWeight.normal,
  //       letterSpacing: 0.025,
  //     ),

  //     initPositionSelected: 0,

  //     screens: [
  //       ScreenHiddenDrawer(
  //         ItemHiddenMenu(
  //           name: "Discover",
  //           baseStyle: GoogleFonts.leagueSpartan(
  //             fontSize: 14,
  //             color: Colors.grey.shade400,
  //             fontWeight: FontWeight.w600,
  //           ),
  //           colorLineSelected: Constants.selectedColor,
  //           selectedStyle: GoogleFonts.leagueSpartan(
  //             fontSize: 14,
  //             color: Constants.selectedColor,
  //             fontWeight: FontWeight.w600,
  //           ),
  //         ),
  //         const HomePage(),
  //       ),
  //       ScreenHiddenDrawer(
  //         ItemHiddenMenu(
  //           name: "Account",
  //           baseStyle: GoogleFonts.leagueSpartan(
  //             fontSize: 14,
  //             color: Colors.grey.shade400,
  //             fontWeight: FontWeight.w600,
  //           ),
  //           colorLineSelected: Constants.selectedColor,
  //           selectedStyle: GoogleFonts.leagueSpartan(
  //             fontSize: 14,
  //             color: Constants.selectedColor,
  //             fontWeight: FontWeight.w600,
  //           ),
  //         ),
  //         const AccountPage(),
  //       ),
  //     ],
  //     backgroundColorMenu: Colors.grey.shade200,
  //     // ... add other customization properties as needed
  //   );
  // }
  int _page = 0;

  List<Widget> pages = [
    HomePage(
      key: getHomeKey(),
    ),
    const AccountPage(),
    // const CartPage(),
  ];

  void updatePage(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          _page == 0 ? Constants.backgroundColor : Colors.grey.shade100,
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
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 90, vertical: 15),
          child: GNav(
            iconSize: 24,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
              // GButton(
              //   icon: _page == 2
              //       ? Icons.shopping_bag
              //       : Icons.shopping_bag_outlined,
              //   text: 'Cart',
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

GlobalKey<NavigatorState> getHomeKey() {
  GlobalKey<NavigatorState> homeKey = GlobalKey();
  return homeKey;
}
