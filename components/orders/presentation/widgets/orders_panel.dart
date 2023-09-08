import 'package:amazon_clone/common/data/constants.dart';
import 'package:amazon_clone/common/presentation/widgets/single_product.dart';
import 'package:amazon_clone/components/orders/data/models/order_model.dart';
import 'package:amazon_clone/components/orders/data/services/order_service.dart';
import 'package:amazon_clone/components/orders/presentation/pages/order_details_page.dart';
import 'package:flutter/material.dart';

class OrdersPanel extends StatefulWidget {
  const OrdersPanel({Key? key}) : super(key: key);

  @override
  State<OrdersPanel> createState() => _OrdersPanelState();
}

class _OrdersPanelState extends State<OrdersPanel> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Order>>(
      future: OrderService.fetchMyOrders(context),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var orders = snapshot.data!;

          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.only(
                      left: 15,
                    ),
                    child: const Text(
                      'Your Orders',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                      right: 15,
                    ),
                    child: Text(
                      'See all',
                      style: TextStyle(
                        color: Constants.selectedColor,
                      ),
                    ),
                  ),
                ],
              ),
              // display orders
              Container(
                height: 170,
                padding: const EdgeInsets.only(
                  left: 10,
                  top: 20,
                  right: 0,
                ),
                child: orders.isEmpty
                    ? const Center(
                        child: Text('No orders yet!'),
                      )
                    : ListView.builder(
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
                            child: SingleProduct(
                              imageUrl: orders[index].products[0]['product']
                                  ['images'][0],
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        }
        if (snapshot.hasError) {
          return const Center(
            child: Text('Error while fetching your orders!'),
          );
        }

        return const CircularProgressIndicator();
      },
    );
  }
}
