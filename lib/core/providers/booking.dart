import 'package:flutter/material.dart';
import '/core/app_export.dart';

class BookingProvider with ChangeNotifier {
  final BuildContext context;
  final supabase = Supabase.instance.client;

  Props props = Props(data: [], initialData: []);
  Props propsBlackoutDates = Props(data: [], initialData: []);

  late ConnectivityProvider connectivity;
  late CurrentUserProvider currentUser;

  BookingProvider(this.context) {
    connectivity = context.read<ConnectivityProvider>();
    currentUser = context.read<CurrentUserProvider>();
  }

  Future<void> onRefresh() async {}

  List<DateTime> get blackoutDates {
    List collection = propsBlackoutDates.data as List;
    if (collection.isNotEmpty) {
      List<DateTime> list = [];
      for (var element in collection) {
        if (element.date != null) list.add(element.date!);
      }
      return list;
    }
    return [];
  }

  Future<void> getBlackoutDates(num? id) async {
    try {
      propsBlackoutDates.setLoading();
      notifyListeners();

      if (!connectivity.isConnected) {
        throw NoInternetException();
      }

      var response = await supabase.rpc('blackout_dates', params: {
        'id': id,
      });

      if (response != null) {
        List<UnavailableProductDates> list = [];
        for (var data in response) {
          list.add(UnavailableProductDates.fromJson(data));
        }
        propsBlackoutDates.setSuccess(currentData: list);
        notifyListeners();
      } else {
        propsBlackoutDates.setSuccess(currentData: []);
        notifyListeners();
      }
    } on NoInternetException catch (error) {
      console.log(
          error, 'BookingProvider::getBlackoutDates::NoInternetException');
      propsBlackoutDates.setError(currentError: error.toString());
      notifyListeners();
    } on CustomException catch (error) {
      console.log(error, 'BookingProvider::getBlackoutDates::CustomException');
      propsBlackoutDates.setError(currentError: error.toString());
      notifyListeners();
    } on AuthException catch (error) {
      console.log(error, 'BookingProvider::getBlackoutDates::AuthException');
      propsBlackoutDates.setError(currentError: error.message.toString());
      notifyListeners();
    } catch (error) {
      console.log(error, 'BookingProvider::getBlackoutDates');
      propsBlackoutDates.setError(currentError: "something_went_wrong".tr);
      notifyListeners();
    }
  }

  Future<Orders> booking({required BookingRequest request}) async {
    try {
      props.setProcessing();
      notifyListeners();

      if (!connectivity.isConnected) {
        throw NoInternetException();
      }

      Map<String, dynamic> params = request.toJson(skip: ['id']);

      var response = await supabase.rpc('booking', params: {'data': params});

      if (response != null) {
        List<Orders> list = [];
        for (var data in response) {
          list.add(Orders.fromJson(data));
        }
        props.setSuccess(currentData: list);
        notifyListeners();
        return list.first;
      } else {
        throw CustomException();
      }
    } on NoInternetException catch (error) {
      console.log(error, 'BookingProvider::booking::NoInternetException');
      props.setError(currentError: error.toString());
      notifyListeners();
      rethrow;
    } on CustomException catch (error) {
      console.log(error, 'BookingProvider::booking::CustomException');
      props.setError(currentError: error.toString());
      notifyListeners();
      rethrow;
    } on AuthException catch (error) {
      console.log(error, 'BookingProvider::booking::AuthException');
      props.setError(currentError: error.message.toString());
      notifyListeners();
      rethrow;
    } catch (error) {
      console.log(error, 'BookingProvider::booking');
      props.setError(currentError: "something_went_wrong".tr);
      notifyListeners();
      rethrow;
    }
  }
}
