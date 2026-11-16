import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../main.dart';
import '../../../core/constants/urls.dart';
import '../../../core/constants/utils.dart';
import '../../../core/models/progress/progress_photos_model.dart';
import '../../../core/services/loader_service.dart';
import '../../../core/blocs/progress/get_progress_photos/get_progress_photos_bloc.dart';
import '../../../core/blocs/progress/upload_progress_photos/upload_progress_photos_bloc.dart';
import '../../widgets/common_app_bar.dart';
import '../../widgets/common_button.dart';
import '../../widgets/common_text.dart';
import '../../widgets/common_text_field.dart';
import '../../widgets/custom_network_image.dart';
import '../profile/widget/profile_section_card.dart';
import 'three_day_food_diary_screen.dart';

class TrackWeeklyProgressScreen extends StatefulWidget {
  final bool isBack;
  const TrackWeeklyProgressScreen({super.key, this.isBack = false});

  @override
  State<TrackWeeklyProgressScreen> createState() => _TrackWeeklyProgressScreenState();
}

class _TrackWeeklyProgressScreenState extends State<TrackWeeklyProgressScreen> {
  final TextEditingController _dateController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String? _dateError;

  File? _frontViewImage;
  String? _frontViewUrl;
  String? _frontViewError;

  File? _sideViewImage;
  String? _sideViewUrl;
  String? _sideViewError;

  File? _backViewImage;
  String? _backViewUrl;
  String? _backViewError;

  bool _consentGiven = false;
  String? _consentError;

  List<ProgressPhotoItem> _photosList = [];

  static const int _maxImageSizeBytes = 15 * 1024 * 1024; // 15MB

  @override
  void initState() {
    super.initState();
    _dateController.text = DateFormat('MMMM dd, yyyy').format(_selectedDate);
    callGetProgressPhotosAPI();
  }

