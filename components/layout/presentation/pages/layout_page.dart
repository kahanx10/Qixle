import 'package:amazon_clone/common/data/services/message_service.dart';
import 'package:amazon_clone/common/logic/cubits/connectivity_cubit.dart';
import 'package:amazon_clone/common/logic/cubits/ui_feedback_cubit.dart';
import 'package:amazon_clone/common/presentation/pages/message_page.dart';
import 'package:amazon_clone/common/presentation/pages/loading_page.dart';
import 'package:amazon_clone/common/presentation/pages/no_internet_page.dart';
import 'package:amazon_clone/common/presentation/pages/splash_screen.dart';
import 'package:amazon_clone/common/presentation/widgets/loading_overlay.dart';
import 'package:amazon_clone/components/bottom_bars/admin_bottom_bar.dart';
import 'package:amazon_clone/components/bottom_bars/customer_bottom_bar_page.dart';
import 'package:amazon_clone/components/authentication/logic/blocs/auth_bloc.dart';
import 'package:amazon_clone/components/authentication/presentation/pages/auth_page.dart';

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
    return BlocBuilder<ConnectivityCubit, ConnectivityStatus>(
      builder: ((context, state) {
        if (state.runtimeType == ConnectivityNone) {
          return const NoInternetPage();
        }

        if (state.runtimeType == ConnectivityLoading) {
          return const LoadingOverlay();
        }

        return BlocListener<UiFeedbackCubit, UiFeedbackState>(
          listener: (context, uiFeedbackState) {
            switch (uiFeedbackState.runtimeType) {
              case ShowLoadingOverlayState:
                MessageService.showLoadingOverlay(context);
                break;

              case HideLoadingOverlayState:
                MessageService.popLoadingOverlay(context);
                break;

              case ShowSnackbarState:
                MessageService.showSnackBar(
                  context,
                  message: (uiFeedbackState as ShowSnackbarState).message,
                );
                break;

              default:
            }
          },
          child: BlocBuilder<UserBloc, UserState>(
            builder: (context, userState) {
              switch (userState.runtimeType) {
                case UserInitialState:
                  Future.delayed(
                    const Duration(seconds: 5),
                  ).then(
                    (value) => BlocProvider.of<UserBloc>(context).add(
                      FetchUserData(),
                    ),
                  );
                  return const SplashScreen();

                case UserLoadingState:
                  return const LoadingPage();

                case UserAuthenticatedState:
                  (userState as UserAuthenticatedState);
                  var userType = userState.user.type;

                  print('${userState.user.cart}\n from layout page');
                  //  otherwise it's gonna be 'customer'
                  return userType == 'admin'
                      ? const AdminBottomBar()
                      : const CustomerBottomBarPage();

                case UserUnauthenticatedState:
                  return const AuthPage();
                default:
                  return const MessagePage(message: 'Invalid Page');
              }
            },
          ),
        );
        // return const Scaffold(body: Center(child: Text('Internet Page')));
      }),
    );
  }
}
