import 'dart:io';

import 'package:flutter/material.dart';
import '/core/app_export.dart';

class ReviewService with ChangeNotifier {
  ImagePicker picker = ImagePicker();

  late ToursProvider tours;
  late ConnectivityProvider connectivity;
  late CurrentUserProvider currentUser;
  late ProductReviewsProvider productReviews;

  final BuildContext context;
  final supabase = Supabase.instance.client;

  Props props = Props(data: [], initialData: []);

  Props propsEvent = Props(data: [], initialData: []);

  num rating = 1;
  num hospitality = 1;
  num impressiveness = 1;
  num valueForMoney = 1;
  num seamlessExperience = 1;

  String? errMsg;
  List photos = [];
  String? description;
  List<ProductReviewPhotos> remove = [];

  TextEditingController descriptionController = TextEditingController();

  ReviewService(this.context) {
    tours = context.read<ToursProvider>();
    connectivity = context.read<ConnectivityProvider>();
    currentUser = context.read<CurrentUserProvider>();
    productReviews = context.read<ProductReviewsProvider>();
  }

  String get trace {
    final stackTrace = StackTrace.current;
    final frames = stackTrace.toString().split('\n');

    if (frames.length > 1) {
      final callerFrame = frames[1].trim();
      final regex = RegExp(r'#\d+\s+(\S+)\.(\S+)\s+\(.*\)');
      final match = regex.firstMatch(callerFrame);

      if (match != null) {
        final className = match.group(1);
        final methodName = match.group(2);
        return "$className::$methodName";
      } else {
        // here get auto class name and method where it call
        return "$runtimeType::unknown";
      }
    } else {
      // here get auto class name and method where it call
      return "$runtimeType::unknown";
    }
  }

  Future<void> create(ReviewsPending item) async {
    try {
      props.setProcessing();
      notifyListeners();

      if (!connectivity.isConnected) {
        throw NoInternetException();
      }

      ProductReviews reviews = ProductReviews(
        rate: rating,
        userId: currentUser.id,
        description: description,
        hospitality: hospitality,
        valueForMoney: valueForMoney,
        impressiveness: impressiveness,
        productId: item.order.productId,
        seamlessExperience: seamlessExperience,
      );

      final response =
          await productReviews.create(reviews, photos, item.order.id);
      if (response != null) {
        props.setSuccess();
        notifyListeners();
        await tours.onReady();
        await tours.onDetails(item.order.id);
        NavigatorService.goBack();
      } else {
        throw CustomException("");
      }
    } on NoInternetException catch (error) {
      console.internet(error, trace);
      props.setError(currentError: error.toString());
      notifyListeners();
    } on CustomException catch (error) {
      console.custom(error, trace);
      props.setError(currentError: error.toString());
      notifyListeners();
    } on AuthException catch (error) {
      console.authentication(error, trace);
      props.setAuthException(currentError: error.message.toString());
      notifyListeners();
    } catch (error) {
      console.error(error, trace);
      props.setError(currentError: "something_went_wrong".tr);
      notifyListeners();
    }
  }

  Future<void> update(ReviewsPending item, ProductReviews? arguments) async {
    try {
      props.setProcessing();
      notifyListeners();

      if (!connectivity.isConnected) {
        throw NoInternetException();
      }

      ProductReviews reviews = ProductReviews(
        rate: rating,
        id: arguments?.id,
        userId: currentUser.id,
        description: description,
        hospitality: hospitality,
        valueForMoney: valueForMoney,
        impressiveness: impressiveness,
        productId: item.order.productId,
        seamlessExperience: seamlessExperience,
      );

      final response = await productReviews.update(reviews, photos, remove);
      if (response != null) {
        props.setSuccess();
        notifyListeners();
        await tours.onReady();
        await tours.onDetails(item.order.id);
        NavigatorService.goBack();
      } else {
        throw CustomException("");
      }
    } on NoInternetException catch (error) {
      console.internet(error, trace);
      props.setError(currentError: error.toString());
      notifyListeners();
    } on CustomException catch (error) {
      console.custom(error, trace);
      props.setError(currentError: error.toString());
      notifyListeners();
    } on AuthException catch (error) {
      console.authentication(error, trace);
      props.setAuthException(currentError: error.message.toString());
      notifyListeners();
    } catch (error) {
      console.error(error, trace);
      props.setError(currentError: "something_went_wrong".tr);
      notifyListeners();
    }
  }

