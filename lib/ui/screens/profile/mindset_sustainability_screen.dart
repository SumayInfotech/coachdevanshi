import 'package:flutter/material.dart';

import '../../../../main.dart';
import '../../../core/constants/utils.dart';
import '../../widgets/common_app_bar.dart';
import '../../widgets/common_button.dart';
import '../../widgets/common_text.dart';
import '../../widgets/common_text_field.dart';

class MindsetSustainabilityScreen extends StatefulWidget {
  const MindsetSustainabilityScreen({super.key});

  @override
  State<MindsetSustainabilityScreen> createState() => _MindsetSustainabilityScreenState();
}

class _MindsetSustainabilityScreenState extends State<MindsetSustainabilityScreen> {
  // 1. Goal-Oriented Mindset
  final List<String> _mindsetOptions = [
    "I do best with a clear routine",
    "I need flexibility or I feel restricted",
    "Numbers and data motivate me",
    "Too much tracking overwhelms me",
    "I prefer simple instructions and fewer choices",
    "I like understanding the reason behind every recommendation",
    "I can become all-or-nothing after one difficult day",
    "I am usually self-directed",
    "Regular accountability keeps me consistent",
    "I get bored when a routine feels repetitive",
    "I am hard on myself when I do not do something perfectly",
    "Small visible wins keep me motivated",
    "Other"
  ];
  final Set<String> _selectedMindsets = {};
  String? _mindsetError;

  // 2. Navigating Slow Progress
  final TextEditingController _slowProgressController = TextEditingController();
  String? _slowProgressError;

  // 3. Starting Points & Boundaries
  final TextEditingController _startChangeController = TextEditingController();
  final TextEditingController _notReadyChangeController = TextEditingController();
  String? _startChangeError;
  String? _notReadyChangeError;

  // 4. Your Vision of Success
  final TextEditingController _visionController = TextEditingController();
  String? _visionError;

  // 5. Open Reflections
  final TextEditingController _reflectionsController = TextEditingController();

  bool _validate() {
    bool isValid = true;

    if (_selectedMindsets.isEmpty) {
      _mindsetError = "Please select up to 3 options";
      isValid = false;
    } else {
      _mindsetError = null;
    }

    if (_slowProgressController.text.trim().isEmpty) {
      _slowProgressError = "This field is required";
      isValid = false;
    } else {
      _slowProgressError = null;
    }

    if (_startChangeController.text.trim().isEmpty) {
      _startChangeError = "This field is required";
      isValid = false;
    } else {
      _startChangeError = null;
    }

    if (_notReadyChangeController.text.trim().isEmpty) {
      _notReadyChangeError = "This field is required";
      isValid = false;
    } else {
      _notReadyChangeError = null;
    }

    if (_visionController.text.trim().isEmpty) {
      _visionError = "This field is required";
      isValid = false;
    } else {
      _visionError = null;
    }

    setState(() {});
    return isValid;
  }

  void _onSaveAndReview() {
    if (_validate()) {
      appLog("Mindset & Sustainability Form Validated!");
      navigation.pop(context); // Usually goes to a review screen next
    }
  }

  @override
  void dispose() {
    _slowProgressController.dispose();
    _startChangeController.dispose();
    _notReadyChangeController.dispose();
    _visionController.dispose();
    _reflectionsController.dispose();
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
              "CHAPTER 6 OF 6",
              style: TextStyle(
                fontSize: 11,
                color: appColors.primary,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.55,
              ),
            ),
            CommonText(
              "Mindset & Sustainability",
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
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        children: [
          _buildMindsetSection(),
          const SizedBox(height: 24),
          _buildSlowProgressSection(),
          const SizedBox(height: 24),
          _buildBoundariesSection(),
          const SizedBox(height: 24),
          _buildVisionSection(),
          const SizedBox(height: 24),
          _buildReflectionsSection(),
          const SizedBox(height: 24),
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
          Row(
            children: [
              Image.asset(icon, height: 20, width: 20, color: appColors.primary),
              const SizedBox(width: 8),
              Expanded(
                child: CommonText(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Playfair_Display",
                    color: const Color(0xFF1D1B1A),
                  ),
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

  Widget _buildRequiredLabel(String text, {String? subtext}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: const TextStyle(
              fontSize: 13,
              fontFamily: fontFamilyPlusJakartaSans,
              color: Color(0xFF1D1B1A),
              fontWeight: FontWeight.w600,
              height: 20 / 13,
            ),
            children: [
              TextSpan(text: "$text "),
              TextSpan(text: "*", style: TextStyle(color: appColors.primary, fontWeight: FontWeight.normal)),
            ],
          ),
        ),
        if (subtext != null) ...[
          const SizedBox(height: 2),
          CommonText(subtext, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: const Color(0xFF9A8687))),
        ]
      ],
    );
  }

