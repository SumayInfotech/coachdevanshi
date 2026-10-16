import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../main.dart';
import '../../../core/constants/utils.dart';
import '../../widgets/common_app_bar.dart';
import '../../widgets/common_button.dart';
import '../../widgets/common_text.dart';
import '../../widgets/common_text_field.dart';
import '../profile/widget/profile_section_card.dart';
import 'three_day_food_diary_screen.dart';

class TrackWeeklyProgressScreen extends StatefulWidget {
  const TrackWeeklyProgressScreen({super.key});

  @override
  State<TrackWeeklyProgressScreen> createState() => _TrackWeeklyProgressScreenState();
}

class _TrackWeeklyProgressScreenState extends State<TrackWeeklyProgressScreen> {
  final TextEditingController _dateController = TextEditingController(text: DateFormat('MMMM dd, yyyy').format(DateTime.now()));
  DateTime _selectedDate = DateTime.now();
  String? _dateError;

  File? _frontViewImage;
  String? _frontViewError;

  File? _sideViewImage;
  String? _sideViewError;

  File? _backViewImage;
  String? _backViewError;

  bool _consentGiven = false;
  String? _consentError;

  bool _validate() {
    bool isValid = true;

    if (_dateController.text.trim().isEmpty) {
      _dateError = "Date is required";
      isValid = false;
    } else {
      _dateError = null;
    }

    if (_frontViewImage == null) {
      _frontViewError = "Front view photo is required";
      isValid = false;
    } else {
      _frontViewError = null;
    }

    if (_sideViewImage == null) {
      _sideViewError = "Side view photo is required";
      isValid = false;
    } else {
      _sideViewError = null;
    }

    if (_backViewImage == null) {
      _backViewError = "Back view photo is required";
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

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('MMMM dd, yyyy').format(picked);
        if (_dateError != null) _validate();
      });
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
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE7E1DF),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: Icon(Icons.camera_alt_outlined, color: appColors.primary),
              title: CommonText("Take Photo", style: TextStyle(color: appColors.neutral, fontSize: 16, fontWeight: FontWeight.w500)),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: Icon(Icons.photo_library_outlined, color: appColors.primary),
              title: CommonText("Choose from Gallery", style: TextStyle(color: appColors.neutral, fontSize: 16, fontWeight: FontWeight.w500)),
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
      setState(() {
        if (viewType == "Front") {
          _frontViewImage = File(image.path);
          _frontViewError = null;
        } else if (viewType == "Side") {
          _sideViewImage = File(image.path);
          _sideViewError = null;
        } else if (viewType == "Back") {
          _backViewImage = File(image.path);
          _backViewError = null;
        }
      });
    }
  }

  void _onSave() {
    if (_validate()) {
      appLog("Progress Photos Saved!");
      _onBack();
    }
  }

  void _onBack() {
    navigation.pushReplaceSlideAnimation(context, ThreeDayFoodDiaryScreen());
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
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
                "Submit with one or more photos. You can update or\nadd more angles at any time.",
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
    String? error,
  }) {
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
            height: imageFile != null ? 240 : null,
            padding: imageFile != null ? EdgeInsets.zero : const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              color: appColors.textFieldBgColor,
              borderRadius: BorderRadius.circular(12),
              border: error != null ? Border.all(color: appColors.red) : null,
            ),
            child: imageFile != null 
              ? Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.file(imageFile, fit: BoxFit.cover),
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
                )
              : Column(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
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
                        child: Image.asset(appIcons.addPhoto, color: appColors.primary, width: 24, height: 24)
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
        if (error != null)
          Padding(
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
                  width: 20,
                  height: 20,
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
          if (_consentError != null)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: CommonText(_consentError!, style: TextStyle(color: appColors.red, fontSize: 12)),
            ),
        ],
      ),
    );
  }
}
