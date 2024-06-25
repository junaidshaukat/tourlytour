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
        props.clear([]);
        props.setSuccess(currentData: list);
        notifyListeners();
      } else {
        props.clear([]);
        props.setSuccess(currentData: []);
        notifyListeners();
      }
    } on NoInternetException catch (error) {
      console.log(error, 'OrderGuestsProvider::findById::NoInternetException');
      props.setError(currentError: error.toString());
      notifyListeners();
    } on CustomException catch (error) {
      console.log(error, 'OrderGuestsProvider::findById::CustomException');
      props.setError(currentError: error.toString());
      notifyListeners();
    } on AuthException catch (error) {
      console.log(error, 'OrderGuestsProvider::findById::AuthException');
      props.setError(currentError: error.message.toString());
      notifyListeners();
    } catch (error) {
      console.log(error, 'OrderGuestsProvider::findById');
      props.setError(currentError: "something_went_wrong".tr);
      notifyListeners();
    }
  }
}
