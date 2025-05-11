import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkUtil {
  NetworkUtil._internal() {
    _connectivity = Connectivity();
  }
  static final NetworkUtil _instance = NetworkUtil._internal();
  factory NetworkUtil() => _instance;

  late final Connectivity _connectivity;

  Stream<bool> get onConnectivityChanged =>
      _connectivity.onConnectivityChanged.map((result) {
        return result != ConnectivityResult.none;
      });

  Future<bool> checkInitialConnection() async {
    final result = await _connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }
}
