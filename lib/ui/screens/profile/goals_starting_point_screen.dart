import 'package:flutter/material.dart';

import '../../../../main.dart';
import '../../../core/constants/utils.dart';
import '../../widgets/common_app_bar.dart';
import '../../widgets/common_button.dart';
import '../../widgets/common_text.dart';
import 'health_safety_intake_screen.dart';

class GoalsStartingPointScreen extends StatefulWidget {
  const GoalsStartingPointScreen({super.key});

  @override
  State<GoalsStartingPointScreen> createState() => _GoalsStartingPointScreenState();
}

class _GoalsStartingPointScreenState extends State<GoalsStartingPointScreen> {
  final TextEditingController _heightController = TextEditingController(text: "165");
  final TextEditingController _learnedController = TextEditingController();
  final TextEditingController _confusingController = TextEditingController();
  final TextEditingController _helpedController = TextEditingController();

  String? _heightError;
  String? _learnedError;
  String? _confusingError;
  String? _helpedError;
  String? _approachesError;
  String? _confidentError;

  bool _isCmSelected = true;

  final List<String> _approachesList = [
    "Calorie counting", "Macro tracking", "Portion control", "Intermittent fasting",
    "Low-carb / Keto", "Detox / Juice plan", "Meal replacement", "Weight medication",
    "Supplements", "Gym / Personal training", "Dietitian plan", "Online program/app",
    "Self-directed", "None", "Other"
  ];
  final Set<String> _selectedApproaches = {};

  final List<String> _confidentList = [
    "Portions", "Protein", "Balanced meals", "Food labels", "Calories or macros",
    "Meal preparation", "Hunger & fullness cues", "Exercise", "Sleep and stress",
    "None yet", "Other"
  ];
  final Set<String> _selectedConfident = {};


  bool _validate() {
    bool isValid = true;

    if (_heightController.text.trim().isEmpty) {
      _heightError = "Please enter your height";
      isValid = false;
    } else {
      _heightError = null;
    }

    if (_learnedController.text.trim().isEmpty) {
      _learnedError = "Please share what you learned";
      isValid = false;
    } else {
      _learnedError = null;
    }

    if (_confusingController.text.trim().isEmpty) {
      _confusingError = "Please share what is confusing";
      isValid = false;
    } else {
      _confusingError = null;
    }

    if (_helpedController.text.trim().isEmpty) {
      _helpedError = "Please share what helped or stopped you";
      isValid = false;
    } else {
      _helpedError = null;
    }

    if (_selectedApproaches.isEmpty) {
      _approachesError = "Please select at least one approach";
      isValid = false;
    } else {
      _approachesError = null;
    }

    if (_selectedConfident.isEmpty) {
      _confidentError = "Please select at least one confident area";
      isValid = false;
    } else {
      _confidentError = null;
    }

    setState(() {});
    return isValid;
  }

  void _onSaveAndContinue() {
    if (_validate()) {
      appLog("Goals Form Validated!");
      navigation.pushReplaceFadeAnimation(context, HealthSafetyIntakeScreen());
    }
  }

