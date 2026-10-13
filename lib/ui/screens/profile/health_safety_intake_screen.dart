import 'package:flutter/material.dart';

import '../../../../main.dart';
import '../../../core/constants/utils.dart';
import '../../widgets/common_app_bar.dart';
import '../../widgets/common_button.dart';
import '../../widgets/common_text.dart';
import '../../widgets/common_text_field.dart';
import 'food_digestion_intake_screen.dart';

class MedicationEntry {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController doseController = TextEditingController();
  final TextEditingController freqController = TextEditingController();
  final TextEditingController reasonController = TextEditingController();

  String? nameError;
  String? doseError;
  String? freqError;
  String? reasonError;

  void dispose() {
    nameController.dispose();
    doseController.dispose();
    freqController.dispose();
    reasonController.dispose();
  }
}

class HealthSafetyIntakeScreen extends StatefulWidget {
  const HealthSafetyIntakeScreen({super.key});

  @override
  State<HealthSafetyIntakeScreen> createState() => _HealthSafetyIntakeScreenState();
}

class _HealthSafetyIntakeScreenState extends State<HealthSafetyIntakeScreen> {
  // Medical Diagnoses
  final List<String> _diagnosesList = [
    "Diabetes or prediabetes", "High blood pressure", "High cholesterol or triglycerides",
    "Thyroid condition", "PCOS or PCOD", "Endometriosis, fibroids or adenomyosis",
    "Fatty liver", "Anaemia or nutrient deficiency", "Kidney, heart or autoimmune condition",
    "Digestive condition", "Anxiety, depression or mental-health condition", "None of the above", "Other"
  ];
  final Set<String> _selectedDiagnoses = {};
  String? _diagnosesError;

  // Family History
  final List<String> _familyHistoryList = [
    "Diabetes", "High blood pressure", "High cholesterol", "Heart disease",
    "Thyroid condition", "Obesity", "None known", "Other"
  ];
  final Set<String> _selectedFamilyHistory = {};
  String? _familyHistoryError;

  // Medications
  bool? _takingMedication;
  String? _medicationError;
  List<MedicationEntry> _medications = [MedicationEntry()];

  // Movement & Limitations
  bool _hasLimitations = false;
  final TextEditingController _limitationsController = TextEditingController();
  String? _limitationsError;

  // Physician Restrictions
  bool _hasRestrictions = false;
  final TextEditingController _restrictionsController = TextEditingController();
  String? _restrictionsError;

  // Recent Clinical Symptoms
  final List<String> _symptomsList = [
    "Chest pain during rest or activity", "Unexplained breathlessness", "Dizziness or fainting",
    "Uncontrolled blood pressure", "Unexplained rapid weight loss", "Blood in stool",
    "Persistent vomiting", "Severe abdominal or pelvic pain", "None of the above"
  ];
  final Set<String> _selectedSymptoms = {};
  String? _symptomsError;

  // Allergies
  String? _selectedAllergy;
  final TextEditingController _allergyDetailsController = TextEditingController();
  String? _allergyError;
  String? _allergyDetailsError;
  final List<String> _allergyOptions = [
    "No known allergies",
    "Yes – medically diagnosed allergy",
    "Yes – suspected allergy",
    "Yes – intolerance or food triggers"
  ];

  // Hormonal Stage
  String? _selectedHormonalStage;
  String? _hormonalStageError;
  final List<String> _hormonalStages = [
    "Regular menstrual cycles", "Irregular menstrual cycles", "Trying to conceive",
    "Pregnant", "Postpartum and breastfeeding", "Postpartum and not breastfeeding",
    "Perimenopause", "Menopause", "Periods absent due to medication or a health condition",
    "Hysterectomy or reproductive surgery", "Not applicable", "Prefer not to answer"
  ];

