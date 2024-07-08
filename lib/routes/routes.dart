import 'package:flutter/material.dart';
import '/core/app_export.dart';

class AppRoutes {
  static const String tour = '/tour';
  static const String blogs = '/blogs';
  static const String initialRoute = '/';
  static const String search = '/search';
  static const String signup = '/signup';
  static const String signin = '/signin';
  static const String payment = '/payment';
  static const String profile = '/profile';
  static const String splash = initialRoute;
  static const String currency = '/currency';
  static const String dashboard = '/dashboard';
  static const String favourite = '/favourite';
  static const String contactUs = '/contact_us';
  static const String onboarding = '/onboarding';
  static const String tourDetails = '/tour_details';
  static const String confirmation = '/confirmation';
  static const String resetPassword = '/reset_password';
  static const String termsCondition = '/terms_condition';
  static const String forgetPassword = '/forget_password';
  static const String productDetails = '/product_details';
  static const String otpVerification = '/otp_verification';
  static const String featuredPackges = '/featured_packges';
  static const String discoverPackges = '/discover_packges';
  static const String otherInformation = '/other_information';
  static const String packageSelection = '/package_selection';

  static Map<String, WidgetBuilder> get routes {
    return {
      tour: (context) => const ToursScreen(),
      blogs: (context) => const BlogsScreen(),
      splash: (context) => const SplashScreen(),
      signin: (context) => const SignInScreen(),
      signup: (context) => const SignUpScreen(),
      search: (context) => const SearchScreen(),
      profile: (context) => const ProfileScreen(),
      favourite: (context) => const FavouriteScreen(),
      dashboard: (context) => const DashboardScreen(),
      onboarding: (context) => const OnboardingScreen(),
      tourDetails: (context) => const TourDetailsScreen(),
      confirmation: (context) => const ConfirmationScreen(),
      resetPassword: (context) => const ResetPasswordScreen(),
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
