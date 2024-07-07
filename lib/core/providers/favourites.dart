import 'package:flutter/material.dart';
import '/core/app_export.dart';

class FavouritesProvider with ChangeNotifier {
  final BuildContext context;
  final supabase = Supabase.instance.client;
  Props props = Props(data: [], initialData: []);

  late AuthenticationProvider auth;
  late CurrentUserProvider currentUser;
  late ConnectivityProvider connectivity;

  FavouritesProvider(this.context) {
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

  Future<void> onReady() async {
    try {
      props.setLoading();
      notifyListeners();

      if (!connectivity.isConnected) {
        throw NoInternetException();
      }

      if (!auth.isAuthorized) {
        throw UnauthorizedException();
      }

      var response = await supabase.rpc('favourites', params: {
        'user_id': currentUser.id,
      });

      if (response == null) {
        props.setSuccess(currentData: []);
        notifyListeners();
      } else {
        List<Favourites> list = [];
        for (var data in response) {
          list.add(Favourites.fromJson(data));
        }
        props.setSuccess(currentData: list);
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

  Future<void> onRefresh({num userId = 1}) async {
    await onReady();
  }

  Future<void> onFavourite(num? productId) async {
    try {
      props.setProcessing();
      notifyListeners();
      if (!connectivity.isConnected) {
        throw NoInternetException();
      }

      if (!auth.isAuthorized) {
        throw UnauthorizedException();
      }

      var response = await supabase
          .from('Favourites')
          .select()
          .eq('UserId', '${currentUser.id}')
          .eq('ProductId', '$productId');

      if (response.isNotEmpty) {
        props.setSuccess();
        notifyListeners();
      } else {
        response = await supabase.from('Favourites').insert(
          {
            'ProductId': productId,
            'UserId': currentUser.id,
            "Status": "Status"
          },
        ).select();
        if (response.isEmpty) {
          props.setSuccess();
          notifyListeners();
        } else {
          props.setSuccess();
          notifyListeners();
          await onReady();
        }
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

  Future<dynamic> onRemove(num? id) async {
    try {
      props.setProcessing();
      notifyListeners();

      if (!connectivity.isConnected) {
        throw NoInternetException();
      }

      if (!auth.isAuthorized) {
        throw UnauthorizedException();
      }

      var response =
          await supabase.from('Favourites').delete().eq('Id', '$id').select();
      if (response.isEmpty) {
        await onReady();
        notifyListeners();
        return true;
      } else {
        await onReady();
        notifyListeners();
        return true;
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

  bool findFavourite(num? productId) {
    if (props.data != null) {
      List collection = props.data as List;
      for (Favourites element in collection) {
        if (element.productId == productId) {
          return true;
        }
      }
      return false;
    }
    return false;
  }
}
