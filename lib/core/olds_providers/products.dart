import 'package:flutter/material.dart';
import '/core/app_export.dart';

class ProductsProvider with ChangeNotifier {
  final BuildContext context;

  late SupabaseService supabase;
  late AuthenticationProvider auth;
  late ConnectivityProvider connectivity;

  late num? productId;

  String key = '';
  DateTime date = DateTime.now();

  Props props = Props(data: [], initialData: []);
  Props propsSearch = Props(data: [], initialData: []);
  Props propsDiscover = Props(data: [], initialData: []);
  Props propsProductDetail = Props(data: {}, initialData: {});

  ProductsProvider(this.context) {
    auth = context.read<AuthenticationProvider>();
    connectivity = context.read<ConnectivityProvider>();
    supabase = context.read<SupabaseService>();
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

      final response = await supabase.rpc(
        'products',
        body: {'isFeatured': true},
      );

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
      props.setAuthException(currentError: error.message.toString());
      notifyListeners();
    } catch (error) {
      console.error(error, trace);
      props.setError(currentError: "something_went_wrong".tr);
      notifyListeners();
    }
  }

  Future<void> onDetail(num? productId) async {
    try {
      propsProductDetail.setLoading();
      notifyListeners();

      if (!connectivity.isConnected) {
        throw NoInternetException();
      }

      final response = await supabase.rpc(
        'product_details',
        body: {'productId': productId},
      );

      if (response.isEmpty) {
        propsProductDetail.setSuccess(currentData: {});
        notifyListeners();
      } else {
        propsProductDetail.setSuccess(
          currentData: ProductDetails.fromJson(response),
        );
        notifyListeners();
      }
    } on NoInternetException catch (error) {
      console.internet(error, trace);
      propsProductDetail.setError(currentError: error.toString());
      notifyListeners();
    } on CustomException catch (error) {
      console.custom(error, trace);
      propsProductDetail.setError(currentError: error.toString());
      notifyListeners();
    } on AuthException catch (error) {
      console.authentication(error, trace);
      propsProductDetail.setAuthException(
          currentError: error.message.toString());
      notifyListeners();
    } catch (error) {
      console.error(error, trace);
      propsProductDetail.setError(currentError: "something_went_wrong".tr);
      notifyListeners();
    }
  }

  Future<void> onSearch(String key, String date) async {
    try {
      propsSearch.setProcessing();
      notifyListeners();

      if (!connectivity.isConnected) {
        throw NoInternetException();
      }

      final response = await supabase.rpc(
        'search',
        body: {'key': key, 'date': date},
      );

      if (response.isEmpty) {
        propsSearch.setSuccess(currentData: []);
        notifyListeners();
      } else {
        List<Products> list = [];
        for (var data in response) {
          list.add(Products.fromJson(data));
        }

        propsSearch.setSuccess(currentData: list);
        notifyListeners();
      }
    } on NoInternetException catch (error) {
      console.internet(error, trace);
      propsSearch.setError(currentError: error.toString());
      notifyListeners();
    } on CustomException catch (error) {
      console.custom(error, trace);
      propsSearch.setError(currentError: error.toString());
      notifyListeners();
    } on AuthException catch (error) {
      console.authentication(error, trace);
      propsSearch.setAuthException(currentError: error.message.toString());
      notifyListeners();
    } catch (error) {
      console.error(error, trace);
      propsSearch.setError(currentError: "something_went_wrong".tr);
      notifyListeners();
    }
  }

  Future<void> onDiscover() async {
    try {
      propsDiscover.setProcessing();
      notifyListeners();

      if (!connectivity.isConnected) {
        throw NoInternetException();
      }

      final response = await supabase.rpc(
        'products',
        body: {'isFeatured': false},
      );

      if (response.isEmpty) {
        propsDiscover.setSuccess(currentData: []);
        notifyListeners();
      } else {
        List<Products> list = [];
        for (var data in response) {
          list.add(Products.fromJson(data));
        }

        propsDiscover.setSuccess(currentData: list);
        notifyListeners();
      }
    } on NoInternetException catch (error) {
      console.internet(error, trace);
      propsDiscover.setError(currentError: error.toString());
      notifyListeners();
    } on CustomException catch (error) {
      console.custom(error, trace);
      propsDiscover.setError(currentError: error.toString());
      notifyListeners();
    } on AuthException catch (error) {
      console.authentication(error, trace);
      propsDiscover.setAuthException(currentError: error.message.toString());
      notifyListeners();
    } catch (error) {
      console.error(error, trace);
      propsDiscover.setError(currentError: "something_went_wrong".tr);
      notifyListeners();
    }
  }

  Future setProductId(num? id) {
    return onDetail(id).then((res) {
      productId = id;
      notifyListeners();

      return id;
    });
  }

  Future<void> onRefresh() async {
    await onReady();
  }
}
