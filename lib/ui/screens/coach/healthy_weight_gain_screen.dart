import 'package:flutter/material.dart';

import '../../../../main.dart';
import '../../../core/constants/utils.dart';
import '../../widgets/common_app_bar.dart';
import '../../widgets/common_button.dart';
import '../../widgets/common_text.dart';
import '../../widgets/common_text_field.dart';
import '../profile/widget/profile_section_card.dart';

class HealthyWeightGainScreen extends StatefulWidget {
  const HealthyWeightGainScreen({super.key});

  @override
  State<HealthyWeightGainScreen> createState() => _HealthyWeightGainScreenState();
}

class _HealthyWeightGainScreenState extends State<HealthyWeightGainScreen> {
  // Section 1: Weight History Intentionality
  String? _weightIntentionality;
  String? _weightIntentionalityError;

  // Section 2: Six-Month Weight Trajectory
  bool _isKgSelected = true;
  final TextEditingController _startingWeightController = TextEditingController(text: "52.0");
  final TextEditingController _currentWeightController = TextEditingController(text: "47.5");
  String _trajectoryNature = "Unplanned change";

  // Section 3: Appetite & Digestive Sensations
  final List<String> _appetiteSensationsList = [
    "Low appetite", "Feel full very quickly", "Difficulty swallowing",
    "Nausea", "Digestive discomfort", "None of these"
  ];
  final Set<String> _selectedAppetiteSensations = {};
  String? _appetiteSensationsError;

  // Section 4: Personal Vision
  final List<String> _goalsList = [
    "More strength", "More muscle", "Better energy", "Improved appetite",
    "Healthy weight restoration", "Sports performance"
  ];
  final Set<String> _selectedGoals = {};
  String? _goalsError;
  final TextEditingController _otherGoalsController = TextEditingController();

  bool _validate() {
    bool isValid = true;

    // Weight Intentionality
    if (_weightIntentionality == null) {
      _weightIntentionalityError = "Required";
      isValid = false;
    } else {
      _weightIntentionalityError = null;
    }

    // Appetite Sensations
    if (_selectedAppetiteSensations.isEmpty) {
      _appetiteSensationsError = "Please select at least 1 sensation";
      isValid = false;
    } else {
      _appetiteSensationsError = null;
    }

    // Personal Vision Goals (max 3 allowed)
    if (_selectedGoals.isEmpty) {
      _goalsError = "Please select at least 1 goal";
      isValid = false;
    } else {
      _goalsError = null;
    }

    setState(() {});
    return isValid;
  }

  void _onSave() {
    if (_validate()) {
      showSnackBar(context: context, isError: false, message: 'Healthy Weight Gain Protocol Submitted!');
      navigation.pop(context);
    } else {
      showSnackBar(context: context, isError: true, message: 'Please complete all required fields.');
    }
  }

