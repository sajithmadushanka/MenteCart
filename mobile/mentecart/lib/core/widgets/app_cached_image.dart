import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';

import 'package:shimmer/shimmer.dart';

class AppCachedImage extends StatelessWidget {
  final String imageUrl;

  final double height;

  final double width;

  final BoxFit fit;

  const AppCachedImage({
    super.key,
    required this.imageUrl,
    required this.height,
    required this.width,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,

      height: height,

      width: width,

      fit: fit,

      placeholder: (context, url) => Shimmer.fromColors(
        baseColor: Colors.grey.shade300,

        highlightColor: Colors.grey.shade100,

        child: Container(height: height, width: width, color: Colors.white),
      ),

      errorWidget: (context, url, error) => Container(
        height: height,

        width: width,

        color: Colors.grey.shade300,

        child: const Center(child: Icon(Icons.broken_image, size: 40)),
      ),
    );
  }
}
