import 'package:flutter/material.dart';
import '/core/app_export.dart';

class ReviewTab extends StatefulWidget {
  final Products product;

  const ReviewTab({super.key, required this.product});

  @override
  ReviewTabState createState() => ReviewTabState();
}

class ReviewTabState extends State<ReviewTab> {
  Widget progress({String? title, String? value}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 3.v),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "$title",
                style: CustomTextStyles.bodySmallBlack900Regular,
              ),
              SizedBox(height: 3.v),
              Container(
                height: 7.v,
                width: 140.h,
                decoration: BoxDecoration(
                  color: appTheme.amber100,
                  borderRadius: BorderRadius.circular(
                    3.h,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                    3.h,
                  ),
                  child: LinearProgressIndicator(
                    value: (num.parse(value!) * 0.1),
                    backgroundColor: appTheme.amber100,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      theme.colorScheme.primary,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            left: 7.h,
            top: 13.v,
          ),
          child: Text(
            value,
            style: CustomTextStyles.bodySmallBlack900Regular,
          ),
        )
      ],
    );
  }

  Widget reviewCard({int index = 0, required ProductReviews reviews}) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 44.h,
              height: 44.h,
              child: CircleAvatar(
                child: CustomImageView(
                  width: 44.h,
                  height: 44.h,
                  fit: BoxFit.cover,
                  imagePath: "product".image.png,
                  radius: BorderRadius.circular(100),
                ),
              ),
            ),
            SizedBox(width: 6.h),
            SizedBox(
              width: 300.h,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    reviews.user?.name ?? "",
                    style: theme.textTheme.labelLarge,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "${reviews.rate ?? "0"}",
                        style: CustomTextStyles.titleSmallBluegray500,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: 2.h,
                          top: 4.v,
                          bottom: 5.v,
                        ),
                        child: CustomRatingBar(
                          color: appTheme.yellow800,
                          unselectedColor: appTheme.black900,
                          initialRating: reviews.rate?.toDouble() ?? 0,
                        ),
                      ),
                      const Spacer(),
                      CustomImageView(
                        imagePath: "thumb".icon.svg,
                      ),
                      SizedBox(width: 2.h),
                      Text(
                        "helpful".tr,
                        style: CustomTextStyles.bodySmallGray600,
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          width: SizeUtils.width,
          child: Text(
            reviews.description ?? "",
            textAlign: TextAlign.justify,
            style: CustomTextStyles.bodySmallBluegray500,
          ),
        ),
        SizedBox(height: 4.v),
        SizedBox(
          height: 90.adaptSize,
          width: SizeUtils.width,
          child: Align(
            alignment:
                index.isEven ? Alignment.centerLeft : Alignment.centerRight,
            child: ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              scrollDirection: Axis.horizontal,
              itemCount: reviews.photos.length,
              itemBuilder: (BuildContext context, int index) {
                ProductReviewPhotos photos = reviews.photos[index];
                return CustomImageView(
                  fit: BoxFit.cover,
                  width: 90.adaptSize,
                  height: 90.adaptSize,
                  imagePath: photos.url,
                  radius: BorderRadius.circular(
                    10.h,
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return SizedBox(width: 6.h);
              },
            ),
          ),
        ),
        SizedBox(height: 12.v),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: SizeUtils.width,
      child: SingleChildScrollView(
        child: Consumer<ProductReviewsProvider>(
            builder: (context, provider, child) {
          Props props = provider.props;
          if (props.isNone || props.isLoading) {
            return SizedBox(
              height: 230.v,
              child: const Loading(),
            );
          } else if (props.isError) {
            return Padding(
              padding: EdgeInsets.all(8.adaptSize),
              child: TryAgain(
                imagePath: "refresh".icon.svg,
                onRefresh: () async {
                  await provider.onRefresh(widget.product.id);
                },
              ),
            );
          } else {
            List data = props.data as List;
            if (data.isEmpty) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 60.v),
                child: const NoRecordsFound(
                  mainAxisAlignment: MainAxisAlignment.start,
                ),
              );
            }

            return Column(
              children: [
                SizedBox(height: 6.v),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    progress(
                      title: 'seamless_experience'.tr,
                      value: provider.seamlessExperience(data),
                    ),
                    progress(
                      title: 'hospitality'.tr,
                      value: provider.hospitality(data),
                    ),
                  ],
                ),
                SizedBox(height: 6.v),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    progress(
                      title: 'value_for_money'.tr,
                      value: provider.valueForMoney(data),
                    ),
                    progress(
                      title: 'impressiveness'.tr,
                      value: provider.impressiveness(data),
                    ),
                  ],
                ),
                SizedBox(height: 12.v),
                Wrap(
                  direction: Axis.horizontal,
                  children: List.generate(data.length, (index) {
                    ProductReviews reviews = data[index];
                    return reviewCard(index: index, reviews: reviews);
                  }),
                ),
              ],
            );
          }
        }),
      ),
    );
  }
}
