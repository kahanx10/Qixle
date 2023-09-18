import 'package:amazon_clone/common/data/constants.dart';
import 'package:amazon_clone/common/presentation/widgets/app_button.dart';
import 'package:amazon_clone/common/presentation/widgets/single_product.dart';
import 'package:amazon_clone/components/orders/data/models/order_model.dart';
import 'package:amazon_clone/components/orders/data/services/order_service.dart';
import 'package:amazon_clone/components/orders/presentation/pages/order_details_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OrdersPanel extends StatefulWidget {
  const OrdersPanel({Key? key}) : super(key: key);

  @override
  State<OrdersPanel> createState() => _OrdersPanelState();
}

class _OrdersPanelState extends State<OrdersPanel> {
  var listViewController = ScrollController();

  @override
  void dispose() {
    listViewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Order>>(
      future: OrderService.fetchMyOrders(context),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var orders = snapshot.data!;

          return Container(
            height: 200,
            padding: const EdgeInsets.only(
              left: 10,
              top: 20,
              right: 0,
            ),
            child: orders.isEmpty
                ? Center(
                    child: MyButton(
                      useWidth: true,
                      width: 250,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Constants.selectedColor,
                        foregroundColor: Constants.backgroundColor,
                      ),
                      onPressed: () {
                        // push search page here
                      },
                      text: 'Explore',
                    ),
                  )
                : Container(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      color: Constants.backgroundColor,
                      border:
                          Border.all(width: 2, color: Constants.selectedColor),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        ListView.builder(
                          controller: listViewController,
                          scrollDirection: Axis.horizontal,
                          itemCount: orders.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                  OrderDetailsPage.routeName,
                                  arguments: orders[index],
                                );
                              },
                              child: Stack(
                                alignment: Alignment.topCenter,
                                children: [
                                  ConstrainedBox(
                                    constraints:
                                        const BoxConstraints(maxWidth: 125),
                                    child: Text(
                                      orders[index]
                                          .products[0]['product']['name']
                                          .toString(),
                                      style: GoogleFonts.leagueSpartan(
                                        fontSize: 14,
                                        color: Colors.grey.shade300,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  SingleProduct(
                                    imageUrl: orders[index].products[0]
                                        ['product']['images'][0],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        Positioned(
                          left: 0,
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back_ios_rounded),
                            onPressed: () {
                              listViewController.animateTo(
                                0,
                                duration: const Duration(milliseconds: 400),
                                curve: Curves.decelerate,
                              );
                            },
                          ),
                        ),
                        Positioned(
                          right: 0,
                          child: IconButton(
                            icon: const Icon(Icons.arrow_forward_ios_rounded),
                            onPressed: () {
                              final maxScroll =
                                  listViewController.position.maxScrollExtent;

                              listViewController.animateTo(
                                maxScroll,
                                duration: const Duration(milliseconds: 400),
                                curve: Curves.decelerate,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
          );
        }
        if (snapshot.hasError) {
          return const Center(
            child: Text('Error while fetching your orders!'),
          );
        }

        return const SizedBox(
          height: 200,
          child: Center(child: Constants.loading),
        );
      },
    );
  }
}
