import 'package:amazon_clone/common/data/constants.dart';
import 'package:amazon_clone/components/authentication/logic/blocs/auth_bloc.dart';
import 'package:amazon_clone/components/customer_home/logic/cubits/customer_products_cubit.dart';
import 'package:amazon_clone/components/customer_home/presentation/pages/product_details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategorizedProductsPage extends StatefulWidget {
  static const String routeName = '/category_deals_route';

  final String category;

  const CategorizedProductsPage({
    Key? key,
    required this.category,
  }) : super(key: key);

  @override
  State<CategorizedProductsPage> createState() =>
      _CategorizedProductsPageState();
}

class _CategorizedProductsPageState extends State<CategorizedProductsPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchCategorizedProducts(context);
    });
  }

  fetchCategorizedProducts(BuildContext context) {
    final cubit = context.read<CustomerProductsCubit>();
    final authBloc = context.read<AuthBloc>().state as UserAuthenticatedState;

    cubit.displayCategorizedProducts(
      category: widget.category,
      token: authBloc.user.token,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: Constants.appBarGradient,
            ),
          ),
          title: Text(
            widget.category,
            style: const TextStyle(
              color: Colors.black,
            ),
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
              var productList = (state as ProductsFetched).products;

              return productList.isEmpty
                  ? const Center(
                      child: Text(
                        'No products in this category.\nBut keep exploring!',
                        textAlign: TextAlign.center,
                      ),
                    )
                  : Column(
                      children: [
                        SizedBox(
                          height: 170,
                          child: GridView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.only(left: 15),
                            itemCount: productList.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 1,
                              childAspectRatio: 1.4,
                              mainAxisSpacing: 10,
                            ),
                            itemBuilder: (context, index) {
                              final product = productList[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    ProductDetailsPage.routeName,
                                    arguments: product,
                                  );
                                },
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 130,
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.black12,
                                            width: 0.5,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Image.network(
                                            product.images[0],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.topLeft,
                                      padding: const EdgeInsets.only(
                                        left: 0,
                                        top: 5,
                                        right: 15,
                                      ),
                                      child: Text(
                                        product.name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
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
        },
      ),
    );
  }
}
