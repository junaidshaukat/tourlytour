import 'package:flutter/material.dart';
import '/core/app_export.dart';

class CustomDrawer extends StatelessWidget {
  final void Function()? onPressed;
  final void Function()? onTap;

  const CustomDrawer({super.key, this.onPressed, this.onTap});

  Widget tab({
    String? icon,
    String? title,
    bool divider = true,
    void Function()? onPressed,
  }) {
    return Column(
      children: [
        ListTile(
          title: Row(
            children: [
              CustomImageView(
                size: 30.adaptSize,
                imagePath: icon,
              ),
              Padding(
                padding: EdgeInsets.only(left: 13.h),
                child: Text(
                  "$title",
                  style: theme.textTheme.titleSmall!.copyWith(
                    color: appTheme.black900,
                  ),
                ),
              ),
              const Spacer(),
              CustomImageView(
                imagePath: "arrow_right".icon.svg,
              )
            ],
          ),
          onTap: onPressed,
        ),
        if (divider)
          const Opacity(
            opacity: 0.2,
            child: Divider(),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(
            right: 12.h,
            top: 24.v,
            bottom: 24.v,
          ),
          child: InkWell(
            onTap: onTap != null
                ? () {
                    NavigatorService.goBack();
                    onTap!();
                  }
                : null,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 21.h,
                      vertical: 13.v,
                    ),
                    decoration: AppDecoration.fillPrimary.copyWith(
                      borderRadius: BorderRadiusStyle.customBorderLR42,
                    ),
                    child: Consumer<CurrentUserProvider>(
                      builder: (BuildContext context, provider, Widget? child) {
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: appTheme.gray500,
                          child: CustomImageView(
                            width: 34,
                            height: 34,
                            onTap: onTap,
                            fit: BoxFit.cover,
                            imagePath: provider.avatar,
                            placeHolder: 'profile'.image.png,
                            radius: BorderRadius.circular(100),
                          ),
                        );

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundColor: appTheme.gray500,
                              child: CustomImageView(
                                width: 44,
                                height: 44,
                                fit: BoxFit.cover,
                                placeHolder: 'profile',
                                imagePath: provider.avatar,
                                radius: BorderRadius.circular(100),
                              ),
                            ),
                            SizedBox(
                              width: 120.h,
                              child: Padding(
                                padding: EdgeInsets.only(
                                  left: 3.h,
                                  top: 12.v,
                                  bottom: 17.v,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 100.h,
                                      child: Text(
                                        provider.name,
                                        overflow: TextOverflow.ellipsis,
                                        style: CustomTextStyles
                                            .titleSmallGray90002,
                                      ),
                                    ),
                                    Text(
                                      "view_profile".tr,
                                      style:
                                          CustomTextStyles.labelMediumGray900,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            const Spacer(),
                            CustomImageView(
                              width: 45.h,
                              height: 34.v,
                              color: appTheme.whiteA700,
                              imagePath: "logo".icon.svg,
                            )
                          ],
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(width: 6.h),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: appTheme.whiteA700,
                  ),
                  child: IconButton(
                    color: Colors.white,
                    icon: CustomImageView(
                      color: appTheme.black900,
                      imagePath: "arrow_left".icon.svg,
                    ),
                    onPressed: onPressed,
                  ),
                ),
              ],
            ),
          ),
        ),
        tab(
          title: 'special_deals'.tr,
          icon: 'special_deals'.icon.svg,
          onPressed: () {},
        ),
        tab(
          title: 'discover'.tr,
          icon: 'discover'.icon.svg,
          onPressed: () {
            NavigatorService.goBack();
            NavigatorService.push(
              context,
              const DiscoverPackgesScreen(),
            );
          },
        ),
        tab(
          title: 'tours'.tr,
          icon: 'tour'.icon.svg,
          onPressed: () {
            NavigatorService.goBack();
            NavigatorService.push(
              context,
              const ToursScreen(),
            );
          },
        ),
        tab(
          title: 'eng_us'.tr,
          icon: 'eng_us'.icon.svg,
          onPressed: () {},
        ),
        tab(
          title: 'usd'.tr,
          icon: 'usd'.icon.svg,
          onPressed: () {},
        ),
        tab(
          title: 'blog'.tr,
          icon: 'blog'.icon.svg,
          onPressed: () {
            NavigatorService.goBack();
            NavigatorService.push(
              context,
              const BlogsScreen(),
            );
          },
        ),
        tab(
          title: 'wishlist'.tr,
          icon: 'wishlist'.icon.svg,
          onPressed: () {
            NavigatorService.goBack();
            NavigatorService.push(
              context,
              const FavouriteScreen(),
            );
          },
        ),
        tab(
          title: 'contact_us'.tr,
          icon: 'contact_us'.icon.svg,
          onPressed: () {},
        ),
        tab(
          title: 'terms_condition'.tr,
          icon: 'terms_condition'.icon.svg,
          onPressed: () {},
        ),
        tab(
          divider: false,
          title: 'log_out'.tr,
          icon: 'sign_up'.icon.svg,
          onPressed: () {
            context.read<AuthenticationProvider>().signOut().then((res) {
              context.read<DependenciesProvider>().onReady().then((res) {});
              NavigatorService.goBack();
            });
          },
        ),
      ],
    );
  }
}
