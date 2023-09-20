import 'dart:convert';

import 'package:amazon_clone/components/home/data/services/customer_products_service.dart';
import 'package:bloc/bloc.dart';
import 'package:amazon_clone/components/admin/data/models/product_model.dart';

class CustomerProductsCubit extends Cubit<CustomerProductsState> {
  CustomerProductsCubit() : super(NoProducts());
  // Method to display categorized products
  void displayCategorizedProducts({
    required String category,
    required String token,
  }) async {
    emit(FetchingProducts());
    await Future.delayed(const Duration(seconds: 2));
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

      print('from products cubit');
      print(products);

      if (products.isEmpty) {
        emit(NoProducts());
      } else {
        emit(ProductsFetched(products: products));
      }
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

      emit(ProductsFetchedBySearch(products: products));
    } catch (e) {
      emit(ErrorFetchingBySearch(errorMessage: e.toString()));
    }
  }
}

abstract class CustomerProductsState {}

class FetchingProducts extends CustomerProductsState {}

class NoProducts extends CustomerProductsState {}

class ProductsFetched extends CustomerProductsState {
  final List<Product> products;

  ProductsFetched({required this.products});
}

class ProductsFetchedBySearch extends CustomerProductsState {
  final List<Product> products;

  ProductsFetchedBySearch({required this.products});
}

class ErrorFetching extends CustomerProductsState {
  final String errorMessage;

  ErrorFetching({required this.errorMessage});
}

class ErrorFetchingBySearch extends CustomerProductsState {
  final String errorMessage;

  ErrorFetchingBySearch({required this.errorMessage});
}
