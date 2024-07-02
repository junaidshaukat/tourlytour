import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'core/app_export.dart';

void main() async {
  Provider.debugCheckInvalidValueType = null;
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey =
      "pk_test_51JXpyCFGJlqg5MKbnfM9Pk4US23dbdTMnd3sabQOMIUxyU1JyU0kpKRH4k2FIbnM0KNk5kEoskGdy4PCf1hQppKB00AcKnhCH3";
  Stripe.merchantIdentifier = "merchant.identifier";

  await Hive.initFlutter();
  await Supabase.initialize(
    url: 'https://vtdjscrvogtprhlhvdwr.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZ0ZGpzY3J2b2d0cHJobGh2ZHdyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDc5NTEzNjUsImV4cCI6MjAyMzUyNzM2NX0.tOsJtFUD20JbYGk00O39jU3sYSrM2fOr8QiWGOSpvh0',
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
