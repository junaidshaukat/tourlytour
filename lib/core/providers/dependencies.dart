import 'package:flutter/material.dart';
import '/core/app_export.dart';

class DependenciesProvider with ChangeNotifier {
  final BuildContext context;

  late ConnectivityProvider connectivity;
  late AuthenticationProvider authentication;
  late CurrentUserProvider currentUser;
  late ProductsProvider products;
  late FavouritesProvider favourites;

  DependenciesProvider(this.context) {
    connectivity = context.read<ConnectivityProvider>();
    authentication = context.read<AuthenticationProvider>();
    currentUser = context.read<CurrentUserProvider>();
    products = context.read<ProductsProvider>();
    favourites = context.read<FavouritesProvider>();
  }

  Future<bool> inject() async {
    try {
      if (!connectivity.isConnected) {
        throw NoInternetException();
      }

      await products.onReady();
      await products.onReady();
      await favourites.onReady();
      return true;
    } on NoInternetException {
      rethrow;
    } on CustomException {
      rethrow;
    } on AuthException {
      rethrow;
    } catch (error) {
      rethrow;
    }
  }
}
