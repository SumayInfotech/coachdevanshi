import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

import '../../main.dart';

class CustomNetworkImage extends StatelessWidget {

  final String? image;
  final double? size;
  final double? height;
  final double? width;
  final BoxFit? fit;
  final Widget Function(BuildContext context, String url, Object error)? errorWidget;

  const CustomNetworkImage({
    super.key,
    required this.image,
    this.size,
    this.height,
    this.width,
    this.errorWidget,
    this.fit,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: image ?? "",
      fit: fit,
      height: height ?? size,
      width: width ?? size,
      alignment: Alignment.center,
      fadeInDuration: const Duration(milliseconds: 100),
      placeholder: (context, url) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: appColors.white,
          child: Container(
            height: height ?? size,
            width: height ?? size,
            decoration: BoxDecoration(color: appColors.white),
          ),
        );
      },
      errorWidget: errorWidget ?? _buildErrorWidget,
    );
  }

  Widget _buildErrorWidget(BuildContext context, String url, dynamic error) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadiusGeometry.circular(15),
      ),
      child: const Center(child: Icon(Icons.error, color: Colors.red)),
    );
  }
}
