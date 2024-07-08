import 'package:flutter/material.dart';
import '/core/app_export.dart';

class AppRoutes {
  /// authentication
  static const String signup = '/signup';
  static const String signin = '/signin';
  static const String resetPassword = '/reset_password';
  static const String forgetPassword = '/forget_password';
  static const String otpVerification = '/otp_verification';

  /// dashboard
  static const String tour = '/tour';
  static const String blogs = '/blogs';
  static const String search = '/search';
  static const String profile = '/profile';
  static const String currency = '/currency';
  static const String language = '/language';
  static const String dashboard = '/dashboard';
  static const String favourite = '/favourite';
  static const String contactUs = '/contact_us';
  static const String tourDetails = '/tour_details';
  static const String confirmation = '/confirmation';
  static const String specialDeals = '/special_deals';
  static const String termsCondition = '/terms_condition';
  static const String productDetails = '/product_details';
  static const String featuredPackges = '/featured_packges';
  static const String discoverPackges = '/discover_packges';
  static const String otherInformation = '/other_information';
  static const String packageSelection = '/package_selection';

  /// onboarding
  static const String onboarding = '/onboarding';

  /// splash
  static const String initialRoute = '/';
  static const String splash = initialRoute;

  static Map<String, WidgetBuilder> get routes {
    return {
      tour: (context) => const ToursScreen(),
      blogs: (context) => const BlogsScreen(),
      splash: (context) => const SplashScreen(),
      signin: (context) => const SignInScreen(),
      signup: (context) => const SignUpScreen(),
      search: (context) => const SearchScreen(),
      profile: (context) => const ProfileScreen(),
      language: (context) => const LanguageScreen(),
      currency: (context) => const CurrencyScreen(),
      contactUs: (context) => const ContactUsScreen(),
      favourite: (context) => const FavouriteScreen(),
      dashboard: (context) => const DashboardScreen(),
      onboarding: (context) => const OnboardingScreen(),
      tourDetails: (context) => const TourDetailsScreen(),
      specialDeals: (context) => const SpecialDealScreen(),
      confirmation: (context) => const ConfirmationScreen(),
      resetPassword: (context) => const ResetPasswordScreen(),
      termsCondition: (context) => const TermsConditionScreen(),
      productDetails: (context) => const ProductDetailsScreen(),
      forgetPassword: (context) => const ForgetPasswordScreen(),
      discoverPackges: (context) => const DiscoverPackgesScreen(),
      otpVerification: (context) => const OtpVerificationScreen(),
      featuredPackges: (context) => const FeaturedPackgesScreen(),
      otherInformation: (context) => const OtherInformationScreen(),
      packageSelection: (context) => const PackageSelectionScreen(),
    };
  }
}
