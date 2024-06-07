import 'package:flutter/material.dart';
import '/core/app_export.dart';

class AboutScreen extends StatefulWidget {
  final Products product;

  const AboutScreen({super.key, required this.product});

  @override
  AboutScreenState createState() => AboutScreenState();
}

class AboutScreenState extends State<AboutScreen> {
  ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: SizeUtils.width,
      child: Consumer<ProductItinerariesProvider>(
        builder: (context, provider, child) {
          Props props = provider.props;
          if (props.isNone || props.isLoading) {
            return SingleChildScrollView(
              child: SizedBox(
                height: 230.v,
                child: const Loading(),
              ),
            );
          } else if (props.isError) {
            return SingleChildScrollView(
              child: SizedBox(
                height: 230.v,
                child: Padding(
                  padding: EdgeInsets.all(8.adaptSize),
                  child: TryAgain(
                    imagePath: "refresh".icon.svg,
                    onRefresh: () async {
                      await provider.onRefresh(widget.product.id);
                    },
                  ),
                ),
              ),
            );
          } else {
            List data = props.data as List;
            if (data.isEmpty) {
              return SingleChildScrollView(
                child: SizedBox(
                  height: 230.v,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 30.v),
                    child: const NoRecordsFound(
                      mainAxisAlignment: MainAxisAlignment.start,
                    ),
                  ),
                ),
              );
            }

            return SingleChildScrollView(
              controller: controller,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 14.v),
                  SizedBox(
                    height: 50.v,
                    child: ListView.separated(
                      controller: controller,
                      itemCount: data.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        ProductItineraries itineraries = data[index];
                        return ClipOval(
                          child: Container(
                            color: appTheme.black900.withOpacity(0.4),
                            width: 50.v,
                            height: 50.v,
                            child: Center(
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Opacity(
                                    opacity: 0.8,
                                    child: CustomImageView(
                                      width: 50.v,
                                      height: 50.v,
                                      fit: BoxFit.cover,
                                      imagePath: itineraries.iconUrl,
                                      radius: BorderRadius.circular(100),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 39.h,
                                    child: Text(
                                      "${itineraries.title}",
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 6.fSize,
                                        fontFamily: 'Poppins',
                                        color: appTheme.whiteA700,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(
                          width: 15.h,
                          child: CustomImageView(
                            imagePath: "dash-line".icon.svg,
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 14.v),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "what_to_expect".tr,
                        style: theme.textTheme.labelLarge,
                      ),
                      SizedBox(height: 5.v),
                      Text(
                        "${widget.product.longDescription}",
                        maxLines: 13,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.justify,
                        style: CustomTextStyles.bodySmallBluegray500,
                      )
                    ],
                  ),
                  SizedBox(height: 20.v),
                  Text(
                    "itinerary".tr,
                    style: theme.textTheme.labelLarge,
                  ),
                  SizedBox(height: 4.v),
                  SizedBox(
                    height: 400.v,
                    child: ListView.builder(
                      controller: controller,
                      itemCount: data.length,
                      padding: EdgeInsets.zero,
                      itemBuilder: (BuildContext context, int index) {
                        ProductItineraries itineraries = data[index];

                        return IntrinsicHeight(
                          child: Timeline(
                            index: index,
                            length: data.length,
                            title: itineraries.title,
                            description: itineraries.description,
                            imagePath: itineraries.imageUrl,
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

class Timeline extends StatelessWidget {
  final String? title;
  final String? imagePath;
  final String? description;
  final int index;
  final int length;

  const Timeline({
    super.key,
    this.title,
    this.description,
    this.imagePath,
    this.index = 0,
    this.length = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          children: [
            CircleAvatar(
              child: CustomImageView(
                fit: BoxFit.cover,
                width: 50.adaptSize,
                height: 50.adaptSize,
                imagePath: imagePath,
                radius: BorderRadius.circular(25.h),
              ),
            ),
            if (index < length - 1)
              Expanded(
                child: CustomPaint(
                  size: const Size(0.5, double.infinity),
                  painter: DashLinePainter(),
                ),
              ),
          ],
        ),
        SizedBox(width: 10.v),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      title ?? "",
                      style: theme.textTheme.labelLarge,
                    ),
                  ),
                  Text(
                    "12:30", // Replace with your time
                    style: CustomTextStyles.labelLargeOnErrorContainer,
                  ),
                ],
              ),
              Text(
                description ?? "",
                style: CustomTextStyles.bodySmallBluegray500,
              ),
              SizedBox(height: 24.v),
            ],
          ),
        ),
      ],
    );
  }
}

class DashLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const double dashWidth = 5;
    const double dashSpace = 5;
    double startY = 0;

    while (startY < size.height) {
      canvas.drawLine(
        Offset(size.width / 2, startY),
        Offset(size.width / 2, startY + dashWidth),
        paint,
      );
      startY += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
