import 'package:flutter/material.dart';
import '/core/app_export.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  bool preloader = true;
  late AuthenticationProvider auth;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      auth = context.read<AuthenticationProvider>();

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
        key: scaffoldKey,
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
                    imagePath: "arrow_left".icon.svg,
                    color: appTheme.black900,
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
          child: Consumer<ProfileProvider>(
            builder: (BuildContext context, provider, Widget? child) {
              Props props = provider.props;
              if (props.isNone || props.isProcessing) {
                return SizedBox(
                  height: 300.v,
                  child: const Center(
                    child: Loading(),
                  ),
                );
              } else if (props.isAuthException) {
                return SizedBox(
                  height: 300.v,
                  child: Center(
                    child: Unauthorized(
                      width: 200.h,
                      buttonWidth: 100.h,
                      message: props.error,
                      onPressed: () {
                        context.read<AuthenticationService>().openBottomSheet();
                      },
                    ),
                  ),
                );
              } else if (props.isError) {
                return SizedBox(
                  height: 300.v,
                  child: Center(
                    child: TryAgain(
                      imagePath: "refresh".icon.svg,
                      onRefresh: provider.onRefresh,
                    ),
                  ),
                );
              } else {
                UserProfile? user = props.data as UserProfile?;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
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
                              imagePath: user?.profilePhotoUrl,
                              placeHolder: 'profile'.image.png,
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
                              onPressed: () {
                                if (!props.isProcessing) {
                                  Pickers.image().then((file) {
                                    if (file != null) {
                                      provider
                                          .onUpdateProfile(file)
                                          .then((res) {
                                        context
                                            .read<DependenciesProvider>()
                                            .onReady()
                                            .then((res) async {
                                          await provider.onReady();
                                        });
                                      });
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
                    ),
                    SizedBox(height: 38.v),
                    input(
                      label: "name".tr,
                      hintText: user?.name ?? '',
                      onPressed: () {
                        context.read<AuthenticationService>().openBottomSheet(
                          event: Event.update,
                          params: {'name': user?.name},
                        );
                      },
                    ),
                    SizedBox(height: 18.v),
                    input(
                      label: "email".tr,
                      hintText: user?.email ?? '',
                      onPressed: () {
                        context.read<AuthenticationService>().openBottomSheet(
                          event: Event.update,
                          params: {'email': user?.email},
                        );
                      },
                    ),
                    SizedBox(height: 18.v),
                    input(
                      label: "phone_number".tr,
                      hintText: user?.mobileNumber ?? '',
                      onPressed: () {
                        context.read<AuthenticationService>().openBottomSheet(
                          event: Event.update,
                          params: {'phone': user?.mobileNumber},
                        );
                      },
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
