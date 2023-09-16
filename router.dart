import 'dart:io';

import 'package:amazon_clone/common/presentation/pages/message_page.dart';
import 'package:amazon_clone/components/admin/data/models/product_model.dart';
import 'package:amazon_clone/components/authentication/presentation/pages/auth_page.dart';
import 'package:amazon_clone/components/bottom_bars/customer_bottom_bar_page.dart';
import 'package:amazon_clone/components/cart/presentation/pages/cart_page.dart';
import 'package:amazon_clone/components/orders/presentation/pages/address_page.dart';
import 'package:amazon_clone/components/home/presentation/pages/home_page.dart';
import 'package:amazon_clone/components/admin/presentation/pages/add_product_page.dart';
import 'package:amazon_clone/components/home/presentation/pages/product_details_page.dart';
import 'package:amazon_clone/components/home/presentation/pages/searched_products_page.dart';
import 'package:amazon_clone/components/orders/data/models/order_model.dart';
import 'package:amazon_clone/components/orders/presentation/pages/order_details_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppRouter {
  Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AuthPage.routeName:
        return platformAwarePageRoute(
          builder: (context) => const AuthPage(),
        );

      case HomePage.routeName:
        return platformAwarePageRoute(
          builder: (context) => const HomePage(),
        );

      case CustomerBottomBarPage.routeName:
        return platformAwarePageRoute(
          builder: (context) => const CustomerBottomBarPage(),
        );

      case AddProductPage.routeName:
        return platformAwarePageRoute(
          builder: (context) => const AddProductPage(),
        );

      case SearchedProductsPage.routeName:
        return platformAwarePageRoute(
          builder: (context) => SearchedProductsPage(
            searchQuery: settings.arguments as String,
          ),
        );

      case ProductDetailsPage.routeName:
        return platformAwarePageRoute(
          builder: (context) => ProductDetailsPage(
            product: settings.arguments as Product,
          ),
        );

      case AddressPage.routeName:
        return platformAwarePageRoute(
          builder: (context) => AddressPage(
            totalPrice: settings.arguments as String,
          ),
        );

      case CartPage.routeName:
        return platformAwarePageRoute(
          builder: (context) => const CartPage(),
        );

      case OrderDetailsPage.routeName:
        return platformAwarePageRoute(
          builder: (context) => OrderDetailsPage(
            order: settings.arguments as Order,
          ),
        );

      default:
        return platformAwarePageRoute(
          builder: (context) => const MessagePage(
            message: 'Invalid Route Name',
          ),
        );
    }
  }

  PageRoute platformAwarePageRoute(
      {required Widget Function(BuildContext) builder}) {
    if (Platform.isIOS) {
      return CupertinoPageRoute(builder: builder);
    } else {
      return MaterialPageRoute(builder: builder);
    }
  }
}
