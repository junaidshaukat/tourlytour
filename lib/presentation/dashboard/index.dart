import 'package:flutter/material.dart';
import '/core/app_export.dart';

export 'widgets/export.dart';
export 'screens/export.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  DashboardScreenState createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {
  bool preloader = true;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late ReviewService review;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      review = context.read<ReviewService>();

      review.fetch(context);
      setState(() {
        preloader = false;
      });
    });
  }

  Widget featured(
    BuildContext context, {
    bool horizontal = true,
  }) {
    if (horizontal) {
      return SizedBox(
        height: 300.v,
        child: Consumer<ProductsProvider>(
          builder: (context, provider, child) {
            Props props = provider.props;
            if (props.isNone || props.isLoading) {
              return SizedBox(
                height: 300.v,
                child: const Center(
                  child: Loading(),
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
              List data = props.data as List;
              if (data.isEmpty) {
                return SizedBox(
                  height: 300.v,
                  child: const Center(
                    child: NoRecordsFound(),
                  ),
                );
              }

              return ListView.separated(
                padding: EdgeInsets.only(left: 10.h),
                scrollDirection: Axis.horizontal,
                separatorBuilder: (context, index) {
                  return SizedBox(
                    width: 10.h,
                  );
                },
                itemCount: data.length,
                itemBuilder: (context, index) {
                  Products product = data[index];
                  return HorizontalProductCard(
                    product: product,
                    onPressed: () async {
                      context.read<ProductVideosProvider>().clear();
                      context.read<ProductPhotosProvider>().clear();
                      context.read<ProductReviewsProvider>().clear();
                      context.read<ProductItinerariesProvider>().clear();

                      NavigatorService.push(
                        context,
                        const ProductDetailsScreen(),
                        arguments: product,
                      );
                    },
                  );
                },
              );
            }
          },
        ),
      );
    } else {
      return Consumer<ProductsProvider>(
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

            return ListView.separated(
              shrinkWrap: true,
              itemCount: data.length,
              scrollDirection: Axis.vertical,
              padding: EdgeInsets.symmetric(horizontal: 10.h),
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                Products product = data[index];
                return VerticalProductCard(
                  product: product,
                  onPressed: () {},
                );
              },
              separatorBuilder: (context, index) {
                return SizedBox(
                  height: 10.v,
                );
              },
            );
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Preloader(
      preloader: preloader,
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: appTheme.whiteA700,
        appBar: Appbar(
          onTap: () {
            NavigatorService.push(context, const ProfileScreen());
          },
          onPressed: () {
            if (mounted) scaffoldKey.currentState?.openDrawer();
          },
        ),
        drawer: Drawer(
          child: CustomDrawer(
            onTap: () {
              NavigatorService.push(context, const ProfileScreen());
            },
            onPressed: () {
              if (mounted) scaffoldKey.currentState?.closeDrawer();
            },
          ),
        ),
        body: SizedBox(
          width: SizeUtils.width,
          child: SingleChildScrollView(
            padding: EdgeInsets.only(top: 19.v),
            child: Padding(
              padding: EdgeInsets.only(bottom: 5.v),
              child: Column(
                children: [
                  Heading(
                    onPressed: () {
                      NavigatorService.push(context, const SearchScreen());
                    },
                  ),
                  SizedBox(height: 21.v),
                  FeaturedPackage(
                    onPressed: () {
                      NavigatorService.push(
                        context,
                        const FeaturedPackgesScreen(),
                      );
                    },
                  ),
                  SizedBox(height: 2.v),
                  featured(context),
                  SizedBox(height: 16.v),
                  featured(context, horizontal: false),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
