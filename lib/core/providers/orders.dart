import 'package:flutter/material.dart';
import '/core/app_export.dart';

class OrdersProvider with ChangeNotifier {
  final BuildContext context;
  final supabase = Supabase.instance.client;
  Props props = Props(data: [], initialData: []);
  Props propsOrder = Props(data: null, initialData: null);

  late ConnectivityProvider connectivity;

  OrdersProvider(this.context) {
    connectivity = context.read<ConnectivityProvider>();
  }

  Future<void> onRefresh({
    num? orderId,
    String? orderNumber,
    String fun = 'findById',
  }) async {
    if (fun == 'findById') {
      await findById(orderId);
    }
    if (fun == 'findByOrderNumber') {
      await findByOrderNumber(orderNumber!);
    }
  }

  Future<void> findById(num? orderId) async {
    try {
      props.setProcessing();
      notifyListeners();
      if (!connectivity.isConnected) {
        throw NoInternetException();
      }

      var response = await supabase.rpc('blackout_dates', params: {
        'order_number': orderId,
      });

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
      console.log(error, 'OrdersProvider::findById::NoInternetException');
      props.setError(currentError: error.toString());
      notifyListeners();
    } on CustomException catch (error) {
      console.log(error, 'OrdersProvider::findById::CustomException');
      props.setError(currentError: error.toString());
      notifyListeners();
    } on AuthException catch (error) {
      console.log(error, 'OrdersProvider::findById::AuthException');
      props.setError(currentError: error.message.toString());
      notifyListeners();
    } catch (error) {
      console.log(error, 'OrdersProvider::findById');
      props.setError(currentError: "something_went_wrong".tr);
      notifyListeners();
    }
  }

  Future<void> findByOrderNumber(String orderNumber) async {
    try {
      propsOrder.setProcessing();
      notifyListeners();
      if (!connectivity.isConnected) {
        throw NoInternetException();
      }

      var response = await supabase.rpc('order_details', params: {
        'order_number': orderNumber,
      });

      if (response != null) {
        OrdersDetails orders = OrdersDetails.fromJson(response);
        propsOrder.clear(null);
        propsOrder.setSuccess(currentData: orders);
        notifyListeners();
      } else {
        propsOrder.clear(null);
        propsOrder.setSuccess(currentData: null);
        notifyListeners();
      }
    } on NoInternetException catch (error) {
      console.log(
          error, 'OrdersProvider::findByOrderNumber::NoInternetException');
      propsOrder.setError(currentError: error.toString());
      notifyListeners();
    } on CustomException catch (error) {
      console.log(error, 'OrdersProvider::findByOrderNumber::CustomException');
      propsOrder.setError(currentError: error.toString());
      notifyListeners();
    } on AuthException catch (error) {
      console.log(error, 'OrdersProvider::findByOrderNumber::AuthException');
      propsOrder.setError(currentError: error.message.toString());
      notifyListeners();
    } catch (error) {
      console.log(error, 'OrdersProvider::findByOrderNumber');
      propsOrder.setError(currentError: "something_went_wrong".tr);
      notifyListeners();
    }
  }
}
