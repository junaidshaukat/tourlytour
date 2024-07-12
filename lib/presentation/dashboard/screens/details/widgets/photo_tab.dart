import 'package:flutter/material.dart';
import '/core/app_export.dart';

class PhotosTab extends StatelessWidget {
  final List<ProductPhotos> photos;

  const PhotosTab({super.key, required this.photos});

  @override
  Widget build(BuildContext context) {
    if (photos.isEmpty) {
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
      itemCount: photos.length,
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        ProductPhotos photo = photos[index];
        return Tile(
          height: (index % 5 + 1) * 100,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.h),
            child: CustomImageView(
              fit: BoxFit.cover,
              imagePath: photo.url,
            ),
          ),
        );
      },
    );
  }
}
