import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../main.dart';
import '../../../core/constants/utils.dart';
import '../../widgets/common_app_bar.dart';
import '../../widgets/common_button.dart';
import '../../widgets/common_text.dart';
import '../../widgets/common_text_field.dart';
import '../profile/widget/profile_section_card.dart';

class RootedRecoveryScreen extends StatefulWidget {
  const RootedRecoveryScreen({super.key});

  @override
  State<RootedRecoveryScreen> createState() => _RootedRecoveryScreenState();
}

class _RootedRecoveryScreenState extends State<RootedRecoveryScreen> {
  // Section 1: Delivery & Timeline
  final TextEditingController _deliveryDateController = TextEditingController(text: "September 14, 2024");
  String? _deliveryDateError;
  String? _typeOfDelivery;
  String? _typeOfDeliveryError;
  final List<String> _deliveryTypes = ["Vaginal Birth", "Assisted Vaginal Birth", "C-section", "Prefer Not to Answer"];

  // Section 2: Lactation & Feeding Support
  String? _feedingSupport;
  String? _feedingSupportError;
  final List<String> _feedingSupportOptions = ["Direct feeding or exclusive pumping", "Combination feeding", "Occasionally", "No"];

  // Section 3: Complications
  bool? _hasComplications;
  String? _hasComplicationsError;
  final TextEditingController _complicationsDetailsController = TextEditingController();

  // Section 4: Medical Exercise Clearance
  String? _exerciseClearance;
  String? _exerciseClearanceError;
  final List<String> _exerciseClearanceOptions = ["Yes", "No", "Not yet discussed", "Exercise clearance is not currently relevant"];

  // Section 5: Current Postpartum Sensations
  final List<String> _sensationsList = [
    "Pelvic-floor heaviness or leaking",
    "Abdominal separation or diastase concern",
    "C-section or scar discomfort",
    "Back, hip or pelvic pain",
    "Very low mood, anxiety or feeling unable to cope",
    "None of these"
  ];
  final Set<String> _selectedSensations = {};
  String? _sensationsError;

  // Section 6: Sleep Rhythms & Support
  final TextEditingController _sleepStretchController = TextEditingController();
  final TextEditingController _caregivingSupportController = TextEditingController();
  String? _sleepStretchError;

  // Section 7: Top Priority Outcomes (Max 2)
  final List<String> _prioritiesList = [
    "Recovery", "Energy", "Strength", "Milk Supply",
    "Digestion", "Gentle Inch Loss", "Sleep & Routine", "Feeling Myself"
  ];
  final Set<String> _selectedPriorities = {};
  String? _prioritiesError;
  final TextEditingController _otherPriorityController = TextEditingController();

  bool _validate() {
    bool isValid = true;

    // Section 1
    if (_deliveryDateController.text.trim().isEmpty) {
      _deliveryDateError = "Required";
      isValid = false;
    } else {
      _deliveryDateError = null;
    }
    if (_typeOfDelivery == null) {
      _typeOfDeliveryError = "Required";
      isValid = false;
    } else {
      _typeOfDeliveryError = null;
    }

    // Section 2
    if (_feedingSupport == null) {
      _feedingSupportError = "Required";
      isValid = false;
    } else {
      _feedingSupportError = null;
    }

    // Section 3
    if (_hasComplications == null) {
      _hasComplicationsError = "Required";
      isValid = false;
    } else {
      _hasComplicationsError = null;
    }

    // Section 4
    if (_exerciseClearance == null) {
      _exerciseClearanceError = "Required";
      isValid = false;
    } else {
      _exerciseClearanceError = null;
    }

    // Section 5
    if (_selectedSensations.isEmpty) {
      _sensationsError = "Please select at least one";
      isValid = false;
    } else {
      _sensationsError = null;
    }

    // Section 6
    if (_sleepStretchController.text.trim().isEmpty) {
      _sleepStretchError = "Required";
      isValid = false;
    } else {
      _sleepStretchError = null;
    }

    // Section 7
    if (_selectedPriorities.isEmpty) {
      _prioritiesError = "Select at least 1 priority";
      isValid = false;
    } else {
      _prioritiesError = null;
    }

    setState(() {});
    return isValid;
  }

