import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AppNetworkImage extends StatelessWidget {
  final String? imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Widget? placeholder;
  final Widget? errorWidget;

  const AppNetworkImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.placeholder,
    this.errorWidget,
  });

  bool get _isValidImage {
    if (imageUrl == null) return false;
    final trimmed = imageUrl!.trim();
    if (trimmed.isEmpty) return false;
    // file:/// বা invalid URI হলে false
    try {
      final uri = Uri.parse(trimmed);
      return uri.hasScheme && uri.host.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final child = !_isValidImage
        ? (errorWidget ?? _defaultErrorWidget())
        : CachedNetworkImage(
            imageUrl: imageUrl!.trim(),
            width: width,
            height: height,
            fit: fit,
            placeholder: (context, url) =>
                placeholder ?? _defaultPlaceholder(),
            errorWidget: (context, url, error) =>
                errorWidget ?? _defaultErrorWidget(),
          );

    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius!,
        child: child,
      );
    }

    return child;
  }

  Widget _defaultPlaceholder() {
    return Container(
      width: width,
      height: height,
      color: Colors.grey.shade200,
      child: const Center(
        child: SizedBox(
          height: 18,
          width: 18,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }

  Widget _defaultErrorWidget() {
    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      color: Colors.grey.shade200,
      child: const Icon(
        Icons.image_not_supported_outlined,
        color: Colors.grey,
      ),
    );
  }
}