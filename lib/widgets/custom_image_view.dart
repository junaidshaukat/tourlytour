import 'dart:io';
import 'package:flutter/material.dart';
import '/core/app_export.dart';

extension ImageTypeExtension on String {
  ImageType get imageType {
    if (startsWith('http') || startsWith('https')) {
      return ImageType.network;
    } else if (endsWith('.svg')) {
      return ImageType.svg;
    } else if (startsWith('file://')) {
      return ImageType.file;
    } else {
      return ImageType.png;
    }
  }
}

enum ImageType { svg, png, network, file, unknown }

class CustomImageView extends StatelessWidget {
  const CustomImageView({
    super.key,
    this.imagePath,
    this.height,
    this.width,
    this.color,
    this.fit,
    this.alignment,
    this.onTap,
    this.radius,
    this.margin,
    this.border,
    this.placeHolder = 'assets/images/image_not_found.png',
  });

  final String? imagePath;
  final String placeHolder;

  final double? height;

  final double? width;

  final Color? color;

  final BoxFit? fit;

  final Alignment? alignment;

  final VoidCallback? onTap;

  final EdgeInsetsGeometry? margin;

  final BorderRadius? radius;

  final BoxBorder? border;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(alignment: alignment!, child: _buildWidget())
        : _buildWidget();
  }

  Widget _buildWidget() {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        child: _buildCircleImage(),
      ),
    );
  }

  ///build the image with border radius
  _buildCircleImage() {
    if (radius != null) {
      return ClipRRect(
        borderRadius: radius ?? BorderRadius.zero,
        child: _buildImageWithBorder(),
      );
    } else {
      return _buildImageWithBorder();
    }
  }

  ///build the image with border and border radius style
  _buildImageWithBorder() {
    if (border != null) {
      return Container(
        decoration: BoxDecoration(
          border: border,
          borderRadius: radius,
        ),
        child: _buildImageView(),
      );
    } else {
      return _buildImageView();
    }
  }

  Widget _buildImageView() {
    console.log(imagePath!);
    if (imagePath != null && imagePath != "") {
      switch (imagePath!.imageType) {
        case ImageType.svg:
          return SizedBox(
            width: width,
            height: height,
            child: SvgPicture.asset(
              imagePath!,
              width: width,
              height: height,
              fit: fit ?? BoxFit.contain,
              colorFilter: color != null
                  ? ColorFilter.mode(
                      color ?? Colors.transparent,
                      BlendMode.srcIn,
                    )
                  : null,
            ),
          );
        case ImageType.file:
          return Image.file(
            File(imagePath!),
            height: height,
            width: width,
            fit: fit ?? BoxFit.cover,
            color: color,
            frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
              return SizedBox(
                height: 30,
                width: 30,
                child: LinearProgressIndicator(
                  color: Colors.grey.shade200,
                  backgroundColor: Colors.grey.shade100,
                ),
              );
            },
            errorBuilder: (context, url, error) {
              return Image.asset(
                placeHolder,
                height: height,
                width: width,
                fit: fit ?? BoxFit.cover,
              );
            },
          );
        case ImageType.network:
          return CachedNetworkImage(
            fit: fit,
            width: width,
            color: color,
            height: height,
            imageUrl: imagePath!,
            placeholder: (context, url) {
              return SizedBox(
                width: width,
                height: height,
                child: LinearProgressIndicator(
                  color: Colors.grey.shade200,
                  backgroundColor: Colors.grey.shade100,
                ),
              );
            },
            errorWidget: (context, url, error) {
              return Image.asset(
                placeHolder,
                width: width,
                height: height,
                fit: fit ?? BoxFit.cover,
              );
            },
          );
        case ImageType.png:
          return Image.asset(
            imagePath!,
            height: height,
            width: width,
            fit: fit ?? BoxFit.cover,
            color: color,
            errorBuilder: (context, url, error) {
              return Image.asset(
                placeHolder,
                height: height,
                width: width,
                fit: fit ?? BoxFit.cover,
              );
            },
          );
        default:
          return Image.asset(
            imagePath!,
            height: height,
            width: width,
            fit: fit ?? BoxFit.cover,
            color: color,
            errorBuilder: (context, url, error) {
              return Image.asset(
                placeHolder,
                height: height,
                width: width,
                fit: fit ?? BoxFit.cover,
              );
            },
          );
      }
    }
    return const SizedBox();
  }
}