  bool _validate() {
    bool isValid = true;

    if (_selectedDiagnoses.isEmpty) {
      _diagnosesError = "Please select at least one diagnosis";
      isValid = false;
    } else {
      _diagnosesError = null;
    }

    if (_selectedFamilyHistory.isEmpty) {
      _familyHistoryError = "Please select family medical history";
      isValid = false;
    } else {
      _familyHistoryError = null;
    }

    if (_takingMedication == null) {
      _medicationError = "Please select Yes or No";
      isValid = false;
    } else {
      _medicationError = null;
      if (_takingMedication == true) {
        for (var med in _medications) {
          if (med.nameController.text.trim().isEmpty) { med.nameError = "Required"; isValid = false; } else { med.nameError = null; }
          if (med.doseController.text.trim().isEmpty) { med.doseError = "Required"; isValid = false; } else { med.doseError = null; }
          if (med.freqController.text.trim().isEmpty) { med.freqError = "Required"; isValid = false; } else { med.freqError = null; }
          if (med.reasonController.text.trim().isEmpty) { med.reasonError = "Required"; isValid = false; } else { med.reasonError = null; }
        }
      }
    }

    if (_hasLimitations == true && _limitationsController.text.trim().isEmpty) {
      _limitationsError = "Please specify details";
      isValid = false;
    } else {
      _limitationsError = null;
    }

    if (_hasRestrictions == true && _restrictionsController.text.trim().isEmpty) {
      _restrictionsError = "Please specify guidance";
      isValid = false;
    } else {
      _restrictionsError = null;
    }

    if (_selectedSymptoms.isEmpty) {
      _symptomsError = "Please select recent clinical symptoms";
      isValid = false;
    } else {
      _symptomsError = null;
    }

    if (_selectedAllergy == null) {
      _allergyError = "Please select an allergy option";
      isValid = false;
    } else {
      _allergyError = null;
    }

    if (_selectedAllergy != null && _selectedAllergy != "No known allergies" && _allergyDetailsController.text.trim().isEmpty) {
      _allergyDetailsError = "Please specify foods & observed symptoms";
      isValid = false;
    } else {
      _allergyDetailsError = null;
    }

    if (_selectedHormonalStage == null) {
      _hormonalStageError = "Please select a hormonal stage";
      isValid = false;
    } else {
      _hormonalStageError = null;
    }

    setState(() {});
    return isValid;
  }

  void _onSaveAndContinue() {
    if (_validate()) {
      appLog("Health & Safety Form Validated!");
      navigation.pushReplaceFadeAnimation(context, FoodDigestionIntakeScreen());
    }
  }

  @override
  void dispose() {
    for (var med in _medications) {
      med.dispose();
    }
    _limitationsController.dispose();
    _restrictionsController.dispose();
    _allergyDetailsController.dispose();
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
              "CHAPTER 3 OF 6",
              style: TextStyle(
                fontSize: 11,
                color: appColors.primary,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.55,
              ),
            ),
            CommonText(
              "Relevant Health & Safety",
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
          _buildDiagnosesSection(),
          const SizedBox(height: 24),
          _buildFamilyHistorySection(),
          const SizedBox(height: 24),
          _buildMedicationsSection(),
          const SizedBox(height: 24),
          _buildLimitationsSection(),
          const SizedBox(height: 24),
          _buildRestrictionsSection(),
          const SizedBox(height: 24),
          _buildSymptomsSection(),
          const SizedBox(height: 24),
          _buildAllergiesSection(),
          const SizedBox(height: 24),
          _buildHormonalStageSection(),
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

  Widget _buildRequiredLabel(String text) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontSize: 13,
          fontFamily: fontFamilyPlusJakartaSans,
          color: Color(0xFF534343),
          fontWeight: FontWeight.w600,
        ),
        children: [
          TextSpan(text: "$text "),
          TextSpan(text: "*", style: TextStyle(color: appColors.primary, fontWeight: FontWeight.normal)),
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

  Widget _buildSegmentedControl(bool? value, ValueChanged<bool> onChanged) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: appColors.textFieldBgColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => onChanged(false),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: value == false ? appColors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(999),
                  boxShadow: value == false ? [BoxShadow(color: appColors.black.withValues(alpha: 0.05), blurRadius: 1, offset: const Offset(0, 1))] : null,
                ),
                child: CommonText(
                  "No",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: value == false ? appColors.primary : const Color(0xFF534343),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => onChanged(true),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: value == true ? appColors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(999),
                  boxShadow: value == true ? [BoxShadow(color: appColors.black.withValues(alpha: 0.05), blurRadius: 1, offset: const Offset(0, 1))] : null,
                ),
                child: CommonText(
                  "Yes",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: value == true ? appColors.primary : const Color(0xFF534343),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiagnosesSection() {
    return _buildSectionCard(
      title: "Medical Diagnoses",
      icon: appIcons.medicalDiagnoses,
      children: [
        _buildRequiredLabel("Have you been diagnosed with, or are you currently being evaluated for, any of the following?"),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 12,
          children: _diagnosesList.map((e) => _buildChip(
            label: e,
            isSelected: _selectedDiagnoses.contains(e),
            onTap: () {
              setState(() {
                if (_selectedDiagnoses.contains(e)) {
                  _selectedDiagnoses.remove(e);
                } else {
                  _selectedDiagnoses.add(e);
                }
                if (_diagnosesError != null) _validate();
              });
            }
          )).toList(),
        ),
        if (_diagnosesError != null)
          Padding(padding: const EdgeInsets.only(top: 8), child: CommonText(_diagnosesError!, style: TextStyle(color: appColors.red, fontSize: 12))),
      ],
    );
  }

