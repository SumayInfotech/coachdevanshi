import 'dart:io';

import 'package:coach_devanshi_doshi/main.dart';
import 'package:flutter/material.dart';

import 'custom_network_image.dart';

class OpenFullImage extends StatefulWidget {
  final List<String>? img;
  final String? image;
  final String? file;

  const OpenFullImage({super.key, this.img, this.image, this.file});

  @override
  State<OpenFullImage> createState() => _OpenFullImageState();
}

class _OpenFullImageState extends State<OpenFullImage> {

  PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Builder(
              builder: (context) {
                if (widget.file != null) {
                  return SizedBox(
                    width: width,
                    height: height,
                    child: Image.file(
                      File(widget.file!),
                      fit: BoxFit.contain
                    ),
                  );
                } else if(widget.image == null) {
                  return PageView(
                    children: widget.img?.map((e) {
                      return InteractiveViewer(
                        maxScale: 10,
                        child: CustomNetworkImage(
                          image: e,
                          fit: BoxFit.contain
                        ),
                      );
                    }).toList() ?? [],
                  );
                } else {
                  return CustomNetworkImage(
                    image: widget.image,
                    fit: BoxFit.contain
                  );
                }
              },
            ),

            Positioned(
              top: 10, right: 10,
              child: IconButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(appColors.primary)
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.close, color: Colors.white,),
              ),
            ),
          ],
        ),
      ),
    );
  }
}