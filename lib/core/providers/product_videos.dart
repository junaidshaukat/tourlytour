import 'package:flutter/material.dart';
import '/core/app_export.dart';

class ProductVideosProvider with ChangeNotifier {
  final BuildContext context;
  final supabase = Supabase.instance.client;
  late ConnectivityProvider connectivity;

  Props props = Props(data: [], initialData: []);

  ProductVideosProvider(this.context) {
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
          .from('ProductVideos')
          .select()
          .eq('ProductId', '$productId');

      if (response.isEmpty) {
        props.setSuccess(currentData: []);
        notifyListeners();
      } else {
        List<ProductVideos> list = [];
        for (var data in response) {
          list.add(ProductVideos.fromJson(data));
        }
        props.setSuccess(currentData: list);
        notifyListeners();
      }
    } on NoInternetException catch (error) {
      console.log(error, 'ProductVideosProvider::onReady::NoInternetException');
      props.setError(currentError: error.toString());
      notifyListeners();
    } on CustomException catch (error) {
      console.log(error, 'ProductVideosProvider::onReady::CustomException');
      props.setError(currentError: error.toString());
      notifyListeners();
    } on AuthException catch (error) {
      console.log(error, 'ProductVideosProvider::onReady::AuthException');
      props.setError(currentError: error.message.toString());
      notifyListeners();
    } catch (error) {
      console.log(error, 'ProductVideosProvider::onReady');
      props.setError(currentError: "something_went_wrong".tr);
      notifyListeners();
    }
  }

  Future<void> onRefresh(num? id) async {
    await onReady(id);
  }

  void clear() {
    props.clear([]);
    props.setLoading();
  }
}
