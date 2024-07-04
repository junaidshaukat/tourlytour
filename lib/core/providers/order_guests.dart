import 'package:flutter/material.dart';
import '/core/app_export.dart';

class OrderGuestsProvider with ChangeNotifier {
  final BuildContext context;
  final supabase = Supabase.instance.client;
  Props props = Props(data: [], initialData: []);

  late ConnectivityProvider connectivity;

  OrderGuestsProvider(this.context) {
    connectivity = context.read<ConnectivityProvider>();
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

  Future<void> onRefresh(num? orderId) async {}

  Future<void> findById(num? orderId) async {
    try {
      props.setProcessing();
      notifyListeners();
      if (!connectivity.isConnected) {
        throw NoInternetException();
      }

      var response =
          await supabase.from('Guests').select().eq('OrderId', '$orderId');

      if (response.isNotEmpty) {
        List<OrderGuests> list = [];
        for (var data in response) {
          list.add(OrderGuests.fromJson(data));
        }
        props.setSuccess(currentData: list);
        notifyListeners();
      } else {
        props.setSuccess(currentData: []);
        notifyListeners();
      }
    } on NoInternetException catch (error) {
      console.internet(error, trace);
      props.setError(currentError: error.toString());
      notifyListeners();
    } on CustomException catch (error) {
      console.custom(error, trace);
      props.setError(currentError: error.toString());
      notifyListeners();
    } on AuthException catch (error) {
      console.authentication(error, trace);
      props.setError(currentError: error.message.toString());
      notifyListeners();
    } catch (error) {
      console.error(error, trace);
      props.setError(currentError: "something_went_wrong".tr);
      notifyListeners();
    }
  }
}
