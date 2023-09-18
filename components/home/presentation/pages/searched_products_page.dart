import 'package:amazon_clone/common/data/constants.dart';
import 'package:amazon_clone/components/authentication/logic/blocs/auth_bloc.dart';
import 'package:amazon_clone/components/home/logic/cubits/customer_products_cubit.dart';
import 'package:amazon_clone/components/home/presentation/widgets/address_panel.dart';
import 'package:amazon_clone/components/home/presentation/widgets/searched_product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.backgroundColor,
      body: BlocBuilder<CustomerProductsCubit, CustomerProductsState>(
          builder: (context, state) {
        switch (state.runtimeType) {
          case FetchingProducts:
            return Center(
              child: CircularProgressIndicator(
                color: Constants.selectedColor,
              ),
            );

          case ProductsFetched:
            var products = (state as ProductsFetched).products;

            return products.isNotEmpty
                ? Column(
                    children: [
                      const SizedBox(
                        height: 40,
                      ),
                      Text(
                        widget.searchQuery.trim().length > 2
                            ? widget.searchQuery
                            : 'All Products',
                        style: GoogleFonts.leagueSpartan(
                          fontSize: 24,
                          color: Constants.selectedColor,
                          fontWeight: FontWeight.normal,
                          letterSpacing: 0.025,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(6),
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey.shade100,
                        ),
                        margin: const EdgeInsets.only(
                            left: 30, right: 30, top: 15, bottom: 20),
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
                                    Navigator.of(context).pushNamed(
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
                                color: Colors.grey.shade400,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: AddressPanel(),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              child: SearchedProduct(
                                product: products[index],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  )
                : const Center(
                    child: Text('No products found!'),
                  );

          case ErrorFetching:
            var errorMessage = (state as ErrorFetching).errorMessage;
            return Center(
              child: Text(errorMessage),
            );
          default:
            return const Center(
              child: Text(
                'Invalid state, please try again!',
              ),
            );
        }
      }),
    );
  }
}
