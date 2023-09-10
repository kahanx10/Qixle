import 'dart:convert';

import 'package:amazon_clone/common/data/constants.dart';
import 'package:amazon_clone/common/data/services/message_service.dart';
import 'package:amazon_clone/common/presentation/widgets/app_button.dart';
import 'package:amazon_clone/components/admin/data/models/product_model.dart';
import 'package:amazon_clone/components/authentication/data/services/auth_token_service.dart';
import 'package:amazon_clone/components/cart/data/services/cart_service.dart';
import 'package:amazon_clone/components/cart/presentation/pages/cart_page.dart';
import 'package:amazon_clone/components/home/data/services/customer_products_service.dart';
import 'package:amazon_clone/components/home/presentation/pages/searched_products_page.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart';

class ProductDetailsPage extends StatefulWidget {
  static const String routeName = '/product_details_page_route';
  final Product product;

  const ProductDetailsPage({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  late double avgRating;
  double? myRating;

  @override
  void initState() {
    super.initState();
    avgRating = widget.product.avgRating.toDouble();
  }

  void navigateToSearchScreen(String query) {
    Navigator.pushNamed(
      context,
      SearchedProductsPage.routeName,
      arguments: query,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: Constants.appBarGradient,
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  height: 42,
                  margin: const EdgeInsets.only(left: 15),
                  child: Material(
                    borderRadius: BorderRadius.circular(7),
                    elevation: 1,
                    child: TextFormField(
                      onFieldSubmitted: navigateToSearchScreen,
                      decoration: InputDecoration(
                        prefixIcon: InkWell(
                          onTap: () {},
                          child: const Padding(
                            padding: EdgeInsets.only(
                              left: 6,
                            ),
                            child: Icon(
                              Icons.search,
                              color: Colors.black,
                              size: 23,
                            ),
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.only(top: 10),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(7),
                          ),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(7),
                          ),
                          borderSide: BorderSide(
                            color: Colors.black38,
                            width: 1,
                          ),
                        ),
                        hintText: 'Find More Products',
                        hintStyle: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                color: Colors.transparent,
                height: 42,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: const Icon(Icons.mic, color: Colors.black, size: 25),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.product.id!,
                  ),
                  // Stars(
                  //   rating: avgRating,
                  // ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 10,
              ),
              child: Text(
                widget.product.name,
                style: const TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
            CarouselSlider(
              items: widget.product.images.map(
                (i) {
                  return Builder(
                    builder: (BuildContext context) => Image.network(
                      i,
                      fit: BoxFit.contain,
                      height: 200,
                    ),
                  );
                },
              ).toList(),
              options: CarouselOptions(
                viewportFraction: 1,
                height: 300,
                enableInfiniteScroll: false,
              ),
            ),
            Container(
              color: Colors.black12,
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: RichText(
                text: TextSpan(
                  text: 'Deal Price: ',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    TextSpan(
                      text: '\$${widget.product.price}',
                      style: const TextStyle(
                        fontSize: 22,
                        color: Colors.red,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(widget.product.description),
            ),
            Container(
              color: Colors.black12,
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: MyButton(
                width: double.infinity,
                label: 'Buy Now',
                onPressed: () {
                  Navigator.of(context).pushNamed(CartPage.routeName);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Constants.secondaryColor,
                  foregroundColor: Constants.backgroundColor,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(10),
              child: MyButton(
                width: double.infinity,
                label: 'Add to Cart',
                onPressed: () {
                  CartService.addToCart(
                    product: widget.product,
                    context: context,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(254, 216, 19, 1),
                  foregroundColor: Constants.backgroundColor,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              color: Colors.black12,
              height: 5,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                'Rate The Product',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Text('Your Rating'),
            FutureBuilder(
                future: fetchMyRating(productId: widget.product.id!),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    return RatingBar.builder(
                      initialRating: myRating ??
                          jsonDecode(snapshot.data!.body).toDouble(),
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 4),
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Constants.secondaryColor,
                      ),
                      onRatingUpdate: (newRating) async {
                        var token = await AuthTokenService.getToken();

                        if (token != null) {
                          var res = await CustomerProductsService.rateProduct(
                            rating: newRating,
                            productId: widget.product.id!,
                            token: token,
                          );

                          var res2 = await CustomerProductsService
                              .fetchMyRatingOnProduct(
                            productId: widget.product.id!,
                            token: token,
                          );

                          if (res == null || res.statusCode != 200) {
                            MessageService.showSnackBar(
                              context,
                              message:
                                  'Couldn\'t rate the product, please try again!',
                            );
                          }

                          var averageRatingUpdated =
                              jsonDecode(res!.body) as num;

                          setState(() {
                            avgRating = averageRatingUpdated.toDouble();
                          });

                          if (res2 == null || res.statusCode != 200) {
                            MessageService.showSnackBar(
                              context,
                              message:
                                  'Couldn\'t fetch your rating, please try again!',
                            );
                          }

                          var myRatingResult = jsonDecode(res2!.body);
                          myRating = myRatingResult.toDouble();
                        }
                      },
                    );
                  } else if (snapshot.hasError) {
                    return const Text('Error while fetching your rating!');
                  } else {
                    return const CircularProgressIndicator();
                  }
                }),
            const Text('Average Rating'),
            AbsorbPointer(
              absorbing: true,
              child: RatingBar.builder(
                initialRating: avgRating,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4),
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Constants.secondaryColor,
                ),
                onRatingUpdate: (newRating) {
                  // fetch avg rating again
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<Response?> fetchMyRating({required String productId}) async {
  var token = await AuthTokenService.getToken();

  if (token != null) {
    return await CustomerProductsService.fetchMyRatingOnProduct(
      productId: productId,
      token: token,
    );
  }
  return null;
}
