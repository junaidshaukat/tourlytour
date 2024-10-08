import 'package:flutter/material.dart';
import '/core/app_export.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  late AuthenticationProvider auth;
  late CurrentUserProvider currentUser;
  late DependenciesProvider dependencies;

  Supabase supabase = Supabase.instance;

  @override
  void initState() {
    super.initState();
    auth = context.read<AuthenticationProvider>();
    currentUser = context.read<CurrentUserProvider>();
    dependencies = context.read<DependenciesProvider>();

    Future.delayed(const Duration(seconds: 1), () async {
      await onReady();
    });
  }

  Future onReady() async {
    try {
      await currentUser.onReady();
      await dependencies.onReady();

      if (currentUser.onboarding) {
        return NavigatorService.pushNamedAndRemoveUntil(
          AppRoutes.onboarding,
        );
      } else {
        return NavigatorService.pushNamedAndRemoveUntil(
          AppRoutes.dashboard,
        );
      }
    } catch (error) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        body: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomImageView(
                width: 120.h,
                height: 86.v,
                imagePath: "logo".icon.svg,
              ),
              SizedBox(height: 21.v),
              Text(
                "tourly_tours".tr,
                style: CustomTextStyles.bodyLargeGray90002,
              ),
              SizedBox(height: 5.v)
            ],
          ),
        ),
      ),
    );
  }
}
