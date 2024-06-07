import 'package:flutter/material.dart';
import '/core/app_export.dart';

class PhotosTab extends StatelessWidget {
  final Products product;

  const PhotosTab({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductPhotosProvider>(
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
                await provider.onRefresh(product.id);
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

          return MasonryGridView.count(
            crossAxisCount: 3,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            itemCount: data.length,
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) {
              ProductPhotos photos = data[index];
              return Tile(
                height: (index % 5 + 1) * 100,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.h),
                  child: CustomImageView(
                    fit: BoxFit.cover,
                    imagePath: photos.url,
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
