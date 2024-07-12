import 'package:flutter/material.dart';
import '/core/app_export.dart';

class ToursProvider with ChangeNotifier {
  final BuildContext context;
  Props props = Props(data: [], initialData: []);
  Props propsDetails = Props(data: {}, initialData: {});

  late SupabaseService supabase;
  late AuthenticationProvider auth;
  late CurrentUserProvider currentUser;
  late ConnectivityProvider connectivity;

  ToursProvider(this.context) {
    auth = context.read<AuthenticationProvider>();
    currentUser = context.read<CurrentUserProvider>();
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
      props.setProcessing();
      notifyListeners();

      if (!connectivity.isConnected) {
        throw NoInternetException();
      }

      if (!auth.isAuthorized) {
        throw UnauthorizedException();
      }

      var response = await supabase.rpc('tours');

      if (response != null) {
        props.setSuccess(currentData: []);
        List<Tour> list = [];
        for (var data in response) {
          list.add(Tour.fromJson(data));
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
      props.setAuthException(currentError: error.message.toString());
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

  Future<void> onDetails(num? id) async {
    try {
      propsDetails.setProcessing();
      notifyListeners();

      if (!connectivity.isConnected) {
        throw NoInternetException();
      }

      if (!auth.isAuthorized) {
        throw UnauthorizedException();
      }

      var response = await supabase.rpc('tour_details', body: {"id": id});
      console.log(response);

      if (response != null) {
        propsDetails.setSuccess(currentData: TourDetails.fromJson(response));
        notifyListeners();
      } else {
        propsDetails.setSuccess(currentData: {});
        notifyListeners();
      }
    } on NoInternetException catch (error) {
      console.internet(error, trace);
      propsDetails.setError(currentError: error.toString());
      notifyListeners();
    } on AuthException catch (error) {
      console.authentication(error, trace);
      propsDetails.setAuthException(currentError: error.message.toString());
      notifyListeners();
    } on CustomException catch (error) {
      console.custom(error, trace);
      propsDetails.setError(currentError: error.toString());
      notifyListeners();
    } catch (error) {
      console.error(error, trace);
      propsDetails.setError(currentError: "something_went_wrong".tr);
      notifyListeners();
    }
  }

  Future<void> onRefresh() async {
    await onReady();
  }

  void onTap() {}

  void onChanged(String p1) {}
}
