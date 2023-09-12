import 'package:flutter_bloc/flutter_bloc.dart';

class QuantityCubit extends Cubit<QuantityState> {
  QuantityCubit() : super(HasQuantity(0));

  void setQuantity(int quantity) {
    emit(HasQuantity(quantity));
  }
}

abstract class QuantityState {}

class HasQuantity extends QuantityState {
  final int quantity;

  HasQuantity(this.quantity);
}
