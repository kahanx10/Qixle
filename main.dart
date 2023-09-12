import 'package:amazon_clone/common/data/constants.dart';
import 'package:amazon_clone/common/logic/cubits/connectivity_cubit.dart';
import 'package:amazon_clone/common/logic/cubits/ui_feedback_cubit.dart';
import 'package:amazon_clone/components/authentication/data/services/auth_service.dart';
import 'package:amazon_clone/components/authentication/logic/blocs/auth_bloc.dart';
import 'package:amazon_clone/components/home/logic/cubits/customer_products_cubit.dart';
import 'package:amazon_clone/components/home/logic/cubits/quantity_cubit.dart';
import 'package:amazon_clone/components/layout/presentation/pages/layout_page.dart';
import 'package:amazon_clone/components/admin/logic/blocs/products_bloc.dart';
import 'package:amazon_clone/router.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(const Qique());
  });
}

class Qique extends StatefulWidget {
  const Qique({super.key});

  @override
  State<Qique> createState() => _QiqueState();
}

class _QiqueState extends State<Qique> {
  final Connectivity _connectivity = Connectivity();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => QuantityCubit(),
        ),
        BlocProvider(create: (context) => CustomerProductsCubit()),
        BlocProvider(create: (context) => ProductBloc()),
        BlocProvider(create: (context) => UiFeedbackCubit()),
        BlocProvider(create: (context) => ConnectivityCubit(_connectivity)),
        BlocProvider(
          create: (context) => UserBloc(
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
          scrollbarTheme: ScrollbarThemeData(
            thickness: MaterialStateProperty.all<double>(5),
            radius: const Radius.circular(6),
            thumbColor: MaterialStateProperty.all<Color>(
              Constants.selectedColor,
            ), // Your color
            // You can also set other properties like thickness, radius, etc.
          ),
        ),
        home: const LayoutPage(),
      ),
    );
  }
}
