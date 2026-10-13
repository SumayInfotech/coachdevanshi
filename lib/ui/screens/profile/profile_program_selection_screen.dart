import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../main.dart';
import '../../../core/constants/utils.dart';
import '../../widgets/common_app_bar.dart';
import '../../widgets/common_button.dart';
import '../../widgets/common_text.dart';
import '../../widgets/common_text_field.dart';
import 'goals_starting_point_screen.dart';

class ProfileProgramSelectionScreen extends StatefulWidget {
  const ProfileProgramSelectionScreen({super.key});

  @override
  State<ProfileProgramSelectionScreen> createState() => _ProfileProgramSelectionScreenState();
}

class _ProfileProgramSelectionScreenState extends State<ProfileProgramSelectionScreen> {
  final TextEditingController _emailController = TextEditingController(text: "ananaya.sharma@gmail.com");
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _dailyRhythmController = TextEditingController();

  String? _fullNameError;
  String? _mobileError;
  String? _dobError;
  String? _cityError;
  String? _dailyRhythmError;

  String _selectedGender = 'Female';
  String _selectedJourney = 'Rooted Recovery for New Moms';
  String _selectedCountry = 'India';

  bool _validate() {
    bool isValid = true;

    if (_fullNameController.text.trim().isEmpty) {
      _fullNameError = "Please enter your full name";
      isValid = false;
    } else {
      _fullNameError = null;
    }

    if (_mobileController.text.length < 10) {
      _mobileError = "Please enter a valid 10-digit mobile number";
      isValid = false;
    } else {
      _mobileError = null;
    }

    if (_dobController.text.trim().isEmpty) {
      _dobError = "Please enter your date of birth";
      isValid = false;
    } else {
      _dobError = null;
    }

    if (_cityController.text.trim().isEmpty) {
      _cityError = "Please enter your city";
      isValid = false;
    } else {
      _cityError = null;
    }

    if (_dailyRhythmController.text.trim().length < 50) {
      _dailyRhythmError = "Please enter at least 50 characters";
      isValid = false;
    } else {
      _dailyRhythmError = null;
    }

    setState(() {});
    return isValid;
  }

