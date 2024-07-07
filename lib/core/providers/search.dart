import 'package:flutter/material.dart';
import '/core/app_export.dart';

class SearchProvider extends ChangeNotifier {
  final BuildContext context;
  final supabase = Supabase.instance.client;

  late AuthenticationProvider auth;
  late ConnectivityProvider connectivity;

  Props props = Props(data: [], initialData: []);

  String key = '';
  DateTime date = DateTime.now();

  SearchProvider(this.context) {
    auth = context.read<AuthenticationProvider>();
    connectivity = context.read<ConnectivityProvider>();
    props.setSuccess();
    notifyListeners();
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

  Future<void> onSearch() async {
    try {
      props.setProcessing();
      notifyListeners();

      if (!connectivity.isConnected) {
        throw NoInternetException();
      }

      var response = await supabase.rpc('search', params: {
        'k': key,
        'd': date.format('yyyy-MM-dd'),
      });

      if (response == null) {
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

  Future<void> onRefresh() async {
    if (key.isNotEmpty) await onSearch();
  }

  Future<void> onTap() async {
    if (key.isNotEmpty) await onSearch();
  }

  Future<void> onDateChange(DateTime d) async {
    date = d;
    notifyListeners();
    if (key.isNotEmpty) await onSearch();
  }

  Future<void> onChanged(String s) async {
    key = s;
    notifyListeners();
    if (key.isNotEmpty) await onSearch();
  }
}
