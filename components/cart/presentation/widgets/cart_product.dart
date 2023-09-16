// ignore_for_file: use_build_context_synchronously

import 'package:amazon_clone/common/data/constants.dart';
import 'package:amazon_clone/components/admin/data/models/product_model.dart';
import 'package:amazon_clone/components/authentication/logic/blocs/auth_bloc.dart';
import 'package:amazon_clone/components/cart/data/services/cart_service.dart';
import 'package:amazon_clone/components/home/presentation/pages/product_details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class CartProduct extends StatefulWidget {
  final int index;

  const CartProduct({
    Key? key,
    required this.index,
  }) : super(key: key);

  @override
  State<CartProduct> createState() => _CartProductState();
}

class _CartProductState extends State<CartProduct> {
  var key1 = UniqueKey();
  var key2 = UniqueKey();

  void increaseQuantity(Product product) {
    CartService.addToCart(
      context: context,
      product: product,
      showMessage: false,
    );
  }

  void decreaseQuantity(Product product) {
    CartService.removeFromCart(
      context: context,
      productId: product.id!,
      showMessage: false,
    );
  }

  var isDeleted = false;

  @override
  Widget build(BuildContext context) {
    final productCart =
        (BlocProvider.of<UserBloc>(context).state as UserAuthenticatedState)
            .user
            .cart[widget.index];
    final product = Product.fromMap(productCart['product']);
    final quantity = productCart['quantity'];

    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      alignment: isDeleted ? Alignment.bottomCenter : null,
      height: isDeleted ? 0 : 160,
      child: isDeleted
          ? Container(
              color: Colors.grey.shade200,
              height: 2,
              margin: const EdgeInsets.symmetric(horizontal: 10),
            )
          : Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(
                    left: 10,
                    right: 10,
                    bottom: 10,
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            ProductDetailsPage.routeName,
                            arguments: product,
                          );
                        },
                        child: Container(
                          height: 125,
                          width: 125,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Image.network(
                              product.images[0],
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  product.name,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.leagueSpartan(
                                    fontSize: 20,
                                    color: Constants.selectedColor,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  maxLines: 2,
                                ),
                                const Spacer(),
                                IconButton(
                                  onPressed: () async {
                                    setState(() {
                                      isDeleted = true;
                                    });

                                    CartService.deleteFromCart(
                                      context: context,
                                      productId: product.id!,
                                    );
                                  },
                                  icon: Icon(
                                    Icons.close,
                                    color: Colors.grey.shade300,
                                    size: 30,
                                  ),
                                )
                              ],
                            ),
                            Transform.translate(
                              offset: const Offset(0, -6),
                              child: Text(
                                product.category,
                                style: GoogleFonts.leagueSpartan(
                                  fontSize: 16,
                                  color: Colors.grey.shade400,
                                  fontWeight: FontWeight.w400,
                                  height: 0.7,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Row(
                              children: [
                                Text(
                                  '\$${product.price.toStringAsFixed(2)}',
                                  style: GoogleFonts.leagueSpartan(
                                    fontSize: 18,
                                    color: Constants.selectedColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 2,
                                ),
                                const Spacer(),
                                Container(
                                  margin: const EdgeInsets.all(10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          GestureDetector(
                                            key: key1,
                                            onTap: () async {
                                              setState(() {
                                                key1 = UniqueKey();
                                              });

                                              decreaseQuantity(product);
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Colors.grey.shade100,
                                                  width: 2,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                color: Colors.grey.shade100,
                                              ),
                                              width: 45,
                                              height: 45,
                                              alignment: Alignment.center,
                                              child: const Icon(
                                                Icons.remove,
                                                size: 18,
                                              ).animate().shake(
                                                    duration: const Duration(
                                                      milliseconds: 700,
                                                    ),
                                                  ),
                                            ),
                                          ),
                                          Container(
                                            width: 30,
                                            height: 30,
                                            alignment: Alignment.center,
                                            child: Text(
                                              quantity.toString(),
                                              style: GoogleFonts.leagueSpartan(
                                                fontSize: 14,
                                                color: Constants.selectedColor,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            key: key2,
                                            onTap: () {
                                              setState(() {
                                                key2 = UniqueKey();
                                              });
                                              increaseQuantity(product);
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color:
                                                      Constants.selectedColor,
                                                  width: 2,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                color:
                                                    Constants.backgroundColor,
                                              ),
                                              width: 45,
                                              height: 45,
                                              alignment: Alignment.center,
                                              child: const Icon(
                                                Icons.add,
                                                size: 18,
                                              ).animate().shake(
                                                    duration: const Duration(
                                                      milliseconds: 700,
                                                    ),
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  color: Colors.grey.shade200,
                  height: 2,
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                )
              ],
            ),
    );
  }
}
