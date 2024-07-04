import 'package:flutter/material.dart';
import '/core/app_export.dart';

class ConnectivityProvider with ChangeNotifier {
  final BuildContext context;
  Connectivity connectivity = Connectivity();
  bool connected = false;

  ConnectivityProvider(this.context) {
    connectivity.onConnectivityChanged.listen(listen);
  }
  String get trace {
    final stackTrace = StackTrace.current;
    final frames = stackTrace.toString().split('\n');

    if (frames.length > 1) {
      final callerFrame = frames[1].trim();
      final regex = RegExp(r'#\d+\s+(\S+)\.(\S+)\s+\(.*\)');
      final match = regex.firstMatch(callerFrame);

      if (match != null) {
        final className = match.group(1);
        final methodName = match.group(2);
        return "$className::$methodName";
      } else {
        return "$runtimeType::unknown";
      }
    } else {
      return "$runtimeType::unknown";
    }
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
    } catch (error) {
      console.error(error, trace);
      throw NoInternetException();
    }
  }
}
