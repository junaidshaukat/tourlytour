import 'package:flutter/material.dart';
import '/core/app_export.dart';

class ProductItinerariesProvider with ChangeNotifier {
  final BuildContext context;
  final supabase = Supabase.instance.client;

  late ConnectivityProvider connectivity;

  Props props = Props(data: [], initialData: []);
  Props propsConfirmation = Props(data: [], initialData: []);

  ProductItinerariesProvider(this.context) {
    connectivity = context.read<ConnectivityProvider>();
  }

  Future<void> onReady(num? productId) async {
    try {
      props.setLoading();
      notifyListeners();

      if (!connectivity.isConnected) {
        throw NoInternetException();
      }

      final response = await supabase
          .from('ProductItineraries')
          .select()
          .eq('ProductId', "$productId");

      if (response.isEmpty) {
        props.setSuccess(currentData: []);
        notifyListeners();
      } else {
        List<ProductItineraries> list = [];
        for (var data in response) {
          list.add(ProductItineraries.fromJson(data));
        }
        props.setSuccess(currentData: list);
        notifyListeners();
      }
    } on NoInternetException catch (error) {
      console.log(
          error, 'ProductItinerariesProvider::onReady::NoInternetException');
      props.setError(currentError: error.toString());
      notifyListeners();
    } on CustomException catch (error) {
      console.log(
          error, 'ProductItinerariesProvider::onReady::CustomException');
      props.setError(currentError: error.toString());
      notifyListeners();
    } on AuthException catch (error) {
      console.log(error, 'ProductItinerariesProvider::onReady::AuthException');
      props.setError(currentError: error.message.toString());
      notifyListeners();
    } catch (error) {
      console.log(error, 'ProductItinerariesProvider::onReady');
      props.setError(currentError: "something_went_wrong".tr);
      notifyListeners();
    }
  }

  Future<void> onRefresh(num? id, {String fun = 'onReady'}) async {
    if (fun == 'onReady') await onReady(id);
    if (fun == 'findById') await findById(id);
  }

  void clear({String fun = 'onReady'}) {
    if (fun == 'onReady') {
      props.clear([]);
      props.setLoading();
    }
    if (fun == 'findById') {
      propsConfirmation.clear([]);
      propsConfirmation.setLoading();
    }
  }

  Future<void> findById(num? productId) async {
    try {
      propsConfirmation.setLoading();
      notifyListeners();

      if (!connectivity.isConnected) {
        throw NoInternetException();
      }

      final response = await supabase
          .from('ProductItineraries')
          .select()
          .eq('ProductId', "$productId");

      if (response.isEmpty) {
        propsConfirmation.setSuccess(currentData: []);
        notifyListeners();
      } else {
        List<ProductItineraries> list = [];
        for (var data in response) {
          list.add(ProductItineraries.fromJson(data));
        }
        propsConfirmation.setSuccess(currentData: list);
        notifyListeners();
      }
    } on NoInternetException catch (error) {
      console.log(
          error, 'ProductItinerariesProvider::findById::NoInternetException');
      propsConfirmation.setError(currentError: error.toString());
      notifyListeners();
    } on CustomException catch (error) {
      console.log(
          error, 'ProductItinerariesProvider::findById::CustomException');
      propsConfirmation.setError(currentError: error.toString());
      notifyListeners();
    } on AuthException catch (error) {
      console.log(error, 'ProductItinerariesProvider::findById::AuthException');
      propsConfirmation.setError(currentError: error.message.toString());
      notifyListeners();
    } catch (error) {
      console.log(error, 'ProductItinerariesProvider::findById');
      propsConfirmation.setError(currentError: "something_went_wrong".tr);
      notifyListeners();
    }
  }
}
