import 'package:amazon_clone/common/data/services/message_service.dart';
import 'package:amazon_clone/common/logic/cubits/ui_feedback_cubit.dart';
import 'package:amazon_clone/common/presentation/pages/error_page.dart';
import 'package:amazon_clone/common/presentation/pages/loading_page.dart';
import 'package:amazon_clone/common/presentation/pages/splash_screen.dart';
import 'package:amazon_clone/components/authentication/logic/blocs/auth_bloc.dart';
import 'package:amazon_clone/components/authentication/presentation/pages/auth_page.dart';
import 'package:amazon_clone/components/home/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LayoutPage extends StatefulWidget {
  const LayoutPage({super.key});

  @override
  State<LayoutPage> createState() => _LayoutPageState();
}

class _LayoutPageState extends State<LayoutPage> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<UiFeedbackCubit, UiFeedbackState>(
      listener: (context, state) {
        switch (state.runtimeType) {
          case ShowLoadingOverlayState:
            MessageService.showLoadingOverlay(context);
            break;
          case HideLoadingOverlayState:
            MessageService.popLoadingOverlay(context);
          case ShowSnackbarState:
            MessageService.showSnackBar(
              context,
              message: (state as ShowSnackbarState).message,
            );

            break;
          default:
        }
      },
      child: BlocBuilder<AuthBloc, UserState>(
        builder: (context, state) {
          switch (state.runtimeType) {
            case UserInitialState:
              Future.delayed(
                const Duration(seconds: 5),
              ).then(
                (value) => BlocProvider.of<AuthBloc>(context).add(
                  FetchUserData(),
                ),
              );
              return const SplashScreen();

            case UserLoadingState:
              return const LoadingPage();

            case UserAuthenticatedState:
              return const HomePage();

            case UserUnauthenticatedState:
              return const AuthPage();
            default:
              return const ErrorPage(message: 'Invalid Page');
          }
        },
      ),
    );
  }
}
