import 'package:flutter/material.dart';
import '/core/app_export.dart';

class ProductsProvider with ChangeNotifier {
  final BuildContext context;
  final supabase = Supabase.instance.client;
  late ConnectivityProvider connectivity;

  Props props = Props(data: [], initialData: []);
  Props propsSingle = Props(data: [], initialData: []);

  ProductsProvider(this.context) {
    connectivity = context.read<ConnectivityProvider>();
  }

  Future<void> onReady() async {
    try {
      props.setLoading();
      notifyListeners();

      if (!connectivity.isConnected) {
        throw NoInternetException();
      }

      final response = await supabase.from('Products').select();
      if (response.isEmpty) {
        props.setSuccess(currentData: []);
        notifyListeners();
      } else {
        List<Products> list = [];
        for (var data in response) {
          list.add(Products.fromJson(data));
        }
        props.setSuccess(currentData: list);
        notifyListeners();
      }
    } on NoInternetException catch (error) {
      props.setError(currentError: error.toString());
      notifyListeners();
    } on CustomException catch (error) {
      props.setError(currentError: error.toString());
      notifyListeners();
    } on AuthException catch (error) {
      props.setError(currentError: error.message.toString());
      notifyListeners();
    } catch (error) {
      console.log(error, 'Error::FavouritesProvider::onReady');
      props.setError(currentError: "something_went_wrong".tr);
      notifyListeners();
    }
  }

  Future<void> onRefresh() async {
    await onReady();
  }

  Future<void> findById(num id) async {
    try {
      propsSingle.setLoading();
      notifyListeners();

      if (!connectivity.isConnected) {
        throw NoInternetException();
      }

      final response = await supabase
          .from('Products')
          .select()
          .eq('Id', '$id')
          .limit(1)
          .maybeSingle();
      if (response == null) {
        propsSingle.setSuccess(currentData: []);
        notifyListeners();
      } else {
        propsSingle.setSuccess(currentData: Products.fromJson(response));
        notifyListeners();
      }
    } on NoInternetException catch (error) {
      propsSingle.setError(currentError: error.toString());
      notifyListeners();
    } on CustomException catch (error) {
      propsSingle.setError(currentError: error.toString());
      notifyListeners();
    } on AuthException catch (error) {
      propsSingle.setError(currentError: error.message.toString());
      notifyListeners();
    } catch (error) {
      console.log(error, 'Error::FavouritesProvider::findById');
      propsSingle.setError(currentError: "something_went_wrong".tr);
      notifyListeners();
    }
  }
}
