import 'package:amazon_clone/components/admin/data/models/product_model.dart';
import 'package:amazon_clone/components/authentication/data/services/auth_token_service.dart';
import 'package:amazon_clone/components/home/data/services/customer_products_service.dart';
import 'package:amazon_clone/components/home/presentation/pages/product_details_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class DealOfTheDay extends StatefulWidget {
  const DealOfTheDay({Key? key}) : super(key: key);

  @override
  State<DealOfTheDay> createState() => _DealOfTheDayState();
}

class _DealOfTheDayState extends State<DealOfTheDay> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Response?>(
        future: fetchDealOfTheDay(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
                child: Text('Error while fetching deal of the day!'));
          } else if (snapshot.hasData && snapshot.data != null) {
            var res = snapshot.data!;

            var product = Product.fromJson(res.body);

            return Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      ProductDetailsPage.routeName,
                      arguments: product,
                    );
                  },
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        padding: const EdgeInsets.only(left: 10, top: 15),
                        child: const Text(
                          'Deal of the day',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      Image.network(
                        product.images[0],
                        height: 235,
                        fit: BoxFit.fitHeight,
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 15),
                        alignment: Alignment.topLeft,
                        child: const Text(
                          '\$100',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        padding:
                            const EdgeInsets.only(left: 15, top: 5, right: 40),
                        child: Text(
                          product.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: product.images
                              .map(
                                (e) => Image.network(
                                  e,
                                  fit: BoxFit.fitWidth,
                                  width: 100,
                                  height: 100,
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                  ).copyWith(left: 15),
                  alignment: Alignment.topLeft,
                  child: Text(
                    'See all deals',
                    style: TextStyle(
                      color: Colors.cyan[800],
                    ),
                  ),
                ),
              ],
            );
          }
          return const CircularProgressIndicator();
        });
  }

  Future<Response?> fetchDealOfTheDay() async {
    var token = await AuthTokenService.getToken();

    if (token != null) {
      return CustomerProductsService.fetchDealOfTheDay(token: token);
    }

    return null;
  }
}
