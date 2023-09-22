import 'dart:convert';

import 'package:amazon_clone/common/data/constants.dart';
import 'package:amazon_clone/common/data/services/message_service.dart';
import 'package:amazon_clone/components/admin/data/models/product_model.dart';
import 'package:amazon_clone/components/authentication/data/models/user_model.dart';
import 'package:amazon_clone/components/authentication/data/services/auth_token_service.dart';
import 'package:amazon_clone/components/authentication/logic/blocs/auth_bloc.dart';
import 'package:amazon_clone/components/cart/data/services/cart_service.dart';
import 'package:amazon_clone/components/cart/presentation/pages/cart_page.dart';
import 'package:amazon_clone/components/home/data/services/customer_products_service.dart';
import 'package:amazon_clone/components/home/logic/cubits/quantity_cubit.dart';
import 'package:amazon_clone/components/home/presentation/pages/searched_products_page.dart';
import 'package:amazon_clone/components/home/presentation/widgets/quantity_chips.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:http/http.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

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
  final _pageController = PageController();

  int qtySelected = 0;

  late bool isSelected;

  Key key = UniqueKey();

  double calculatePercentageLiked(int totalRatings, int avgRating) {
    if (totalRatings == 0 || avgRating == 0) return 0;

    double maxPossibleLikes = totalRatings.toDouble();
    double actualLikes = (avgRating / 5) * totalRatings;

    double percentageLiked = (actualLikes / maxPossibleLikes) * 100;

    return percentageLiked;
  }

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

  void checkProductInCart(User user) {
    isSelected = user.cart.any(
      (productMap) => productMap['product']['_id'] == widget.product.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<QuantityCubit, QuantityState>(
      listener: (context, state) {
        qtySelected = (state as HasQuantity).quantity;

        print(qtySelected);
      },
      child: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          var user = (state as UserAuthenticatedState).user;

          checkProductInCart(user);

          return Scaffold(
            backgroundColor: Colors.grey.shade100,
            body: LayoutBuilder(builder: (context, viewportConstraints) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        SizedBox(
                          height: 400,
                          child: PageView(
                            controller: _pageController,
                            children: widget.product.images.map(
                              (i) {
                                return Builder(
                                  builder: (BuildContext context) => Padding(
                                    padding: const EdgeInsets.all(40.0),
                                    child: Image.network(
                                      i,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                );
                              },
                            ).toList(),
                          ),
                        ),
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
                                  decoration: BoxDecoration(
                                    color: Constants.backgroundColor,
                                    borderRadius: BorderRadius.circular(100),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black
                                            .withOpacity(0.1), // subtle shadow
                                        blurRadius: 8, // soften the shadow
                                        spreadRadius:
                                            0.05, // extent of shadow, negative values can also be used
                                        offset: const Offset(
                                          -0.2,
                                          0.2,
                                        ), // Move to bottom-left by 4 units
                                      ),
                                    ],
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
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  GestureDetector(
                                    key: key,
                                    onTap: () {
                                      setState(() {
                                        key = UniqueKey();
                                      });

                                      if (isSelected) {
                                        CartService.removeFromCart(
                                          productId: widget.product.id!,
                                          context: context,
                                        );

                                        print('removed');
                                      } else {
                                        CartService.addToCart(
                                          product: widget.product,
                                          context: context,
                                        );
                                      }

                                      isSelected = !isSelected;
                                    },
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: Constants.backgroundColor,
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(
                                                0.1), // subtle shadow
                                            blurRadius: 8, // soften the shadow
                                            spreadRadius:
                                                0.05, // extent of shadow, negative values can also be used
                                            offset: const Offset(
                                              -0.2,
                                              0.2,
                                            ), // Move to bottom-left by 4 units
                                          ),
                                        ],
                                      ),
                                      child: Center(
                                        child: Icon(
                                          isSelected
                                              ? Icons.favorite_rounded
                                              : Icons.favorite_outline_rounded,
                                          color: isSelected
                                              ? Colors.red.shade300
                                              : Constants.selectedColor,
                                          size: 20,
                                        ),
                                      ),
                                    ).animate().shake(),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        Transform.translate(
                          offset: const Offset(180, 350),
                          child: SmoothPageIndicator(
                            count: widget.product.images.length,
                            effect: WormEffect(
                              activeDotColor: Constants.selectedColor,
                              dotColor: Colors.white,
                              spacing: 8.0,
                            ),
                            controller: _pageController,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(
                        color: Constants.backgroundColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                widget.product.name,
                                style: GoogleFonts.leagueSpartan(
                                  fontSize: 24,
                                  fontWeight: FontWeight.normal,
                                  color: Constants.selectedColor,
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                width: 110,
                                height: 45,
                                decoration: BoxDecoration(
                                  color: Colors.red.shade300,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Text(
                                  '% On sale',
                                  style: GoogleFonts.leagueSpartan(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Constants.backgroundColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Container(
                                width: 95,
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Constants.backgroundColor,
                                  border: Border.all(
                                      color: Colors.grey.shade100, width: 2.5),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    const Icon(
                                      Icons.star_rounded,
                                      size: 20,
                                      color: Constants.secondaryColor,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: Text(
                                        widget.product.avgRating
                                            .toStringAsFixed(1),
                                        style: GoogleFonts.leagueSpartan(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                width: 95,
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Constants.backgroundColor,
                                  border: Border.all(
                                      color: Colors.grey.shade100, width: 2.5),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Icon(
                                      Icons.thumb_up_alt_rounded,
                                      size: 16,
                                      color: Colors.black,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: Text(
                                        '${calculatePercentageLiked(
                                          widget.product.totalRatings.toInt(),
                                          widget.product.avgRating.toInt(),
                                        ).toStringAsFixed(0)}%',
                                        style: GoogleFonts.leagueSpartan(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Text(
                                '${widget.product.totalRatings} reviews',
                                style: GoogleFonts.leagueSpartan(
                                  color: Colors.grey.shade400,
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            height: 110,
                            child: SingleChildScrollView(
                              child: Text(
                                widget.product.description,
                                style: GoogleFonts.leagueSpartan(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Your rating:',
                            style: GoogleFonts.leagueSpartan(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade500,
                            ),
                          ),
                          FutureBuilder(
                              future:
                                  fetchMyRating(productId: widget.product.id!),
                              builder: (context, snapshot) {
                                if (snapshot.hasData && snapshot.data != null) {
                                  return RatingBar.builder(
                                    initialRating: myRating ??
                                        jsonDecode(snapshot.data!.body)
                                            .toDouble(),
                                    minRating: 1,
                                    direction: Axis.horizontal,
                                    allowHalfRating: true,
                                    itemCount: 5,
                                    itemBuilder: (context, _) => const SizedBox(
                                      height: 30,
                                      width: 30,
                                      child: Icon(
                                        Icons.star_rounded,
                                        color: Constants.secondaryColor,
                                      ),
                                    ),
                                    onRatingUpdate: (newRating) async {
                                      var token =
                                          await AuthTokenService.getToken();

                                      if (token != null) {
                                        var res = await CustomerProductsService
                                            .rateProduct(
                                          rating: newRating,
                                          productId: widget.product.id!,
                                          token: token,
                                        );

                                        var res2 = await CustomerProductsService
                                            .fetchMyRatingOnProduct(
                                          productId: widget.product.id!,
                                          token: token,
                                        );

                                        if (res == null ||
                                            res.statusCode != 200) {
                                          MessageService.showSnackBar(
                                            context,
                                            message:
                                                'Couldn\'t rate the product, please try again!',
                                          );

                                          return;
                                        }

                                        var averageRatingUpdated =
                                            jsonDecode(res.body) as num;

                                        if (mounted) {
                                          setState(() {
                                            avgRating =
                                                averageRatingUpdated.toDouble();
                                          });
                                        }

                                        if (res2 == null ||
                                            res.statusCode != 200) {
                                          MessageService.showSnackBar(
                                            context,
                                            message:
                                                'Couldn\'t fetch your rating, please try again!',
                                          );
                                        }

                                        var myRatingResult =
                                            jsonDecode(res2!.body);
                                        myRating = myRatingResult.toDouble();
                                      }
                                    },
                                  );
                                } else if (snapshot.hasError) {
                                  return const Text(
                                      'Error while fetching your rating!');
                                } else {
                                  return const SizedBox(height: 0, width: 0);
                                }
                              }),
                          Transform.translate(
                              offset: const Offset(0, 4),
                              child:
                                  const QuantityChips(chipList: [5, 10, 15])),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 112,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Constants.backgroundColor,
                      border: Border(
                          top: BorderSide(
                              width: 2.5, color: Colors.grey.shade100)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '\$${(widget.product.price * 1.175).toStringAsFixed(2)}',
                              style: GoogleFonts.leagueSpartan(
                                color: Colors.grey.shade400,
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                                decoration: TextDecoration.lineThrough,
                                // decorationColor: Colors.grey.shade400,
                              ),
                            ),
                            Text(
                              '\$${widget.product.price.toStringAsFixed(2)}',
                              style: GoogleFonts.leagueSpartan(
                                fontSize: 20.0,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                height: 1,
                              ),
                            ),
                            const SizedBox(
                              height: 8.0,
                            )
                          ],
                        ),
                        GestureDetector(
                          onTap: () async {
                            if (qtySelected != 0 && !isSelected) {
                              await CartService.addToCart(
                                product: widget.product,
                                context: context,
                                quantity: qtySelected,
                              );

                              Navigator.of(context)
                                  .pushNamed(CartPage.routeName);
                              return;
                            }
                            if (qtySelected != 0 && isSelected) {
                              await CartService.addToCart(
                                product: widget.product,
                                context: context,
                                quantity: qtySelected - 1,
                              );

                              Navigator.of(context)
                                  .pushNamed(CartPage.routeName);
                              return;
                            }
                            if (!isSelected) {
                              await CartService.addToCart(
                                product: widget.product,
                                context: context,
                                showMessage: false,
                              );

                              Navigator.of(context)
                                  .pushNamed(CartPage.routeName);
                              return;
                            }

                            if (isSelected) {
                              Navigator.of(context)
                                  .pushNamed(CartPage.routeName);
                              return;
                            }
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: 230,
                            height: 75,
                            decoration: BoxDecoration(
                              color: Constants.selectedColor,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black
                                      .withOpacity(0.3), // subtle shadow
                                  blurRadius: 12, // soften the shadow
                                  spreadRadius:
                                      0.3, // extent of shadow, negative values can also be used
                                  offset: const Offset(
                                    -0.6,
                                    0.6,
                                  ), // Move to bottom-left by 4 units
                                ),
                              ],
                            ),
                            child: Text(
                              'Buy Now',
                              style: GoogleFonts.leagueSpartan(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Constants.backgroundColor,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              );
            }),
          );
        },
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
