import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/constants/utils.dart';
import '../../main.dart';
import 'custom_network_image.dart';

class UserAvatar extends StatefulWidget {
  final String? name;
  final String? imageUrl;
  final String? galleryFile;
  final double size;
  final bool isCameraShown;
  final Uint8List? bytes;
  final Color? bgColor;
  final Color? color;
  final VoidCallback onTap;
  final Future<void> Function(File, AttachmentType type)? uploadFile;
  final Future<void> Function(File, AttachmentType type)? removeFile;

  const UserAvatar({
    super.key,
    required this.size,
    required this.onTap,
    this.imageUrl,
    this.name,
    this.galleryFile,
    this.bgColor,
    this.isCameraShown = false,
    this.color,
    this.uploadFile,
    this.removeFile,
    this.bytes,
  });

  @override
  State<UserAvatar> createState() => _UserAvatarState();
}

class _UserAvatarState extends State<UserAvatar> with SingleTickerProviderStateMixin {

  final ValueNotifier<bool> isShowFile = ValueNotifier(true);
  final int maxSizeInBytes = 10 * 1024 * 1024;


  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    isShowFile.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.galleryFile != null) {
      isShowFile.value = true;
    }

    return SizedBox(
      width: widget.size + 16,
      height: widget.size + 16,
      child: Stack(
        alignment: Alignment.center,
        children: [
          /// Avatar body
          ValueListenableBuilder(
            valueListenable: isShowFile,
            builder: (context, isShow, _) {
              return buildInkWell(
                onTap: widget.onTap,
                child: Container(
                  width: widget.size,
                  height: widget.size,
                  padding: const EdgeInsets.all(2.5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: appColors.white,
                    border: Border.all(
                      color: appColors.primary,
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: (widget.isCameraShown ? appColors.primary : Colors.black)
                            .withValues(alpha: widget.isCameraShown ? 0.12 : 0.05),
                        blurRadius: 10,
                        spreadRadius: 0.5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ClipOval(child: _buildAvatarContent(isShow)),
                ),
              );
            },
          ),

          /// Edit camera button
          if (widget.isCameraShown)
            Positioned(
              bottom: 5,
              right: 5,
              child: _buildEditButton(),
            ),

          /// Remove image button
          if (widget.galleryFile != null && isShowFile.value)
            Positioned(
              top: 5,
              right: 5,
              child: _buildRemoveButton(),
            ),
        ],
      ),
    );
  }

  Widget _buildAvatarContent(bool isShow) {
    final bool hasGalleryFile = widget.galleryFile != null && isShow;
    final bool showInitials = widget.name != null && !hasGalleryFile && widget.imageUrl == null;

    if (showInitials) {
      return _buildInitials();
    }

    if (hasGalleryFile) {
      return widget.bytes != null
          ? Image.memory(widget.bytes!,
          fit: BoxFit.cover,
          width: widget.size,
          height: widget.size)
          : Image.file(File(widget.galleryFile!),
          fit: BoxFit.cover,
          width: widget.size,
          height: widget.size);
    }

    return CustomNetworkImage(
      image: widget.imageUrl,
      size: widget.size,
      fit: BoxFit.cover,
      errorWidget: (context, url, error) => _buildInitials(),
    );
  }

  Widget _buildInitials() {
    final initial = widget.name?.characters.first.toUpperCase() ?? "?";
    final Color defaultTextColor = Colors.white;

    return Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        color: widget.bgColor,
        gradient: widget.bgColor != null
            ? null
            : LinearGradient(
                colors: [
                  appColors.primary,
                  appColors.primary.withValues(alpha: 0.75),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
      ),
      alignment: Alignment.center,
      child: Text(
        initial,
        style: TextStyle(
          fontSize: widget.size * 0.38,
          fontWeight: FontWeight.w800,
          color: widget.color ?? (widget.bgColor != null ? appColors.primary : defaultTextColor),
          letterSpacing: -0.5,
        ),
      ),
    );
  }

  Widget _buildEditButton() {
    return buildInkWell(
      onTap: () => _showImagePickerSheet(context),
      child: Container(
        height: 32,
        width: 32,
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: appColors.primary.withValues(alpha: 0.75),
          shape: BoxShape.circle,
          border: Border.all(color: appColors.white, width: 2),
          boxShadow: [
            BoxShadow(
              color: appColors.primary.withValues(alpha: 0.35),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        // child: Image.asset(
        //   appIcons.editProfile,
        //   height: 18,
        //   width: 18,
        //   color: appColors.white,
        // ),
        child: Icon(Icons.camera_alt_outlined, size: 18),
      ),
    );
  }

  Widget _buildRemoveButton() {
    return buildInkWell(
      onTap: () async {
        await widget.removeFile?.call(
          File(widget.galleryFile!),
          AttachmentType.image,
        );
        isShowFile.value = false;
      },
      child: Container(
        height: 32,
        width: 32,
        decoration: BoxDecoration(
          color: appColors.red.withValues(alpha: 0.75),
          shape: BoxShape.circle,
          border: Border.all(color: appColors.white, width: 2),
          boxShadow: [
            BoxShadow(
              color: appColors.primary.withValues(alpha: 0.35),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Icon(Icons.close_rounded, color: appColors.white, size: 18),
      ),
    );
  }

  // ── Bottom Sheet ──────────────────────────────────────────────────────────
  void _showImagePickerSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      isScrollControlled: true,
      builder: (_) => _ImagePickerSheet(
        onCamera: () async {
          navigation.pop(context);
          await _selectedImage(ImageSource.camera, context);
        },
        onGallery: () async {
          navigation.pop(context);
          await _selectedImage(ImageSource.gallery, context);
        },
        hasExistingImage:
        widget.galleryFile != null || widget.imageUrl != null,
        onRemove: widget.galleryFile != null
            ? () async {
          navigation.pop(context);
          await widget.removeFile?.call(
            File(widget.galleryFile!),
            AttachmentType.image,
          );
          isShowFile.value = false;
        }
            : null,
      ),
    );
  }

  Future<void> _selectedImage(ImageSource source, BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? pickedFile = await picker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 1024,
        maxHeight: 1024,
      );

      if (pickedFile == null) return;

      final String extension = pickedFile.path.split('.').last.toLowerCase();
      const allowedExtensions = ['jpg', 'jpeg', 'png', 'webp', 'gif'];

      if (!allowedExtensions.contains(extension)) {
        showSnackBar(
          // ignore: use_build_context_synchronously
          context: context,
          isError: true,
          message: "Only JPG, PNG, WEBP, or GIF images are allowed.",
        );
        return;
      }

      final File imageFile = File(pickedFile.path);
      final int fileSize = await imageFile.length();

      if (fileSize > maxSizeInBytes) {
        showSnackBar(
          // ignore: use_build_context_synchronously
          context: context,
          isError: true,
          message: "Image must be under 10 MB. Please choose a smaller file.",
        );
        return;
      }

      await widget.uploadFile?.call(imageFile, AttachmentType.image);
    } catch (e) {
      showSnackBar(
        context: navigatorKey.currentContext!,
        isError: true,
        message: "Failed to pick image. Please try again.",
      );
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Image Picker Bottom Sheet
// ─────────────────────────────────────────────────────────────────────────────

class _ImagePickerSheet extends StatelessWidget {
  final VoidCallback onCamera;
  final VoidCallback onGallery;
  final VoidCallback? onRemove;
  final bool hasExistingImage;

  const _ImagePickerSheet({
    required this.onCamera,
    required this.onGallery,
    this.onRemove,
    this.hasExistingImage = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: appColors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 24,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Profile Photo",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: appColors.black,
                            letterSpacing: -0.3,
                          ),
                        ),
                        Text(
                          "Choose how to update your photo",
                          style: TextStyle(
                            fontSize: 12,
                            color: appColors.grey,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Divider(height: 1, color: Colors.grey.shade100),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    _SheetOption(
                      icon: Icons.camera_alt_rounded,
                      iconBgColor: appColors.primary.withValues(alpha: 0.12),
                      iconColor: appColors.primary,
                      title: "Take a Photo",
                      subtitle: "Use your camera",
                      onTap: onCamera,
                    ),
                    const SizedBox(height: 4),
                    _SheetOption(
                      icon: Icons.photo_library_rounded,
                      iconBgColor: appColors.primary.withValues(alpha: 0.12),
                      iconColor: appColors.primary,
                      title: "Choose from Gallery",
                      subtitle: "Browse your photos",
                      onTap: onGallery,
                    ),
                    if (onRemove != null) ...[
                      const SizedBox(height: 4),
                      _SheetOption(
                        icon: Icons.delete_outline_rounded,
                        iconBgColor: const Color(0xFFFFF1F1),
                        iconColor: Colors.red.shade400,
                        title: "Remove Photo",
                        subtitle: "Reset to default avatar",
                        onTap: onRemove!,
                        isDestructive: true,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

class _SheetOption extends StatefulWidget {
  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool isDestructive;

  const _SheetOption({
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  State<_SheetOption> createState() => _SheetOptionState();
}

class _SheetOptionState extends State<_SheetOption> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: _pressed
              ? Colors.grey.shade100
              : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            // Icon container
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: widget.iconBgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(widget.icon, color: widget.iconColor, size: 22),
            ),
            const SizedBox(width: 14),
            // Labels
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: widget.isDestructive
                          ? Colors.red.shade500
                          : appColors.black,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: appColors.grey,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            // Chevron
            Icon(
              Icons.chevron_right_rounded,
              color: Colors.grey.shade400,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

enum AttachmentType { image, file }