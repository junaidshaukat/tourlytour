import 'package:flutter/material.dart';
import '/core/app_export.dart';

class AuthenticationService with ChangeNotifier {
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

  AuthenticationService(this.context) {
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

  void onSignin(BuildContext ctx) {
    openBottomSheet(ctx);
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
