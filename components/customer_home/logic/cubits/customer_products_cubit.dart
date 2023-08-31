import 'dart:convert';

import 'package:amazon_clone/components/customer_home/data/services/customer_products_service.dart';
import 'package:bloc/bloc.dart';
import 'package:amazon_clone/components/admin_products/data/models/product_model.dart';

class CustomerProductsCubit extends Cubit<CustomerProductsState> {
  CustomerProductsCubit() : super(FetchingProducts());

  // Method to display categorized products
  void displayCategorizedProducts({
    required String category,
    required String token,
  }) async {
    emit(FetchingProducts());

    try {
      var res = await CustomerProductsService.fetchProductsByCategory(
        category: category,
        token: token,
      );

      if (res == null || res.statusCode != 200) {
        throw Exception('Couldn\'t fetch products, please try again!');
      }

      var products = <Product>[];

      var productMaps = jsonDecode(res.body);

      for (var productMap in productMaps) {
        products.add(Product.fromMap(productMap));
      }

      emit(ProductsFetched(products: products));
    } catch (e) {
      emit(ErrorFetching(errorMessage: e.toString()));
    }
  }

  // Method to display searched products
  void displaySearchedProducts({
    required String name,
    required String token,
  }) async {
    emit(FetchingProducts());

    try {
      var res = await CustomerProductsService.fetchProductsBySearch(
        name: name,
        token: token,
      );

      if (res == null || res.statusCode != 200) {
        throw Exception('Couldn\'t fetch products, please try again!');
      }

      var products = <Product>[];

      var productMaps = jsonDecode(res.body);

      for (var productMap in productMaps) {
        products.add(Product.fromMap(productMap));
      }

      emit(ProductsFetched(products: products));
    } catch (e) {
      emit(ErrorFetching(errorMessage: e.toString()));
    }
  }
}

abstract class CustomerProductsState {}

class FetchingProducts extends CustomerProductsState {}

class ProductsFetched extends CustomerProductsState {
  final List<Product> products;

  ProductsFetched({required this.products});
}

class ErrorFetching extends CustomerProductsState {
  final String errorMessage;

  ErrorFetching({required this.errorMessage});
}
