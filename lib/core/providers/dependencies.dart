import 'package:flutter/material.dart';
import '/core/app_export.dart';

class DependenciesProvider with ChangeNotifier {
  final BuildContext context;

  late ConnectivityProvider connectivity;
  late AuthenticationProvider authentication;
  late CurrentUserProvider currentUser;
  late ProductsProvider products;
  late FavouritesProvider favourites;
  late ToursProvider tours;
  late DiscoverProvider discover;
  late ProfileProvider profile;

  DependenciesProvider(this.context) {
    connectivity = context.read<ConnectivityProvider>();
    authentication = context.read<AuthenticationProvider>();
    currentUser = context.read<CurrentUserProvider>();
    products = context.read<ProductsProvider>();
    favourites = context.read<FavouritesProvider>();
    tours = context.read<ToursProvider>();
    discover = context.read<DiscoverProvider>();
    profile = context.read<ProfileProvider>();
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

  Future<bool> inject() async {
    try {
      if (!connectivity.isConnected) {
        throw NoInternetException();
      }

      await currentUser.onReady();
      await profile.onReady();
      await products.onReady();
      await favourites.onReady();
      await tours.onReady();
      await discover.onReady();

      return true;
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
}
