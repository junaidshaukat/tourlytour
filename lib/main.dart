import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'core/app_export.dart';

void main() async {
  Provider.debugCheckInvalidValueType = null;
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Supabase.initialize(
    url: Environment.url,
    anonKey: Environment.anonKey,
    authOptions: const FlutterAuthClientOptions(
      authFlowType: AuthFlowType.pkce,
    ),
    realtimeClientOptions: const RealtimeClientOptions(
      logLevel: RealtimeLogLevel.info,
    ),
    storageOptions: const StorageClientOptions(
      retryAttempts: 10,
    ),
  );

  await Future.wait([
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]),
    PrefUtils().init(),
    HiveBox.onReady(),
  ]).then((value) {
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (c) => ThemeProvider(c)),
          ChangeNotifierProvider(create: (c) => ConnectivityProvider(c)),
          ChangeNotifierProvider(create: (c) => CurrentUserProvider(c)),
          ChangeNotifierProvider(create: (c) => AuthenticationProvider(c)),

          ///
          ChangeNotifierProvider(create: (c) => ToursProvider(c)),
          ChangeNotifierProvider(create: (c) => StripeProvider(c)),
          ChangeNotifierProvider(create: (c) => SearchProvider(c)),
          ChangeNotifierProvider(create: (c) => OrdersProvider(c)),
          ChangeNotifierProvider(create: (c) => BookingProvider(c)),
          ChangeNotifierProvider(create: (c) => ProductsProvider(c)),
          ChangeNotifierProvider(create: (c) => FavouritesProvider(c)),
          ChangeNotifierProvider(create: (c) => OrderGuestsProvider(c)),
          ChangeNotifierProvider(create: (c) => ProductPriceProvider(c)),
          ChangeNotifierProvider(create: (c) => DependenciesProvider(c)),
          ChangeNotifierProvider(create: (c) => ProductVideosProvider(c)),
          ChangeNotifierProvider(create: (c) => ProductPhotosProvider(c)),
          ChangeNotifierProvider(create: (c) => ProductReviewsProvider(c)),
          ChangeNotifierProvider(create: (c) => ProductItinerariesProvider(c)),

          ///
          ChangeNotifierProvider(create: (c) => ReviewService(c)),
        ],
        child: const MyApp(),
      ),
    );
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return ChangeNotifierProvider<ThemeProvider>(
          create: (context) => ThemeProvider(context),
          child: Consumer<ThemeProvider>(
            builder: (context, provider, child) {
              return MaterialApp(
                theme: theme,
                title: 'app_title',
                routes: AppRoutes.routes,
                debugShowCheckedModeBanner: false,
                initialRoute: AppRoutes.initialRoute,
                supportedLocales: const [Locale('en', '')],
                navigatorKey: NavigatorService.navigatorKey,
                localizationsDelegates: const [
                  AppLocalizationDelegate(),
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate
                ],
              );
            },
          ),
        );
      },
    );
  }
}
