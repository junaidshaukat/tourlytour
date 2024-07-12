import 'package:flutter/material.dart';
import '/core/app_export.dart';

class BookingProvider with ChangeNotifier {
  final BuildContext context;
  final supabase = Supabase.instance.client;

  Props props = Props(data: [], initialData: []);
  Props propsBlackoutDates = Props(data: [], initialData: []);

  late AuthenticationProvider auth;
  late ConnectivityProvider connectivity;
  late CurrentUserProvider currentUser;

  BookingProvider(this.context) {
    auth = context.read<AuthenticationProvider>();
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

      if (!auth.isAuthorized) {
        throw UnauthorizedException();
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
      console.internet(error, trace);
      propsBlackoutDates.setError(currentError: error.toString());
      notifyListeners();
    } on CustomException catch (error) {
      console.custom(error, trace);
      propsBlackoutDates.setError(currentError: error.toString());
      notifyListeners();
    } on AuthException catch (error) {
      console.authentication(error, trace);
      propsBlackoutDates.setError(currentError: error.message.toString());
      notifyListeners();
    } catch (error) {
      console.error(error, trace);
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

      if (!auth.isAuthorized) {
        throw UnauthorizedException();
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
      console.internet(error, trace);
      props.setError(currentError: error.toString());
      notifyListeners();
      rethrow;
    } on CustomException catch (error) {
      console.custom(error, trace);
      props.setError(currentError: error.toString());
      notifyListeners();
      rethrow;
    } on AuthException catch (error) {
      console.authentication(error, trace);
      props.setAuthException(currentError: error.message.toString());
      notifyListeners();
      rethrow;
    } catch (error) {
      console.error(error, trace);
      props.setError(currentError: "something_went_wrong".tr);
      notifyListeners();
      rethrow;
    }
  }
}
