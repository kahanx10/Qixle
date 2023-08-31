import 'package:amazon_clone/common/data/constants.dart';
import 'package:amazon_clone/common/presentation/pages/message_page.dart';
import 'package:amazon_clone/components/account/presentation/pages/account_page.dart';
import 'package:amazon_clone/components/customer_home/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';

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
    const MessagePage(message: 'Cart Page'),
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _page,
        selectedItemColor: Constants.selectedColor,
        unselectedItemColor: Constants.unselectedColor,
        backgroundColor: Constants.backgroundColor,
        iconSize: 28,
        onTap: updatePage,
        items: [
          // HOME
          BottomNavigationBarItem(
            icon: Container(
              width: bottomBarWidth,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: _page == 0
                        ? Constants.selectedColor
                        : Colors.transparent,
                    width: bottomBarBorderWidth,
                  ),
                ),
              ),
              child: const Icon(
                Icons.home_outlined,
              ),
            ),
            label: '',
          ),
          // ACCOUNT
          BottomNavigationBarItem(
            icon: Container(
              width: bottomBarWidth,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: _page == 1
                        ? Constants.selectedColor
                        : Colors.transparent,
                    width: bottomBarBorderWidth,
                  ),
                ),
              ),
              child: const Icon(
                Icons.person_outline_outlined,
              ),
            ),
            label: '',
          ),
          // CART
          BottomNavigationBarItem(
            icon: Container(
              width: bottomBarWidth,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: _page == 2
                        ? Constants.selectedColor
                        : Colors.transparent,
                    width: bottomBarBorderWidth,
                  ),
                ),
              ),
              child: const Badge(
                backgroundColor: Constants.backgroundColor,
                label: Text('6'),
                textColor: Constants.unselectedColor,
                child: Icon(
                  Icons.shopping_cart_outlined,
                ),
              ),
            ),
            label: '',
          ),
        ],
      ),
    );
  }
}
