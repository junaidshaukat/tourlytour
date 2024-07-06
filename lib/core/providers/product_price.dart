import 'package:flutter/material.dart';
import '/core/app_export.dart';

class ProductPriceProvider with ChangeNotifier {
  final BuildContext context;
  final supabase = Supabase.instance.client;

  late AuthenticationProvider auth;
  late ConnectivityProvider connectivity;

  Props props = Props(data: [], initialData: []);

  ProductPriceProvider(this.context) {
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

  Future<void> onRefresh(dynamic request) async {
    await getPrice(request);
  }

  Future<ProductPrice> getPrice(Map<String, dynamic> params) async {
    try {
      props.setLoading();
      notifyListeners();
      if (!connectivity.isConnected) {
        throw NoInternetException();
      }

      final response = await supabase
          .from('ProductPrice')
          .select()
          .eq('ProductId', params['productId'])
          .eq('Quantity', params['quantity'])
          .single();

      if (response.isEmpty) {
        props.setSuccess(currentData: []);
        notifyListeners();
        return ProductPrice();
      } else {
        ProductPrice productPrice = ProductPrice.fromJson(response);
        props.setSuccess(currentData: productPrice);
        notifyListeners();
        return productPrice;
      }
    } on NoInternetException catch (error) {
      console.internet(error, trace);
      props.setError(currentError: error.toString());
      notifyListeners();
      return ProductPrice();
    } on CustomException catch (error) {
      console.custom(error, trace);
      props.setError(currentError: error.toString());
      notifyListeners();
      return ProductPrice();
    } on AuthException catch (error) {
      console.authentication(error, trace);
      props.setUnauthorized(currentError: error.message.toString());
      notifyListeners();
      return ProductPrice();
    } catch (error) {
      console.error(error, trace);
      props.setError(currentError: "something_went_wrong".tr);
      notifyListeners();
      return ProductPrice();
    }
  }
}
