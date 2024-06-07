import 'package:flutter/material.dart';
import '/core/app_export.dart';

class FavouritesProvider with ChangeNotifier {
  final BuildContext context;
  final supabase = Supabase.instance.client;
  Props props = Props(data: [], initialData: []);

  late CurrentUserProvider currentUser;
  late ConnectivityProvider connectivity;

  FavouritesProvider(this.context) {
    connectivity = context.read<ConnectivityProvider>();
    currentUser = context.read<CurrentUserProvider>();
  }

  Future<void> onReady() async {
    try {
      props.setLoading();
      notifyListeners();

      if (!connectivity.isConnected) {
        throw NoInternetException();
      }

      var response = await supabase
          .from('Favourites')
          .select('*, Products(*)')
          .eq('UserId', "${currentUser.id}");

      if (response.isEmpty) {
        props.clear([]);
        props.setSuccess(currentData: []);
        notifyListeners();
      } else {
        List<Favourites> list = [];
        for (var data in response) {
          list.add(Favourites.fromJson(data));
        }
        props.clear([]);
        props.setSuccess(currentData: list);
        notifyListeners();
      }
    } on NoInternetException catch (error) {
      props.setError(currentError: error.toString());
      notifyListeners();
    } on CustomException catch (error) {
      props.setError(currentError: error.toString());
      notifyListeners();
    } on AuthException catch (error) {
      props.setError(currentError: error.message.toString());
      notifyListeners();
    } catch (error) {
      console.log(error, 'Error::FavouritesProvider::onReady');
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
      props.setError(currentError: error.toString());
      notifyListeners();
    } on CustomException catch (error) {
      props.setError(currentError: error.toString());
      notifyListeners();
    } on AuthException catch (error) {
      props.setError(currentError: error.message.toString());
      notifyListeners();
    } catch (error) {
      console.log(error, 'Error::FavouritesProvider::onFavourite');
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
      props.setError(currentError: error.toString());
      notifyListeners();
    } on CustomException catch (error) {
      props.setError(currentError: error.toString());
      notifyListeners();
    } on AuthException catch (error) {
      props.setError(currentError: error.message.toString());
      notifyListeners();
    } catch (error) {
      console.log(error, 'Error::FavouritesProvider::onRemove');
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
