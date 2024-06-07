import 'package:flutter/material.dart';
import '/core/app_export.dart';

class ConnectivityProvider with ChangeNotifier {
  final BuildContext context;
  Connectivity connectivity = Connectivity();
  bool connected = false;

  ConnectivityProvider(this.context) {
    connectivity.onConnectivityChanged.listen(listen);
  }

  void listen(List<ConnectivityResult> result) {
    if (result.contains(ConnectivityResult.mobile)) {
      connected = true;
      notifyListeners();
    } else if (result.contains(ConnectivityResult.wifi)) {
      connected = true;
      notifyListeners();
    } else if (result.contains(ConnectivityResult.ethernet)) {
      connected = true;
      notifyListeners();
    } else if (result.contains(ConnectivityResult.vpn)) {
      connected = true;
      notifyListeners();
    } else if (result.contains(ConnectivityResult.bluetooth)) {
      connected = true;
      notifyListeners();
    } else if (result.contains(ConnectivityResult.other)) {
      connected = true;
      notifyListeners();
    } else if (result.contains(ConnectivityResult.none)) {
      connected = false;
      notifyListeners();
    } else {
      connected = false;
      notifyListeners();
    }
  }

  bool get isConnected {
    try {
      if (connected) {
        return connected;
      } else {
        throw NoInternetException();
      }
    } catch (e) {
      throw NoInternetException();
    }
  }
}
