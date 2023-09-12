// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:amazon_clone/components/home/presentation/pages/product_details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:amazon_clone/common/data/constants.dart';
import 'package:amazon_clone/components/admin/data/models/product_model.dart';

class ProductThumbnail extends StatefulWidget {
  final Product product;

  const ProductThumbnail({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  State<ProductThumbnail> createState() => _ProductThumbnailState();
}

class _ProductThumbnailState extends State<ProductThumbnail> {
  Key key = UniqueKey();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          ProductDetailsPage.routeName,
          arguments: widget.product,
        );
      },
      child: Column(
        children: [
          Expanded(
            child: GestureDetector(
              key: key,
              onLongPress: () {
                setState(() {
                  key = UniqueKey();
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.all(4),
                padding: const EdgeInsets.all(10),
                child: Center(
                  child: Image.network(
                    widget.product.images[0],
                    width: 200,
                    height: 200,
                  ).animate().shimmer(),
                ),
              ).animate().shake(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.product.name,
                      style: GoogleFonts.leagueSpartan(
                        fontSize: 14,
                        color: Colors.blueGrey.shade100,
                        fontWeight: FontWeight.w500,
                        height: 1,
                        letterSpacing: 0.1,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          size: 20,
                          color: Constants.secondaryColor,
                        ),
                        const SizedBox(
                          width: 2,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            widget.product.avgRating.toStringAsFixed(1),
                            style: GoogleFonts.leagueSpartan(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              height: 1,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Text(
                  '\$${widget.product.price}',
                  style: GoogleFonts.leagueSpartan(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
