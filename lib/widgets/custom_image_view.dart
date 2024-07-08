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
        return this!.endsWith('.svg')
            ? ImageType.networkSvg
            : ImageType.network;
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

enum ImageType { svg, png, network, file, networkSvg, unknown, empty }

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
    this.size,
    this.placeHolder = 'assets/images/image_not_found.png',
  });

  final String? imagePath;
  final String placeHolder;
  final double? size;
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

  ColorFilter? get _colorFilter {
    return color != null
        ? ColorFilter.mode(
            color ?? Colors.transparent,
            BlendMode.srcIn,
          )
        : null;
  }

  Widget _frameBuilder(context, child, frame, was) {
    return SizedBox(
      width: width ?? size ?? 100,
      height: height ?? size ?? 100,
      child: LinearProgressIndicator(
        color: Colors.grey.shade200,
        backgroundColor: Colors.grey.shade100,
      ),
    );
  }

  Widget _placeholder(context, url) {
    return SizedBox(
      width: width ?? size ?? 100,
      height: height ?? size ?? 100,
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
          width: width ?? size ?? 20.adaptSize,
          height: height ?? size ?? 20.adaptSize,
          child: SvgPicture.asset(
            src,
            colorFilter: _colorFilter,
            fit: fit ?? BoxFit.contain,
            width: width ?? size ?? 20.adaptSize,
            height: height ?? size ?? 20.adaptSize,
            placeholderBuilder: (context) {
              return SvgPicture.asset(
                colorFilter: _colorFilter,
                fit: fit ?? BoxFit.contain,
                "assets/icons/image_not_found.svg",
                width: width ?? size ?? 20.adaptSize,
                height: height ?? size ?? 20.adaptSize,
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
          color: color,
          imageUrl: src,
          width: width ?? size,
          height: height ?? size,
          placeholder: _placeholder,
          errorWidget: (context, url, error) {
            return Image.asset(
              color: color,
              width: width ?? size,
              height: height ?? size,
              fit: fit ?? BoxFit.cover,
              frameBuilder: _frameBuilder,
              errorBuilder: _errorBuilder,
              "assets/images/image_not_found.png",
            );
          },
        );
      case ImageType.networkSvg:
        return SvgPicture.network(
          src,
          colorFilter: _colorFilter,
          fit: fit ?? BoxFit.contain,
          width: width ?? size ?? 20.adaptSize,
          height: height ?? size ?? 20.adaptSize,
          placeholderBuilder: (context) {
            return SvgPicture.asset(
              colorFilter: _colorFilter,
              fit: fit ?? BoxFit.contain,
              "assets/icons/image_not_found.svg",
              width: width ?? size ?? 20.adaptSize,
              height: height ?? size ?? 20.adaptSize,
            );
          },
        );
      case ImageType.empty:
        return Image.asset(
          color: color,
          width: width ?? size,
          height: height ?? size,
          fit: fit ?? BoxFit.cover,
          "assets/images/image_not_found.png",
        );
      case ImageType.png:
      default:
        return Image.asset(
          src,
          color: color,
          width: width ?? size,
          height: height ?? size,
          fit: fit ?? BoxFit.cover,
          frameBuilder: _frameBuilder,
          errorBuilder: (context, url, error) {
            return Image.asset(
              color: color,
              width: width ?? size,
              height: height ?? size,
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
          width: width ?? size ?? 20.adaptSize,
          height: height ?? size ?? 20.adaptSize,
          child: SvgPicture.asset(
            imagePath!,
            colorFilter: _colorFilter,
            fit: fit ?? BoxFit.contain,
            width: width ?? size ?? 20.adaptSize,
            height: height ?? size ?? 20.adaptSize,
            placeholderBuilder: _placeholderBuilder,
          ),
        );
      case ImageType.file:
        return Image.file(
          color: color,
          File(imagePath!),
          width: width ?? size,
          height: height ?? size,
          fit: fit ?? BoxFit.cover,
          errorBuilder: _errorBuilder,
        );
      case ImageType.network:
        return CachedNetworkImage(
          fit: fit,
          color: color,
          imageUrl: imagePath!,
          width: width ?? size,
          height: height ?? size,
          placeholder: _placeholder,
          errorWidget: _errorBuilder,
        );
      case ImageType.networkSvg:
        return SvgPicture.network(
          imagePath!,
          colorFilter: _colorFilter,
          fit: fit ?? BoxFit.contain,
          width: width ?? size ?? 20.adaptSize,
          height: height ?? size ?? 20.adaptSize,
          placeholderBuilder: _placeholderBuilder,
        );
      case ImageType.empty:
        return Image.asset(
          color: color,
          width: width ?? size,
          height: height ?? size,
          fit: fit ?? BoxFit.cover,
          "assets/images/image_not_found.png",
        );
      case ImageType.png:
      default:
        return Image.asset(
          imagePath!,
          color: color,
          width: width ?? size,
          height: height ?? size,
          fit: fit ?? BoxFit.cover,
          errorBuilder: _errorBuilder,
        );
    }
  }
}
