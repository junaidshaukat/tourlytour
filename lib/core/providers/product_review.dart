import 'package:flutter/material.dart';
import '/core/app_export.dart';

class ProductReviewsProvider with ChangeNotifier {
  final BuildContext context;
  final supabase = Supabase.instance.client;
  late ConnectivityProvider connectivity;

  Props props = Props(data: [], initialData: []);

  ProductReviewsProvider(this.context) {
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
          .from('ProductReviews')
          .select(
              '*, Products(*), Users(*),ProductReviewPhotos!inner(ProductReviewId,Url,Id)')
          .eq('ProductId', '$productId');

      if (response.isEmpty) {
        props.setSuccess(currentData: []);
        notifyListeners();
      } else {
        List<ProductReviews> list = [];
        for (var data in response) {
          list.add(ProductReviews.fromJson(data));
        }
        props.setSuccess(currentData: list);
        notifyListeners();
      }
    } on NoInternetException catch (error) {
      console.log(
          error, 'ProductReviewsProvider::onReady::NoInternetException');
      props.setError(currentError: error.toString());
      notifyListeners();
    } on CustomException catch (error) {
      console.log(error, 'ProductReviewsProvider::onReady::CustomException');
      props.setError(currentError: error.toString());
      notifyListeners();
    } on AuthException catch (error) {
      console.log(error, 'ProductReviewsProvider::onReady::AuthException');
      props.setError(currentError: error.message.toString());
      notifyListeners();
    } catch (error) {
      console.log(error, 'ProductReviewsProvider::onReady');
      props.setError(currentError: "something_went_wrong".tr);
      notifyListeners();
    }
  }

  Future<void> onRefresh(num? id) async {
    await onReady(id);
  }

  String seamlessExperience(List collection) {
    double sum = 0;
    for (var element in collection) {
      sum += element.hospitality;
    }

    return (sum / collection.length).toStringAsFixed(1);
  }

  String hospitality(List collection) {
    double sum = 0;
    for (var element in collection) {
      sum += element.hospitality;
    }

    return (sum / collection.length).toStringAsFixed(1);
  }

  String valueForMoney(List collection) {
    double sum = 0;
    for (var element in collection) {
      sum += element.hospitality;
    }

    return (sum / collection.length).toStringAsFixed(1);
  }

  String impressiveness(List collection) {
    double sum = 0;
    for (var element in collection) {
      sum += element.hospitality;
    }

    return (sum / collection.length).toStringAsFixed(1);
  }

  void clear() {
    props.clear([]);
    props.setLoading();
  }
}