  void callGetProgressPhotosAPI() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      LoaderService.show(context);
      BlocProvider.of<GetProgressPhotosBloc>(context).add(
        const UserGetProgressPhotosEvent(url: Urls.getProgressPhotos),
      );
    });
  }

  void _populateForSelectedDate() {
    final String dateStr = DateFormat('yyyy-MM-dd').format(_selectedDate);
    final ProgressPhotoItem? item = _photosList.cast<ProgressPhotoItem?>().firstWhere(
      (p) => p?.recordDate == dateStr,
      orElse: () => null,
    );

    if (item != null) {
      _frontViewImage = null;
      _frontViewUrl = item.frontPhoto?.url;
      _sideViewImage = null;
      _sideViewUrl = item.sidePhoto?.url;
      _backViewImage = null;
      _backViewUrl = item.backPhoto?.url;
      _consentGiven = item.consent ?? false;
      _frontViewError = null;
      _sideViewError = null;
      _backViewError = null;
      _consentError = null;
    } else {
      _clearPhotos();
    }
    setState(() {});
  }

  void _clearPhotos() {
    _frontViewImage = null;
    _frontViewUrl = null;
    _sideViewImage = null;
    _sideViewUrl = null;
    _backViewImage = null;
    _backViewUrl = null;
    _consentGiven = false;
    _frontViewError = null;
    _sideViewError = null;
    _backViewError = null;
    _consentError = null;
    setState(() {});
  }

  bool _validate() {
    bool isValid = true;

    if (_dateController.text.trim().isEmpty) {
      _dateError = "Date is required";
      isValid = false;
    } else {
      _dateError = null;
    }

    if (_frontViewImage == null && (_frontViewUrl == null || _frontViewUrl!.isEmpty)) {
      _frontViewError = "Front view photo is required";
      isValid = false;
    } else if (_frontViewImage != null && _frontViewImage!.existsSync() && _frontViewImage!.lengthSync() > _maxImageSizeBytes) {
      _frontViewError = "Image size must not exceed 15MB";
      isValid = false;
    } else {
      _frontViewError = null;
    }

    if (_sideViewImage == null && (_sideViewUrl == null || _sideViewUrl!.isEmpty)) {
      _sideViewError = "Side view photo is required";
      isValid = false;
    } else if (_sideViewImage != null && _sideViewImage!.existsSync() && _sideViewImage!.lengthSync() > _maxImageSizeBytes) {
      _sideViewError = "Image size must not exceed 15MB";
      isValid = false;
    } else {
      _sideViewError = null;
    }

    if (_backViewImage == null && (_backViewUrl == null || _backViewUrl!.isEmpty)) {
      _backViewError = "Back view photo is required";
      isValid = false;
    } else if (_backViewImage != null && _backViewImage!.existsSync() && _backViewImage!.lengthSync() > _maxImageSizeBytes) {
      _backViewError = "Image size must not exceed 15MB";
      isValid = false;
    } else {
      _backViewError = null;
    }

    if (!_consentGiven) {
      _consentError = "Please accept the verification and consent terms";
      isValid = false;
    } else {
      _consentError = null;
    }

    setState(() {});
    return isValid;
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('MMMM dd, yyyy').format(picked);
        if (_dateError != null) _validate();
      });
      _populateForSelectedDate();
    }
  }

  Future<void> _pickImage(String viewType) async {
    final ImageSource? source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: appColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE7E1DF),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: Icon(Icons.camera_alt_outlined, color: appColors.primary),
              title: CommonText(
                "Take Photo",
                style: TextStyle(
                  color: appColors.neutral, fontSize: 16, fontWeight: FontWeight.w500
                )
              ),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: Icon(Icons.photo_library_outlined, color: appColors.primary),
              title: CommonText(
                "Choose from Gallery",
                style: TextStyle(
                  color: appColors.neutral, fontSize: 16, fontWeight: FontWeight.w500
                )
              ),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );

    if (source == null) return;

    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);
    
    if (image != null) {
      final int imageLength = await image.length();
      if (imageLength > _maxImageSizeBytes) {
        if (mounted) {
          showSnackBar(
            context: context,
            isError: true,
            message: "Selected image exceeds 15MB limit. Please choose a smaller image.",
          );
        }
        return;
      }

      setState(() {
        if (viewType == "Front") {
          _frontViewImage = File(image.path);
          _frontViewUrl = null;
          _frontViewError = null;
        } else if (viewType == "Side") {
          _sideViewImage = File(image.path);
          _sideViewUrl = null;
          _sideViewError = null;
        } else if (viewType == "Back") {
          _backViewImage = File(image.path);
          _backViewUrl = null;
          _backViewError = null;
        }
      });
    }
  }

  void _onSave() {
    if (_validate()) {
      if (_frontViewImage == null && _sideViewImage == null && _backViewImage == null && _frontViewUrl != null) {
        showSnackBar(
          context: context,
          isError: false,
          message: "Progress photos already uploaded for this date",
        );
        _onBack();
        return;
      }

      LoaderService.show(context);

      final Map<String, dynamic> body = {
        "record_date": DateFormat('yyyy-MM-dd').format(_selectedDate),
        "consent": "true",
        if (_frontViewImage != null) "front_photo": _frontViewImage,
        if (_sideViewImage != null) "side_photo": _sideViewImage,
        if (_backViewImage != null) "back_photo": _backViewImage,
      };

      BlocProvider.of<UploadProgressPhotosBloc>(context).add(
        UserUploadProgressPhotosEvent(
          url: Urls.progressPhotos,
          body: body,
        ),
      );
    }
  }

  void _onBack() {
    if(widget.isBack) {
      navigation.pop(context);
    } else {
      navigation.pushReplaceSlideAnimation(context, ThreeDayFoodDiaryScreen());
    }
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<GetProgressPhotosBloc, GetProgressPhotosState>(
          listener: (context, state) {
            if (state is GetProgressPhotosSuccess) {
              LoaderService.hide();
              _photosList = state.model.data?.photos ?? [];
              _populateForSelectedDate();
            } else if (state is GetProgressPhotosFailed) {
              LoaderService.hide();
              _clearPhotos();
            }
          },
        ),
        BlocListener<UploadProgressPhotosBloc, UploadProgressPhotosState>(
          listener: (context, state) {
            if (state is UploadProgressPhotosSuccess) {
              LoaderService.hide();
              showSnackBar(
                context: context,
                isError: false,
                message: state.model.message ?? "Progress photos uploaded successfully",
              );
              _onBack();
            } else if (state is UploadProgressPhotosFailed) {
              LoaderService.hide();
              showSnackBar(
                context: context,
                isError: true,
                message: state.message,
              );
            }
          },
        ),
      ],
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          _onBack();
        },
        child: Scaffold(
          backgroundColor: appColors.bgColor,
          appBar: CommonAppBar(
            appBarColor: appColors.bgColor.withValues(alpha: 0.85),
            centerTitle: true,
            leading: buildInkWell(
              onTap: _onBack,
              child: Container(
                alignment: Alignment.center,
                child: Icon(
                  Icons.arrow_back,
                  size: 24,
                  color: appColors.neutral,
                ),
              ),
            ),
            title: CommonText(
              "Baseline And Progress Measurements",
              fontFamily: fontPlayfairDisplay,
              style: TextStyle(
                fontSize: 16,
                color: const Color(0xFF1D1B1A),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24).copyWith(bottom: bottomPadding(context)),
            children: [
              _buildDateSection(),
              const SizedBox(height: 16),
              _buildPhotoUploadSection(
                title: "Front View",
                icon: appIcons.abdomen,
                description: "Stand relaxed, arms slightly away from sides, facing directly at the camera.",
                hintTitle: "Full length · Eye-level angle",
                hintIcon: Icons.camera_alt_outlined,
                imageFile: _frontViewImage,
                imageUrl: _frontViewUrl,
                error: _frontViewError,
                onTap: () => _pickImage("Front"),
              ),
              const SizedBox(height: 16),
              _buildPhotoUploadSection(
                title: "Side View (Profile)",
                icon: appIcons.movement,
                description: "Turn 90 degrees to show natural posture, spinal alignment, and abdominal profile.",
                hintTitle: "Right or Left Profile · Relaxed breath",
                hintIcon: Icons.person_outline_rounded,
                imageFile: _sideViewImage,
                imageUrl: _sideViewUrl,
                error: _sideViewError,
                onTap: () => _pickImage("Side"),
              ),
              const SizedBox(height: 16),
              _buildPhotoUploadSection(
                title: "Back View",
                icon: appIcons.maintenance,
                description: "Stand upright showing shoulders, upper back, and hip alignment.",
                hintTitle: "Even weight on both feet",
                hintIcon: Icons.visibility_outlined,
                imageFile: _backViewImage,
                imageUrl: _backViewUrl,
                error: _backViewError,
                onTap: () => _pickImage("Back"),
              ),
              const SizedBox(height: 16),
              _buildConsentSection(),
              const SizedBox(height: 24),
              CommonButton(
                name: "Save Progress Photos",
                icon: Icons.arrow_forward_rounded,
                isIconFirst: false,
                imageSize: 16,
                btnColor: appColors.primary,
                fontSize: 14,
                fontWeight: FontWeight.w700,
                onTap: _onSave,
              ),
              const SizedBox(height: 16),
              Center(
                child: CommonText(
                  "Submit with one or more photos. You can update or add more angles at any time.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: const Color(0xFF534343),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateSection() {
    return ProfileSectionCard(
      title: "Photo Date",
      icon: appIcons.calender,
      children: [
        buildRequiredLabel("Date of record for body composition markers"),
        const SizedBox(height: 8),
        CommonTextField(
          label: '',
          controller: _dateController,
          hint: "October 24, 2024",
          fillColor: appColors.textFieldBgColor,
          borderColor: Colors.transparent,
          readOnly: true,
          suffixIcon: Icon(Icons.edit_calendar_outlined, size: 18, color: appColors.primary),
          error: _dateError,
          onTap: _selectDate,
        ),
      ],
    );
  }

  Widget _buildPhotoUploadSection({
    required String title,
    required String icon,
    required String description,
    required String hintTitle,
    required IconData hintIcon,
    required VoidCallback onTap,
    File? imageFile,
    String? imageUrl,
    String? error,
  }) {
    final bool hasImage = imageFile != null || (imageUrl != null && imageUrl.isNotEmpty);
    return ProfileSectionCard(
      title: title,
      icon: icon,
      children: [
        CommonText(
          description,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF534343),
            height: 20 / 13,
          ),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            height: hasImage ? 240 : null,
            padding: hasImage ? EdgeInsets.zero : const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              color: appColors.textFieldBgColor,
              borderRadius: BorderRadius.circular(12),
              border: error != null ? Border.all(color: appColors.red) : null,
            ),
            child: hasImage ? Stack(
              fit: StackFit.expand,
              children: [
                if (imageFile != null)
                  Image.file(imageFile, fit: BoxFit.cover)
                else if (imageUrl != null && imageUrl.isNotEmpty)
                  CustomNetworkImage(image: imageUrl, fit: BoxFit.cover),
                Positioned(
                  top: 12,
                  right: 12,
                  child: GestureDetector(
                    onTap: onTap,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: appColors.black.withValues(alpha: 0.6),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.edit, color: appColors.white, size: 18),
                    ),
                  ),
                ),
              ],
            ) : Column(
              children: [
                Container(
                  width: 56, height: 56,
                  decoration: BoxDecoration(
                    color: appColors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: appColors.black.withValues(alpha: 0.05),
                        blurRadius: 1,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Image.asset(
                      appIcons.addPhoto, color: appColors.primary, width: 24, height: 24
                    )
                  ),
                ),
                const SizedBox(height: 16),
                CommonText(
                  "Tap to upload or take photo",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: appColors.primary,
                  ),
                ),
                const SizedBox(height: 4),
                CommonText(
                  "Supports JPG, PNG up to 15MB",
                  style: TextStyle(
                    fontSize: 13,
                    color: const Color(0xFF534343),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: appColors.white,
                    borderRadius: BorderRadius.circular(999),
                    boxShadow: [
                      BoxShadow(
                        color: appColors.black.withValues(alpha: 0.05),
                        blurRadius: 1,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(hintIcon, color: const Color(0xFF534343), size: 14),
                      const SizedBox(width: 6),
                      CommonText(
                        hintTitle,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF534343),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        if (error != null) Padding(
          padding: const EdgeInsets.only(top: 8),
          child: CommonText(error, style: TextStyle(color: appColors.red, fontSize: 12)),
        ),
      ],
    );
  }

  Widget _buildConsentSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: appColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: appColors.black.withValues(alpha: 0.05),
            offset: const Offset(0, 1),
            blurRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonText(
            "VERIFICATION & CONSENT *",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: appColors.primary,
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _consentGiven = !_consentGiven;
                    if (_consentError != null) _validate();
                  });
                },
                child: Container(
                  width: 20, height: 20,
                  decoration: BoxDecoration(
                    color: _consentGiven ? appColors.primary : appColors.white,
                    borderRadius: BorderRadius.circular(6),
                    border: _consentGiven ? null : Border.all(color: const Color(0xFFE7E1DF)),
                  ),
                  child: _consentGiven ? Icon(Icons.check, size: 14, color: appColors.white) : null,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonText(
                      "I understand these photos will be stored privately and used only to monitor my coaching progress.",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF1D1B1A),
                        height: 22 / 13,
                      ),
                    ),
                    const SizedBox(height: 8),
                    CommonText(
                      "Restricted strictly to you and your authorized coaching team. Never shared, published, or accessible outside your care circle.",
                      style: TextStyle(
                        fontSize: 13,
                        color: const Color(0xFF534343),
                        height: 22 / 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (_consentError != null) Padding(
            padding: const EdgeInsets.only(top: 12),
            child: CommonText(_consentError!, style: TextStyle(color: appColors.red, fontSize: 12)),
          ),
        ],
      ),
    );
  }
}
