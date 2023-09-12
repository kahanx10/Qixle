import 'package:amazon_clone/common/data/constants.dart';
import 'package:amazon_clone/components/authentication/logic/blocs/auth_bloc.dart';
import 'package:amazon_clone/components/cart/presentation/widgets/cart_product.dart';
import 'package:amazon_clone/components/home/presentation/pages/address_page.dart';
import 'package:amazon_clone/components/home/presentation/pages/searched_products_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class CartPage extends StatefulWidget {
  static const String routeName = '/cart_route';
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  void navigateToSearchScreen(String query) {
    Navigator.pushNamed(
      context,
      SearchedProductsPage.routeName,
      arguments: query,
    );
  }

  void navigateToAddress(int sum) {
    Navigator.pushNamed(
      context,
      AddressPage.routeName,
      arguments: sum.toString(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        final user =
            (BlocProvider.of<UserBloc>(context).state as UserAuthenticatedState)
                .user;

        int sum = 0;

        user.cart
            .map((e) => sum += e['quantity'] * e['product']['price'] as int)
            .toList();

        return Scaffold(
          backgroundColor: Constants.backgroundColor,
          body: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 30,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Constants.backgroundColor,
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(
                              color: Colors.grey.shade200,
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: Constants.selectedColor,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                      Text(
                        'My cart',
                        style: GoogleFonts.leagueSpartan(
                          fontSize: 20,
                          color: Constants.selectedColor,
                          letterSpacing: 0.1,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Constants.backgroundColor,
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(
                              color: Colors.grey.shade200,
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.more_horiz,
                              color: Constants.selectedColor,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // const CartSubtotal(),
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: MyButton(
                //     label: 'Proceed to Buy (${user.cart.length} items)',
                //     onPressed: () => navigateToAddress(sum),
                //     style: ElevatedButton.styleFrom(
                //       backgroundColor: Colors.yellow[600],
                //     ),
                //   ),
                // ),
                const SizedBox(height: 15),
                user.cart.isNotEmpty
                    ? ListView.builder(
                        itemCount: user.cart.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          if (user.cart[index] == null) {
                            return null;
                          }

                          return CartProduct(
                            index: index,
                          );
                        },
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Lottie.asset('assets/lottie/empty_cart.json'),
                          Text(
                            'Nothing here yet.',
                            style: GoogleFonts.leagueSpartan(
                              color: Constants.selectedColor,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Your cart seems lonely right now.\nLet\'s Fill It Up!',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.leagueSpartan(
                              color: Colors.grey.shade600,
                              fontSize: 15,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                // Container(
                //   color: Colors.grey.shade200,
                //   height: 2,
                // ),
              ],
            ),
          ),
        );
      },
    );
  }
}