  @override
  void dispose() {
    _startingWeightController.dispose();
    _currentWeightController.dispose();
    _otherGoalsController.dispose();
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
        title: const CommonText(
          "Healthy Weight Gain Protocol",
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF1D1B1A),
            fontWeight: FontWeight.w600,
            fontFamily: "Playfair_Display",
            letterSpacing: 0.24,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        children: [
          _buildIntentionalitySection(),
          const SizedBox(height: 24),
          _buildWeightTrajectorySection(),
          const SizedBox(height: 24),
          _buildAppetiteSensationsSection(),
          const SizedBox(height: 24),
          _buildPersonalVisionSection(),
          const SizedBox(height: 32),
          CommonButton(
            name: "Save & Submit Weight Gain Protocol",
            onTap: _onSave,
            icon: Icons.arrow_forward_rounded,
            isIconFirst: false,
            btnColor: const Color(0xFF8B484D),
            fontColor: appColors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            radius: 999,
          ),
          SizedBox(height: bottomPadding(context)),
        ],
      ),
    );
  }

  Widget _buildIntentionalitySection() {
    return ProfileSectionCard(
      title: "Is your current low weight or recent weight loss intentional?",
      icon: appIcons.error,
      children: [
        buildRequiredLabel("Helps your care team tailor metabolic replenishment and caloric safety bounds.", color: const Color(0xFF534343)),
        const SizedBox(height: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildRadioRow("Yes"),
            const SizedBox(height: 10),
            _buildRadioRow("No"),
            const SizedBox(height: 10),
            _buildRadioRow("Partly"),
            const SizedBox(height: 10),
            _buildRadioRow("Not sure"),
          ],
        ),
        if (_weightIntentionalityError != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 4),
            child: CommonText(_weightIntentionalityError!, style: TextStyle(color: appColors.red, fontSize: 12)),
          ),
        const SizedBox(height: 20),
        _buildClinicalPriorityNote(),
      ],
    );
  }

  Widget _buildRadioRow(String value) {
    bool isSelected = _weightIntentionality == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _weightIntentionality = value;
          if (_weightIntentionalityError != null) _validate();
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFDADB).withValues(alpha: 0.4) : const Color(0xFFF8F2F0),
          borderRadius: BorderRadius.circular(12),
          boxShadow: isSelected
              ? [BoxShadow(color: Colors.black.withValues(alpha: 0.05), offset: const Offset(0, 1), blurRadius: 2)]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CommonText(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? const Color(0xFF713439) : const Color(0xFF1D1B1A),
              ),
            ),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? const Color(0xFF8B484D) : Colors.white,
                border: isSelected ? null : Border.all(color: const Color(0xFF857373)),
              ),
              child: isSelected ? const Icon(Icons.check, size: 14, color: Colors.white) : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClinicalPriorityNote() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFDADB).withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(appIcons.clinicalShield, height: 22, color: const Color(0xFF534343)), // Assuming checkShield is available
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CommonText(
                  "CLINICAL PRIORITY NOTE",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF8B484D),
                    letterSpacing: 0.275,
                  ),
                ),
                const SizedBox(height: 4),
                const CommonText(
                  "Unplanned or unintentional weight shifts are flagged for compassionate clinical review by our medical nutritionist before protocol formulation to ensure complete hormonal and metabolic safety.",
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF534343),
                    height: 21.13 / 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeightTrajectorySection() {
    return ProfileSectionCard(
      title: "Six-Month Weight Trajectory",
      icon: appIcons.down,
      children: [
        buildRequiredLabel("How has your weight changed during the past six months?", color: const Color(0xFF534343)),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFFEDE7E5),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildUnitToggleBtn("Kilograms (kg)", _isKgSelected, () => setState(() => _isKgSelected = true)),
                  _buildUnitToggleBtn("Pounds (lbs)", !_isKgSelected, () => setState(() => _isKgSelected = false)),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: const TextSpan(
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  fontFamily: fontFamilyPlusJakartaSans,
                ),
                children: [
                  TextSpan(
                      text: "Approximate Starting Weight (6 Months Ago)",
                      style: TextStyle(color: Color(0xFF1D1B1A))),
                  TextSpan(
                      text: " Optional", style: TextStyle(color: Color(0xFF9A8687))),
                ],
              )
            ),
            const SizedBox(height: 6),
            CommonTextField(
              label: "",
              controller: _startingWeightController,
              isRequired: false,
              isDense: true,
              borderColor: Colors.transparent,
              fillColor: const Color(0xFFF8F2F0),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [digitalWithDot],
              suffixText: "KG",
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF9A8687)),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const CommonText("Current Weight", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1D1B1A))),
                const CommonText("Today", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF8B484D))),
              ],
            ),
            const SizedBox(height: 6),
            CommonTextField(
              label: "",
              controller: _currentWeightController,
              isRequired: false,
              isDense: true,
              borderColor: Colors.transparent,
              fillColor: const Color(0xFFF8F2F0),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [digitalWithDot],
              suffixText: "KG",
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF9A8687)),
            ),
          ],
        ),
        const SizedBox(height: 20),
        const CommonText("Trajectory Nature", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1D1B1A))),
        const SizedBox(height: 10),
        Column(
          children: [
            _buildTrajectoryOption("Planned change"),
            const SizedBox(height: 8),
            _buildTrajectoryOption("Unplanned change"),
            const SizedBox(height: 8),
            _buildTrajectoryOption("Fluctuating / Unstable"),
          ],
        ),
      ],
    );
  }

  Widget _buildUnitToggleBtn(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF8B484D) : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
        ),
        child: CommonText(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected ? Colors.white : const Color(0xFF534343),
          ),
        ),
      ),
    );
  }

  Widget _buildTrajectoryOption(String label) {
    bool isSelected = _trajectoryNature == label;
    return GestureDetector(
      onTap: () => setState(() => _trajectoryNature = label),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFDADB).withValues(alpha: 0.4) : const Color(0xFFF8F2F0),
          borderRadius: BorderRadius.circular(12),
          boxShadow: isSelected
              ? [BoxShadow(color: Colors.black.withValues(alpha: 0.05), offset: const Offset(0, 1), blurRadius: 2)]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CommonText(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? const Color(0xFF713439) : const Color(0xFF1D1B1A),
              ),
            ),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? const Color(0xFF8B484D) : Colors.white,
                border: isSelected ? null : Border.all(color: const Color(0xFF9A8687)),
              ),
              child: isSelected ? const Icon(Icons.check, size: 14, color: Colors.white) : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppetiteSensationsSection() {
    return ProfileSectionCard(
      title: "Appetite & Digestive Sensations",
      icon: appIcons.cup,
      children: [
        buildRequiredLabel("Select all sensations that currently affect your meal capacity", color: const Color(0xFF534343)),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _appetiteSensationsList.map((item) => _buildSelectionPill(
            item,
            _selectedAppetiteSensations.contains(item),
            () {
              setState(() {
                if (_selectedAppetiteSensations.contains(item)) {
                  _selectedAppetiteSensations.remove(item);
                } else {
                  if (item == "None of these") {
                    _selectedAppetiteSensations.clear();
                    _selectedAppetiteSensations.add(item);
                  } else {
                    _selectedAppetiteSensations.remove("None of these");
                    _selectedAppetiteSensations.add(item);
                  }
                }
                if (_appetiteSensationsError != null) _validate();
              });
            },
          )).toList(),
        ),
        if (_appetiteSensationsError != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: CommonText(_appetiteSensationsError!, style: TextStyle(color: appColors.red, fontSize: 12)),
          ),
      ],
    );
  }

  Widget _buildPersonalVisionSection() {
    return ProfileSectionCard(
      title: "What would healthy weight gain mean for you?",
      icon: appIcons.sparkle,
      children: [
        buildRequiredLabel("Select up to 3 core goals that will guide your nourishment curriculum:", color: const Color(0xFF534343)),
        const SizedBox(height: 16),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: _goalsList.map((item) {
            bool isSelected = _selectedGoals.contains(item);
            double chipWidth = (MediaQuery.of(context).size.width - 40 - 40 - 10) / 2; // Responsive 2 columns
            return SizedBox(
              width: chipWidth,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      _selectedGoals.remove(item);
                    } else {
                      if (_selectedGoals.length < 3) {
                        _selectedGoals.add(item);
                      }
                    }
                    if (_goalsError != null) _validate();
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFFFFDADB).withValues(alpha: 0.4) : const Color(0xFFF8F2F0),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: CommonText(
                    item,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: isSelected ? const Color(0xFF713439) : const Color(0xFF1D1B1A),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        if (_goalsError != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: CommonText(_goalsError!, style: TextStyle(color: appColors.red, fontSize: 12)),
          ),
        const SizedBox(height: 20),
        RichText(
          text: const TextSpan(
            style: TextStyle(
              fontSize: 13,
              fontFamily: fontFamilyPlusJakartaSans,
            ),
            children: [
              TextSpan(text: "Other specific personal goals", style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF1D1B1A))),
              TextSpan(text: " (optional)", style: TextStyle(color: Color(0xFF857373))),
            ],
          ),
        ),
        const SizedBox(height: 8),
        CommonTextField(
          label: "",
          controller: _otherGoalsController,
          hint: "e.g., Feeling resilient and overcoming fatigue during afternoon work meetings...",
          maxLines: 4,
          borderColor: Colors.transparent,
          fillColor: const Color(0xFFF8F2F0),
        ),
      ],
    );
  }

  Widget _buildSelectionPill(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFDADB) : const Color(0xFFF8F2F0),
          borderRadius: BorderRadius.circular(999),
        ),
        child: CommonText(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: isSelected ? const Color(0xFF713439) : const Color(0xFF534343),
          ),
        ),
      ),
    );
  }
}
