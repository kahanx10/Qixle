// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:amazon_clone/components/home/presentation/widgets/searched_product_with_query.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';

import 'package:amazon_clone/common/data/constants.dart';
import 'package:amazon_clone/components/admin/data/models/product_model.dart';
import 'package:amazon_clone/components/authentication/logic/blocs/auth_bloc.dart';
import 'package:amazon_clone/components/home/logic/cubits/customer_products_cubit.dart';
import 'package:amazon_clone/components/home/presentation/widgets/address_panel.dart';
import 'package:amazon_clone/components/home/presentation/widgets/searched_product_all.dart';

class SearchedProductsPage extends StatefulWidget {
  static const String routeName = '/searched_page';
  final String searchQuery;

  const SearchedProductsPage({
    Key? key,
    required this.searchQuery,
  }) : super(key: key);

  @override
  State<SearchedProductsPage> createState() => _SearchedProductsPageState();
}

class _SearchedProductsPageState extends State<SearchedProductsPage> {
  var searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchSearchedProduct(context);
    });
  }

  fetchSearchedProduct(BuildContext context) async {
    var token =
        (context.read<UserBloc>().state as UserAuthenticatedState).user.token;

    context.read<CustomerProductsCubit>().displaySearchedProducts(
          name: widget.searchQuery,
          token: token,
        );
  }

  void navigateToSearchScreen(String query) {
    Navigator.pushNamed(
      context,
      SearchedProductsPage.routeName,
      arguments: query,
    );
  }

  var products = <Product>[];
  var selectedFilter = 0;

  void _showMenu(BuildContext context, Offset position) {
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
          position.dx, position.dy, position.dx, position.dy),
      items: [
        PopupMenuItem<int>(
          value: 0,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (selectedFilter == 0)
                const Icon(
                  Icons.check,
                  color: Constants.backgroundColor,
                  size: 20,
                ),
              const SizedBox(
                width: 10,
              ),
              Text(
                'Relevance',
                style: GoogleFonts.leagueSpartan(
                  fontSize: 14,
                  color: Constants.backgroundColor,
                  fontWeight: FontWeight.normal,
                  letterSpacing: 0.025,
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem<int>(
          value: 1,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (selectedFilter == 1)
                const Icon(
                  Icons.check,
                  color: Constants.backgroundColor,
                  size: 20,
                ),
              const SizedBox(
                width: 10,
              ),
              Text(
                'Lowest',
                style: GoogleFonts.leagueSpartan(
                  fontSize: 14,
                  color: Constants.backgroundColor,
                  fontWeight: FontWeight.normal,
                  letterSpacing: 0.025,
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem<int>(
          value: 2,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (selectedFilter == 2)
                const Icon(
                  Icons.check,
                  color: Constants.backgroundColor,
                  size: 20,
                ),
              const SizedBox(
                width: 10,
              ),
              Text(
                'Highest',
                style: GoogleFonts.leagueSpartan(
                  fontSize: 14,
                  color: Constants.backgroundColor,
                  fontWeight: FontWeight.normal,
                  letterSpacing: 0.025,
                ),
              ),
            ],
          ),
        ),
      ],
      elevation: 4.0,
    ).then((value) {
      if (value != null) {
        setState(() {
          selectedFilter = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Constants.backgroundColor,
      body: BlocBuilder<CustomerProductsCubit, CustomerProductsState>(
          builder: (context, state) {
        switch (state.runtimeType) {
          case FetchingProductsBySearch:
            return Constants.loading;

          case ProductsFetchedBySearch:
            products = (state as ProductsFetchedBySearch).products;

            switch (selectedFilter) {
              case 0:
                sortByRelevance(products);
                break;
              case 1:
                sortByPriceLowestFirst(products);
                break;
              case 2:
                sortByPriceHighestFirst(products);
                break;
              default:
            }

            return Column(
              children: [
                const SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(
                      width: 70,
                    ),
                    Text(
                      widget.searchQuery.trim().length > 2
                          ? widget.searchQuery.replaceRange(
                              0, 1, widget.searchQuery[0].toUpperCase())
                          : 'All Products',
                      style: GoogleFonts.leagueSpartan(
                        fontSize: 24,
                        color: Constants.selectedColor,
                        fontWeight: FontWeight.normal,
                        letterSpacing: 0.025,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        double screenWidth = MediaQuery.of(context).size.width;
                        double screenHeight =
                            MediaQuery.of(context).size.height;

                        _showMenu(
                          context,
                          Offset(
                            screenWidth * 0.68,
                            screenHeight * 0.035,
                          ),
                        );
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        margin: const EdgeInsets.only(right: 30),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Constants.backgroundColor,
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(
                            color: Colors.grey.shade200,
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.sort_rounded,
                            color: Constants.selectedColor,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  width: double.infinity,
                  height: 2.0,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 20),
                ),
                Container(
                  padding: const EdgeInsets.all(6),
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey.shade100,
                  ),
                  margin: const EdgeInsets.only(
                      left: 30, right: 30, top: 10, bottom: 20),
                  child: Center(
                    child: TextFormField(
                      controller: searchController,
                      onFieldSubmitted: (val) {
                        if (val.isNotEmpty) {
                          Navigator.of(context).pushReplacementNamed(
                            SearchedProductsPage.routeName,
                            arguments: val,
                          );
                        }
                      },
                      cursorColor: Constants.selectedColor,
                      decoration: InputDecoration(
                        suffixIcon: InkWell(
                          onTap: () {
                            if (searchController.text.isNotEmpty) {
                              Navigator.of(context).pushReplacementNamed(
                                SearchedProductsPage.routeName,
                                arguments: searchController.text,
                              );
                            }
                          },
                          child: const Padding(
                            padding: EdgeInsets.only(left: 6),
                            child: Icon(
                              LineIcons.search,
                              color: Colors.black,
                              size: 23,
                            ),
                          ),
                        ),
                        contentPadding: const EdgeInsets.only(
                          left: 10,
                          right: 10,
                          top: 5,
                        ),
                        border: InputBorder.none,
                        hintText: 'Search More',
                        hintStyle: GoogleFonts.leagueSpartan(
                          fontSize: 16,
                          color: Colors.grey.shade300,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.0,
                  ),
                  child: AddressPanel(),
                ),
                Expanded(
                  child: widget.searchQuery.trim().length <= 2
                      ? Container(
                          margin: const EdgeInsets.only(top: 20),
                          child: PageView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: (products.length / 2).ceil(),
                            itemBuilder: (context, pageIndex) {
                              int firstIndex = pageIndex * 2;
                              int secondIndex = firstIndex + 1;

                              return Column(
                                children: [
                                  if (products.length > firstIndex)
                                    Expanded(
                                      child: SearchedProductAll(
                                        product: products[firstIndex],
                                        isReversed: false,
                                      ),
                                    ),
                                  if (products.length > secondIndex)
                                    Expanded(
                                      child: SearchedProductAll(
                                        product: products[secondIndex],
                                        isReversed: true,
                                      ),
                                    ),
                                ],
                              );
                            },
                          ),
                        )
                      : Stack(
                          children: [
                            Transform.translate(
                              offset: const Offset(5, 5),
                              child: Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade400,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: Constants.selectedColor,
                                      width: 2.5,
                                    ),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                  ),
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 20,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Constants.selectedColor,
                                  width: 2.5,
                                ),
                                color: Constants.backgroundColor,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              margin: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 20,
                              ),
                              child: ListView.builder(
                                itemCount: products.length,
                                itemBuilder: (context, index) {
                                  return SearchedProductWithQuery(
                                    product: products[index],
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                ),
              ],
            );

          case ErrorFetchingBySearch:
            var errorMessage = (state as ErrorFetchingBySearch).errorMessage;

            return Center(
              child: Text(
                errorMessage,
                style: GoogleFonts.leagueSpartan(),
              ),
            );
          default:
            return Center(
              child: Text(
                'Invalid state, please try again!',
                style: GoogleFonts.leagueSpartan(),
              ),
            );
        }
      }),
    );
  }

  // Method to sort products by price in ascending order (lowest first)
  List<Product> sortByPriceLowestFirst(List<Product> products) {
    products.sort((a, b) => a.price.compareTo(b.price));

    return products;
  }

// Method to sort products by price in descending order (highest first)
  List<Product> sortByPriceHighestFirst(List<Product> products) {
    products.sort((a, b) => b.price.compareTo(a.price));

    return products;
  }

  List<Product> sortByRelevance(List<Product> products) {
    products.sort((a, b) => b.avgRating.compareTo(a.avgRating));

    return products;
  }
}
