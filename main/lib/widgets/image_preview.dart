import 'dart:typed_data';
import 'package:core/context/navigation_extension.dart';
import 'package:core/helpers/app_size.dart';
import 'package:core/styles/text_style.dart';
import 'package:flutter/material.dart';

class ImagePreview extends StatefulWidget {
  final Uint8List byte;
  final String tag;
  const ImagePreview({super.key, required this.byte, required this.tag});

  @override
  State<ImagePreview> createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<ImagePreview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'Preview',
          style: textTheme.titleMedium?.copyWith(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        leading: IconButton(
          onPressed: () => context.back(),
          icon: const Icon(
            Icons.close_rounded,
            color: Colors.white,
          ),
        ),
      ),
      body: Center(
        child: AspectRatio(
          aspectRatio: 1,
          child: Hero(
            tag: widget.tag,
            child: Image.memory(
              widget.byte,
              width: AppSize.getAppWidth(context),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
