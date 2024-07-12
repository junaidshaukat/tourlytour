import 'package:flutter/material.dart';
import '/core/app_export.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({super.key});

  @override
  FavouriteScreenState createState() => FavouriteScreenState();
}

class FavouriteScreenState extends State<FavouriteScreen> {
  bool preloader = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        preloader = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Preloader(
      preloader: preloader,
      child: Scaffold(
        key: scaffoldKey,
        appBar: CustomAppBar(
          centerTitle: true,
          title: AppbarTitle(
            text: "bucket_list".tr,
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
                    imagePath: "arrow_left".icon.svg,
                  ),
                  onPressed: () {
                    NavigatorService.goBack();
                  },
                ),
              ),
            ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 10.h,
            vertical: 16.v,
          ),
          child: Consumer<FavouritesProvider>(
            builder: (context, provider, child) {
              Props props = provider.props;
              if (props.isNone || props.isLoading || props.isProcessing) {
                return SizedBox(
                  height: 135.v,
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
                  height: 135.v,
                  child: Center(
                    child: TryAgain(
                      imagePath: "refresh".icon.svg,
                      onRefresh: provider.onRefresh,
                    ),
                  ),
                );
              } else {
                List data = props.data as List;

                if (data.isEmpty) {
                  return SizedBox(
                    height: 135.v,
                    child: const Center(
                      child: NoRecordsFound(),
                    ),
                  );
                }

                return Wrap(
                  spacing: 8.h,
                  runSpacing: 8.v,
                  children: List.generate(data.length, (index) {
                    Favourites favourite = data[index];
                    return Container(
                      width: 180.h,
                      padding: EdgeInsets.symmetric(
                        horizontal: 2.h,
                        vertical: 2.v,
                      ),
                      decoration: AppDecoration.outlineBlack900.copyWith(
                        borderRadius: BorderRadiusStyle.roundedBorder15,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12.h),
                            child: CustomImageView(
                              width: 180.h,
                              fit: BoxFit.cover,
                              imagePath: favourite.products?.thumbnailUrl ?? "",
                              radius: BorderRadius.circular(12.h),
                            ),
                          ),
                          SizedBox(height: 6.v),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4.h),
                            child: SizedBox(
                              width: 150.h,
                              height: 30.v,
                              child: Text(
                                maxLines: 2,
                                favourite.products?.name ?? "",
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.labelMedium,
                              ),
                            ),
                          ),
                          SizedBox(height: 4.v),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      CustomImageView(
                                        imagePath: "star".icon.svg,
                                      ),
                                      SizedBox(width: 2.v),
                                      Text(
                                        "${favourite.products?.rating ?? "0"}",
                                        style: CustomTextStyles
                                            .labelMediumBluegray500,
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 20.v,
                                  width: 80.h,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: InkWell(
                                    onTap: () async {
                                      await provider.onRemove(favourite.id);
                                    },
                                    child: Text(
                                      "remove".tr,
                                      style:
                                          CustomTextStyles.labelMediumRedA200a2,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 4.v),
                        ],
                      ),
                    );
                  }),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
