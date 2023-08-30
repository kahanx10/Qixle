// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:amazon_clone/components/products/data/models/product_model.dart';
import 'package:amazon_clone/components/products/data/services/product_service.dart';

class ProductEvent {}

class FetchProductsEvent extends ProductEvent {}

class AddProductEvent extends ProductEvent {
  String productName;
  String description;
  int quantity;
  double price;
  List<String> images;
  String category;

  AddProductEvent({
    required this.productName,
    required this.description,
    required this.quantity,
    required this.price,
    required this.images,
    required this.category,
  });
}

class DeleteProductEvent extends ProductEvent {
  String productID;

  DeleteProductEvent({
    required this.productID,
  });
}

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc() : super(ProductsLoadingState()) {
    on<FetchProductsEvent>(_onFetchProductsEvent);

    on<AddProductEvent>(_onAddProductEvent);

    on<DeleteProductEvent>(_onDeleteProductEvent);
  }

  Future<void> _onFetchProductsEvent(
    FetchProductsEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductsLoadingState());

    var products = <Product>[];

    try {
      var res = await ProductService.fetchProducts();

      switch (res.statusCode) {
        case 200:
          var productMaps = jsonDecode(res.body) as List<dynamic>;

          for (var productMap in productMaps) {
            products.add(Product.fromMap(productMap));
          }
          break;
        case 401:
          emit(
            ProductErrorState(errorMessage: jsonDecode(res.body)['msg']),
          );
        case 500:
          emit(
            ProductErrorState(errorMessage: jsonDecode(res.body)['error']),
          );
        default:
          emit(
            ProductErrorState(
              errorMessage:
                  'Some unknown error occurred while trying to fetch products!',
            ),
          );
      }
    } catch (e) {
      emit(ProductErrorState(errorMessage: e.toString()));
    } finally {
      emit(ProductsFetchedState(products: products));
    }
  }

  Future<void> _onAddProductEvent(
    AddProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    try {
      var res = await ProductService.uploadProduct(event: event);

      if (res == null) {
        throw Exception('Couldn\'t add product, please try again!');
      }

      switch (res.statusCode) {
        case 200:
          emit(ProductAddedState(addedProduct: Product.fromJson(res.body)));
          break;
        case 401:
          emit(
            ProductErrorState(errorMessage: jsonDecode(res.body)['msg']),
          );
        case 500:
          emit(
            ProductErrorState(errorMessage: jsonDecode(res.body)['error']),
          );
        default:
          emit(
            ProductErrorState(
              errorMessage:
                  'Some unknown error occurred while trying to add the product!',
            ),
          );
      }
    } catch (e) {
      emit(ProductErrorState(errorMessage: e.toString()));
    }
  }

  Future<void> _onDeleteProductEvent(
    DeleteProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    try {
      var res = await ProductService.deleteProduct(event: event);

      if (res == null) {
        throw Exception('Couldn\'t delete the product, please try again!');
      }

      switch (res.statusCode) {
        case 200:
          emit(
            ProductDeletedState(
              deletedProduct: Product.fromJson(res.body),
            ),
          );
          break;
        case 401:
          emit(
            ProductErrorState(errorMessage: jsonDecode(res.body)['msg']),
          );
        case 500:
          emit(
            ProductErrorState(errorMessage: jsonDecode(res.body)['error']),
          );
        default:
          emit(
            ProductErrorState(
              errorMessage:
                  'Some unknown error occurred while trying to delete the product!',
            ),
          );
      }
    } catch (e) {
      emit(ProductErrorState(errorMessage: e.toString()));
    }
  }
}

class ProductState {}

class ProductsLoadingState extends ProductState {}

class ProductsFetchedState extends ProductState {
  List<Product> products;

  ProductsFetchedState({
    required this.products,
  });
}

class ProductAddedState extends ProductState {
  Product addedProduct;

  ProductAddedState({
    required this.addedProduct,
  });
}

class ProductDeletedState extends ProductState {
  Product deletedProduct;

  ProductDeletedState({
    required this.deletedProduct,
  });
}

class ProductErrorState extends ProductState {
  String errorMessage;
  ProductErrorState({
    required this.errorMessage,
  });
}
