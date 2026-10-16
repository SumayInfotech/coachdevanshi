import 'package:flutter/material.dart';

import '../../../../main.dart';
import '../../../core/constants/utils.dart';
import '../../widgets/common_app_bar.dart';
import '../../widgets/common_button.dart';
import '../../widgets/common_text.dart';
import '../../widgets/common_text_field.dart';
import '../profile/widget/profile_section_card.dart';

class MaintenanceLifestyleScreen extends StatefulWidget {
  const MaintenanceLifestyleScreen({super.key});

  @override
  State<MaintenanceLifestyleScreen> createState() => _MaintenanceLifestyleScreenState();
}

class _MaintenanceLifestyleScreenState extends State<MaintenanceLifestyleScreen> {
  // Section 1: Achieved Milestones
  final TextEditingController _milestonesController = TextEditingController();
  String? _milestonesError;

  // Section 2: Sustainable Equilibrium
  final TextEditingController _equilibriumController = TextEditingController();
  String? _equilibriumError;

  // Section 3: Maintenance Disruptions
  final List<String> _disruptionsList = [
    "Travel", "Festivals or social events", "Work pressure", "Changes in routine",
    "Emotional eating", "Poor sleep", "Reduced exercise", "Meal planning"
  ];
  final Set<String> _selectedDisruptions = {};
  String? _disruptionsError;
  final TextEditingController _otherDisruptionsController = TextEditingController();

  // Section 4: Coaching Partnership
  final TextEditingController _partnershipController = TextEditingController();
  String? _partnershipError;

  bool _validate() {
    bool isValid = true;

    if (_milestonesController.text.trim().isEmpty) {
      _milestonesError = "Required";
      isValid = false;
    } else {
      _milestonesError = null;
    }

    if (_equilibriumController.text.trim().isEmpty) {
      _equilibriumError = "Required";
      isValid = false;
    } else {
      _equilibriumError = null;
    }

    if (_selectedDisruptions.isEmpty) {
      _disruptionsError = "Please select at least 1 disruption";
      isValid = false;
    } else {
      _disruptionsError = null;
    }

    if (_partnershipController.text.trim().isEmpty) {
      _partnershipError = "Required";
      isValid = false;
    } else {
      _partnershipError = null;
    }

    setState(() {});
    return isValid;
  }

  void _onSave() {
    if (_validate()) {
      showSnackBar(context: context, isError: false, message: 'Maintenance & Lifestyle Management Submitted!');
      navigation.pop(context);
    } else {
      showSnackBar(context: context, isError: true, message: 'Please complete all required fields.');
    }
  }