  Future<void> submit(ReviewsPending item, String action,
      {ProductReviews? arguments}) async {
    if (action == 'create') {
      await create(item);
    }

    if (action == 'update') {
      await update(item, arguments);
    }
  }

  void fetch(
    BuildContext ctx, {
    num? id,
    int seconds = 5,
    String action = 'create',
    ProductReviews? arguments,
  }) {
    Future.delayed(Duration(seconds: seconds), () {
      if (!connectivity.isConnected) {
        throw NoInternetException();
      }

      supabase.rpc('reviews_pending', params: {
        'data': {'UserId': currentUser.id, 'Id': id}
      }).then((response) {
        if (response != null) {
          openBottomSheet(
            ctx,
            action: action,
            arguments: arguments,
            ReviewsPending.fromJson(response),
          );
        }
      });
    });
  }

  void openBottomSheet(
    BuildContext ctx,
    ReviewsPending item, {
    String action = 'create',
    ProductReviews? arguments,
  }) {
    errMsg = null;
    photos = [];
    remove = [];
    rating = 1;
    hospitality = 1;
    impressiveness = 1;
    valueForMoney = 1;
    seamlessExperience = 1;

    if (arguments != null) {
      rating = arguments.rate ?? 1;
      hospitality = arguments.hospitality ?? 1;
      impressiveness = arguments.impressiveness ?? 1;
      valueForMoney = arguments.valueForMoney ?? 1;
      seamlessExperience = arguments.seamlessExperience ?? 1;

      description = arguments.description;
      descriptionController.text =
          arguments.description ?? 'enter_your_review'.tr;

      for (var e in arguments.photos) {
        photos.add(e);
      }
    }

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
            return StatefulBuilder(
              builder: (context, setState) {
                return PopScope(
                  canPop: false,
                  onPopInvoked: (pop) {},
                  child: Container(
                    width: double.maxFinite,
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.h,
                      vertical: 4.v,
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
                        SizedBox(height: 2.v),
                        const HorizontalDivider(),
                        SizedBox(height: 2.v),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CustomImageView(
                              fit: BoxFit.cover,
                              height: 94.adaptSize,
                              width: 100.adaptSize,
                              imagePath: item.product.thumbnailUrl,
                              radius: BorderRadius.circular(
                                10.h,
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(
                                  left: 13.h,
                                  bottom: 26.v,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      child: Text(
                                        maxLines: 2,
                                        item.product.name ?? '',
                                        overflow: TextOverflow.ellipsis,
                                        style:
                                            CustomTextStyles.labelLargeSemiBold,
                                      ),
                                    ),
                                    SizedBox(height: 2.v),
                                    Text(
                                      "Order Number: ${item.order.orderNumber ?? ''}",
                                      overflow: TextOverflow.ellipsis,
                                      style:
                                          CustomTextStyles.labelLargeSemiBold,
                                    ),
                                    SizedBox(height: 2.v),
                                    Row(
                                      children: [
                                        Text(
                                          "Price: \$${item.order.totalAmount ?? ''} ${"usd".tr}",
                                          overflow: TextOverflow.ellipsis,
                                          style: CustomTextStyles
                                              .labelLargeSemiBold,
                                        ),
                                        SizedBox(width: 16.h),
                                        Text(
                                          "${'people'.tr} ${item.order.totalNumberOfGuest}",
                                          overflow: TextOverflow.ellipsis,
                                          style: CustomTextStyles
                                              .labelLargeSemiBold,
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 2.v),
                        CustomTextFormField(
                          maxLines: 4,
                          hintText: 'enter_your_review'.tr,
                          controller: descriptionController,
                          textStyle: CustomTextStyles.titleLargeBlack900,
                          hintStyle: CustomTextStyles.titleLargeBlack900,
                          onChanged: (val) {
                            setState(() {
                              description = val;
                            });
                          },
                        ),
                        SizedBox(height: 2.v),
                        const HorizontalDivider(),
                        SizedBox(height: 2.v),
                        LabelReview(
                          label: 'rating'.tr,
                          initial: rating.toDouble(),
                          onChanged: (val) {
                            setState(() {
                              rating = val.toInt();
                            });
                          },
                        ),
                        SizedBox(height: 2.v),
                        const HorizontalDivider(),
                        SizedBox(height: 2.v),
                        LabelReview(
                          label: 'hospitality'.tr,
                          initial: hospitality.toDouble(),
                          onChanged: (val) {
                            setState(() {
                              hospitality = val.toInt();
                            });
                          },
                        ),
                        SizedBox(height: 2.v),
                        const HorizontalDivider(),
                        SizedBox(height: 2.v),
                        LabelReview(
                          label: 'impressiveness'.tr,
                          initial: impressiveness.toDouble(),
                          onChanged: (val) {
                            setState(() {
                              impressiveness = val.toInt();
                            });
                          },
                        ),
                        SizedBox(height: 2.v),
                        const HorizontalDivider(),
                        SizedBox(height: 2.v),
                        LabelReview(
                          label: 'value_for_money'.tr,
                          initial: valueForMoney.toDouble(),
                          onChanged: (val) {
                            setState(() {
                              valueForMoney = val.toInt();
                            });
                          },
                        ),
                        SizedBox(height: 2.v),
                        const HorizontalDivider(),
                        SizedBox(height: 2.v),
                        LabelReview(
                          label: 'seamless_experience'.tr,
                          initial: seamlessExperience.toDouble(),
                          onChanged: (val) {
                            setState(() {
                              seamlessExperience = val.toInt();
                            });
                          },
                        ),
                        SizedBox(height: 2.v),
                        const HorizontalDivider(),
                        SizedBox(height: 2.v),
                        SizedBox(
                          height: 70.v,
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
                                        int length =
                                            files.length + photos.length;
                                        if (length > 4) {
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
                                    width: 70.h,
                                    height: 70.v,
                                    color: Colors.grey[300],
                                    child: Icon(
                                      Icons.add_a_photo,
                                      size: 50.adaptSize,
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
                                              width: 70.h,
                                              height: 70.v,
                                              fit: BoxFit.cover,
                                              File(photos[index].path),
                                            )
                                          : Image.network(
                                              width: 70.h,
                                              height: 70.v,
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
                                            remove.add(photos[index]);
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
                        if (errMsg != null) SizedBox(height: 2.v),
                        SizedBox(height: 2.v),
                        Consumer<ReviewService>(
                          builder:
                              (BuildContext context, provider, Widget? child) {
                            Props props = provider.props;
                            if (props.isProcessing) {
                              return CustomElevatedButton(
                                text: "",
                                height: 50.v,
                                leftIcon: CustomProgressButton(
                                  lable: 'processing'.tr,
                                  textStyle:
                                      CustomTextStyles.titleLargeWhite900,
                                ),
                                buttonStyle: CustomButtonStyles.fillPrimaryTL29,
                                buttonTextStyle:
                                    CustomTextStyles.titleLargeWhite900,
                              );
                            } else {
                              if (props.isError) {
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      props.error ?? '',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 12.fSize,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w400,
                                        color:
                                            Theme.of(context).colorScheme.error,
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
                                        await provider.submit(
                                          item,
                                          action,
                                          arguments: arguments,
                                        );
                                      },
                                    )
                                  ],
                                );
                              }

                              return CustomElevatedButton(
                                height: 50.v,
                                text: "submit_review".tr,
                                buttonStyle: CustomButtonStyles.fillPrimaryTL29,
                                buttonTextStyle:
                                    CustomTextStyles.titleLargeWhite900,
                                onPressed: () async {
                                  await provider.submit(
                                    item,
                                    action,
                                    arguments: arguments,
                                  );
                                },
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
