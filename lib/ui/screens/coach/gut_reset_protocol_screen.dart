import 'package:flutter/material.dart';

import '../../../../main.dart';
import '../../../core/constants/utils.dart';
import '../../widgets/common_app_bar.dart';
import '../../widgets/common_button.dart';
import '../../widgets/common_text.dart';
import '../../widgets/common_text_field.dart';
import '../profile/widget/profile_section_card.dart';

class GutResetProtocolScreen extends StatefulWidget {
  const GutResetProtocolScreen({super.key});

  @override
  State<GutResetProtocolScreen> createState() => _GutResetProtocolScreenState();
}

class _GutResetProtocolScreenState extends State<GutResetProtocolScreen> {
  // 1. Primary Digestive Symptoms
  final List<String> _digestiveSymptomsList = [
    "Bloating after meals", "Bloating all day", "Gas & flatulence", "Frequent burping",
    "Acidity or reflux", "Constipation", "Loose stools", "Alternating pattern",
    "Abdominal pain", "Nausea", "Early fullness", "None of these"
  ];
  final Set<String> _selectedDigestiveSymptoms = {};
  String? _symptomsError;

  // 2. Onset & Frequency
  String? _selectedDuration;
  final List<String> _durationList = [
    "< 3 months", "3 to 6 months", "6 to 12 months", "1+ years", "5+ years / Chronic"
  ];
  String? _onsetDurationError;

  String? _selectedFrequency;
  final List<String> _frequencyList = [
    "Daily / Constant", "Multiple times / week", "Weekly", "Periodic flare-ups"
  ];
  String? _occurrenceFrequencyError;

  // 3. Symptom Peak Timing
  final List<String> _peakTimingList = [
    "Immediately after eating", "Within 1-2 hours", "By evening",
    "During the night", "All day uniformly", "During stressful periods",
    "Around menstrual cycle", "No clear pattern"
  ];
  final Set<String> _selectedPeakTiming = {};
  String? _peakTimingError;

  // 4. Bowel Cadence & Transit
  String? _bowelCadence;
  final List<String> _bowelCadenceList = [
    "1-2 times per day", "Every 2-3 days", "3+ times per day", "Irregular / Variable"
  ];
  String? _bowelCadenceError;
  
  String? _evacuationCompleteness;
  final List<String> _evacuationCompletenessList = ["Always", "Sometimes", "Rarely"];
  String? _evacuationError;

  String? _stimulantReliance;
  final List<String> _stimulantRelianceList = [
    "Yes - morning warm tea/coffee is essential",
    "No - spontaneous morning rhythm without hot liquids"
  ];
  String? _stimulantError;

  // 5. Trigger Foods & Situations
  final List<String> _dairyGrainsList = ["Milk", "Curd or yoghurt", "Paneer", "Wheat"];
  final Set<String> _selectedDairyGrains = {};
  
  final List<String> _alliumsLegumesList = ["Onion or garlic", "Beans or legumes"];
  final Set<String> _selectedAlliumsLegumes = {};

  final List<String> _prepDiningList = ["Fried food", "Sweets", "Coffee", "Restaurant meals", "Large meals"];
  final Set<String> _selectedPrepDining = {};

  final List<String> _systemicMindGutList = ["Emotional stress", "Not sure yet", "Other"];
  final Set<String> _selectedSystemicMindGut = {};

  final TextEditingController _otherTriggersController = TextEditingController();
  String? _triggerFoodsError;

  // 6. Prior Diagnosis, Tests or Care
  bool? _hasPriorDiagnosis;
  final TextEditingController _clinicalHistoryController = TextEditingController();
  String? _priorDiagnosisError;

  // 7. Priority Relief Focus
  final TextEditingController _priorityReliefController = TextEditingController();