  void _onSaveAndContinue() {
    if (_validate()) {
      // Navigate to next screen
      appLog("Form Validated! Ready to proceed.");
      navigation.pushReplaceFadeAnimation(context, GoalsStartingPointScreen());
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _fullNameController.dispose();
    _nicknameController.dispose();
    _mobileController.dispose();
    _dobController.dispose();
    _cityController.dispose();
    _dailyRhythmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColors.bgColor,
      appBar: CommonAppBar(
        appBarColor: appColors.bgColor.withValues(alpha: 0.85),
        centerTitle: true,
        leading: buildInkWell(
          onTap: () => navigation.pop(context),
          child: Container(
            alignment: Alignment.center,
            child: Icon(
              Icons.arrow_back,
              size: 24,
              color: appColors.neutral,
            ),
          ),
        ),
        title: Column(
          children: [
            CommonText(
              "CHAPTER 1 OF 6",
              style: TextStyle(
                fontSize: 11,
                color: appColors.primary,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.55,
              ),
            ),
            CommonText(
              "Profile & Program",
              style: TextStyle(
                fontSize: 16,
                color: const Color(0xFF1D1B1A),
                fontWeight: FontWeight.w500,
                fontFamily: "Playfair_Display",
                letterSpacing: 0.24,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                children: [
                  _buildPersonalDetailsSection(),
                  const SizedBox(height: 24),
                  _buildBiologicalContextSection(),
                  const SizedBox(height: 24),
                  _buildLocationSection(),
                  const SizedBox(height: 24),
                  _buildDailyLifeSection(),
                  const SizedBox(height: 24),
                  _buildCoachingJourneySection(),
                ],
              ),
            ),
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({required String title, required String icon, required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: appColors.white,
        borderRadius: BorderRadius.circular(12),
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
          Row(
            children: [
              Image.asset(icon, height: 20, width: 20, color: appColors.primary),
              const SizedBox(width: 10),
              CommonText(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  fontFamily: "Playfair_Display",
                  color: const Color(0xFF1D1B1A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildPersonalDetailsSection() {
    return _buildSectionCard(
      title: "Personal Details",
      icon: appIcons.personalDetail,
      children: [
        CommonTextField(
          label: "Email address",
          controller: _emailController,
          isRequired: true,
          hint: "",
          readOnly: true,
          borderColor: Colors.transparent,
          prefixIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Image.asset(appIcons.email, color: Color(0xFF857373), height: 18, width: 18),
          ),
        ),
        const SizedBox(height: 16),
        CommonTextField(
          label: "Full name",
          controller: _fullNameController,
          isRequired: true,
          hint: "Enter your full name",
          error: _fullNameError,
          borderColor: Colors.transparent,
          prefixIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Image.asset(appIcons.profileProgram, color: Color(0xFF857373), height: 18, width: 18),
          ),
          onChanged: (v) {
            if (_fullNameError != null) _validate();
          },
        ),
        const SizedBox(height: 16),
        CommonTextField(
          label: "What name would you like us to use?",
          controller: _nicknameController,
          isRequired: false,
          hint: "Enter Nickname",
          borderColor: Colors.transparent,
          prefixIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Image.asset(appIcons.smile, color: Color(0xFF857373), height: 18, width: 18),
          ),
        ),
        const SizedBox(height: 4),
        CommonText(
          "Optional — what friends or coaches call you",
          style: TextStyle(fontSize: 11, color: const Color(0xFF534343), fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 16),
        CommonTextField(
          label: "Mobile number",
          controller: _mobileController,
          isRequired: true,
          hint: "Enter Mobile No.",
          keyboardType: TextInputType.phone,
          error: _mobileError,
          borderColor: Colors.transparent,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10),
          ],
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 14, right: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CommonText(
                  "🇮🇳 +91",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1D1B1A),
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF1D1B1A), size: 16),
                const SizedBox(width: 8),
                Container(height: 24, width: 1, color: const Color(0xFFE7E1DF)),
              ],
            ),
          ),
          onChanged: (v) {
            if (_mobileError != null) _validate();
          },
        ),
        const SizedBox(height: 16),
        CommonTextField(
          label: "Date of Birth",
          controller: _dobController,
          isRequired: true,
          hint: "MM / DD / YYYY",
          error: _dobError,
          borderColor: Colors.transparent,
          prefixIcon: const Icon(Icons.calendar_today_rounded, color: Color(0xFF857373), size: 20),
          onChanged: (v) {
            if (_dobError != null) _validate();
          },
        ),
      ],
    );
  }

  Widget _buildBiologicalContextSection() {
    return _buildSectionCard(
      title: "Biological Context",
      icon: appIcons.progress, // using a relevant icon
      children: [
        RichText(
          text: TextSpan(
            style: const TextStyle(
              fontSize: 13,
              fontFamily: fontFamilyPlusJakartaSans,
              color: Color(0xFF534343),
            ),
            children: [
              const TextSpan(
                text: "For health planning and calculations, please select one from below? ",
                style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF1D1B1A)),
              ),
              TextSpan(
                text: "*",
                style: TextStyle(color: appColors.primary),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _buildSelectionPill(
          label: "Female",
          icon: Icons.female_rounded,
          isSelected: _selectedGender == "Female",
          onTap: () => setState(() => _selectedGender = "Female"),
        ),
        const SizedBox(height: 10),
        _buildSelectionPill(
          label: "Male",
          icon: Icons.male_rounded,
          isSelected: _selectedGender == "Male",
          onTap: () => setState(() => _selectedGender = "Male"),
        ),
        const SizedBox(height: 10),
        _buildSelectionPill(
          label: "Prefer not to answer",
          icon: Icons.transgender_rounded,
          isSelected: _selectedGender == "Prefer not to answer",
          onTap: () => setState(() => _selectedGender = "Prefer not to answer"),
        ),
      ],
    );
  }

  Widget _buildSelectionPill({required String label, required IconData icon, required bool isSelected, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFDADB) : appColors.textFieldBgColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: isSelected
              ? [BoxShadow(color: appColors.black.withValues(alpha: 0.05), offset: const Offset(0, 1), blurRadius: 1)]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, color: isSelected ? const Color(0xFF713439) : const Color(0xFF1D1B1A), size: 16),
                const SizedBox(width: 12),
                CommonText(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? const Color(0xFF713439) : const Color(0xFF1D1B1A),
                  ),
                ),
              ],
            ),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? appColors.primary : appColors.white,
                border: isSelected ? null : Border.all(color: const Color(0xFFE7E1DF)),
              ),
              child: isSelected ? Icon(Icons.check, size: 12, color: appColors.white) : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationSection() {
    return _buildSectionCard(
      title: "Location",
      icon: appIcons.world,
      children: [
        RichText(
          text: TextSpan(
            style: const TextStyle(
              fontSize: 13,
              fontFamily: fontFamilyPlusJakartaSans,
              color: Color(0xFF534343),
            ),
            children: [
              const TextSpan(text: "Where are you currently based? "),
              TextSpan(text: "*", style: TextStyle(color: appColors.primary)),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: CommonTextField(
                label: "City",
                controller: _cityController,
                isRequired: false,
                hint: "e.g. Ahmedabad",
                error: _cityError,
                borderColor: Colors.transparent,
                onChanged: (v) {
                  if (_cityError != null) _validate();
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CommonTextField(
                label: "Country",
                controller: TextEditingController(text: _selectedCountry),
                isRequired: false,
                hint: "",
                readOnly: true,
                borderColor: Colors.transparent,
                suffixIcon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF1D1B1A), size: 18),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: appColors.textFieldBgColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2EDEB),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.access_time_rounded, color: Color(0xFF576245), size: 16),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonText(
                        "TIME ZONE",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF576245),
                          letterSpacing: 0.55,
                        ),
                      ),
                      CommonText(
                        "Auto-detected: IST (UTC+5:30)",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF1D1B1A),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Icon(Icons.refresh_rounded, color: Color(0xFF576245), size: 16),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDailyLifeSection() {
    return _buildSectionCard(
      title: "Daily Life & Schedule",
      icon: appIcons.dailyLifeSchedule,
      children: [
        RichText(
          text: TextSpan(
            style: const TextStyle(
              fontSize: 13,
              fontFamily: fontFamilyPlusJakartaSans,
              color: Color(0xFF1D1B1A),
            ),
            children: [
              const TextSpan(text: "Your Daily Rhythm ", style: TextStyle(fontWeight: FontWeight.w600)),
              TextSpan(text: "*", style: TextStyle(color: appColors.primary, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        const SizedBox(height: 4),
        CommonText(
          "Share your commitments, typical sleep/wake times, desk vs. active hours, or family responsibilities so we fit wellness into your real life.",
          style: TextStyle(
            fontSize: 13,
            color: const Color(0xFF534343),
            height: 20 / 13,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          height: 134,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: appColors.textFieldBgColor,
            borderRadius: BorderRadius.circular(12),
            border: _dailyRhythmError != null ? Border.all(color: appColors.red) : null,
          ),
          child: TextField(
            controller: _dailyRhythmController,
            maxLines: null,
            keyboardType: TextInputType.multiline,
            style: TextStyle(
              fontSize: 15,
              color: const Color(0xFF1D1B1A),
              fontFamily: fontFamilyPlusJakartaSans,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "e.g. I work a hybrid job 9:30-6:30 with a commute on weekdays. Usually wake up by 6:30 AM, prepare meals with family, have chai around 5 PM, and wind down by 10:30 PM...",
              hintStyle: TextStyle(
                fontSize: 15,
                color: const Color(0xFF857373),
                fontFamily: fontFamilyPlusJakartaSans,
              ),
            ),
            onChanged: (v) {
              setState(() {});
              if (_dailyRhythmError != null) _validate();
            },
          ),
        ),
        if (_dailyRhythmError != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 4),
            child: CommonText(
              _dailyRhythmError!,
              style: TextStyle(color: appColors.red, fontSize: 12),
            ),
          ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset(appIcons.edit, height: 12, width: 12, color: const Color(0xFF576245)),
                const SizedBox(width: 4),
                CommonText(
                  "Min 50 characters",
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF576245),
                  ),
                ),
              ],
            ),
            CommonText(
              "${_dailyRhythmController.text.length} chars",
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF857373),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCoachingJourneySection() {
    return _buildSectionCard(
      title: "Coaching Journey",
      icon: appIcons.coachingJourney,
      children: [
        RichText(
          text: TextSpan(
            style: const TextStyle(
              fontSize: 13,
              fontFamily: fontFamilyPlusJakartaSans,
              color: Color(0xFF534343),
            ),
            children: [
              const TextSpan(text: "Which coaching journey are you joining? "),
              TextSpan(text: "*", style: TextStyle(color: appColors.primary)),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _buildJourneyPill(
          title: "Fat Loss and Inch Loss",
          subtitle: "Sustainable metabolic tuning & mindful body recomp",
          icon: appIcons.fatInchLoss,
          isSelected: _selectedJourney == "Fat Loss and Inch Loss",
          onTap: () => setState(() => _selectedJourney = "Fat Loss and Inch Loss"),
        ),
        const SizedBox(height: 12),
        _buildJourneyPill(
          title: "Healthy Weight Gain",
          subtitle: "Nourishing caloric density & strength optimization",
          icon: appIcons.healthyWeightGain,
          isSelected: _selectedJourney == "Healthy Weight Gain",
          onTap: () => setState(() => _selectedJourney = "Healthy Weight Gain"),
        ),
        const SizedBox(height: 12),
        _buildJourneyPill(
          title: "Rooted Recovery for New Moms",
          subtitle: "Postpartum restorative nourishment & gentle hormonal balance",
          icon: appIcons.rootedRecovery,
          isSelected: _selectedJourney == "Rooted Recovery for New Moms",
          onTap: () => setState(() => _selectedJourney = "Rooted Recovery for New Moms"),
        ),
        const SizedBox(height: 12),
        _buildJourneyPill(
          title: "Maintenance and Lifestyle Management",
          subtitle: "Long-term nutritional intuition & energy stability",
          icon: appIcons.maintenance,
          isSelected: _selectedJourney == "Maintenance and Lifestyle Management",
          onTap: () => setState(() => _selectedJourney = "Maintenance and Lifestyle Management"),
        ),
        const SizedBox(height: 12),
        _buildJourneyPill(
          title: "Gut Reset",
          subtitle: "Microbiome rebalancing & anti-inflammatory food protocols",
          icon: appIcons.progress,
          isSelected: _selectedJourney == "Gut Reset",
          onTap: () => setState(() => _selectedJourney = "Gut Reset"),
        ),
      ],
    );
  }

  Widget _buildJourneyPill({required String title, required String subtitle, required String icon, required bool isSelected, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFDADB) : appColors.textFieldBgColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: isSelected
              ? [BoxShadow(color: appColors.black.withValues(alpha: 0.05), offset: const Offset(0, 1), blurRadius: 1)]
              : null,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected ? appColors.primary : const Color(0xFFD8C1C2),
                shape: BoxShape.circle,
              ),
              child: Image.asset(icon, color: isSelected ? appColors.white : const Color(0xFF1D1B1A)),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonText(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1D1B1A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  CommonText(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: const Color(0xFF534343),
                      height: 17.88 / 13,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 14),
            Container(
              width: 20,
              height: 20,
              margin: const EdgeInsets.only(top: 4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? appColors.primary : appColors.white,
                border: isSelected ? null : Border.all(color: const Color(0xFFE7E1DF)),
              ),
              child: isSelected ? Icon(Icons.check, size: 12, color: appColors.white) : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 12, 16, bottomPadding(context) > 0 ? bottomPadding(context) : 24),
      decoration: BoxDecoration(
        color: appColors.bgColor.withValues(alpha: 0.9),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF292726).withValues(alpha: 0.04),
            offset: const Offset(0, -4),
            blurRadius: 20,
          ),
        ],
      ),
      child: CommonButton(
        name: "Save & Continue to Goals & Starting Point",
        icon: Icons.arrow_forward_rounded,
        isIconFirst: false,
        imageSize: 16,
        btnColor: appColors.primary,
        fontSize: 14,
        fontWeight: FontWeight.w700,
        onTap: _onSaveAndContinue,
      ),
    );
  }
}
