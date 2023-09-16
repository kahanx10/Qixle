import 'package:amazon_clone/common/data/constants.dart';
import 'package:amazon_clone/common/data/services/message_service.dart';
import 'package:amazon_clone/common/logic/cubits/ui_feedback_cubit.dart';
import 'package:amazon_clone/common/presentation/widgets/single_product.dart';
import 'package:amazon_clone/components/admin/data/models/product_model.dart';
import 'package:amazon_clone/components/admin/logic/blocs/products_bloc.dart';
import 'package:amazon_clone/components/admin/presentation/pages/add_product_page.dart';
import 'package:amazon_clone/components/authentication/logic/blocs/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  var products = <Product>[];

  void fetchProducts() {
    BlocProvider.of<ProductBloc>(context).add(FetchProductsEvent());
  }

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductBloc, ProductState>(
      listener: (context, state) {
        switch (state.runtimeType) {
          case ProductsFetchedState:
            products = (state as ProductsFetchedState).products;

            setState(() {});
            break;

          case ProductAddedState:
            var product = (state as ProductAddedState).addedProduct;
            products.add(product);

            fetchProducts();

            MessageService.showSnackBar(
              context,
              message: '${product.name} added!',
            );

            setState(() {});
            break;

          case ProductToggledState:
            state as ProductToggledState;
            var toggledProduct = state.toggledProduct;

            MessageService.showSnackBar(
              context,
              message:
                  'Made ${toggledProduct.name} ${toggledProduct.isAvailable ? 'available' : 'unavailable'}',
            );

            fetchProducts();
            break;

          case ProductErrorState:
            var errorMessage = (state as ProductErrorState).errorMessage;

            MessageService.showSnackBar(context, message: errorMessage);
          default:
        }
      },
      child: Scaffold(
        backgroundColor: Constants.backgroundColor,
        appBar: AppBar(
          title: const Text('Qique'),
          actions: [
            const Text(
              'Admin',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            IconButton(
              onPressed: () async {
                BlocProvider.of<UiFeedbackCubit>(context).showLoadingOverlay();

                await Future.delayed(const Duration(seconds: 3));

                BlocProvider.of<UiFeedbackCubit>(context).popLoadingOverlay();

                BlocProvider.of<UserBloc>(context).add(SignOutUser());
              },
              icon: const Icon(Icons.logout_outlined),
            ),
            const SizedBox(
              width: 8,
            ),
          ],
        ),
        body: products.isEmpty
            ? const Center(
                child: Text('No Products To Display'),
              )
            : GridView.builder(
                itemCount: products.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemBuilder: (context, index) {
                  final product = products[index];

                  return Column(
                    children: [
                      SizedBox(
                        height: 140,
                        child: SingleProduct(
                          imageUrl: product.images[0],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: Text(
                              product.name,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                          Switch(
                            value: product.isAvailable,
                            onChanged: (value) {
                              BlocProvider.of<ProductBloc>(context).add(
                                ToggleProductEvent(
                                  productId: product.id!,
                                  isAvailable: value,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
        floatingActionButton: FloatingActionButton(
          tooltip: 'Add A Product',
          onPressed: () {
            Navigator.of(context).pushNamed(AddProductPage.routeName);
          },
          backgroundColor: Constants.selectedColor,
          child: const Icon(
            Icons.add,
            color: Constants.backgroundColor,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
