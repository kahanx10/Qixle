import 'package:amazon_clone/common/logic/cubits/ui_feedback_cubit.dart';
import 'package:amazon_clone/components/authentication/data/services/auth_service.dart';
import 'package:amazon_clone/components/authentication/logic/blocs/auth_bloc.dart';
import 'package:amazon_clone/components/layout/presentation/pages/layout_page.dart';
import 'package:amazon_clone/components/products/logic/blocs/products_bloc.dart';
import 'package:amazon_clone/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const Qixle());
}

class Qixle extends StatefulWidget {
  const Qixle({super.key});

  @override
  State<Qixle> createState() => _QixleState();
}

class _QixleState extends State<Qixle> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ProductBloc()),
        BlocProvider(
          create: (context) => UiFeedbackCubit(),
        ),
        BlocProvider(
          create: (context) => AuthBloc(
            authService: AuthService(client: http.Client()),
            uiFeedbackCubit: context.read<UiFeedbackCubit>(),
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        onGenerateRoute: (settings) => AppRouter().generateRoute(settings),
        title: 'Flutter Demo',
        theme: ThemeData(
          useMaterial3: true,
        ),
        home: const LayoutPage(),
      ),
    );
  }
}