  bool _validate() {
    bool isValid = true;
    if (_selectedDigestiveSymptoms.isEmpty) {
      _symptomsError = "Please select at least 1 symptom";
      isValid = false;
    } else {
      _symptomsError = null;
    }

    if (_selectedDuration == null) {
      _onsetDurationError = "Please select onset duration";
      isValid = false;
    } else {
      _onsetDurationError = null;
    }

    if (_selectedFrequency == null) {
      _occurrenceFrequencyError = "Please select occurrence frequency";
      isValid = false;
    } else {
      _occurrenceFrequencyError = null;
    }

    if (_selectedPeakTiming.isEmpty) {
      _peakTimingError = "Please select symptom peak timing";
      isValid = false;
    } else {
      _peakTimingError = null;
    }

    if (_bowelCadence == null) {
      _bowelCadenceError = "Please select bowel cadence";
      isValid = false;
    } else {
      _bowelCadenceError = null;
    }

    if (_evacuationCompleteness == null) {
      _evacuationError = "Please select evacuation completeness";
      isValid = false;
    } else {
      _evacuationError = null;
    }

    if (_stimulantReliance == null) {
      _stimulantError = "Please select stimulant reliance";
      isValid = false;
    } else {
      _stimulantError = null;
    }

    if (_selectedDairyGrains.isEmpty &&
        _selectedAlliumsLegumes.isEmpty &&
        _selectedPrepDining.isEmpty &&
        _selectedSystemicMindGut.isEmpty) {
      _triggerFoodsError = "Please select at least 1 trigger food/situation";
      isValid = false;
    } else {
      _triggerFoodsError = null;
    }

    if (_hasPriorDiagnosis == null) {
      _priorDiagnosisError = "Please answer prior diagnosis";
      isValid = false;
    } else {
      _priorDiagnosisError = null;
    }

    setState(() {});
    return isValid;
  }

  void _onSave() {
    if (_validate()) {
      showSnackBar(context: context, isError: false, message: 'Gut Reset Protocol Submitted!');
      navigation.pop(context);
    } else {
      showSnackBar(context: context, isError: true, message: 'Please complete all required fields.');
    }
  }