  @override
  void dispose() {
    _heightController.dispose();
    _learnedController.dispose();
    _confusingController.dispose();
    _helpedController.dispose();
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
              "CHAPTER 2 OF 6",
              style: TextStyle(
                fontSize: 11,
                color: appColors.primary,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.55,
              ),
            ),
            CommonText(
              "Goals & Starting Point",
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
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              children: [
                _buildBaselineMeasurements(),
                const SizedBox(height: 24),
                _buildExperienceSection(),
              ],
            ),
          ),
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildSectionCard({required String title, required String icon, required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: appColors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF292726).withValues(alpha: 0.04),
            offset: const Offset(0, 4),
            blurRadius: 20,
            spreadRadius: -2,
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

  Widget _buildBaselineMeasurements() {
    return _buildSectionCard(
      title: "Baseline Measurements",
      icon: appIcons.measurement,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 13,
                  fontFamily: fontFamilyPlusJakartaSans,
                  color: Color(0xFF1D1B1A),
                  fontWeight: FontWeight.w600,
                ),
                children: [
                  const TextSpan(text: "Current height "),
                  TextSpan(text: "*", style: TextStyle(color: appColors.primary, fontWeight: FontWeight.normal)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: appColors.textFieldBgColor,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Row(
                children: [
                  _buildToggleBtn(label: "cm", isSelected: _isCmSelected, onTap: () => setState(() => _isCmSelected = true)),
                  _buildToggleBtn(label: "Feet & inches", isSelected: !_isCmSelected, onTap: () => setState(() => _isCmSelected = false)),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Container(
                height: 56,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: appColors.textFieldBgColor,
                  borderRadius: BorderRadius.circular(16),
                  border: _heightError != null ? Border.all(color: appColors.red) : null,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _heightController,
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF1D1B1A),
                          fontFamily: fontFamilyPlusJakartaSans,
                          letterSpacing: -0.64,
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                        onChanged: (v) {
                          if (_heightError != null) _validate();
                        },
                      ),
                    ),
                    CommonText(
                      _isCmSelected ? "cm" : "ft",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF534343),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            Column(
              children: [
                _buildIncrementBtn(Icons.keyboard_arrow_up_rounded, () {
                  int val = int.tryParse(_heightController.text) ?? 165;
                  _heightController.text = (val + 1).toString();
                }),
                const SizedBox(height: 4),
                _buildIncrementBtn(Icons.keyboard_arrow_down_rounded, () {
                  int val = int.tryParse(_heightController.text) ?? 165;
                  _heightController.text = (val - 1).toString();
                }),
              ],
            ),
          ],
        ),
        if (_heightError != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 4),
            child: CommonText(
              _heightError!,
              style: TextStyle(color: appColors.red, fontSize: 12),
            ),
          ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.info_outline_rounded, color: Color(0xFF534343), size: 14),
            const SizedBox(width: 6),
            Expanded(
              child: CommonText(
                "Used for personalized caloric density and biological benchmarks.",
                style: TextStyle(
                  fontSize: 13,
                  color: const Color(0xFF534343),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildToggleBtn({required String label, required bool isSelected, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? appColors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
        ),
        child: CommonText(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected ? const Color(0xFF1D1B1A) : const Color(0xFF534343),
          ),
        ),
      ),
    );
  }

  Widget _buildIncrementBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 24,
        decoration: BoxDecoration(
          color: appColors.textFieldBgColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 16, color: const Color(0xFF1D1B1A)),
      ),
    );
  }

  Widget _buildExperienceSection() {
    return _buildSectionCard(
      title: "Experience & Foundations",
      icon: appIcons.book,
      children: [
        CommonText(
          "What have you already tried, and what knowledge are you bringing into this journey?",
          style: TextStyle(
            fontSize: 13,
            color: const Color(0xFF534343),
          ),
        ),
        const SizedBox(height: 24),

        // Approaches
        _buildRequiredLabel("Approaches you have tried"),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 12,
          children: _approachesList.map((e) => _buildChip(
            label: e,
            isSelected: _selectedApproaches.contains(e),
            onTap: () {
              setState(() {
                if (_selectedApproaches.contains(e)) {
                  _selectedApproaches.remove(e);
                } else {
                  _selectedApproaches.add(e);
                }
                if (_approachesError != null) _validate();
              });
            }
          )).toList(),
        ),
        if (_approachesError != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 4),
            child: CommonText(
              _approachesError!,
              style: TextStyle(color: appColors.red, fontSize: 12),
            ),
          ),
        const SizedBox(height: 24),

        // Learnings
        _buildRequiredLabel(isRequired: false, "What did you understand or learn from those experiences?"),
        const SizedBox(height: 12),
        _buildTextArea(
          controller: _learnedController,
          hint: "e.g. Learned that extreme restriction leads to fatigue and binge cycles...",
          error: _learnedError,
        ),
        const SizedBox(height: 8),
        CommonText(
          "Reflect freely; honest notes help refine pacing",
          style: TextStyle(fontSize: 11, color: const Color(0xFF534343), fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 24),

        // Confident areas
        _buildRequiredLabel("Which areas do you already feel confident about?"),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 12,
          children: _confidentList.map((e) => _buildChip(
            label: e,
            isSelected: _selectedConfident.contains(e),
            selectedBgColor: const Color(0xFFD8E5BF),
            selectedTextColor: const Color(0xFF5B6749),
            onTap: () {
              setState(() {
                if (_selectedConfident.contains(e)) {
                  _selectedConfident.remove(e);
                } else {
                  _selectedConfident.add(e);
                }
                if (_confidentError != null) _validate();
              });
            }
          )).toList(),
        ),
        if (_confidentError != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 4),
            child: CommonText(
              _confidentError!,
              style: TextStyle(color: appColors.red, fontSize: 12),
            ),
          ),
        const SizedBox(height: 24),

        // Confusing
        _buildRequiredLabel("What still feels confusing or difficult?"),
        const SizedBox(height: 12),
        _buildTextArea(
          controller: _confusingController,
          hint: "e.g. Balancing evening meals when working late...",
          error: _confusingError,
        ),
        const SizedBox(height: 24),

        // What helped
        _buildRequiredLabel("What helped, what made you stop, and what contributed to progress returning?"),
        const SizedBox(height: 12),
        _buildTextArea(
          controller: _helpedController,
          hint: "e.g. Having accountability and structured groceries helped most...",
          error: _helpedError,
        ),
      ],
    );
  }

  Widget _buildRequiredLabel(String text, {bool isRequired = true}) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontSize: 13,
          fontFamily: fontFamilyPlusJakartaSans,
          color: Color(0xFF1D1B1A),
          fontWeight: FontWeight.w600,
        ),
        children: [
          TextSpan(text: "$text "),
          if(isRequired) TextSpan(text: "*", style: TextStyle(color: appColors.primary, fontWeight: FontWeight.normal)),
        ],
      ),
    );
  }

  Widget _buildChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    Color? selectedBgColor,
    Color? selectedTextColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? (selectedBgColor ?? const Color(0xFFFFDADB)) : appColors.textFieldBgColor,
          borderRadius: BorderRadius.circular(999),
        ),
        child: CommonText(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isSelected ? (selectedTextColor ?? const Color(0xFF3A0910)) : const Color(0xFF534343),
          ),
        ),
      ),
    );
  }

  Widget _buildTextArea({required TextEditingController controller, required String hint, String? error}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: appColors.textFieldBgColor,
        borderRadius: BorderRadius.circular(16),
        border: error != null ? Border.all(color: appColors.red) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: controller,
            maxLines: 4,
            minLines: 3,
            keyboardType: TextInputType.multiline,
            style: TextStyle(
              fontSize: 14,
              color: const Color(0xFF1D1B1A),
              fontFamily: fontFamilyPlusJakartaSans,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hint,
              hintStyle: TextStyle(
                fontSize: 14,
                color: const Color(0xFF9A8687), // Updated hint color to match design slightly better
                fontFamily: fontFamilyPlusJakartaSans,
              ),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 8),
            ),
            onChanged: (v) {
              setState(() {});
              if (error != null) _validate();
            },
          ),
          if (error != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: CommonText(
                error,
                style: TextStyle(color: appColors.red, fontSize: 12),
              ),
            ),
        ],
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
        name: "Save & Continue to Health & Safety",
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
