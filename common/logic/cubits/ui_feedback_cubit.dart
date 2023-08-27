// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';

// States
abstract class UiFeedbackState {}

class IdleState extends UiFeedbackState {}

class ShowLoadingOverlayState extends UiFeedbackState {}

class HideLoadingOverlayState extends UiFeedbackState {}

class ShowSnackbarState extends UiFeedbackState {
  final String message;

  ShowSnackbarState({
    required this.message,
  });
}

// Cubit
class UiFeedbackCubit extends Cubit<UiFeedbackState> {
  UiFeedbackCubit() : super(IdleState());

  // Methods
  void showLoadingOverlay() {
    emit(ShowLoadingOverlayState());
  }

  void popLoadingOverlay() {
    emit(HideLoadingOverlayState());
  }

  void showSnackbar(String message) {
    emit(
      ShowSnackbarState(message: message),
    );
  }
}
