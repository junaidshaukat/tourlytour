import 'dart:io';

import 'package:flutter/material.dart';
import '/core/app_export.dart';

class ReviewService with ChangeNotifier {
  ImagePicker picker = ImagePicker();

  late ConnectivityProvider connectivity;
  late CurrentUserProvider currentUser;

  final BuildContext context;
  final supabase = Supabase.instance.client;

  Props props = Props(data: [], initialData: []);

  ReviewService(this.context) {
    connectivity = context.read<ConnectivityProvider>();
    currentUser = context.read<CurrentUserProvider>();
  }

  Future<void> submit() async {
    try {
      props.setProcessing();
      notifyListeners();

      if (!connectivity.isConnected) {
        throw NoInternetException();
      }

      Future.delayed(const Duration(seconds: 5));

      props.setSuccess();
      notifyListeners();
    } on NoInternetException catch (error) {
      console.log(error, 'AuthenticationProvider::signin::NoInternetException');
      props.setError(currentError: error.toString());
      notifyListeners();
    } on CustomException catch (error) {
      console.log(error, 'AuthenticationProvider::signin::CustomException');
      props.setError(currentError: error.toString());
      notifyListeners();
    } on AuthException catch (error) {
      console.log(error,
          'AuthenticationProvider::signin::AuthException::AuthException');
      props.setError(currentError: error.message.toString());
      notifyListeners();
    } catch (error) {
      console.log(error, 'AuthenticationProvider::signin');
      props.setError(currentError: "something_went_wrong".tr);
      notifyListeners();
    }
  }

  void fetch(BuildContext ctx, [int seconds = 5]) {
    Future.delayed(Duration(seconds: seconds), () {
      if (!connectivity.isConnected) {
        throw NoInternetException();
      }
      supabase
          .from('Orders')
          .select()
          .eq('isReview', 0)
          .eq('UserId', currentUser.id)
          .single()
          .then((response) {
        console.log(response);
        openBottomSheet(ctx);
      });
    });
  }

