import 'package:amazon_clone/common/data/constants.dart';
import 'package:amazon_clone/common/presentation/widgets/app_button.dart';
import 'package:amazon_clone/components/authentication/logic/blocs/auth_bloc.dart';
import 'package:amazon_clone/components/home/presentation/pages/address_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class CartSubtotal extends StatefulWidget {
  const CartSubtotal({Key? key}) : super(key: key);

  @override
  State<CartSubtotal> createState() => _CartSubtotalState();
}

class _CartSubtotalState extends State<CartSubtotal> {
  var deliveryFee = 7;

  void navigateToAddress(int sum) {
    if (sum < 50) {
      sum += deliveryFee;
    }

    Navigator.pushNamed(
      context,
      AddressPage.routeName,
      arguments: sum.toString(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user =
        (BlocProvider.of<UserBloc>(context).state as UserAuthenticatedState)
            .user;

    int sum = 20;
    user.cart
        .map((cartItem) =>
            sum += cartItem['quantity'] * cartItem['product']['price'] as int)
        .toList();

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade200, width: 2),
            borderRadius: BorderRadius.circular(15),
          ),
          margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Subtotal: ',
                    style: GoogleFonts.leagueSpartan(
                      fontSize: 16,
                      // color: Colors.grey,
                    ),
                  ),
                  Text(
                    '\$${sum.toStringAsFixed(2)}',
                    style: GoogleFonts.leagueSpartan(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Delivery: ',
                    style: GoogleFonts.leagueSpartan(
                      fontSize: 16,
                      // color: Colors.grey,
                    ),
                  ),
                  Text(
                    sum > 50 ? 'FREE' : '\\$deliveryFee',
                    style: GoogleFonts.leagueSpartan(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(
                color: Colors.grey.shade200,
                height: 2,
                margin:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              ),
              if (sum < 50)
                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Text(
                    'Shop for just \$${(50 - sum).toStringAsFixed(2)} more to make the delivery free!'
                        .toUpperCase(),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.leagueSpartan(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ),
              Container(
                margin: const EdgeInsets.only(top: 10),
                child: MyButton(
                  label: user.cart.length == 1
                      ? 'Let\'s Checkout! (1 item)'
                      : 'Let\'s Checkout! (${user.cart.length} item)',
                  onPressed: () => navigateToAddress(sum),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Constants.selectedColor,
                    foregroundColor: Constants.backgroundColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