  Widget _buildChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFDADB) : appColors.textFieldBgColor,
          borderRadius: BorderRadius.circular(999),
        ),
        child: CommonText(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isSelected ? const Color(0xFF3A0910) : const Color(0xFF534343),
          ),
        ),
      ),
    );
  }

  Widget _buildTextArea({required TextEditingController controller, required String hint, String? error}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: appColors.textFieldBgColor,
        borderRadius: BorderRadius.circular(12),
        border: error != null ? Border.all(color: appColors.red) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: controller,
            maxLines: 4,
            minLines: 3,
            style: TextStyle(fontSize: 14, color: const Color(0xFF1D1B1A), fontFamily: fontFamilyPlusJakartaSans),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hint,
              hintStyle: TextStyle(fontSize: 14, color: const Color(0xFF857373)),
              isDense: true,
            ),
            onChanged: (v) {
              setState(() {});
              if (error != null) _validate();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMindsetSection() {
    return _buildSectionCard(
      title: "Goal-Oriented Mindset",
      icon: appIcons.mindset,
      children: [
        _buildRequiredLabel("Which statements sound most like you when you are working toward a goal?", subtext: "(Select up to 3)"),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 12,
          children: _mindsetOptions.map((e) => _buildChip(
            label: e,
            isSelected: _selectedMindsets.contains(e),
            onTap: () {
              setState(() {
                if (_selectedMindsets.contains(e)) {
                  _selectedMindsets.remove(e);
                } else {
                  if (_selectedMindsets.length < 3) {
                    _selectedMindsets.add(e);
                  } else {
                    appLog("Can only select up to 3 options");
                  }
                }
                if (_mindsetError != null) _validate();
              });
            },
          )).toList(),
        ),
        if (_mindsetError != null)
          Padding(padding: const EdgeInsets.only(top: 8), child: CommonText(_mindsetError!, style: TextStyle(color: appColors.red, fontSize: 12))),
      ],
    );
  }

  Widget _buildSlowProgressSection() {
    return _buildSectionCard(
      title: "Navigating Slow Progress",
      icon: appIcons.navigating,
      children: [
        _buildRequiredLabel("When progress is slower than you hoped, what tends to happen in your head — and what do you usually do next?"),
        const SizedBox(height: 12),
        _buildTextArea(
          controller: _slowProgressController,
          hint: "e.g., I start questioning whether anything is working and feel tempted to restart from scratch or restrict more heavily...",
          error: _slowProgressError,
        ),
        if (_slowProgressError != null)
          Padding(padding: const EdgeInsets.only(top: 4), child: CommonText(_slowProgressError!, style: TextStyle(color: appColors.red, fontSize: 12))),
      ],
    );
  }

  Widget _buildBoundariesSection() {
    return _buildSectionCard(
      title: "Starting Points & Boundaries",
      icon: appIcons.flag,
      children: [
        _buildRequiredLabel("What is one change you could genuinely start this week, and one thing you are not ready to change yet?"),
        const SizedBox(height: 16),
        CommonText("One change you could genuinely start this week", style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: const Color(0xFF534343))),
        const SizedBox(height: 6),
        CommonTextField(
          label: '',
          controller: _startChangeController,
          hint: "e.g., Drinking 2 liters of water daily...",
          fillColor: appColors.textFieldBgColor,
          borderColor: Colors.transparent,
          onChanged: (v) { if (_startChangeError != null) _validate(); },
        ),
        if (_startChangeError != null)
          Padding(padding: const EdgeInsets.only(top: 4, bottom: 8), child: CommonText(_startChangeError!, style: TextStyle(color: appColors.red, fontSize: 12))),
        
        const SizedBox(height: 12),
        CommonText("One thing you are not ready to change yet", style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: const Color(0xFF534343))),
        const SizedBox(height: 6),
        CommonTextField(
          label: '',
          controller: _notReadyChangeController,
          hint: "e.g., My morning milk tea with sugar...",
          fillColor: appColors.textFieldBgColor,
          borderColor: Colors.transparent,
          onChanged: (v) { if (_notReadyChangeError != null) _validate(); },
        ),
        if (_notReadyChangeError != null)
          Padding(padding: const EdgeInsets.only(top: 4), child: CommonText(_notReadyChangeError!, style: TextStyle(color: appColors.red, fontSize: 12))),
      ],
    );
  }

  Widget _buildVisionSection() {
    return _buildSectionCard(
      title: "Your Vision of Success",
      icon: appIcons.stars,
      children: [
        _buildRequiredLabel("If coaching worked well for you, what would feel different in your body, your routine and your life?"),
        const SizedBox(height: 12),
        _buildTextArea(
          controller: _visionController,
          hint: "e.g., Waking up with steady energy without afternoon crashes, feeling calm around food choices...",
          error: _visionError,
        ),
        if (_visionError != null)
          Padding(padding: const EdgeInsets.only(top: 4), child: CommonText(_visionError!, style: TextStyle(color: appColors.red, fontSize: 12))),
      ],
    );
  }

  Widget _buildReflectionsSection() {
    return _buildSectionCard(
      title: "Open Reflections",
      icon: appIcons.edit,
      children: [
        CommonText("Is there anything important about your health, body, food or lifestyle that we have not asked?", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: const Color(0xFF534343))),
        const SizedBox(height: 12),
        _buildTextArea(
          controller: _reflectionsController,
          hint: "e.g., Any past experiences with diets, specific daily rhythms, travel schedules...",
        ),
      ],
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
        name: "Save & Review",
        icon: Icons.arrow_forward_rounded,
        isIconFirst: false,
        imageSize: 16,
        btnColor: appColors.primary,
        fontSize: 14,
        fontWeight: FontWeight.w700,
        onTap: _onSaveAndReview,
      ),
    );
  }
}
