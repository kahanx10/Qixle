// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:amazon_clone/common/logic/cubits/ui_feedback_cubit.dart';
import 'package:amazon_clone/components/authentication/data/services/auth_token_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:amazon_clone/components/authentication/data/models/user_model.dart';
import 'package:amazon_clone/components/authentication/data/services/auth_service.dart';

// events
abstract class UserEvent {}

class FetchUserData extends UserEvent {}

class SignUpUser extends UserEvent {
  String name;
  String userName;
  String password;

  SignUpUser({
    required this.name,
    required this.userName,
    required this.password,
  });
}

class SignInUser extends UserEvent {
  String userName;
  String password;

  SignInUser({
    required this.userName,
    required this.password,
  });
}

class SignOutUser extends UserEvent {}

// bloc
class AuthBloc extends Bloc<UserEvent, UserState> {
  final AuthService _authService;
  final UiFeedbackCubit _uiFeedbackCubit;

  AuthBloc({
    required AuthService authService,
    required uiFeedbackCubit,
  })  : _authService = authService,
        _uiFeedbackCubit = uiFeedbackCubit,
        super(UserInitialState()) {
    on<FetchUserData>(_onFetchUserData);
    on<SignUpUser>(_onSignUpUser);
    on<SignInUser>(_onSignInUser);
    on<SignOutUser>(_onSignOutUser);
  }

  // handlers
  Future<void> _onFetchUserData(
      FetchUserData event, Emitter<UserState> emit) async {
    emit(UserLoadingState());

    try {
      var user = await _authService.verifyUserToken();

      if (user == null) {
        emit(UserUnauthenticatedState());
        return;
      }

      emit(UserAuthenticatedState(user: user));
    } catch (e) {
      _uiFeedbackCubit.showSnackbar(e.toString());

      emit(UserUnauthenticatedState());
    }
  }

  Future<void> _onSignUpUser(SignUpUser event, Emitter<UserState> emit) async {
    emit(UserUnauthenticatedState());
    _uiFeedbackCubit.showLoadingOverlay();
    try {
      print('entered handling _onSignUpUser in auth_bloc.dart');

      var res = await _authService.userSignUpAuthentication(
        name: event.name,
        username: event.userName,
        password: event.password,
      );

      if (res == null) {
        throw Exception('Some error occurred, please try again!');
      }

      switch (res.statusCode) {
        case 200:
          var user = User.fromJson(res.body);

          await AuthTokenService.setToken(user.token);

          emit(
            UserAuthenticatedState(
              user: user,
            ),
          );

          return;
        case 400:
          _uiFeedbackCubit.showSnackbar(
            jsonDecode(res.body)['msg'] as String,
          );

          return;
        case 500:
          _uiFeedbackCubit.showSnackbar(
            jsonDecode(res.body)['error'] as String,
          );
      }
    } catch (e) {
      print(
        '---> Error in auth_bloc.dart:\n$e <---',
      );
      _uiFeedbackCubit.showSnackbar(e.toString());
      return;
    } finally {
      print('exited handling _onSignUpUser in auth_bloc.dart');
      _uiFeedbackCubit.popLoadingOverlay();
    }
  }

  Future<void> _onSignInUser(SignInUser event, Emitter<UserState> emit) async {
    emit(UserUnauthenticatedState());
    _uiFeedbackCubit.showLoadingOverlay();

    try {
      print('entered handling _onSignInUser in auth_bloc.dart');

      var res = await _authService.userSignInAuthentication(
        username: event.userName,
        password: event.password,
      );

      if (res == null) {
        throw Exception('Some error occurred, please try again!');
      }

      switch (res.statusCode) {
        case 200:
          var user = User.fromJson(res.body);

          await AuthTokenService.setToken(user.token);

          emit(
            UserAuthenticatedState(
              user: user,
            ),
          );
        case 400 || 401:
          _uiFeedbackCubit.showSnackbar(
            jsonDecode(res.body)['msg'] as String,
          );

          return;
        case 500:
          _uiFeedbackCubit.showSnackbar(
            jsonDecode(res.body)['error'] as String,
          );
      }
    } catch (e) {
      print(
        '---> Error in auth_bloc.dart:\n$e <---',
      );

      _uiFeedbackCubit.showSnackbar(e.toString());
    } finally {
      print('exited handling _onSignInUser in auth_bloc.dart');
      _uiFeedbackCubit.popLoadingOverlay();
    }
  }

  Future<void> _onSignOutUser(
      SignOutUser event, Emitter<UserState> emit) async {
    _uiFeedbackCubit.showLoadingOverlay();

    try {
      await AuthTokenService.clearToken();

      emit(UserUnauthenticatedState());
    } catch (e) {
      _uiFeedbackCubit.showSnackbar(e.toString());
    } finally {
      _uiFeedbackCubit.popLoadingOverlay();
    }
  }
}

// states
abstract class UserState {}

class UserInitialState extends UserState {}

class UserLoadingState extends UserState {}

class UserAuthenticatedState extends UserState {
  User user;

  UserAuthenticatedState({required this.user});
}

class UserUnauthenticatedState extends UserState {}

// class UserErrorState extends UserState {
//   final String errorMessage;

//   UserErrorState({required this.errorMessage});
// }
