import 'package:amazon_clone/common/data/constants.dart';
import 'package:amazon_clone/common/presentation/widgets/app_button.dart';
import 'package:amazon_clone/components/authentication/logic/blocs/auth_bloc.dart';
import 'package:amazon_clone/components/cart/data/services/cart_service.dart';
import 'package:amazon_clone/components/cart/presentation/widgets/cart_product.dart';
import 'package:amazon_clone/components/cart/presentation/widgets/subtotal.dart';
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

  void _showMenu(BuildContext context, Offset position) {
    void _showAlertDialog(BuildContext context) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Constants.selectedColor,
            title: Text(
              'Clear Cart?',
              style: GoogleFonts.leagueSpartan(
                fontSize: 20,
                color: Constants.backgroundColor,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.025,
              ),
            ),
            content: Text(
              'All cart items will be discarded.\nThink again!',
              style: GoogleFonts.leagueSpartan(
                fontSize: 16,
                color: Constants.backgroundColor,
                fontWeight: FontWeight.normal,
                letterSpacing: 0.025,
              ),
            ),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    child: Text(
                      'Cancel',
                      style: GoogleFonts.leagueSpartan(
                        fontSize: 14,
                        color: Constants.backgroundColor,
                        fontWeight: FontWeight.normal,
                        letterSpacing: 0.025,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                  ),
                  TextButton(
                    child: Text(
                      'OK',
                      style: GoogleFonts.leagueSpartan(
                        fontSize: 14,
                        color: Colors.grey,
                        fontWeight: FontWeight.normal,
                        letterSpacing: 0.025,
                      ),
                    ),
                    onPressed: () {
                      CartService.clearCart(context);
                      Navigator.of(context).pop(); // Close the dialog
                    },
                  ),
                ],
              ),
            ],
          );
        },
      );
    }

    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
          position.dx, position.dy, position.dx, position.dy),
      items: [
        PopupMenuItem<String>(
          value: 'Clear cart',
          child: Text(
            'Clear cart',
            style: GoogleFonts.leagueSpartan(
              fontSize: 14,
              color: Constants.backgroundColor,
              fontWeight: FontWeight.normal,
              letterSpacing: 0.025,
            ),
          ),
        ),
      ],
      elevation: 4.0,
    ).then((value) {
      if (value == 'Clear cart') {
        _showAlertDialog(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        final user =
            (BlocProvider.of<UserBloc>(context).state as UserAuthenticatedState)
                .user;

        return Scaffold(
          backgroundColor: Constants.backgroundColor,
          body: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
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
                          fontSize: 24,
                          color: Constants.selectedColor,
                          fontWeight: FontWeight.normal,
                          letterSpacing: 0.025,
                        ),
                      ),
                      user.cart.isNotEmpty
                          ? GestureDetector(
                              onTap: () {
                                double screenWidth =
                                    MediaQuery.of(context).size.width;
                                double screenHeight =
                                    MediaQuery.of(context).size.height;

                                _showMenu(
                                  context,
                                  Offset(
                                    screenWidth * 0.68,
                                    screenHeight * 0.035,
                                  ),
                                );
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
                            )
                          : const SizedBox(
                              width: 40,
                            ),
                    ],
                  ),
                ),
                // Container(
                //   color: Colors.grey.shade200,
                //   height: 2,
                //   margin:
                //       const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                // ),
                if (user.cart.isNotEmpty) const CartSubtotal(),
                user.cart.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: ListView.builder(
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
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 35),
                          Lottie.asset('assets/lottie/empty_cart.json'),
                          const SizedBox(height: 95),
                          Container(
                            color: Colors.grey.shade200,
                            height: 2,
                          ),
                          const SizedBox(height: 15),
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
                          const SizedBox(height: 20),
                          MyButton(
                            width: MediaQuery.of(context).size.width,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Constants.selectedColor,
                              foregroundColor: Constants.backgroundColor,
                            ),
                            onPressed: () {
                              // push search page here
                              Navigator.of(context).popUntil((route) {
                                return route.isFirst;
                              });
                            },
                            label: 'Explore',
                          ),
                        ],
                      ),
              ],
            ),
          ),
        );
      },
    );
  }
}
