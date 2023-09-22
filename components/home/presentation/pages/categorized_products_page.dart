// ignore_for_file: must_be_immutable

import 'package:amazon_clone/common/data/constants.dart';
import 'package:amazon_clone/components/home/logic/cubits/customer_products_cubit.dart';
import 'package:amazon_clone/components/home/presentation/widgets/product_thumbnail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class CategorizedProducts extends StatefulWidget {
  const CategorizedProducts({
    Key? key,
  }) : super(key: key);

  @override
  State<CategorizedProducts> createState() => _CategorizedProductsState();
}

class _CategorizedProductsState extends State<CategorizedProducts> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CustomerProductsCubit, CustomerProductsState>(
      builder: (context, state) {
        switch (state.runtimeType) {
          case NoProducts:
            return SizedBox(
              height: 300,
              child: Column(
                children: [
                  Transform.translate(
                    offset: const Offset(0, -20),
                    child: Lottie.asset(
                      'assets/lottie/click.json',
                      width: 100,
                      height: 100,
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Text(
                    'Select a category\nto load products!',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.leagueSpartan(
                      fontSize: 20,
                      color: Colors.grey.shade300,
                      letterSpacing: 0.1,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          case FetchingProducts:
            return const SizedBox(height: 300, child: Constants.loading);

          case ProductsFetched:
            var productsList = (state as ProductsFetched).products;

            return productsList.isEmpty
                // this won't happen because we'll curate enough products initially
                ? SizedBox(
                    height: 300,
                    child: Center(
                      child: Text(
                        'No products in this category yet.\nBut keep exploring!',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.leagueSpartan(
                          fontSize: 16,
                          color: Colors.grey.shade300,
                          letterSpacing: 0.1,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30.0,
                      vertical: 30.0,
                    ),
                    child: GridView.builder(
                      itemCount: productsList.length,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 3 / 4,
                        mainAxisSpacing: 10,
                      ),
                      itemBuilder: (context, index) {
                        final product = productsList[index];
                        return ProductThumbnail(
                          product: product,
                        );
                      },
                    ),
                  );

          case ErrorFetching:
            var errorMessage = (state as ErrorFetching).errorMessage;
            return SizedBox(
              height: 300,
              child: Center(
                child: Text(errorMessage),
              ),
            );
          default:
            return const SizedBox();
        }
      },
    );
  }
}
