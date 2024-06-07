import 'package:flutter/material.dart';
import '/core/app_export.dart';

export 'update.dart';
export 'verify.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  bool preloader = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setState(() {
        preloader = false;
      });
    });
  }

  Widget input({
    required String label,
    required String hintText,
    void Function()? onPressed,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.titleSmall,
        ),
        SizedBox(height: 4.v),
        CustomTextFormField(
          readOnly: true,
          hintText: hintText,
          hintStyle: CustomTextStyles.bodyMediumBlack900,
          suffix: IconButton(
            onPressed: onPressed,
            icon: CustomImageView(
              imagePath: "edit".icon.svg,
            ),
          ),
          contentPadding: EdgeInsets.only(left: 16.h),
          borderDecoration: TextFormFieldStyleHelper.fillBlueTL15,
          fillColor: appTheme.blue50,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Preloader(
      preloader: preloader,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: CustomAppBar(
          centerTitle: false,
          title: Padding(
            padding: EdgeInsets.only(left: 16.h),
            child: AppbarTitle(
              text: "profile".tr,
            ),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 16.h,
              ),
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: CustomImageView(
                    color: appTheme.black900,
                    imagePath: "arrow-left".icon.svg,
                  ),
                  onPressed: () {
                    NavigatorService.goBack();
                  },
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.h),
          child: Column(
            children: [
              Consumer<CurrentUserProvider>(
                builder: (BuildContext context, provider, Widget? child) {
                  Props props = provider.props;

                  return Container(
                    height: 150.adaptSize,
                    width: 150.adaptSize,
                    decoration: BoxDecoration(
                      color: appTheme.gray500,
                      shape: BoxShape.circle,
                    ),
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 150.adaptSize,
                          backgroundColor: appTheme.gray500,
                          child: CustomImageView(
                            fit: BoxFit.cover,
                            width: 150.adaptSize,
                            height: 150.adaptSize,
                            placeHolder: 'profile',
                            imagePath: provider.avatar,
                            radius: BorderRadius.circular(100.h),
                          ),
                        ),
                        if (props.isUploading)
                          const Positioned(
                            child: Align(
                              alignment: Alignment.center,
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        Positioned(
                          bottom: 0.v,
                          right: 0.h,
                          child: IconButton(
                            icon: CustomImageView(
                              imagePath: "edit".icon.svg,
                            ),
                            onPressed: () async {
                              if (!props.isProcessing) {
                                Pickers.image().then((file) async {
                                  if (file != null) {
                                    await provider.uploadProfile(
                                      file,
                                    );
                                  }
                                });
                              }
                            },
                            style: IconButton.styleFrom(
                              backgroundColor: appTheme.yellow800,
                              minimumSize: Size(40.adaptSize, 40.adaptSize),
                              maximumSize: Size(40.adaptSize, 40.adaptSize),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              SizedBox(height: 24.v),
              Consumer<CurrentUserProvider>(
                builder: (BuildContext context, provider, Widget? child) {
                  return input(
                    label: "name".tr,
                    hintText: provider.name,
                    onPressed: () {
                      NavigatorService.push(
                        context,
                        const ProfileUpdateScreen(),
                        arguments: {
                          'field': 'name',
                          'verified': true,
                          'hintText': provider.name,
                        },
                      );
                    },
                  );
                },
              ),
              SizedBox(height: 8.v),
              Consumer<CurrentUserProvider>(
                builder: (BuildContext context, provider, Widget? child) {
                  return input(
                    label: "phone_number".tr,
                    hintText: provider.mobileNumber,
                    onPressed: () {
                      NavigatorService.push(
                        context,
                        const ProfileUpdateScreen(),
                        arguments: {
                          'field': 'phone',
                          'verified': false,
                          'hintText': provider.mobileNumber,
                        },
                      );
                    },
                  );
                },
              ),
              SizedBox(height: 14.v),
              Consumer<CurrentUserProvider>(
                builder: (BuildContext context, provider, Widget? child) {
                  return input(
                    label: "email".tr,
                    hintText: provider.email,
                    onPressed: () {
                      NavigatorService.push(
                        context,
                        const ProfileUpdateScreen(),
                        arguments: {
                          'field': 'email',
                          'verified': false,
                          'hintText': provider.email,
                        },
                      );
                    },
                  );
                },
              ),
              SizedBox(height: 5.v)
            ],
          ),
        ),
      ),
    );
  }
}