  @override
  void dispose() {
    _otherTriggersController.dispose();
    _clinicalHistoryController.dispose();
    _priorityReliefController.dispose();
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
          "Gut Reset Protocol",
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
          _buildPrimarySymptomsSection(),
          const SizedBox(height: 24),
          _buildOnsetFrequencySection(),
          const SizedBox(height: 24),
          _buildSymptomPeakTimingSection(),
          const SizedBox(height: 24),
          _buildBowelCadenceSection(),
          const SizedBox(height: 24),
          _buildTriggerFoodsSection(),
          const SizedBox(height: 24),
          _buildPriorDiagnosisSection(),
          const SizedBox(height: 24),
          _buildPriorityReliefFocusSection(),
          const SizedBox(height: 32),
          CommonButton(
            name: "Save & Submit Gut Reset Protocol",
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

  Widget _buildPrimarySymptomsSection() {
    return ProfileSectionCard(
      title: "Primary Digestive Symptoms",
      icon: appIcons.progress,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildRequiredLabel("Which digestive symptoms are affecting you most? (Select up to 4)", color: const Color(0xFF534343)),
                  const SizedBox(height: 4),
                  const CommonText("Mindful self-observation", style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Color(0xFF576245), fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFEDE7E5),
                borderRadius: BorderRadius.circular(999),
              ),
              child: CommonText("Selected: ${_selectedDigestiveSymptoms.length}/4", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF8B484D))),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _digestiveSymptomsList.map((item) {
            bool isSelected = _selectedDigestiveSymptoms.contains(item);
            double chipWidth = (MediaQuery.of(context).size.width - 40 - 40 - 8) / 2; // 20 pad(x2), 20 cardPad(x2), 8 spacing
            return SizedBox(
              width: chipWidth,
              child: _buildCheckPill(item, isSelected, () {
                setState(() {
                  if (isSelected) {
                    _selectedDigestiveSymptoms.remove(item);
                  } else {
                    if (item == "None of these") {
                      _selectedDigestiveSymptoms.clear();
                      _selectedDigestiveSymptoms.add(item);
                    } else {
                      _selectedDigestiveSymptoms.remove("None of these");
                      if (_selectedDigestiveSymptoms.length < 4) {
                        _selectedDigestiveSymptoms.add(item);
                      }
                    }
                  }
                  if (_symptomsError != null) _validate();
                });
              }),
            );
          }).toList(),
        ),
        if (_symptomsError != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: CommonText(_symptomsError!, style: TextStyle(color: appColors.red, fontSize: 12)),
          ),
      ],
    );
  }

  Widget _buildOnsetFrequencySection() {
    return ProfileSectionCard(
      title: "Onset & Frequency",
      icon: appIcons.calenderTime,
      children: [
        buildRequiredLabel("When did these symptoms begin, and how often do they occur?", color: const Color(0xFF534343)),
        const SizedBox(height: 16),
        Row(
          children: [
            Container(width: 6, height: 6, decoration: const BoxDecoration(color: Color(0xFF8B484D), shape: BoxShape.circle)),
            const SizedBox(width: 6),
            const CommonText("Symptom Chronic / Onset Duration", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1D1B1A))),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _durationList.map((item) => _buildSimplePill(
            item,
            _selectedDuration == item,
            () => setState(() {
              _selectedDuration = item;
              if (_onsetDurationError != null) _validate();
            }),
          )).toList(),
        ),
        if (_onsetDurationError != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: CommonText(_onsetDurationError!, style: TextStyle(color: appColors.red, fontSize: 12)),
          ),
        const SizedBox(height: 20),
        Row(
          children: [
            Container(width: 6, height: 6, decoration: const BoxDecoration(color: Color(0xFF576245), shape: BoxShape.circle)),
            const SizedBox(width: 6),
            const CommonText("Occurrence Frequency", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1D1B1A))),
          ],
        ),
        const SizedBox(height: 12),
        Column(
          children: [
            Row(
              children: [
                Expanded(child: _buildOptionCard(_frequencyList[0], _selectedFrequency == _frequencyList[0], () => _onFreqSelected(_frequencyList[0]), selectedBg: const Color(0xFFD8E5BF), selectedText: const Color(0xFF151E07))),
                const SizedBox(width: 8),
                Expanded(child: _buildOptionCard(_frequencyList[1], _selectedFrequency == _frequencyList[1], () => _onFreqSelected(_frequencyList[1]))),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: _buildOptionCard(_frequencyList[2], _selectedFrequency == _frequencyList[2], () => _onFreqSelected(_frequencyList[2]))),
                const SizedBox(width: 8),
                Expanded(child: _buildOptionCard(_frequencyList[3], _selectedFrequency == _frequencyList[3], () => _onFreqSelected(_frequencyList[3]))),
              ],
            ),
          ],
        ),
        if (_occurrenceFrequencyError != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: CommonText(_occurrenceFrequencyError!, style: TextStyle(color: appColors.red, fontSize: 12)),
          ),
      ],
    );
  }

  void _onFreqSelected(String item) {
    setState(() {
      _selectedFrequency = item;
      if (_occurrenceFrequencyError != null) _validate();
    });
  }

  Widget _buildSymptomPeakTimingSection() {
    return ProfileSectionCard(
      title: "Symptom Peak Timing",
      icon: appIcons.clockFill,
      children: [
        buildRequiredLabel("When are symptoms usually strongest throughout the circadian cycle?", color: const Color(0xFF534343)),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _peakTimingList.map((item) => _buildSimplePill(
            item,
            _selectedPeakTiming.contains(item),
            () {
              setState(() {
                if (_selectedPeakTiming.contains(item)) {
                  _selectedPeakTiming.remove(item);
                } else {
                  _selectedPeakTiming.add(item);
                }
                if (_peakTimingError != null) _validate();
              });
            },
          )).toList(),
        ),
        if (_peakTimingError != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: CommonText(_peakTimingError!, style: TextStyle(color: appColors.red, fontSize: 12)),
          ),
      ],
    );
  }

  Widget _buildBowelCadenceSection() {
    return ProfileSectionCard(
      title: "Bowel Cadence & Transit",
      icon: appIcons.bowelCadence,
      children: [
        buildRequiredLabel("Bowel movements cadence", color: const Color(0xFF1D1B1A)),
        const SizedBox(height: 12),
        Column(
          children: [
            Row(
              children: [
                Expanded(child: _buildOptionCard(_bowelCadenceList[0], _bowelCadence == _bowelCadenceList[0], () => _onCadenceSelected(_bowelCadenceList[0]), selectedBg: const Color(0xFFD8E5BF), selectedText: const Color(0xFF151E07))),
                const SizedBox(width: 8),
                Expanded(child: _buildOptionCard(_bowelCadenceList[1], _bowelCadence == _bowelCadenceList[1], () => _onCadenceSelected(_bowelCadenceList[1]))),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: _buildOptionCard(_bowelCadenceList[2], _bowelCadence == _bowelCadenceList[2], () => _onCadenceSelected(_bowelCadenceList[2]))),
                const SizedBox(width: 8),
                Expanded(child: _buildOptionCard(_bowelCadenceList[3], _bowelCadence == _bowelCadenceList[3], () => _onCadenceSelected(_bowelCadenceList[3]))),
              ],
            ),
          ],
        ),
        if (_bowelCadenceError != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: CommonText(_bowelCadenceError!, style: TextStyle(color: appColors.red, fontSize: 12)),
          ),
        const SizedBox(height: 16),
        buildRequiredLabel("Usually feel fully emptied?", color: const Color(0xFF1D1B1A)),
        const SizedBox(height: 12),
        Row(
          children: _evacuationCompletenessList.map((item) => Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: item != _evacuationCompletenessList.last ? 8.0 : 0.0),
              child: _buildOptionCard(
                item,
                _evacuationCompleteness == item,
                () => setState(() {
                  _evacuationCompleteness = item;
                  if (_evacuationError != null) _validate();
                }),
              ),
            ),
          )).toList(),
        ),
        if (_evacuationError != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: CommonText(_evacuationError!, style: TextStyle(color: appColors.red, fontSize: 12)),
          ),
        const SizedBox(height: 16),
        buildRequiredLabel("Need coffee, tea or stimulant to initiate transit?", color: const Color(0xFF1D1B1A)),
        const SizedBox(height: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: _stimulantRelianceList.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: _buildOptionCard(
              item,
              _stimulantReliance == item,
              () => setState(() {
                _stimulantReliance = item;
                if (_stimulantError != null) _validate();
              }),
            ),
          )).toList(),
        ),
        if (_stimulantError != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: CommonText(_stimulantError!, style: TextStyle(color: appColors.red, fontSize: 12)),
          ),
      ],
    );
  }

  void _onCadenceSelected(String item) {
    setState(() {
      _bowelCadence = item;
      if (_bowelCadenceError != null) _validate();
    });
  }

  Widget _buildTriggerFoodsSection() {
    return ProfileSectionCard(
      title: "Trigger Foods & Situations",
      icon: appIcons.spoon,
      children: [
        buildRequiredLabel("Which foods or situations seem to worsen your symptoms?", color: const Color(0xFF534343)),
        const SizedBox(height: 16),
        _buildTriggerCategory("Dairy & Grains", _dairyGrainsList, _selectedDairyGrains),
        const SizedBox(height: 16),
        _buildTriggerCategory("Alliums & Legumes", _alliumsLegumesList, _selectedAlliumsLegumes),
        const SizedBox(height: 16),
        _buildTriggerCategory("Preparation & Dining Style", _prepDiningList, _selectedPrepDining),
        const SizedBox(height: 16),
        _buildTriggerCategory("Systemic & Mind-gut", _systemicMindGutList, _selectedSystemicMindGut),
        if (_triggerFoodsError != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: CommonText(_triggerFoodsError!, style: TextStyle(color: appColors.red, fontSize: 12)),
          ),
        const SizedBox(height: 20),
        const CommonText(
          "Other specific food or sensory triggers (optional)",
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF534343)),
        ),
        const SizedBox(height: 8),
        CommonTextField(
          label: "",
          controller: _otherTriggersController,
          hint: "e.g. Raw calciferous vegetables (broccoli/cabbage) & deep-fried snacks",
          maxLines: 3,
          borderColor: Colors.transparent,
          fillColor: const Color(0xFFF2EDEB),
        ),
      ],
    );
  }

  Widget _buildTriggerCategory(String title, List<String> list, Set<String> selectedSet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonText(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF534343))),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: list.map((item) => _buildSimplePill(
            item,
            selectedSet.contains(item),
            () {
              setState(() {
                if (selectedSet.contains(item)) {
                  selectedSet.remove(item);
                } else {
                  selectedSet.add(item);
                }
                if (_triggerFoodsError != null) _validate();
              });
            },
          )).toList(),
        ),
      ],
    );
  }

  Widget _buildPriorDiagnosisSection() {
    return ProfileSectionCard(
      title: "Prior Diagnosis, Tests or Care",
      icon: appIcons.priorDiagnosis,
      children: [
        buildRequiredLabel("Have you had any medical diagnosis, clinical test, or prescription treatment for these symptoms?", color: const Color(0xFF534343)),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildOptionCard(
                "No",
                _hasPriorDiagnosis == false,
                () => setState(() {
                  _hasPriorDiagnosis = false;
                  if (_priorDiagnosisError != null) _validate();
                }),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildOptionCard(
                "Yes",
                _hasPriorDiagnosis == true,
                () => setState(() {
                  _hasPriorDiagnosis = true;
                  if (_priorDiagnosisError != null) _validate();
                }),
              ),
            ),
          ],
        ),
        if (_priorDiagnosisError != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: CommonText(_priorDiagnosisError!, style: TextStyle(color: appColors.red, fontSize: 12)),
          ),
        const SizedBox(height: 16),
        const CommonText("Clinical History & Test Findings", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1D1B1A))),
        const SizedBox(height: 8),
        CommonTextField(
          label: "",
          controller: _clinicalHistoryController,
          hint: "e.g. Diagnosed with mild GERD by gastroenterologist in autumn 2023. Upper endoscopy was unremarkable.",
          maxLines: 4,
          borderColor: Colors.transparent,
          fillColor: const Color(0xFFF2EDEB),
        ),
      ],
    );
  }

  Widget _buildPriorityReliefFocusSection() {
    return ProfileSectionCard(
      title: "Priority Relief Focus",
      icon: appIcons.starsFill,
      children: [
        const CommonText(
          "If we improved only one digestive concern during this program, which would make the biggest difference to your quality of life?",
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF534343)),
        ),
        const SizedBox(height: 16),
        CommonTextField(
          label: "",
          controller: _priorityReliefController,
          hint: "e.g. Eliminating severe post-meal bloating and burning reflux after lunch, so I can sit through afternoon client meetings comfortably without abdominal distension.",
          maxLines: 4,
          borderColor: Colors.transparent,
          fillColor: const Color(0xFFF2EDEB),
        ),
      ],
    );
  }

  // Helper UI Widgets
  Widget _buildCheckPill(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 57,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFDADB) : const Color(0xFFF2EDEB),
          border: Border.all(color: isSelected ? const Color(0x338B484D) : Colors.transparent),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: CommonText(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: isSelected ? const Color(0xFF3A0910) : const Color(0xFF1D1B1A),
                ),
                maxLines: 2,
              ),
            ),
            if (isSelected)
              Container(
                margin: const EdgeInsets.only(left: 4),
                width: 20,
                height: 20,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF8B484D),
                ),
                child: const Icon(Icons.check, size: 14, color: Colors.white),
              )
            else
              Container(
                margin: const EdgeInsets.only(left: 4),
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFF857373)),
                ),
              )
          ],
        ),
      ),
    );
  }

  Widget _buildSimplePill(String label, bool isSelected, VoidCallback onTap, {Color? selectedBg, Color? selectedText}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? (selectedBg ?? const Color(0xFFFFDADB)) : const Color(0xFFF2EDEB),
          borderRadius: BorderRadius.circular(999),
        ),
        child: CommonText(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: isSelected ? (selectedText ?? const Color(0xFF3A0910)) : const Color(0xFF1D1B1A),
          ),
        ),
      ),
    );
  }

  Widget _buildOptionCard(String label, bool isSelected, VoidCallback onTap, {Color? selectedBg, Color? selectedText}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? (selectedBg ?? const Color(0xFFFFDADB)) : const Color(0xFFF2EDEB),
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: CommonText(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: isSelected ? (selectedText ?? const Color(0xFF3A0910)) : const Color(0xFF1D1B1A),
          ),
        ),
      ),
    );
  }
}
