import 'dart:ui';

import 'package:amazon_clone/components/admin/data/models/product_model.dart';
import 'package:amazon_clone/components/home/presentation/pages/product_details_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchedProductWithQuery extends StatelessWidget {
  final Product product;

  const SearchedProductWithQuery({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          ProductDetailsPage.routeName,
          arguments: product,
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 10,
        ),
        child: Column(
          children: [
            Row(
              children: [
                Stack(
                  children: [
                    Opacity(
                      opacity: 0.3,
                      child: Image.network(
                        product.images[0],
                        color: Colors.black,
                        fit: BoxFit.contain,
                        height: 120,
                        width: 120,
                      ),
                    ),
                    ClipRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                        child: Image.network(
                          product.images[0],
                          fit: BoxFit.contain,
                          height: 120,
                          width: 120,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 150,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            product.name,
                            style: GoogleFonts.leagueSpartan(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Icon(
                            product.isAvailable
                                ? Icons.check_circle_outline_rounded
                                : Icons.block_outlined,
                            color: product.isAvailable
                                ? Colors.green.shade400
                                : Colors.red.shade400,
                          ),
                        )
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 10, top: 5),
                      child: Row(
                        children: [
                          Text(
                            '\$${product.price}',
                            style: GoogleFonts.leagueSpartan(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          if (product.price >= 50)
                            Text(
                              '(Free Delivery)',
                              style: GoogleFonts.leagueSpartan(
                                color: Colors.grey.shade400,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Container(
              width: 55,
              height: 2.0,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.symmetric(vertical: 20),
            ),
          ],
        ),
      ),
    );
  }
}
