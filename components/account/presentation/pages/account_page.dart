import 'package:amazon_clone/common/data/constants.dart';
import 'package:amazon_clone/components/authentication/logic/blocs/auth_bloc.dart';
import 'package:amazon_clone/components/account/presentation/widgets/orders_panel.dart';
import 'package:amazon_clone/components/orders/data/models/order_model.dart';
import 'package:amazon_clone/components/orders/data/services/order_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class AccountPage extends StatefulWidget {
  static const String routeName = '/home_route';

  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    var user = (context.read<UserBloc>().state as UserAuthenticatedState).user;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.grey.shade100,
      ),
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.grey.shade100,
            scrolledUnderElevation: 0.0,
            centerTitle: true,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Hello ${((user.name).split(' '))[0]}',
                  style: GoogleFonts.leagueSpartan(
                    fontSize: 24,
                    color: Constants.selectedColor,
                    fontWeight: FontWeight.normal,
                    letterSpacing: 0.025,
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                const Icon(Icons.shopping_cart_outlined),
              ],
            ),
          ),
          backgroundColor: Colors.grey.shade100,
          body: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(0),
                child: Container(
                  height: 2,
                  decoration: BoxDecoration(
                    color: Constants.selectedColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const OrdersPanel(),
              const SizedBox(
                height: 15,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(vertical: 10),
                margin: const EdgeInsets.symmetric(horizontal: 22.5),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  border: Border.all(width: 2, color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  'Keep an eye on your goodies!\nTracking them is a breeze ;)'
                      .toUpperCase(),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.leagueSpartan(
                    fontSize: 14,
                    color: Constants.selectedColor,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.025,
                  ),
                ),
              ),
              const Spacer(),
              Stack(
                alignment: Alignment.topCenter,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 0,
                    ),
                    child: Container(
                      height: 2,
                      decoration: BoxDecoration(
                        color: Constants.selectedColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  FutureBuilder<List<Order>>(
                      future: OrderService.fetchMyOrders(context),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          var orders = snapshot.data!;

                          return Container(
                            color: Colors.grey.shade100,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Transform.translate(
                              offset: const Offset(0, -20),
                              child: Text(
                                orders.isNotEmpty ? 'Your Orders' : 'No Orders',
                                style: GoogleFonts.leagueSpartan(
                                  fontSize: 35,
                                  color: Colors.grey.shade300,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        } else {
                          return const SizedBox(height: 0, width: 0);
                        }
                      }),
                  Lottie.asset(
                    'assets/lottie/man.json',
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
