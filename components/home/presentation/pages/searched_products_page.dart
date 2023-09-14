import 'package:amazon_clone/common/data/constants.dart';
import 'package:amazon_clone/components/authentication/logic/blocs/auth_bloc.dart';
import 'package:amazon_clone/components/home/logic/cubits/customer_products_cubit.dart';
import 'package:amazon_clone/components/home/presentation/widgets/address_panel.dart';
import 'package:amazon_clone/components/home/presentation/widgets/searched_product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          backgroundColor: Constants.selectedColor,
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
                      controller: searchController,
                      onFieldSubmitted: navigateToSearchScreen,
                      decoration: InputDecoration(
                        prefixIcon: InkWell(
                          onTap: () {
                            if (searchController.text.isNotEmpty) {
                              navigateToSearchScreen(searchController.text);
                            }
                          },
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
                      const AddressPanel(),
                      const SizedBox(height: 10),
                      Expanded(
                        child: ListView.builder(
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            return SearchedProduct(
                              product: products[index],
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