  void openBottomSheet(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16.h),
        ),
      ),
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          snap: true,
          expand: false,
          minChildSize: 0.25,
          initialChildSize: 0.8,
          builder: (context, controller) {
            String? errMsg;
            List photos = [];
            List<ProductReviewPhotos> removePhotos = [];

            return StatefulBuilder(
              builder: (context, setState) {
                return PopScope(
                    canPop: false,
                    onPopInvoked: (pop) {
                      console.log(pop);
                    },
                    child: Container(
                      width: double.maxFinite,
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.h,
                        vertical: 8.v,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(16.h),
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              Text(
                                "submit_your_last_experience_review".tr,
                                style: TextStyle(
                                  fontSize: 14.fSize,
                                  fontFamily: 'Poppins',
                                  color: appTheme.black900,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const Spacer(),
                              IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: const Icon(
                                  Icons.close,
                                  color: Colors.amber,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4.0),
                          const HorizontalDivider(),
                          const SizedBox(height: 4.0),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              CustomImageView(
                                fit: BoxFit.cover,
                                height: 94.adaptSize,
                                width: 100.adaptSize,
                                imagePath: "product".image.png,
                                radius: BorderRadius.circular(
                                  10.h,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  left: 13.h,
                                  bottom: 26.v,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 196.h,
                                      child: Text(
                                        "Product Name",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style:
                                            CustomTextStyles.labelLargeSemiBold,
                                      ),
                                    ),
                                    SizedBox(height: 5.v),
                                    Text(
                                      "\$85 ${"usd".tr}",
                                      style: theme.textTheme.titleMedium,
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 8.0),
                          CustomTextFormField(
                            maxLines: 4,
                            onChanged: (val) {},
                          ),
                          const SizedBox(height: 4.0),
                          const HorizontalDivider(),
                          const SizedBox(height: 4.0),
                          LabelReview(
                            label: 'hospitality'.tr,
                            onChange: (val) {},
                          ),
                          const SizedBox(height: 4.0),
                          const HorizontalDivider(),
                          const SizedBox(height: 4.0),
                          LabelReview(
                            label: 'impressiveness'.tr,
                            onChange: (val) {},
                          ),
                          const SizedBox(height: 4.0),
                          const HorizontalDivider(),
                          const SizedBox(height: 4.0),
                          LabelReview(
                            label: 'value_for_money'.tr,
                            onChange: (val) {},
                          ),
                          const SizedBox(height: 4.0),
                          const HorizontalDivider(),
                          const SizedBox(height: 4.0),
                          LabelReview(
                            label: 'seamless_experience'.tr,
                            onChange: (val) {},
                          ),
                          const SizedBox(height: 4.0),
                          const HorizontalDivider(),
                          const SizedBox(height: 4.0),
                          SizedBox(
                            height: 80,
                            child: ListView.separated(
                              padding: EdgeInsets.zero,
                              itemCount: photos.length + 1,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                if (index == photos.length) {
                                  return GestureDetector(
                                    onTap: () {
                                      picker
                                          .pickMultiImage(limit: 4)
                                          .then((files) {
                                        if (files.isNotEmpty) {
                                          if (files.length > 4) {
                                            errMsg =
                                                'Please select up to 4 images only.';
                                            setState(() {});
                                          } else {
                                            errMsg = null;
                                            photos.addAll(files);
                                            setState(() {});
                                          }
                                        }
                                      });
                                    },
                                    child: Container(
                                      width: 80,
                                      height: 80,
                                      color: Colors.grey[300],
                                      child: const Icon(
                                        Icons.add_a_photo,
                                        size: 50,
                                      ),
                                    ),
                                  );
                                } else {
                                  return Stack(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: photos[index] is XFile
                                            ? Image.file(
                                                width: 80,
                                                height: 80,
                                                fit: BoxFit.cover,
                                                File(photos[index].path),
                                              )
                                            : Image.network(
                                                width: 80,
                                                height: 80,
                                                fit: BoxFit.cover,
                                                photos[index].url,
                                              ),
                                      ),
                                      Positioned(
                                        right: 0,
                                        top: 0,
                                        child: GestureDetector(
                                          onTap: () {
                                            bool xFile = photos[index] is XFile;

                                            if (!xFile) {
                                              removePhotos.add(photos[index]);
                                            }

                                            setState(() {
                                              photos.removeAt(index);
                                            });
                                          },
                                          child: Container(
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.red,
                                            ),
                                            child: const Icon(
                                              Icons.remove_circle,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return SizedBox(width: 4.h);
                              },
                            ),
                          ),
                          if (errMsg != null)
                            Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                Text(
                                  "$errMsg",
                                  style: TextStyle(
                                    fontSize: 14.fSize,
                                    fontFamily: 'Poppins',
                                    color: appTheme.black900,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          if (errMsg != null) const SizedBox(height: 4.0),
                          const SizedBox(height: 4.0),
                          Consumer<ReviewService>(
                            builder: (BuildContext context, provider,
                                Widget? child) {
                              Props props = provider.props;
                              if (props.isProcessing) {
                                return CustomElevatedButton(
                                  text: "",
                                  height: 50.v,
                                  leftIcon: CustomProgressButton(
                                    lable: 'processing'.tr,
                                    textStyle:
                                        CustomTextStyles.titleLargeBlack900,
                                  ),
                                  buttonStyle:
                                      CustomButtonStyles.fillPrimaryTL29,
                                  buttonTextStyle:
                                      CustomTextStyles.titleLargeBlack900,
                                );
                              } else {
                                if (props.isError) {
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        props.error ?? '',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 12.fSize,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w400,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .error,
                                        ),
                                      ),
                                      SizedBox(height: 6.v),
                                      CustomElevatedButton(
                                        height: 50.v,
                                        text: "submit_review".tr,
                                        buttonStyle:
                                            CustomButtonStyles.fillPrimaryTL29,
                                        buttonTextStyle:
                                            CustomTextStyles.titleLargeWhite900,
                                        onPressed: () async {
                                          await provider.submit();
                                        },
                                      )
                                    ],
                                  );
                                }

                                return CustomElevatedButton(
                                  height: 50.v,
                                  text: "submit_review".tr,
                                  buttonStyle:
                                      CustomButtonStyles.fillPrimaryTL29,
                                  buttonTextStyle:
                                      CustomTextStyles.titleLargeWhite900,
                                  onPressed: () async {
                                    await provider.submit();
                                  },
                                );
                              }
                            },
                          ),
                          // CustomElevatedButton(
                          //   text: "submit_review".tr,
                          //   buttonStyle: CustomButtonStyles.fillYellow,
                          //   buttonTextStyle:
                          //       CustomTextStyles.titleLargeBlack900.copyWith(
                          //     color: appTheme.whiteA700,
                          //   ),
                          //   onPressed: () {},
                          // ),
                        ],
                      ),
                    ));
              },
            );
          },
        );
      },
    );
  }
}
