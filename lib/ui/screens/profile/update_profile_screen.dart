import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../main.dart';
import '../../../core/blocs/auth/profile/profile_bloc.dart';
import '../../../core/blocs/auth/update_profile/update_profile_bloc.dart';
import '../../../core/constants/urls.dart';
import '../../../core/constants/utils.dart';
import '../../../core/models/auth/user_model.dart';
import '../../../core/services/loader_service.dart';
import '../../widgets/common_app_bar.dart';
import '../../widgets/common_button.dart';
import '../../widgets/common_text.dart';
import '../../widgets/common_text_field.dart';
import '../../widgets/user_avatar.dart';
import '../bottom_bar_screen.dart';
import 'widget/profile_section_card.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();

  File? _pickedImageFile;
  String? _firstNameError;
  String? _lastNameError;

  @override
  void initState() {
    super.initState();
    _populateUserData();
    userData.addListener(_onUserDataChanged);

    // If userData is not yet loaded, fetch it
    if (userData.value == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        callUserAPI(context: context);
      });
    }
  }

  void _onUserDataChanged() {
    if (mounted) {
      _populateUserData();
      setState(() {});
    }
  }

  void _populateUserData() {
    final user = userData.value;
    if (user != null) {
      String firstName = (user.name ?? "").trim();
      String lastName = (user.lastName?.toString() ?? "").trim();

      // If lastName is not provided separately but name contains both first and last name
      if (lastName.isEmpty && firstName.contains(" ")) {
        final parts = firstName.split(RegExp(r'\s+'));
        firstName = parts.first;
        lastName = parts.sublist(1).join(" ");
      }

      // Populate controllers if they haven't been edited by user yet
      if (_firstNameController.text.isEmpty) {
        _firstNameController.text = firstName;
      }
      if (_lastNameController.text.isEmpty) {
        _lastNameController.text = lastName;
      }

      _emailController.text = user.email ?? "";
      final phoneCode = user.phoneCode != null && user.phoneCode!.isNotEmpty
          ? (user.phoneCode!.startsWith("+") ? user.phoneCode! : "+${user.phoneCode}")
          : "+91";
      _mobileController.text = user.mobile != null && user.mobile!.isNotEmpty
          ? "$phoneCode ${user.mobile}"
          : "";
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 1024,
        maxHeight: 1024,
      );
      if (picked != null) {
        setState(() {
          _pickedImageFile = File(picked.path);
        });
      }
    } catch (e) {
      appLog(name: "ImagePicker Exception", e.toString());
    }
  }

  String _formatFileSize(File file) {
    try {
      final bytes = file.lengthSync();
      if (bytes < 1024) return "$bytes B";
      if (bytes < 1024 * 1024) return "${(bytes / 1024).toStringAsFixed(1)} KB";
      return "${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB";
    } catch (_) {
      return "";
    }
  }

  bool _validate() {
    bool isValid = true;

    final firstName = _firstNameController.text.trim();
    if (firstName.isEmpty) {
      _firstNameError = "Please enter your first name";
      isValid = false;
    } else {
      _firstNameError = null;
    }

    final lastName = _lastNameController.text.trim();
    if (lastName.isEmpty) {
      _lastNameError = "Please enter your last name";
      isValid = false;
    } else {
      _lastNameError = null;
    }

    setState(() {});
    return isValid;
  }

  void _onSaveProfile() {
    if (_validate()) {
      LoaderService.show(context);

      // Matches exact Postman form-data fields: name, last_name, profile_image
      final Map<String, dynamic> body = {
        "name": _firstNameController.text.trim(),
        "last_name": _lastNameController.text.trim(),
      };

      if (_pickedImageFile != null) {
        body["profile_image"] = _pickedImageFile!;
      }

      BlocProvider.of<UpdateProfileBloc>(context).add(
        UserUpdateProfileEvent(
          url: Urls.updateProfile,
          body: body,
          isMultipart: true,
        ),
      );
    }
  }

  @override
  void dispose() {
    userData.removeListener(_onUserDataChanged);
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UpdateProfileBloc, UpdateProfileState>(
      listener: (context, state) {
        if (state is UpdateProfileSuccess) {
          LoaderService.hide();
          showSnackBar(
            context: context,
            isError: false,
            message: state.model.message ?? "Profile updated successfully!",
          );

          // Update cached user in memory
          if (state.model.data?.user != null) {
            userData.value = state.model.data!.user;
          }

          // Trigger background profile refresh
          BlocProvider.of<ProfileBloc>(context).add(
            UserProfileEvent(url: Urls.profile),
          );

          Navigator.pop(context, true);
        } else if (state is UpdateProfileFailed) {
          LoaderService.hide();
          showSnackBar(
            context: context,
            isError: true,
            message: state.message,
          );
        }
      },
      child: Scaffold(
        backgroundColor: appColors.bgColor,
        appBar: CommonAppBar(
          appBarColor: appColors.transparent,
          isLeading: true,
          title: const CommonText(
            "Update Profile",
            fontFamily: fontPlayfairDisplay,
            style: TextStyle(
              fontSize: 20,
              color: Color(0xFF1D1B1A),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: SafeArea(
          child: ValueListenableBuilder<UserData?>(
            valueListenable: userData,
            builder: (context, user, _) {
              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Column(
                        children: [
                          // Avatar / Photo Section (profile_image)
                          _buildAvatarSection(user),
                          const SizedBox(height: 20),

                          // Profile Details Section (name & last_name)
                          _buildProfileDetailsSection(),
                          const SizedBox(height: 16),

                          // Account Information (Read-only)
                          _buildAccountDetailsSection(user),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),

                  // Bottom Save Button
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: appColors.white,
                      boxShadow: [
                        BoxShadow(
                          color: appColors.black.withValues(alpha: 0.05),
                          offset: const Offset(0, -2),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: CommonButton(
                      name: "Save Changes",
                      btnColor: appColors.primary,
                      fontColor: appColors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      radius: 999,
                      onTap: _onSaveProfile,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarSection(UserData? user) {
    return Center(
      child: Column(
        children: [
          UserAvatar(
            size: 100,
            isCameraShown: true,
            name: user?.name,
            imageUrl: user?.profileImage?.toString(),
            galleryFile: _pickedImageFile?.path,
            onTap: () => _showPhotoOptionSheet(),
            uploadFile: (file, type) async {
              setState(() {
                _pickedImageFile = file;
              });
            },
            removeFile: (file, type) async {
              setState(() {
                _pickedImageFile = null;
              });
            },
          ),
          const SizedBox(height: 8),
          buildInkWell(
            onTap: _showPhotoOptionSheet,
            child: CommonText(
              _pickedImageFile != null ? "Change photo" : "Tap to change profile picture",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: appColors.primary,
              ),
              fontFamily: fontFamilyPlusJakartaSans,
            ),
          ),

          // Preview chip if a file is selected
          if (_pickedImageFile != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: appColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: appColors.primary.withValues(alpha: 0.2)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.image_outlined, color: appColors.primary, size: 18),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonText(
                          _pickedImageFile!.path.split(RegExp(r'[/\\]')).last,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1D1B1A),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        CommonText(
                          "Selected file • ${_formatFileSize(_pickedImageFile!)}",
                          style: TextStyle(
                            fontSize: 11,
                            color: appColors.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  buildInkWell(
                    onTap: () {
                      setState(() {
                        _pickedImageFile = null;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: appColors.primary.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.close_rounded, color: appColors.primary, size: 14),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showPhotoOptionSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Material(
          color: appColors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          clipBehavior: Clip.antiAlias,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CommonText(
                  "Profile Photo",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1D1B1A),
                  ),
                  fontFamily: fontFamilyPlusJakartaSans,
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: appColors.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.camera_alt_rounded, color: appColors.primary),
                  ),
                  title: const CommonText(
                    "Take a photo",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1D1B1A),
                    ),
                    fontFamily: fontFamilyPlusJakartaSans,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: appColors.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.photo_library_rounded, color: appColors.primary),
                  ),
                  title: const CommonText(
                    "Choose from gallery",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1D1B1A),
                    ),
                    fontFamily: fontFamilyPlusJakartaSans,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.gallery);
                  },
                ),
                if (_pickedImageFile != null)
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: appColors.red.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.delete_outline_rounded, color: appColors.red),
                    ),
                    title: CommonText(
                      "Remove selected photo",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: appColors.red,
                      ),
                      fontFamily: fontFamilyPlusJakartaSans,
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      setState(() {
                        _pickedImageFile = null;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileDetailsSection() {
    return ProfileSectionCard(
      title: "Profile Details",
      icon: appIcons.personalDetail,
      children: [
        CommonTextField(
          label: "First Name",
          controller: _firstNameController,
          isRequired: true,
          hint: "e.g. Ananya",
          error: _firstNameError,
          textCapitalization: TextCapitalization.words,
          borderColor: Colors.transparent,
          prefixIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Image.asset(
              appIcons.profileProgram,
              color: const Color(0xFF857373),
              height: 18,
              width: 18,
            ),
          ),
          onChanged: (_) {
            if (_firstNameError != null) _validate();
          },
        ),
        const SizedBox(height: 16),
        CommonTextField(
          label: "Last Name",
          controller: _lastNameController,
          isRequired: true,
          hint: "e.g. Sharma",
          error: _lastNameError,
          textCapitalization: TextCapitalization.words,
          borderColor: Colors.transparent,
          prefixIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Image.asset(
              appIcons.profileProgram,
              color: const Color(0xFF857373),
              height: 18,
              width: 18,
            ),
          ),
          onChanged: (_) {
            if (_lastNameError != null) _validate();
          },
        ),
      ],
    );
  }

  Widget _buildAccountDetailsSection(UserData? user) {
    return ProfileSectionCard(
      title: "Account Information",
      icon: appIcons.email,
      children: [
        CommonTextField(
          label: "Email Address",
          controller: _emailController,
          isRequired: false,
          readOnly: true,
          hint: "Not available",
          borderColor: Colors.transparent,
          fillColor: appColors.textFieldBgColor,
          prefixIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Image.asset(
              appIcons.email,
              color: const Color(0xFF857373),
              height: 18,
              width: 18,
            ),
          ),
          suffixIcon: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Icon(Icons.lock_outline_rounded, color: Color(0xFF857373), size: 18),
          ),
        ),
        const SizedBox(height: 16),
        CommonTextField(
          label: "Mobile Number",
          controller: _mobileController,
          isRequired: false,
          readOnly: true,
          hint: "Not available",
          borderColor: Colors.transparent,
          fillColor: appColors.textFieldBgColor,
          prefixIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Image.asset(
              appIcons.call,
              color: const Color(0xFF857373),
              height: 18,
              width: 18,
            ),
          ),
          suffixIcon: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Icon(Icons.lock_outline_rounded, color: Color(0xFF857373), size: 18),
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.info_outline_rounded, size: 15, color: appColors.grey),
              const SizedBox(width: 6),
              Expanded(
                child: CommonText(
                  "Email and phone number are connected to your account login and cannot be modified here.",
                  style: TextStyle(
                    fontSize: 12,
                    color: appColors.grey,
                    fontWeight: FontWeight.w400,
                  ),
                  fontFamily: fontFamilyPlusJakartaSans,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
