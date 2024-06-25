import 'package:flutter/material.dart';
import '/core/app_export.dart';

class SearchProvider extends ChangeNotifier {
  final BuildContext context;
  final supabase = Supabase.instance.client;
  late ConnectivityProvider connectivity;

  Props props = Props(data: [], initialData: []);

  String key = '';
  DateTime date = DateTime.now();

  SearchProvider(this.context) {
    connectivity = context.read<ConnectivityProvider>();
    props.setSuccess();
    notifyListeners();
  }

  Future<void> onSearch() async {
    try {
      props.setProcessing();
      notifyListeners();
      if (!connectivity.isConnected) {
        throw NoInternetException();
      }

      var response = await supabase.rpc('search', params: {
        'k': key,
        'd': date.format('yyyy-MM-dd'),
      });

      if (response == null) {
        props.clear([]);
        props.setSuccess(currentData: []);
        notifyListeners();
      } else {
        List<Products> list = [];
        for (var data in response) {
          list.add(Products.fromJson(data));
        }
        props.clear([]);
        props.setSuccess(currentData: list);
        notifyListeners();
      }
    } on NoInternetException catch (error) {
      console.log(error, 'SearchProvider::onSearch::NoInternetException');
      props.setError(currentError: error.toString());
      notifyListeners();
    } on CustomException catch (error) {
      console.log(error, 'SearchProvider::onSearch::CustomException');
      props.setError(currentError: error.toString());
      notifyListeners();
    } on AuthException catch (error) {
      console.log(error, 'SearchProvider::onSearch::AuthException');
      props.setError(currentError: error.message.toString());
      notifyListeners();
    } catch (error) {
      console.log(error, 'SearchProvider::onSearch');
      props.setError(currentError: "something_went_wrong".tr);
      notifyListeners();
    }
  }

  Future<void> onRefresh() async {
    if (key.isNotEmpty) await onSearch();
  }

  Future<void> onTap() async {
    if (key.isNotEmpty) await onSearch();
  }

  Future<void> onDateChange(DateTime d) async {
    date = d;
    notifyListeners();
    if (key.isNotEmpty) await onSearch();
  }

  Future<void> onChanged(String s) async {
    key = s;
    notifyListeners();
    if (key.isNotEmpty) await onSearch();
  }
}
