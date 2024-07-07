import 'package:flutter/material.dart';
import '/core/app_export.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  OnboardingScreenState createState() => OnboardingScreenState();
}

class OnboardingScreenState extends State<OnboardingScreen> {
  PageController controller = PageController();
  int activeIndex = 0;
  String imagePath = "onboarding@1".image.png;

  @override
  void initState() {
    super.initState();
  }

  void onContinue() {
    context.read<CurrentUserProvider>().setOnboarding(false).then((res) {
      NavigatorService.pushNamedAndRemoveUntil(
        AppRoutes.signin,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomImageView(
            imagePath: imagePath,
            height: 590.v,
            width: double.maxFinite,
            alignment: Alignment.topCenter,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 480.v,
              width: double.maxFinite,
              padding: EdgeInsets.symmetric(
                horizontal: 32.h,
                vertical: 21.v,
              ),
              decoration: AppDecoration.outlineBlack.copyWith(
                borderRadius: BorderRadiusStyle.customBorderTL30,
              ),
              child: PageView(
                controller: controller,
                onPageChanged: (page) {
                  setState(() {
                    if (page == 0) {
                      imagePath = "onboarding@1".image.png;
                    } else if (page == 1) {
                      imagePath = "onboarding@3".image.png;
                    } else if (page == 2) {
                      imagePath = "onboarding@5".image.png;
                    }
                    activeIndex = page;
                  });
                },
                children: [
                  Onboarding(
                    activeIndex: activeIndex,
                    heading: "drive_your_bangkok".tr,
                    subheading: "whispers_of_ancient".tr,
                    imagePath: "onboarding@2".image.png,
                    text: "continue".tr,
                    onPressed: () {
                      controller.animateToPage(
                        1,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeIn,
                      );
                    },
                  ),
                  Onboarding(
                    activeIndex: activeIndex,
                    heading: "explore_thailand".tr,
                    subheading: "freedom_for_one".tr,
                    imagePath: "onboarding@4".image.png,
                    text: "continue".tr,
                    onPressed: () {
                      controller.animateToPage(
                        2,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeIn,
                      );
                    },
                  ),
                  Onboarding(
                    activeIndex: activeIndex,
                    heading: "explore_thailand".tr,
                    subheading: "freedom_for_one".tr,
                    imagePath: "onboarding@6".image.png,
                    text: "let_s_get_start".tr,
                    onPressed: onContinue,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class Onboarding extends StatelessWidget {
  final String imagePath;
  final String heading;
  final String subheading;
  final String text;
  final int activeIndex;
  final void Function() onPressed;

  const Onboarding({
    super.key,
    required this.heading,
    required this.subheading,
    required this.text,
    required this.imagePath,
    required this.onPressed,
    this.activeIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 3.v),
        CustomImageView(
          imagePath: imagePath,
          height: 216.v,
          width: double.maxFinite,
          margin: EdgeInsets.only(left: 2.h),
        ),
        SizedBox(height: 8.v),
        Text(
          heading,
          style: CustomTextStyles.titleMediumDeeporange400,
        ),
        SizedBox(height: 5.v),
        SizedBox(
          height: 68.v,
          width: double.maxFinite,
          child: Text(
            subheading,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
            style: CustomTextStyles.bodySmallBlack900,
          ),
        ),
        SizedBox(height: 12.v),
        CustomElevatedButton(
          width: 200.h,
          text: text,
          buttonTextStyle: CustomTextStyles.labelLargeInterBlack900,
          onPressed: onPressed,
          alignment: Alignment.center,
        ),
        SizedBox(height: 24.v),
        Align(
          alignment: Alignment.center,
          child: SizedBox(
            height: 12.v,
            child: AnimatedSmoothIndicator(
              activeIndex: activeIndex,
              count: 3,
              effect: ScrollingDotsEffect(
                spacing: 5,
                activeDotColor: appTheme.yellow80001,
                dotColor: appTheme.blueGray100,
                activeDotScale: 1.5,
                dotHeight: 8.v,
                dotWidth: 8.h,
              ),
            ),
          ),
        )
      ],
    );
  }
}