  void _onSave() {
    if (_validate()) {
      showSnackBar(context: context, isError: false, message: 'Rooted Recovery for New Moms Submitted!');
      navigation.pop(context);
    } else {
      showSnackBar(context: context, isError: true, message: 'Please complete all required fields.');
    }
  }

  @override
  void dispose() {
    _deliveryDateController.dispose();
    _complicationsDetailsController.dispose();
    _sleepStretchController.dispose();
    _caregivingSupportController.dispose();
    _otherPriorityController.dispose();
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
          "Rooted Recovery for New Moms",
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
          _buildDeliveryAndTimeline(),
          const SizedBox(height: 24),
          _buildLactationSupport(),
          const SizedBox(height: 24),
          _buildComplications(),
          const SizedBox(height: 24),
          _buildMedicalClearance(),
          const SizedBox(height: 24),
          _buildPostpartumSensations(),
          const SizedBox(height: 24),
          _buildSleepAndSupport(),
          const SizedBox(height: 24),
          _buildPriorityOutcomes(),
          const SizedBox(height: 32),
          CommonButton(
            name: "Save & Submit Rooted Recovery Protocol",
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

  Widget _buildDeliveryAndTimeline() {
    return ProfileSectionCard(
      title: "Delivery & Timeline",
      icon: appIcons.calender,
      children: [
        buildRequiredLabel("Delivery Date and Type of Delivery", color: const Color(0xFF534343)),
        const SizedBox(height: 16),
        const CommonText("Date of Delivery", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1D1B1A))),
        const SizedBox(height: 6),
        CommonTextField(
          label: "",
          controller: _deliveryDateController,
          isRequired: false,
          hint: "Select Date",
          readOnly: true,
          borderColor: _deliveryDateError != null ? appColors.red : Colors.transparent,
          fillColor: const Color(0xFFF8F2F0),
          suffixIcon: const Icon(Icons.calendar_today_outlined, size: 16, color: Color(0xFF1D1B1A)),
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF9A8687)),
          onTap: () async {
            DateTime? picked = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime.now(),
            );
            if (picked != null) {
              setState(() {
                _deliveryDateController.text = DateFormat('MMMM dd, yyyy').format(picked);
                if (_deliveryDateError != null) _validate();
              });
            }
          },
        ),
        if (_deliveryDateError != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 4),
            child: CommonText(_deliveryDateError!, style: TextStyle(color: appColors.red, fontSize: 12)),
          ),
        const SizedBox(height: 16),
        const CommonText("Type of Delivery", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1D1B1A))),
        const SizedBox(height: 8),
        Column(
          children: _deliveryTypes.map((type) => _buildRadioRow(type, _typeOfDelivery, (val) {
            setState(() {
              _typeOfDelivery = val;
              if (_typeOfDeliveryError != null) _validate();
            });
          })).toList(),
        ),
        if (_typeOfDeliveryError != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 4),
            child: CommonText(_typeOfDeliveryError!, style: TextStyle(color: appColors.red, fontSize: 12)),
          ),
      ],
    );
  }

  Widget _buildLactationSupport() {
    return ProfileSectionCard(
      title: "Lactation & Feeding Support",
      icon: appIcons.drop,
      children: [
        buildRequiredLabel("Are you currently breastfeeding or expressing milk?", color: const Color(0xFF534343)),
        const SizedBox(height: 16),
        Column(
          children: _feedingSupportOptions.map((type) => _buildRadioRow(type, _feedingSupport, (val) {
            setState(() {
              _feedingSupport = val;
              if (_feedingSupportError != null) _validate();
            });
          })).toList(),
        ),
        if (_feedingSupportError != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 4),
            child: CommonText(_feedingSupportError!, style: TextStyle(color: appColors.red, fontSize: 12)),
          ),
      ],
    );
  }

  Widget _buildComplications() {
    return ProfileSectionCard(
      title: "Pregnancy or Postpartum Complications",
      icon: appIcons.clinicalShieldFill,
      children: [
        buildRequiredLabel("Were there any pregnancy, delivery or postpartum complications that still affect your daily care (e.g. gestational diabetes, preeclampsia, perineal tears, postpartum hemorrhage)?", color: const Color(0xFF534343)),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildToggleBtn("No", _hasComplications == false, () {
                setState(() {
                  _hasComplications = false;
                  if (_hasComplicationsError != null) _validate();
                });
              }),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildToggleBtn("Yes", _hasComplications == true, () {
                setState(() {
                  _hasComplications = true;
                  if (_hasComplicationsError != null) _validate();
                });
              }),
            ),
          ],
        ),
        if (_hasComplicationsError != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 4),
            child: CommonText(_hasComplicationsError!, style: TextStyle(color: appColors.red, fontSize: 12)),
          ),
        const SizedBox(height: 16),
        const CommonText("Details of complication or continuing care", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1D1B1A))),
        const SizedBox(height: 6),
        CommonTextField(
          label: "",
          controller: _complicationsDetailsController,
          hint: "e.g. Mild gestational hypertension during third trimester; now monitored by OB-GYN and resolving steadily.",
          maxLines: 4,
          borderColor: Colors.transparent,
          fillColor: const Color(0xFFF8F2F0),
        ),
      ],
    );
  }

  Widget _buildMedicalClearance() {
    return ProfileSectionCard(
      title: "Medical Exercise Clearance",
      icon: appIcons.movement,
      children: [
        buildRequiredLabel("Have you received formal medical clearance from your OB-GYN or midwife to begin or resume intentional exercise?", color: const Color(0xFF534343)),
        const SizedBox(height: 16),
        Column(
          children: _exerciseClearanceOptions.map((type) => _buildRadioRow(type, _exerciseClearance, (val) {
            setState(() {
              _exerciseClearance = val;
              if (_exerciseClearanceError != null) _validate();
            });
          })).toList(),
        ),
        if (_exerciseClearanceError != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 4),
            child: CommonText(_exerciseClearanceError!, style: TextStyle(color: appColors.red, fontSize: 12)),
          ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFD8E5BF).withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.shield_outlined, size: 20, color: Color(0xFF576245)),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CommonText(
                      "SAFETY FIRST",
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF576245), letterSpacing: 0.275),
                    ),
                    const SizedBox(height: 4),
                    const CommonText(
                      "If not yet discussed or not cleared, we strictly limit physical movement until cleared by your physician.",
                      style: TextStyle(fontSize: 12, color: Color(0xFF404A2F), height: 18 / 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPostpartumSensations() {
    return ProfileSectionCard(
      title: "Current Postpartum Sensations",
      icon: appIcons.maintenance,
      children: [
        buildRequiredLabel("Are you currently experiencing any physical or emotional symptoms?", color: const Color(0xFF534343)),
        const SizedBox(height: 16),
        Column(
          children: _sensationsList.map((item) => _buildCheckboxRow(item, _selectedSensations.contains(item), () {
            setState(() {
              if (_selectedSensations.contains(item)) {
                _selectedSensations.remove(item);
              } else {
                if (item == "None of these") {
                  _selectedSensations.clear();
                  _selectedSensations.add(item);
                } else {
                  _selectedSensations.remove("None of these");
                  _selectedSensations.add(item);
                }
              }
              if (_sensationsError != null) _validate();
            });
          })).toList(),
        ),
        if (_sensationsError != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 4),
            child: CommonText(_sensationsError!, style: TextStyle(color: appColors.red, fontSize: 12)),
          ),
      ],
    );
  }

  Widget _buildSleepAndSupport() {
    return ProfileSectionCard(
      title: "Sleep Rhythms & Support System",
      icon: appIcons.halfOutlineMoon,
      children: [
        buildRequiredLabel("Postpartum recovery happens in tiny stolen pockets. Sharing your real rest environment helps us recommend doable nourishment.", color: const Color(0xFF534343)),
        const SizedBox(height: 16),
        const CommonText("Longest usual stretch of sleep", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF1D1B1A))),
        const SizedBox(height: 6),
        CommonTextField(
          label: "",
          controller: _sleepStretchController,
          hint: "e.g. 3.5 hours at night between feeds",
          borderColor: _sleepStretchError != null ? appColors.red : Colors.transparent,
          fillColor: const Color(0xFFF8F2F0),
          onChanged: (v) {
            setState(() {});
            if (_sleepStretchError != null) _validate();
          },
        ),
        if (_sleepStretchError != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 4),
            child: CommonText(_sleepStretchError!, style: TextStyle(color: appColors.red, fontSize: 12)),
          ),
        const SizedBox(height: 16),
        const CommonText("Caregiving and meal support", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF1D1B1A))),
        const SizedBox(height: 6),
        CommonTextField(
          label: "",
          controller: _caregivingSupportController,
          hint: "e.g. Partner helps with evening feeds; mother visits on weekdays to help with warm home-cooked meals.",
          maxLines: 4,
          borderColor: Colors.transparent,
          fillColor: const Color(0xFFF8F2F0),
        ),
      ],
    );
  }

  Widget _buildPriorityOutcomes() {
    return ProfileSectionCard(
      title: "What are your top two priorities right now?",
      icon: appIcons.compass,
      children: [
        buildRequiredLabel("Choose up to 2 primary areas to anchor your first 6 weeks of maternal nourishment:", color: const Color(0xFF534343)),
        const SizedBox(height: 16),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: _prioritiesList.map((item) {
            bool isSelected = _selectedPriorities.contains(item);
            double chipWidth = (MediaQuery.of(context).size.width - 40 - 40 - 10) / 2; // Responsive 2 cols
            return SizedBox(
              width: chipWidth,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      _selectedPriorities.remove(item);
                    } else {
                      if (_selectedPriorities.length < 2) {
                        _selectedPriorities.add(item);
                      }
                    }
                    if (_prioritiesError != null) _validate();
                  });
                },
                child: Container(
                  height: 54, // Fixed height to handle wraps effectively
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  alignment: Alignment.centerLeft,
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
                      Flexible(
                        child: CommonText(
                          item,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: isSelected ? const Color(0xFF8B484D) : const Color(0xFF1D1B1A),
                          ),
                          maxLines: 2,
                        ),
                      ),
                      if (isSelected)
                        Container(
                          margin: const EdgeInsets.only(left: 4),
                          width: 20,
                          height: 20,
                          decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFF8B484D)),
                          child: const Icon(Icons.check, size: 14, color: Colors.white),
                        )
                      else
                        Container(
                          margin: const EdgeInsets.only(left: 4),
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white, border: Border.all(color: const Color(0xFF857373))),
                        ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        if (_prioritiesError != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: CommonText(_prioritiesError!, style: TextStyle(color: appColors.red, fontSize: 12)),
          ),
        const SizedBox(height: 16),
        CommonTextField(
          label: "",
          controller: _otherPriorityController,
          hint: "Other specific priority (optional)...",
          borderColor: Colors.transparent,
          fillColor: const Color(0xFFF8F2F0),
        ),
      ],
    );
  }

  // --- Reusable Control Helpers ---

  Widget _buildRadioRow(String value, String? groupValue, ValueChanged<String> onChanged) {
    bool isSelected = groupValue == value;
    return GestureDetector(
      onTap: () => onChanged(value),
      child: Container(
        padding: const EdgeInsets.all(14),
        margin: const EdgeInsets.only(bottom: 10),
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
            Expanded(
              child: CommonText(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w500 : FontWeight.w500,
                  color: isSelected ? const Color(0xFF8B484D) : const Color(0xFF1D1B1A),
                ),
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

  Widget _buildCheckboxRow(String value, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        margin: const EdgeInsets.only(bottom: 10),
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
            Expanded(
              child: CommonText(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w500 : FontWeight.w500,
                  color: isSelected ? const Color(0xFF8B484D) : const Color(0xFF1D1B1A),
                ),
              ),
            ),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: isSelected ? const Color(0xFF8B484D) : const Color(0xFFE7E1DF),
              ),
              child: isSelected ? const Icon(Icons.check, size: 14, color: Colors.white) : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleBtn(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF8B484D) : const Color(0xFFEDE7E5),
          borderRadius: BorderRadius.circular(999),
          boxShadow: isSelected
              ? [BoxShadow(color: Colors.black.withValues(alpha: 0.05), offset: const Offset(0, 1), blurRadius: 2)]
              : null,
        ),
        child: CommonText(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : const Color(0xFF534343),
          ),
        ),
      ),
    );
  }
}
