import 'package:amazon_clone/common/data/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductThumbnail extends StatefulWidget {
  final String productImage;
  final String productName;
  final double price;
  final double rating;

  const ProductThumbnail({
    super.key,
    required this.productImage,
    required this.price,
    required this.rating,
    required this.productName,
  });

  @override
  State<ProductThumbnail> createState() => _ProductThumbnailState();
}

class _ProductThumbnailState extends State<ProductThumbnail> {
  Key key = UniqueKey();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: GestureDetector(
            key: key,
            onTapDown: (tapDownDetails) {
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
                  widget.productImage,
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
                    widget.productName,
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
                          widget.rating.toStringAsFixed(1),
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
                '\$${widget.price}',
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
    );
  }
}