  @override
  void dispose() {
    _milestonesController.dispose();
    _equilibriumController.dispose();
    _otherDisruptionsController.dispose();
    _partnershipController.dispose();
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
          "Maintenance and Lifestyle Management",
          fontFamily: fontPlayfairDisplay,
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF1D1B1A),
            fontWeight: FontWeight.w600,
            letterSpacing: 0.24,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        children: [
          _buildMilestonesSection(),
          const SizedBox(height: 24),
          _buildEquilibriumSection(),
          const SizedBox(height: 24),
          _buildDisruptionsSection(),
          const SizedBox(height: 24),
          _buildPartnershipSection(),
          const SizedBox(height: 32),
          CommonButton(
            name: "Save & Submit Maintenance Protocol",
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

  Widget _buildMilestonesSection() {
    return ProfileSectionCard(
      title: "Achieved Milestones",
      icon: appIcons.achieved,
      children: [
        buildRequiredLabel("What progress have you already made, and for how long have you maintained it?", color: const Color(0xFF534343)),
        const SizedBox(height: 16),
        CommonTextField(
          label: "",
          controller: _milestonesController,
          hint: "e.g., Lost 8 kg over 7 months and have kept it stable for the past 4 months; feeling significantly lighter, clothes fit effortlessly...",
          maxLines: 4,
          borderColor: _milestonesError != null ? appColors.red : Colors.transparent,
          fillColor: const Color(0xFFF8F2F0),
          onChanged: (v) {
            setState(() {});
            if (_milestonesError != null) _validate();
          },
        ),
        if (_milestonesError != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 4),
            child: CommonText(_milestonesError!, style: TextStyle(color: appColors.red, fontSize: 12)),
          ),
      ],
    );
  }

  Widget _buildEquilibriumSection() {
    return ProfileSectionCard(
      title: "Sustainable Equilibrium",
      icon: appIcons.sustainable,
      children: [
        buildRequiredLabel("What weight, measurement or routine range feels sustainable for you?", color: const Color(0xFF1D1B1A)),
        const SizedBox(height: 16),
        CommonTextField(
          label: "",
          controller: _equilibriumController,
          hint: "e.g., 61-63 kg, 28-inch waist, and walking 7k steps 5 days a week without stress.",
          maxLines: 4,
          borderColor: _equilibriumError != null ? appColors.red : Colors.transparent,
          fillColor: const Color(0xFFF8F2F0),
          onChanged: (v) {
            setState(() {});
            if (_equilibriumError != null) _validate();
          },
        ),
        if (_equilibriumError != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 4),
            child: CommonText(_equilibriumError!, style: TextStyle(color: appColors.red, fontSize: 12)),
          ),
      ],
    );
  }

  Widget _buildDisruptionsSection() {
    return ProfileSectionCard(
      title: "Maintenance Disruptions",
      icon: appIcons.upStick,
      children: [
        buildRequiredLabel("Which situations make maintenance most difficult? Select maximum up to 3", color: const Color(0xFF1D1B1A)),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _disruptionsList.map((item) => _buildSelectionPill(
            item,
            _selectedDisruptions.contains(item),
            () {
              setState(() {
                if (_selectedDisruptions.contains(item)) {
                  _selectedDisruptions.remove(item);
                } else {
                  if (_selectedDisruptions.length < 3) {
                    _selectedDisruptions.add(item);
                  }
                }
                if (_disruptionsError != null) _validate();
              });
            },
          )).toList(),
        ),
        if (_disruptionsError != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: CommonText(_disruptionsError!, style: TextStyle(color: appColors.red, fontSize: 12)),
          ),
        const SizedBox(height: 16),
        CommonTextField(
          label: "",
          controller: _otherDisruptionsController,
          hint: "Other specific situation (optional)...",
          borderColor: Colors.transparent,
          fillColor: const Color(0xFFF8F2F0),
        ),
      ],
    );
  }

  Widget _buildPartnershipSection() {
    return ProfileSectionCard(
      title: "Coaching Partnership",
      icon: appIcons.partnership,
      children: [
        buildRequiredLabel("What support would help you stay consistent without feeling controlled by a plan?", color: const Color(0xFF1D1B1A)),
        const SizedBox(height: 16),
        CommonTextField(
          label: "",
          controller: _partnershipController,
          hint: "e.g., Fortnightly check-ins focusing on mindset rather than food logs, mindful guidance when dining out...",
          maxLines: 4,
          borderColor: _partnershipError != null ? appColors.red : Colors.transparent,
          fillColor: const Color(0xFFF8F2F0),
          onChanged: (v) {
            setState(() {});
            if (_partnershipError != null) _validate();
          },
        ),
        if (_partnershipError != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 4),
            child: CommonText(_partnershipError!, style: TextStyle(color: appColors.red, fontSize: 12)),
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
          color: isSelected ? const Color(0xFFFFDADB).withValues(alpha: 0.8) : const Color(0xFFF2EDEB),
          borderRadius: BorderRadius.circular(999),
        ),
        child: CommonText(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: isSelected ? const Color(0xFF3A0910) : const Color(0xFF534343),
          ),
        ),
      ),
    );
  }
}
