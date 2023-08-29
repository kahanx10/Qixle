// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:amazon_clone/components/products/data/models/product_model.dart';

class ProductsEvent {}

class FetchProductsEvent extends ProductsEvent {}

class DeleteProductsEvent extends ProductsEvent {}

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  ProductsBloc(super.initialState) {
    on<FetchProductsEvent>((event, emit) {});

    on<DeleteProductsEvent>((event, emit) {});
  }
}

class ProductsState {}

class ProductsLoadingState extends ProductsState {}

class ProductsObtainedState extends ProductsState {
  List<Product> products;

  ProductsObtainedState({
    required this.products,
  });
}

class ProductsFailedState extends ProductsState {
  String errorMessage;
  ProductsFailedState({
    required this.errorMessage,
  });
}
