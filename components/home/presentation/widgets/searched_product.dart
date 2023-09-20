import 'dart:math';
import 'dart:ui';

import 'package:amazon_clone/common/data/constants.dart';
import 'package:amazon_clone/components/admin/data/models/product_model.dart';
import 'package:amazon_clone/components/home/presentation/pages/product_details_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';

class SearchedProduct extends StatelessWidget {
  final Product product;
  final bool isReversed;

  const SearchedProduct({
    Key? key,
    required this.product,
    required this.isReversed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> rowChildren = [
      Stack(
        children: [
          Transform.translate(
            offset: Offset(
              isReversed
                  ? -5
                  : product.price.toString().length >= 4
                      ? 100
                      : 165,
              -20,
            ),
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center, // centered vertically
              crossAxisAlignment: isReversed
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.end,
              children: [
                Container(
                  width: 150,
                  height: 2.0,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: const EdgeInsets.only(
                    top: 5,
                    bottom: 10,
                  ),
                ),
                Text(
                  'In ${product.category}',
                  style: GoogleFonts.leagueSpartan(
                    fontWeight: FontWeight.w500,
                    color: Constants.selectedColor,
                  ),
                ),
                SizedBox(
                  width: 150,
                  child: Text(
                    product.name.toUpperCase(),
                    textAlign: isReversed ? TextAlign.start : TextAlign.end,
                    style: GoogleFonts.leagueSpartan(
                      color: Colors.grey.shade300,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  width: 50,
                  height: 2.0,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: const EdgeInsets.only(top: 5, bottom: 10),
                ),
                Stack(
                  children: [
                    Transform.translate(
                      offset: const Offset(4, 4),
                      child: Container(
                        alignment: isReversed
                            ? Alignment.centerLeft
                            : Alignment.centerRight,
                        width: 180,
                        child: Text(
                          '\$${product.price}',
                          overflow: TextOverflow.fade,
                          style: GoogleFonts.leagueSpartan(
                            height: 1.1,
                            color: Colors.grey.shade300,
                            fontSize: 50,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 180,
                      alignment: isReversed
                          ? Alignment.centerLeft
                          : Alignment.centerRight,
                      child: Text(
                        '\$${product.price}',
                        overflow: TextOverflow.fade,
                        style: GoogleFonts.leagueSpartan(
                          height: 1.1,
                          color: Constants.selectedColor,
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      ProductDetailsPage.routeName,
                      arguments: product,
                    );
                  },
                  child: Stack(
                    children: [
                      Transform.translate(
                        offset: const Offset(4, 4),
                        child: Container(
                          width: 60,
                          height: 40,
                          margin: const EdgeInsets.only(
                            top: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            // border: Border.all(color: Colors.black, width: 2.0),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      Container(
                        width: 60,
                        height: 40,
                        margin: const EdgeInsets.only(
                          top: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Constants.backgroundColor,
                          border: Border.all(color: Colors.black, width: 2.0),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(LineIcons.arrowRight),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment:
                isReversed ? Alignment.centerLeft : Alignment.centerRight,
            child: Transform.translate(
              offset: Offset(isReversed ? 160 : -160, isReversed ? 30 : 0),
              child: Container(
                height: 290,
                width: 290,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey.shade100,
                    width: 12,
                  ),
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(300),
                ),
              ),
            ),
          ),
          Align(
            alignment: isReversed ? Alignment.bottomRight : Alignment.topLeft,
            child: Transform.rotate(
              angle: isReversed ? (pi / 180) * -10 : (pi / 180) * 10,
              // angle: 0,
              child: Transform.translate(
                offset: Offset(isReversed ? 120 : -120, isReversed ? 35 : 0),
                child: Stack(
                  children: [
                    ImageFiltered(
                      imageFilter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: Opacity(
                        opacity: 0.3,
                        child: Image.network(
                          product.images[0],
                          color: Colors.black,
                          fit: BoxFit.contain,
                          height: 315,
                          width: 315,
                        ),
                      ),
                    ),
                    Image.network(
                      product.images[0],
                      fit: BoxFit.contain,
                      height: 310,
                      width: 310,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ];

    return Container(
      width: double.infinity, // to make it span horizontally
      // color: isReversed ? Constants.selectedColor : null,
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
              // <--- top side
              color: Colors.black,
              width: 2.0),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        children: isReversed ? rowChildren.reversed.toList() : rowChildren,
      ),
    );
  }
}