  Widget _buildFamilyHistorySection() {
    return _buildSectionCard(
      title: "Family Medical History",
      icon: appIcons.familyMedicalHistory,
      children: [
        _buildRequiredLabel("Does your immediate family have a history of any of the following?"),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 12,
          children: _familyHistoryList.map((e) => _buildChip(
            label: e,
            isSelected: _selectedFamilyHistory.contains(e),
            onTap: () {
              setState(() {
                if (_selectedFamilyHistory.contains(e)) {
                  _selectedFamilyHistory.remove(e);
                } else {
                  _selectedFamilyHistory.add(e);
                }
                if (_familyHistoryError != null) _validate();
              });
            }
          )).toList(),
        ),
        if (_familyHistoryError != null)
          Padding(padding: const EdgeInsets.only(top: 8), child: CommonText(_familyHistoryError!, style: TextStyle(color: appColors.red, fontSize: 12))),
      ],
    );
  }

  Widget _buildMedicationsSection() {
    return _buildSectionCard(
      title: "Medications & Supplements",
      icon: appIcons.medication,
      children: [
        _buildRequiredLabel("Are you currently taking any prescribed medicine or regular supplement?"),
        const SizedBox(height: 12),
        _buildSegmentedControl(_takingMedication, (v) {
          setState(() {
            _takingMedication = v;
            if (_medicationError != null) _validate();
          });
        }),
        if (_medicationError != null)
          Padding(padding: const EdgeInsets.only(top: 8), child: CommonText(_medicationError!, style: TextStyle(color: appColors.red, fontSize: 12))),
        if (_takingMedication == true) ...[
          const SizedBox(height: 16),
          ...List.generate(_medications.length, (index) {
            final med = _medications[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: appColors.textFieldBgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CommonText(
                        "Entry #${index + 1} • Active Prescription",
                        style: TextStyle(fontSize: 12, color: appColors.primary, fontWeight: FontWeight.w600),
                      ),
                      if (_medications.length > 1)
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _medications[index].dispose();
                              _medications.removeAt(index);
                            });
                          },
                          child: Icon(Icons.close_rounded, size: 16, color: appColors.neutral),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  CommonTextField(
                    controller: med.nameController,
                    label: "Medication / Supplement Name",
                    hint: "e.g. Levothyroxine",
                    fillColor: Colors.white,
                    error: med.nameError,
                    onChanged: (v) { if (med.nameError != null) _validate(); },
                  ),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: CommonTextField(
                          controller: med.doseController, 
                          label: "Dose (if known)", 
                          hint: "e.g. 50 mcg", 
                          fillColor: Colors.white,
                          error: med.doseError,
                          onChanged: (v) { if (med.doseError != null) _validate(); },
                        )
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: CommonTextField(
                          controller: med.freqController, 
                          label: "Frequency", 
                          hint: "e.g. Once daily", 
                          fillColor: Colors.white,
                          error: med.freqError,
                          onChanged: (v) { if (med.freqError != null) _validate(); },
                        )
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  CommonTextField(
                    controller: med.reasonController, 
                    label: "Reason / Condition", 
                    hint: "e.g. Hypothyroidism management", 
                    fillColor: Colors.white,
                    error: med.reasonError,
                    onChanged: (v) { if (med.reasonError != null) _validate(); },
                  ),
                ],
              ),
            );
          }),
          GestureDetector(
            onTap: () {
              setState(() {
                _medications.add(MedicationEntry());
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0x80FFDADB),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add, size: 16, color: appColors.primary),
                  const SizedBox(width: 6),
                  CommonText(
                    "Add another medication/supplement",
                    style: TextStyle(fontSize: 14, color: appColors.primary, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          )
        ],
      ],
    );
  }

  Widget _buildLimitationsSection() {
    return _buildSectionCard(
      title: "Movement & Limitations",
      icon: appIcons.movement,
      children: [
        _buildRequiredLabel("Do you currently have any injury, pain, past surgery or physical limitation that may affect walking, exercise or daily movement?"),
        const SizedBox(height: 12),
        _buildSegmentedControl(_hasLimitations, (v) => setState(() => _hasLimitations = v)),
        if (_hasLimitations == true) ...[
          const SizedBox(height: 16),
          CommonText("Details", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: const Color(0xFF534343))),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: appColors.textFieldBgColor,
              borderRadius: BorderRadius.circular(12),
              border: _limitationsError != null ? Border.all(color: appColors.red) : null,
            ),
            child: TextField(
              controller: _limitationsController,
              maxLines: 3,
              style: TextStyle(fontSize: 14, color: const Color(0xFF1D1B1A), fontFamily: fontFamilyPlusJakartaSans),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "e.g., Mild lower back stiffness after prolonged sitting...",
                hintStyle: TextStyle(fontSize: 14, color: const Color(0xFF857373)),
                isDense: true,
              ),
              onChanged: (v) {
                if (_limitationsError != null) _validate();
              },
            ),
          ),
          if (_limitationsError != null)
            Padding(padding: const EdgeInsets.only(top: 4), child: CommonText(_limitationsError!, style: TextStyle(color: appColors.red, fontSize: 12))),
        ],
      ],
    );
  }

  Widget _buildRestrictionsSection() {
    return _buildSectionCard(
      title: "Physician Restrictions",
      icon: appIcons.note,
      children: [
        _buildRequiredLabel("Has a doctor asked you to avoid or limit any food, exercise or lifestyle practice?"),
        const SizedBox(height: 12),
        _buildSegmentedControl(_hasRestrictions, (v) => setState(() => _hasRestrictions = v)),
        if (_hasRestrictions == true) ...[
          const SizedBox(height: 16),
          CommonText("Specific medical guidance", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: const Color(0xFF534343))),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: appColors.textFieldBgColor,
              borderRadius: BorderRadius.circular(12),
              border: _restrictionsError != null ? Border.all(color: appColors.red) : null,
            ),
            child: TextField(
              controller: _restrictionsController,
              maxLines: 3,
              style: TextStyle(fontSize: 14, color: const Color(0xFF1D1B1A), fontFamily: fontFamilyPlusJakartaSans),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "e.g. Advised to moderate sodium intake...",
                hintStyle: TextStyle(fontSize: 14, color: const Color(0xFF857373)),
                isDense: true,
              ),
              onChanged: (v) {
                if (_restrictionsError != null) _validate();
              },
            ),
          ),
          if (_restrictionsError != null)
            Padding(padding: const EdgeInsets.only(top: 4), child: CommonText(_restrictionsError!, style: TextStyle(color: appColors.red, fontSize: 12))),
        ],
      ],
    );
  }

  Widget _buildSymptomsSection() {
    return _buildSectionCard(
      title: "Recent Clinical Symptoms",
      icon: appIcons.notificationRecent,
      children: [
        _buildRequiredLabel("In the past six months, have you experienced any of the following?"),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 12,
          children: _symptomsList.map((e) => _buildChip(
            label: e,
            isSelected: _selectedSymptoms.contains(e),
            selectedBgColor: e == "None of the above" ? const Color(0xFFD8E5BF) : null,
            selectedTextColor: e == "None of the above" ? const Color(0xFF5B6749) : null,
            onTap: () {
              setState(() {
                if (e == "None of the above") {
                  _selectedSymptoms.clear();
                  _selectedSymptoms.add(e);
                } else {
                  _selectedSymptoms.remove("None of the above");
                  if (_selectedSymptoms.contains(e)) _selectedSymptoms.remove(e);
                  else _selectedSymptoms.add(e);
                }
                if (_symptomsError != null) _validate();
              });
            }
          )).toList(),
        ),
        if (_symptomsError != null)
          Padding(padding: const EdgeInsets.only(top: 8), child: CommonText(_symptomsError!, style: TextStyle(color: appColors.red, fontSize: 12))),
      ],
    );
  }

  Widget _buildAllergiesSection() {
    return _buildSectionCard(
      title: "Allergies & Intolerances",
      icon: appIcons.allergies,
      children: [
        _buildRequiredLabel("Do you have any food allergy or food intolerance?"),
        const SizedBox(height: 12),
        ..._allergyOptions.map((e) => _buildRadioOption(
          label: e,
          isSelected: _selectedAllergy == e,
          onTap: () {
            setState(() {
              _selectedAllergy = e;
              if (_allergyError != null || _allergyDetailsError != null) _validate();
            });
          },
        )),
        if (_allergyError != null)
          Padding(padding: const EdgeInsets.only(top: 8), child: CommonText(_allergyError!, style: TextStyle(color: appColors.red, fontSize: 12))),
        if (_selectedAllergy != null && _selectedAllergy != "No known allergies") ...[
          const SizedBox(height: 16),
          CommonText("Specify foods & observed symptoms", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: const Color(0xFF534343))),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: appColors.textFieldBgColor,
              borderRadius: BorderRadius.circular(12),
              border: _allergyDetailsError != null ? Border.all(color: appColors.red) : null,
            ),
            child: TextField(
              controller: _allergyDetailsController,
              maxLines: 3,
              style: TextStyle(fontSize: 14, color: const Color(0xFF1D1B1A), fontFamily: fontFamilyPlusJakartaSans),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "e.g. Cow's milk causes bloating...",
                hintStyle: TextStyle(fontSize: 14, color: const Color(0xFF857373)),
                isDense: true,
              ),
              onChanged: (v) {
                if (_allergyDetailsError != null) _validate();
              },
            ),
          ),
          if (_allergyDetailsError != null)
            Padding(padding: const EdgeInsets.only(top: 4), child: CommonText(_allergyDetailsError!, style: TextStyle(color: appColors.red, fontSize: 12))),
        ],
      ],
    );
  }

  Widget _buildHormonalStageSection() {
    return _buildSectionCard(
      title: "Hormonal & Life Stage",
      icon: appIcons.lotas, // or pregnant_woman depending on user
      children: [
        _buildRequiredLabel("Which reproductive or hormonal life stage best describes you currently?"),
        const SizedBox(height: 12),
        ..._hormonalStages.map((e) => _buildRadioOption(
          label: e,
          isSelected: _selectedHormonalStage == e,
          onTap: () {
            setState(() {
              _selectedHormonalStage = e;
              if (_hormonalStageError != null) _validate();
            });
          },
        )),
        if (_hormonalStageError != null)
          Padding(padding: const EdgeInsets.only(top: 8), child: CommonText(_hormonalStageError!, style: TextStyle(color: appColors.red, fontSize: 12))),
      ],
    );
  }

  Widget _buildRadioOption({required String label, required bool isSelected, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFDADB) : appColors.textFieldBgColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: CommonText(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                  color: const Color(0xFF1D1B1A),
                ),
              ),
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

  Widget _buildBottomBar() {
    return Container(
      padding: EdgeInsets.only(bottom: bottomPadding(context) > 0 ? bottomPadding(context) : 24),
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
        name: "Save & Continue to Food & Digestion",
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
