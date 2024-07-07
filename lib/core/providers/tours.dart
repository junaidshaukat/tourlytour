import 'package:flutter/material.dart';
import '/core/app_export.dart';

class ToursProvider with ChangeNotifier {
  final BuildContext context;
  final supabase = Supabase.instance.client;
  Props props = Props(data: [], initialData: []);
  Props propsSingleTour = Props(data: [], initialData: {});

  late AuthenticationProvider auth;
  late CurrentUserProvider currentUser;
  late ConnectivityProvider connectivity;

  ToursProvider(this.context) {
    auth = context.read<AuthenticationProvider>();
    currentUser = context.read<CurrentUserProvider>();
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
      props.setProcessing();
      notifyListeners();

      if (!connectivity.isConnected) {
        throw NoInternetException();
      }

      if (!auth.isAuthorized) {
        throw UnauthorizedException();
      }

      var response = await supabase.rpc('tour_history', params: {
        'user_id': currentUser.id,
      });

      if (response != null) {
        props.setSuccess(currentData: []);
        List<TourHistory> list = [];
        for (var data in response) {
          list.add(TourHistory.fromJson(data));
        }
        props.setSuccess(currentData: list);
        notifyListeners();
      } else {
        props.setSuccess(currentData: []);
        notifyListeners();
      }
    } on NoInternetException catch (error) {
      console.internet(error, trace);
      props.setError(currentError: error.toString());
      notifyListeners();
    } on AuthException catch (error) {
      console.authentication(error, trace);
      props.setUnauthorized(currentError: error.message.toString());
      notifyListeners();
    } on CustomException catch (error) {
      console.custom(error, trace);
      props.setError(currentError: error.toString());
      notifyListeners();
    } catch (error) {
      console.error(error, trace);
      props.setError(currentError: "something_went_wrong".tr);
      notifyListeners();
    }
  }

  Future<void> getTourDetails(num? id) async {
    try {
      propsSingleTour.setProcessing();
      notifyListeners();

      if (!connectivity.isConnected) {
        throw NoInternetException();
      }

      if (!auth.isAuthorized) {
        throw UnauthorizedException();
      }

      var response = await supabase.rpc('tour_details', params: {
        'order_id': id,
        'user_id': currentUser.id,
      });

      if (response != null) {
        propsSingleTour.setSuccess(currentData: TourHistory.fromJson(response));
        notifyListeners();
      } else {
        propsSingleTour.setSuccess(currentData: []);
        notifyListeners();
      }
    } on NoInternetException catch (error) {
      console.internet(error, trace);
      propsSingleTour.setError(currentError: error.toString());
      notifyListeners();
    } on AuthException catch (error) {
      console.authentication(error, trace);
      propsSingleTour.setUnauthorized(currentError: error.message.toString());
      notifyListeners();
    } on CustomException catch (error) {
      console.custom(error, trace);
      propsSingleTour.setError(currentError: error.toString());
      notifyListeners();
    } catch (error) {
      console.error(error, trace);
      propsSingleTour.setError(currentError: "something_went_wrong".tr);
      notifyListeners();
    }
  }

  Future<void> onRefresh() async {
    await onReady();
  }

  void onTap() {}

  void onChanged(String p1) {}
}
