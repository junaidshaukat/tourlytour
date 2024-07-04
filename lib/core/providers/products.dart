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

  Future<void> onReady() async {
    try {
      props.setLoading();
      notifyListeners();

      if (!connectivity.isConnected) {
        throw NoInternetException();
      }

      final response = await supabase.rpc('products');
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
      console.internet(error, trace);
      propsSingle.setError(currentError: error.toString());
      notifyListeners();
    } on CustomException catch (error) {
      console.custom(error, trace);
      propsSingle.setError(currentError: error.toString());
      notifyListeners();
    } on AuthException catch (error) {
      console.authentication(error, trace);
      propsSingle.setError(currentError: error.message.toString());
      notifyListeners();
    } catch (error) {
      console.error(error, trace);
      propsSingle.setError(currentError: "something_went_wrong".tr);
      notifyListeners();
    }
  }
}
