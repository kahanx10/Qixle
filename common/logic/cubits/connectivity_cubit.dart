import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

abstract class ConnectivityStatus {}

class ConnectivityWifi extends ConnectivityStatus {}

class ConnectivityMobileData extends ConnectivityStatus {}

class ConnectivityNone extends ConnectivityStatus {}

class ConnectivityLoading extends ConnectivityStatus {}

class ConnectivityCubit extends Cubit<ConnectivityStatus> {
  final Connectivity _connectivity;
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  ConnectivityCubit(this._connectivity) : super(ConnectivityLoading()) {
    _startConnectivityListener();
    _getInitialConnectivityStatus();
  }

  void _getInitialConnectivityStatus() async {
    final result = await _connectivity.checkConnectivity();
    switch (result) {
      case ConnectivityResult.wifi:
        emit(ConnectivityWifi());
        break;
      case ConnectivityResult.mobile:
        emit(ConnectivityMobileData());
        break;
      case ConnectivityResult.none:
        emit(ConnectivityNone());
        break;
      default:
    }
  }

  void _startConnectivityListener() async {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      (result) {
        print(result);
        switch (result) {
          case ConnectivityResult.wifi:
            emit(ConnectivityWifi());
            break;
          case ConnectivityResult.mobile:
            emit(ConnectivityMobileData());
            break;
          case ConnectivityResult.none:
            emit(ConnectivityNone());
            break;
          default:
        }
      },
      onError: (error) {
        print("Connectivity Error: $error");
      },
    );
  }

  @override
  Future<void> close() {
    _connectivitySubscription.cancel();
    return super.close();
  }
}
