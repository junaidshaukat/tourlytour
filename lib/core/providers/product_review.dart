import 'dart:io';
import 'package:flutter/material.dart';
import '/core/app_export.dart';

class ProductReviewsProvider with ChangeNotifier {
  ImagePicker picker = ImagePicker();

  final BuildContext context;
  final supabase = Supabase.instance.client;
  late ConnectivityProvider connectivity;
  late CurrentUserProvider currentUser;

  List photos = [];
  List<ProductReviewPhotos> removePhotos = [];

  num seamlessExperience = 0;
  num hospitality = 0;
  num valueForMoney = 0;
  num impressiveness = 0;
  num rating = 0;
  String description = '';

  Props props = Props(data: [], initialData: []);
  Props currentReviews = Props(data: [], initialData: null);

  ProductReviewsProvider(this.context) {
    connectivity = context.read<ConnectivityProvider>();
    currentUser = context.read<CurrentUserProvider>();
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

  Future<dynamic> create(ProductReviews reviews, List files, num? id) async {
    try {
      if (!connectivity.isConnected) {
        throw NoInternetException();
      }

      List skip = [];
      List photos = [];

      if (reviews.id == null) {
        skip = ['id', 'product', 'productReviewId'];
      }

      for (int i = 0; i < files.length; i++) {
        if (files[i] is XFile) {
          File file = File(files[i].path);
          String filename = '${fn.objectId()}.png';
          String path =
              await supabase.storage.from('content').upload(filename, file);
          photos.add("${Environment.bucket}/$path");
        }
      }

      Map<String, dynamic> params = reviews.toJson(skip: skip);
      params.addAll({'Photos': photos, 'OrderId': id});

      var response = await supabase.rpc(
        'reviews_create',
        params: {'data': params},
      );

      if (response.isEmpty) {
        await onReady(reviews.productId);
        return response;
      } else {
        await onReady(reviews.productId);
        return response;
      }
    } on NoInternetException catch (error) {
      console.internet(error, trace);
      rethrow;
    } on CustomException catch (error) {
      console.custom(error, trace);
      rethrow;
    } on AuthException catch (error) {
      console.authentication(error, trace);
      rethrow;
    } catch (error) {
      console.error(error, trace);
      rethrow;
    }
  }

  Future<dynamic> update(ProductReviews reviews, List files,
      List<ProductReviewPhotos> remove) async {
    try {
      props.setLoading();
      notifyListeners();
      if (!connectivity.isConnected) {
        throw NoInternetException();
      }

      List skip = [];
      List photos = [];

      if (reviews.id == null) {
        skip = ['id', 'product', 'productReviewId'];
      }

      for (int i = 0; i < files.length; i++) {
        if (files[i] is XFile) {
          File file = File(files[i].path);
          String filename = '${fn.objectId()}.png';
          String path =
              await supabase.storage.from('content').upload(filename, file);
          photos.add("${Environment.bucket}/$path");
        }
      }

      Map<String, dynamic> params = reviews.toJson(skip: skip);
      params.addAll({'Photos': photos});
      params.addAll({'removePhotos': remove.map((e) => e.toJson()).toList()});

      var response = await supabase.rpc(
        'reviews_update',
        params: {'data': params},
      );

      if (response.isEmpty) {
        await onReady(reviews.productId);
        return response;
      } else {
        await onReady(reviews.productId);
        return response;
      }
    } on NoInternetException catch (error) {
      console.internet(error, trace);
      props.setError(currentError: error.toString());
      notifyListeners();
      NavigatorService.goBack();
    } on CustomException catch (error) {
      console.custom(error, trace);
      props.setError(currentError: error.toString());
      notifyListeners();
      NavigatorService.goBack();
    } on AuthException catch (error) {
      console.authentication(error, trace);
      props.setError(currentError: error.message.toString());
      notifyListeners();
      NavigatorService.goBack();
    } catch (error) {
      console.error(error, trace);
      props.setError(currentError: "something_went_wrong".tr);
      notifyListeners();
      NavigatorService.goBack();
    }
  }

  Future<void> onRefresh(num? id) async {
    await onReady(id);
  }

  void onChanged(String value) {
    description = value;
    notifyListeners();
  }

  String average(List collection, String field) {
    double sum = 0;
    for (var element in collection) {
      if (field == 'seamless_experience') sum += element.seamlessExperience;
      if (field == 'hospitality') sum += element.hospitality;
      if (field == 'value_for_money') sum += element.valueForMoney;
      if (field == 'impressiveness') sum += element.impressiveness;
      if (field == 'rating') sum += element.rate;
    }

    return (sum / collection.length).toStringAsFixed(1);
  }

  void clear() {
    props.clear([]);
    props.setLoading();
  }
}
