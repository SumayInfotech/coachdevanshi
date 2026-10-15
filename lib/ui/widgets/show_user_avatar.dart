import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../main.dart';
import 'common_text.dart';
import 'custom_network_image.dart';

class ShowUserAvatar extends StatefulWidget {
  final String? name;
  final String? image;
  final String? file;
  final double size;
  final double? fontSize;
  final double? radius;
  final Color? bgColor;
  final Color? color;
  final List<BoxShadow>? boxShadow;

  const ShowUserAvatar({
    super.key,
    required this.size,
    this.fontSize,
    this.image,
    this.name,
    this.file,
    this.bgColor,
    this.color, this.radius, this.boxShadow,
  });

  @override
  State<ShowUserAvatar> createState() => _ShowUserAvatarState();
}

class _ShowUserAvatarState extends State<ShowUserAvatar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.size + 1,
      width: widget.size + 1,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: appColors.primary,
        shape: BoxShape.circle
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.radius ?? 50),
        child: Container(
          height: widget.size,
          width: widget.size,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: appColors.primary.withValues(alpha: .2),
            borderRadius: BorderRadius.circular(widget.radius ?? 50),
          ),
          child: (widget.name == null && widget.file == null && widget.image == null)
            ? Shimmer.fromColors(
            baseColor: appColors.primary,
            highlightColor: appColors.primary.withValues(alpha: .2),
            child: Container(
              height: widget.size,
              width: widget.size,
              color: Colors.white,
            )
          ) : (widget.name != null && widget.file == null && widget.image == null) ? CommonText(
            widget.name!.characters.first.toUpperCase(),
            style: TextStyle(
              color: appColors.white, fontSize: widget.fontSize ?? 20, fontWeight: FontWeight.bold
            ),
          ) : (widget.file != null) ? Image.file(
            File(widget.file!),
            fit: BoxFit.cover,
            height: widget.size,
            width: widget.size,
          ) : CustomNetworkImage(
            image: widget.image,
            size: widget.size,
            fit: BoxFit.cover,
            errorWidget: (context, url, error) {
              return Center(
                child: widget.name != null ? CommonText(
                  widget.name?.characters.first.toUpperCase() ?? "",
                  style: TextStyle(
                    color: appColors.white, fontSize: widget.fontSize ?? 20, fontWeight: FontWeight.bold
                  ),
                ) : Icon(Icons.person_outline_rounded, color: appColors.white),
              );
            },
          ),
        ),
      ),
    );
  }
}