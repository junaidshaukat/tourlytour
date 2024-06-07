import 'package:flutter/material.dart';
import '/core/app_export.dart';

class AppRoutes {
  static const String initialRoute = '/';
  static const String splash = initialRoute;
  static const String onboarding = '/onboarding';
  static const String signin = '/signin';
  static const String signup = '/signup';
  static const String forgetPassword = '/forget_password';
  static const String resetPassword = '/reset_password';
  static const String otpVerification = '/otp_verification';
  static const String dashboard = '/dashboard';
  static const String search = '/search';
  static const String profile = '/profile';
  static const String profileUpdate = '/profile_update';
  static const String profileVerify = '/profile_verify';
  static const String featuredPackges = '/featured_packges';
  static const String favourite = '/favourite';
  static const String productDetails = '/product_details';
  static const String otherInformation = '/other_information';
  static const String packageSelection = '/package_selection';
  static const String payment = '/payment';
  static const String confirmation = '/confirmation';

  static Map<String, WidgetBuilder> get routes {
    return {
      splash: (context) => const SplashScreen(),
      onboarding: (context) => const OnboardingScreen(),
      signin: (context) => const SignInScreen(),
      signup: (context) => const SignUpScreen(),
      forgetPassword: (context) => const ForgetPasswordScreen(),
      resetPassword: (context) => const ResetPasswordScreen(),
      otpVerification: (context) => const OtpVerificationScreen(),
      dashboard: (context) => const DashboardScreen(),
      search: (context) => const SearchScreen(),
      profile: (context) => const ProfileScreen(),
      profileUpdate: (context) => const ProfileUpdateScreen(),
      profileVerify: (context) => const ProfileVerifyScreen(),
      featuredPackges: (context) => const FeaturedPackgesScreen(),
      favourite: (context) => const FavouriteScreen(),
      productDetails: (context) => const ProductDetailsScreen(),
      otherInformation: (context) => const OtherInformationScreen(),
      packageSelection: (context) => const PackageSelectionScreen(),
      payment: (context) => const PaymentScreen(),
      confirmation: (context) => const ConfirmationScreen(),
    };
  }
}
