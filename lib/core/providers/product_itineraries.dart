import 'package:flutter/material.dart';
import '/core/app_export.dart';

class ProductItinerariesProvider with ChangeNotifier {
  final BuildContext context;
  final supabase = Supabase.instance.client;

  late AuthenticationProvider auth;
  late ConnectivityProvider connectivity;

  Props props = Props(data: [], initialData: []);
  Props propsConfirmation = Props(data: [], initialData: []);

  ProductItinerariesProvider(this.context) {
    auth = context.read<AuthenticationProvider>();
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

  Future<void> onRefresh(num? id, {String fun = 'onReady'}) async {
    if (fun == 'onReady') await onReady(id);
    if (fun == 'findById') await findById(id);
  }

  void clear({String fun = 'onReady'}) {
    if (fun == 'onReady') {
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

      if (!auth.isAuthorized) {
        throw UnauthorizedException();
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
      console.internet(error, trace);
      propsConfirmation.setError(currentError: error.toString());
      notifyListeners();
    } on CustomException catch (error) {
      console.custom(error, trace);
      propsConfirmation.setError(currentError: error.toString());
      notifyListeners();
    } on AuthException catch (error) {
      console.authentication(error, trace);
      propsConfirmation.setError(currentError: error.message.toString());
      notifyListeners();
    } catch (error) {
      console.error(error, trace);
      propsConfirmation.setError(currentError: "something_went_wrong".tr);
      notifyListeners();
    }
  }
}
