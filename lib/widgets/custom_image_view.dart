import 'dart:io';
import 'package:flutter/material.dart';
import '/core/app_export.dart';

extension ImageTypeExtension on String? {
  ImageType get imageType {
    if (this == null) {
      return ImageType.empty;
    } else {
      if (this!.replaceAll(RegExp(r'\s+'), '').isEmpty) {
        return ImageType.empty;
      } else if (this!.startsWith('http') || this!.startsWith('https')) {
        return ImageType.network;
      } else if (this!.endsWith('.svg')) {
        return ImageType.svg;
      } else if (this!.startsWith('file://')) {
        return ImageType.file;
      } else {
        return ImageType.png;
      }
    }
  }
}

enum ImageType { svg, png, network, file, unknown, empty }

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

  ColorFilter? get colorFilter {
    return color != null
        ? ColorFilter.mode(
            color ?? Colors.transparent,
            BlendMode.srcIn,
          )
        : null;
  }

  Widget _frameBuilder(context, child, frame, was) {
    return SizedBox(
      width: width ?? 100,
      height: height ?? 100,
      child: LinearProgressIndicator(
        color: Colors.grey.shade200,
        backgroundColor: Colors.grey.shade100,
      ),
    );
  }

  Widget _placeholder(context, url) {
    return SizedBox(
      width: width ?? 100,
      height: height ?? 100,
      child: LinearProgressIndicator(
        color: Colors.grey.shade200,
        backgroundColor: Colors.grey.shade100,
      ),
    );
  }

  Widget _placeholderBuilder(context) {
    return _builder(placeHolder);
  }

  Widget _errorBuilder(context, url, error) {
    return _builder(placeHolder);
  }

  Widget _builder(String src) {
    switch (src.imageType) {
      case ImageType.svg:
        return SizedBox(
          width: width,
          height: height,
          child: SvgPicture.asset(
            src,
            width: width,
            height: height,
            colorFilter: colorFilter,
            fit: fit ?? BoxFit.contain,
            placeholderBuilder: (context) {
              return SvgPicture.asset(
                width: width,
                height: height,
                colorFilter: colorFilter,
                fit: fit ?? BoxFit.contain,
                "assets/icons/image_not_found.svg",
              );
            },
          ),
        );
      case ImageType.file:
        return Image.file(
          File(src),
          color: color,
          width: width,
          height: height,
          fit: fit ?? BoxFit.cover,
          frameBuilder: _frameBuilder,
          errorBuilder: (context, url, error) {
            return Image.asset(
              width: width,
              color: color,
              height: height,
              fit: fit ?? BoxFit.cover,
              frameBuilder: _frameBuilder,
              errorBuilder: _errorBuilder,
              "assets/images/image_not_found.png",
            );
          },
        );
      case ImageType.network:
        return CachedNetworkImage(
          fit: fit,
          width: width,
          color: color,
          imageUrl: src,
          height: height,
          placeholder: _placeholder,
          errorWidget: (context, url, error) {
            return Image.asset(
              width: width,
              color: color,
              height: height,
              fit: fit ?? BoxFit.cover,
              frameBuilder: _frameBuilder,
              errorBuilder: _errorBuilder,
              "assets/images/image_not_found.png",
            );
          },
        );
      case ImageType.empty:
        return Image.asset(
          "assets/images/image_not_found.png",
          width: width,
          color: color,
          height: height,
          fit: fit ?? BoxFit.cover,
        );
      case ImageType.png:
      default:
        return Image.asset(
          src,
          width: width,
          color: color,
          height: height,
          fit: fit ?? BoxFit.cover,
          frameBuilder: _frameBuilder,
          errorBuilder: (context, url, error) {
            return Image.asset(
              width: width,
              color: color,
              height: height,
              fit: fit ?? BoxFit.cover,
              frameBuilder: _frameBuilder,
              errorBuilder: _errorBuilder,
              "assets/images/image_not_found.png",
            );
          },
        );
    }
  }

  Widget _buildImageView() {
    switch (imagePath.imageType) {
      case ImageType.svg:
        return SizedBox(
          width: width,
          height: height,
          child: SvgPicture.asset(
            imagePath!,
            width: width,
            height: height,
            colorFilter: colorFilter,
            fit: fit ?? BoxFit.contain,
            placeholderBuilder: _placeholderBuilder,
          ),
        );
      case ImageType.file:
        return Image.file(
          width: width,
          color: color,
          height: height,
          File(imagePath!),
          fit: fit ?? BoxFit.cover,
          errorBuilder: _errorBuilder,
        );
      case ImageType.network:
        return CachedNetworkImage(
          fit: fit,
          width: width,
          color: color,
          height: height,
          imageUrl: imagePath!,
          placeholder: _placeholder,
          errorWidget: _errorBuilder,
        );
      case ImageType.empty:
        return Image.asset(
          "assets/images/image_not_found.png",
          width: width,
          color: color,
          height: height,
          fit: fit ?? BoxFit.cover,
        );
      case ImageType.png:
      default:
        return Image.asset(
          imagePath!,
          width: width,
          color: color,
          height: height,
          fit: fit ?? BoxFit.cover,
          errorBuilder: _errorBuilder,
        );
    }
  }
}
