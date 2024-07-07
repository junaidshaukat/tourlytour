import 'package:flutter/material.dart';
import '/core/app_export.dart';

class DiscoverPackgesScreen extends StatefulWidget {
  const DiscoverPackgesScreen({super.key});

  @override
  DiscoverPackgesScreenState createState() => DiscoverPackgesScreenState();
}

class DiscoverPackgesScreenState extends State<DiscoverPackgesScreen> {
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

  void onPressed(Products product) {
    context.read<ProductVideosProvider>().clear();
    context.read<ProductPhotosProvider>().clear();
    context.read<ProductReviewsProvider>().clear();
    context.read<ProductItinerariesProvider>().clear();

    NavigatorService.push(
      context,
      const ProductDetailsScreen(),
      arguments: product,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Preloader(
      preloader: preloader,
      child: Scaffold(
        appBar: CustomAppBar(
          centerTitle: false,
          title: Padding(
            padding: EdgeInsets.only(left: 16.h),
            child: AppbarTitle(
              text: "discover_packges".tr,
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
        body: Consumer<DiscoverProvider>(
          builder: (context, provider, child) {
            Props props = provider.props;
            if (props.isNone || props.isLoading) {
              return SizedBox(
                height: 135.v,
                child: const Center(
                  child: Loading(),
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

              return ListView.builder(
                shrinkWrap: true,
                itemCount: (data.length / 2).ceil(),
                itemBuilder: (context, index) {
                  final firstIndex = index * 2;
                  final secondIndex = index * 2 + 1;
                  if (secondIndex >= data.length) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ProductCard(
                          width: 190,
                          product: data[firstIndex],
                          onPressed: () {
                            onPressed(data[firstIndex]);
                          },
                        ),
                      ],
                    );
                  } else {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: ProductCard(
                            product: data[firstIndex],
                            onPressed: () {
                              onPressed(data[firstIndex]);
                            },
                          ),
                        ),
                        Expanded(
                          child: ProductCard(
                            product: data[secondIndex],
                            onPressed: () {
                              onPressed(data[secondIndex]);
                            },
                          ),
                        ),
                      ],
                    );
                  }
                },
              );
            }
          },
        ),
      ),
    );
  }
}
