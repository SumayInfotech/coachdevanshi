import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../main.dart';
import '../../../core/blocs/profile/chapter_three/chapter_three_bloc.dart';
import '../../../core/blocs/profile/save_chapter/save_chapter_bloc.dart';
import '../../../core/constants/urls.dart';
import '../../../core/constants/utils.dart';
import '../../../core/models/profile/chapter_three_model.dart';
import '../../../core/models/profile/onboarding_masters_model.dart';
import '../../../core/services/loader_service.dart';
import '../../widgets/common_app_bar.dart';
import '../../widgets/common_text.dart';
import '../../widgets/common_text_field.dart';
import 'widget/profile_bottom_button.dart';
import 'widget/profile_chip.dart';
import 'widget/profile_radio_option.dart';
import 'widget/profile_section_card.dart';

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
  final List<OnboardingData> medicalDiagnoses;
  final List<OnboardingData> familyMedicalHistory;
  final List<OnboardingData> recentClinicalSymptoms;
  final List<OnboardingData> allergiesIntolerances;
  final List<OnboardingData> hormonalLifeStage;

  const HealthSafetyIntakeScreen({
    super.key, required this.medicalDiagnoses, required this.familyMedicalHistory,
    required this.recentClinicalSymptoms, required this.allergiesIntolerances,
    required this.hormonalLifeStage
  });

  @override
  State<HealthSafetyIntakeScreen> createState() => _HealthSafetyIntakeScreenState();
}

class _HealthSafetyIntakeScreenState extends State<HealthSafetyIntakeScreen> {
  ChapterThreeModel? chapterThreeModel;

  // Medical Diagnoses
  final Set<String> _selectedDiagnoses = {};
  String? _diagnosesError;

  // Family History
  final Set<String> _selectedFamilyHistory = {};
  String? _familyHistoryError;

  // Medications
  bool _takingMedication = false;
  String? _medicationError;
  List<MedicationEntry> medications = [MedicationEntry()];

  // Movement & Limitations
  bool _hasLimitations = false;
  final TextEditingController _limitationsController = TextEditingController();
  String? _limitationsError;

  // Physician Restrictions
  bool _hasRestrictions = false;
  final TextEditingController _restrictionsController = TextEditingController();
  String? _restrictionsError;

  // Recent Clinical Symptoms
  final Set<String> _selectedSymptoms = {};
  String? _symptomsError;

  // Allergies
  String? _selectedAllergy;
  final TextEditingController _allergyDetailsController = TextEditingController();
  String? _allergyError;
  String? _allergyDetailsError;

  // Hormonal Stage
  String? _selectedHormonalStage;
  String? _hormonalStageError;

  @override
  void initState() {
    super.initState();
    callChapterThreeAPI();
  }

  void callChapterThreeAPI() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      LoaderService.show(context);
      BlocProvider.of<ChapterThreeBloc>(context).add(
        UserChapterThreeEvent(url: Urls.onboardingChapter(chapterId: "3")),
      );
    });
  }

  void _populateFromChapterThree(ChapterThreeModel model) {
    final answers = model.data?.answers;
    if (answers != null) {
      if (answers.medicalDiagnoses != null && answers.medicalDiagnoses!.isNotEmpty) {
        _selectedDiagnoses.clear();
        _selectedDiagnoses.addAll(answers.medicalDiagnoses!);
      }
      if (answers.familyMedicalHistory != null && answers.familyMedicalHistory!.isNotEmpty) {
        _selectedFamilyHistory.clear();
        _selectedFamilyHistory.addAll(answers.familyMedicalHistory!);
      }
      if (answers.takingMedications != null) {
        _takingMedication = answers.takingMedications!;
      }
      if (answers.medications != null && answers.medications!.isNotEmpty) {
        medications.clear();
        for (final med in answers.medications!) {
          final entry = MedicationEntry();
          entry.nameController.text = med.name ?? "";
          entry.doseController.text = med.dose ?? "";
          entry.freqController.text = med.frequency ?? "";
          entry.reasonController.text = med.reason ?? "";
          medications.add(entry);
        }
      }
      if (answers.hasMovementLimitations != null) {
        _hasLimitations = answers.hasMovementLimitations!;
      }
      final limitationDetail = answers.movementLimitationsDetail ?? answers.movementLimitationDetails;
      if (limitationDetail != null) {
        _limitationsController.text = limitationDetail;
      }
      if (answers.hasPhysicianRestrictions != null) {
        _hasRestrictions = answers.hasPhysicianRestrictions!;
      }
      if (answers.physicianGuidance != null) {
        _restrictionsController.text = answers.physicianGuidance!;
      }
      if (answers.recentClinicalSymptoms != null && answers.recentClinicalSymptoms!.isNotEmpty) {
        _selectedSymptoms.clear();
        _selectedSymptoms.addAll(answers.recentClinicalSymptoms!);
      }
      if (answers.allergiesIntolerances != null && answers.allergiesIntolerances!.isNotEmpty) {
        _selectedAllergy = answers.allergiesIntolerances;
      }
      if (answers.allergyDetails != null) {
        _allergyDetailsController.text = answers.allergyDetails!;
      }
      if (answers.hormonalLifeStage != null && answers.hormonalLifeStage!.isNotEmpty) {
        _selectedHormonalStage = answers.hormonalLifeStage;
      }
    }
  }

  Field? _getField(String key) {
    final fields = chapterThreeModel?.data?.fields ?? [];
    for (final f in fields) {
      if (f.key == key) return f;
    }
    return null;
  }

  bool _isNoKnownAllergy(String? valueOrUuid) {
    if (valueOrUuid == null) return false;
    final allergyField = _getField("allergies_intolerances");
    if (allergyField != null && allergyField.options.isNotEmpty) {
      for (final opt in allergyField.options) {
        if (opt.value == valueOrUuid) {
          return opt.label?.toLowerCase().contains("no known") ?? false;
        }
      }
    }
    for (final item in widget.allergiesIntolerances) {
      if (item.uuid == valueOrUuid) {
        return item.title?.toLowerCase().contains("no known") ?? false;
      }
    }
    return valueOrUuid.toLowerCase().contains("no known");
  }

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

    _medicationError = null;
    if (_takingMedication == true) {
      for (var med in medications) {
        if (med.nameController.text.trim().isEmpty) { med.nameError = "Required"; isValid = false; } else { med.nameError = null; }
        if (med.doseController.text.trim().isEmpty) { med.doseError = "Required"; isValid = false; } else { med.doseError = null; }
        if (med.freqController.text.trim().isEmpty) { med.freqError = "Required"; isValid = false; } else { med.freqError = null; }
        if (med.reasonController.text.trim().isEmpty) { med.reasonError = "Required"; isValid = false; } else { med.reasonError = null; }
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

    if (_selectedAllergy != null && !_isNoKnownAllergy(_selectedAllergy) && _allergyDetailsController.text.trim().isEmpty) {
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
      LoaderService.show(context);

      final List<Map<String, dynamic>> medicationPayload = [];
      if (_takingMedication) {
        for (var med in medications) {
          if (med.nameController.text.trim().isNotEmpty) {
            medicationPayload.add({
              "name": med.nameController.text.trim(),
              "dose": med.doseController.text.trim(),
              "frequency": med.freqController.text.trim(),
              "reason": med.reasonController.text.trim(),
            });
          }
        }
      }

      final String limitationDetail = _hasLimitations ? _limitationsController.text.trim() : "";

      BlocProvider.of<SaveChapterBloc>(context).add(
        UserSaveChapterEvent(
          url: Urls.onboardingChapter(chapterId: "3"),
          body: {
            "movement_limitations_detail": limitationDetail,
            "answers": {
              "medical_diagnoses": _selectedDiagnoses.toList(),
              "family_medical_history": _selectedFamilyHistory.toList(),
              "taking_medications": _takingMedication,
              "medications": medicationPayload,
              "has_movement_limitations": _hasLimitations,
              "movement_limitations_detail": limitationDetail,
              "movement_limitation_details": limitationDetail,
              "has_physician_restrictions": _hasRestrictions,
              "physician_guidance": _restrictionsController.text.trim(),
              "recent_clinical_symptoms": _selectedSymptoms.toList(),
              "allergies_intolerances": _selectedAllergy ?? "",
              "allergy_details": _allergyDetailsController.text.trim(),
              "hormonal_life_stage": _selectedHormonalStage ?? ""
            }
          },
        ),
      );
    }
  }


  @override
  void dispose() {
    for (var med in medications) {
      med.dispose();
    }
    _limitationsController.dispose();
    _restrictionsController.dispose();
    _allergyDetailsController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ChapterThreeBloc, ChapterThreeState>(
          listener: (context, state) {
            if (state is ChapterThreeSuccess) {
              LoaderService.hide();
              chapterThreeModel = state.model;
              _populateFromChapterThree(state.model);
              setState(() {});
            } else if (state is ChapterThreeFailed) {
              LoaderService.hide();
              showSnackBar(context: context, isError: true, message: state.message);
            }
          },
        ),
        BlocListener<SaveChapterBloc, SaveChapterState>(
          listener: (context, state) {
            if (state is SaveChapterSuccess) {
              LoaderService.hide();
              showSnackBar(context: context, isError: false, message: state.model.message ?? "");
              navigation.pop(context, value: true);
            } else if (state is SaveChapterFailed) {
              LoaderService.hide();
              showSnackBar(context: context, isError: true, message: state.message);
            }
          },
        ),
      ],
      child: Scaffold(
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
                "CHAPTER ${chapterThreeModel?.data?.chapter ?? 3} OF ${chapterThreeModel?.data?.total ?? 6}",
                style: TextStyle(
                  fontSize: 11,
                  color: appColors.primary,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.55,
                ),
              ),
              CommonText(
                chapterThreeModel?.data?.title ?? "Relevant Health & Safety",
                fontFamily: fontPlayfairDisplay,
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF1D1B1A),
                  fontWeight: FontWeight.w500,
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
            ProfileBottomButton(
              name: "Save & Continue to Food & Digestion",
              onTap: _onSaveAndContinue,
            )
          ],
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
                  boxShadow: value == false ? [BoxShadow(
                    color: appColors.black.withValues(alpha: 0.05),
                    blurRadius: 1, offset: const Offset(0, 1)
                  )] : null,
                ),
                child: CommonText("No",
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
                  boxShadow: value == true ? [BoxShadow(
                    color: appColors.black.withValues(alpha: 0.05),
                    blurRadius: 1, offset: const Offset(0, 1)
                  )] : null,
                ),
                child: CommonText("Yes",
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
    final diagnosesField = _getField("medical_diagnoses");
    final dynamicDiagnoses = diagnosesField?.options ?? [];
    final hasDynamicDiagnoses = dynamicDiagnoses.isNotEmpty;

    return ProfileSectionCard(
      title: "Medical Diagnoses",
      icon: appIcons.medicalDiagnoses,
      children: [
        buildRequiredLabel(diagnosesField?.label ?? "Have you been diagnosed with, or are you currently being evaluated for, any of the following?"),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 12,
          children: hasDynamicDiagnoses
              ? dynamicDiagnoses.map((e) => ProfileChip(
                  label: e.label ?? "",
                  isSelected: _selectedDiagnoses.contains(e.value),
                  onTap: () {
                    setState(() {
                      if (_selectedDiagnoses.contains(e.value)) {
                        _selectedDiagnoses.remove(e.value);
                      } else {
                        if (e.value != null) _selectedDiagnoses.add(e.value!);
                      }
                      if (_diagnosesError != null) _validate();
                    });
                  },
                )).toList()
              : widget.medicalDiagnoses.map((e) => ProfileChip(
                  label: e.title ?? "",
                  isSelected: _selectedDiagnoses.contains(e.uuid),
                  onTap: () {
                    setState(() {
                      if (_selectedDiagnoses.contains(e.uuid)) {
                        _selectedDiagnoses.remove(e.uuid);
                      } else {
                        _selectedDiagnoses.add(e.uuid ?? "0");
                      }
                      if (_diagnosesError != null) _validate();
                    });
                  },
                )).toList(),
        ),
        if (_diagnosesError != null) Padding(
          padding: const EdgeInsets.only(top: 8),
          child: CommonText(_diagnosesError!, style: TextStyle(
            color: appColors.red, fontSize: 12
          ))
        ),
      ],
    );
  }

  Widget _buildFamilyHistorySection() {
    final familyField = _getField("family_medical_history");
    final dynamicFamily = familyField?.options ?? [];
    final hasDynamicFamily = dynamicFamily.isNotEmpty;

    return ProfileSectionCard(
      title: "Family Medical History",
      icon: appIcons.familyMedicalHistory,
      children: [
        buildRequiredLabel(familyField?.label ?? "Does your immediate family have a history of any of the following?"),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 12,
          children: hasDynamicFamily
              ? dynamicFamily.map((e) => ProfileChip(
                  label: e.label ?? "",
                  isSelected: _selectedFamilyHistory.contains(e.value),
                  onTap: () {
                    setState(() {
                      if (_selectedFamilyHistory.contains(e.value)) {
                        _selectedFamilyHistory.remove(e.value);
                      } else {
                        if (e.value != null) _selectedFamilyHistory.add(e.value!);
                      }
                      if (_familyHistoryError != null) _validate();
                    });
                  },
                )).toList()
              : widget.familyMedicalHistory.map((e) => ProfileChip(
                  label: e.title ?? "",
                  isSelected: _selectedFamilyHistory.contains(e.uuid),
                  onTap: () {
                    setState(() {
                      if (_selectedFamilyHistory.contains(e.uuid)) {
                        _selectedFamilyHistory.remove(e.uuid);
                      } else {
                        _selectedFamilyHistory.add(e.uuid ?? "0");
                      }
                      if (_familyHistoryError != null) _validate();
                    });
                  },
                )).toList(),
        ),
        if (_familyHistoryError != null) Padding(
          padding: const EdgeInsets.only(top: 8),
          child: CommonText(_familyHistoryError!, style: TextStyle(
            color: appColors.red, fontSize: 12
          ))
        ),
      ],
    );
  }

  Widget _buildMedicationsSection() {
    return ProfileSectionCard(
      title: "Medications & Supplements",
      icon: appIcons.medication,
      children: [
        buildRequiredLabel("Are you currently taking any prescribed medicine or regular supplement?"),
        const SizedBox(height: 12),
        _buildSegmentedControl(_takingMedication, (v) {
          setState(() {
            _takingMedication = v;
            if (_medicationError != null) _validate();
          });
        }),
        if (_medicationError != null) Padding(
          padding: const EdgeInsets.only(top: 8),
          child: CommonText(_medicationError!,
            style: TextStyle(color: appColors.red, fontSize: 12)
          ),
        ),
        if (_takingMedication == true) ...[
          const SizedBox(height: 16),
          ...List.generate(medications.length, (index) {
            final med = medications[index];
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
                      if (medications.length > 1) GestureDetector(
                        onTap: () {
                          setState(() {
                            medications[index].dispose();
                            medications.removeAt(index);
                          });
                        },
                        child: Icon(Icons.close_rounded, size: 16, color: appColors.neutral),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  CommonTextField(
                    isRequired: false,
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
                          isRequired: false,
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
                          isRequired: false,
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
                    isRequired: false,
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
                medications.add(MedicationEntry());
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
                  const SizedBox(width: 4),
                  CommonText(
                    "Add another medication/supplement",
                    style: TextStyle(fontSize: 12, color: appColors.primary, fontWeight: FontWeight.w600),
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
    return ProfileSectionCard(
      title: "Movement & Limitations",
      icon: appIcons.movement,
      children: [
        buildRequiredLabel("Do you currently have any injury, pain, past surgery or physical limitation that may affect walking, exercise or daily movement?"),
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
          if (_limitationsError != null) Padding(
            padding: const EdgeInsets.only(top: 4),
            child: CommonText(_limitationsError!, style: TextStyle(
              color: appColors.red, fontSize: 12)
            )
          ),
        ],
      ],
    );
  }

  Widget _buildRestrictionsSection() {
    return ProfileSectionCard(
      title: "Physician Restrictions",
      icon: appIcons.note,
      children: [
        buildRequiredLabel("Has a doctor asked you to avoid or limit any food, exercise or lifestyle practice?"),
        const SizedBox(height: 12),
        _buildSegmentedControl(_hasRestrictions, (v) => setState(() => _hasRestrictions = v)),
        if (_hasRestrictions == true) ...[
          const SizedBox(height: 16),
          CommonText("Specific medical guidance",
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: const Color(0xFF534343))
          ),
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
              style: TextStyle(
                fontSize: 14, color: const Color(0xFF1D1B1A), fontFamily: fontFamilyPlusJakartaSans
              ),
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
          if (_restrictionsError != null) Padding(
            padding: const EdgeInsets.only(top: 4),
            child: CommonText(_restrictionsError!, style: TextStyle(
              color: appColors.red, fontSize: 12)
            )
          ),
        ],
      ],
    );
  }

  Widget _buildSymptomsSection() {
    final symptomsField = _getField("recent_clinical_symptoms");
    final dynamicSymptoms = symptomsField?.options ?? [];
    final hasDynamicSymptoms = dynamicSymptoms.isNotEmpty;

    return ProfileSectionCard(
      title: "Recent Clinical Symptoms",
      icon: appIcons.notificationRecent,
      children: [
        buildRequiredLabel(symptomsField?.label ?? "In the past six months, have you experienced any of the following?"),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 12,
          children: hasDynamicSymptoms
              ? dynamicSymptoms.map((e) => ProfileChip(
                  label: e.label ?? "",
                  isSelected: _selectedSymptoms.contains(e.value),
                  onTap: () {
                    setState(() {
                      if (_selectedSymptoms.contains(e.value)) {
                        _selectedSymptoms.remove(e.value);
                      } else {
                        if (e.value != null) _selectedSymptoms.add(e.value!);
                      }
                      if (_symptomsError != null) _validate();
                    });
                  },
                )).toList()
              : widget.recentClinicalSymptoms.map((e) => ProfileChip(
                  label: e.title ?? "",
                  isSelected: _selectedSymptoms.contains(e.uuid),
                  onTap: () {
                    setState(() {
                      if (_selectedSymptoms.contains(e.uuid)) {
                        _selectedSymptoms.remove(e.uuid);
                      } else {
                        _selectedSymptoms.add(e.uuid ?? "0");
                      }
                      if (_symptomsError != null) _validate();
                    });
                  },
                )).toList(),
        ),
        if (_symptomsError != null) Padding(
          padding: const EdgeInsets.only(top: 8),
          child: CommonText(_symptomsError!, style: TextStyle(
            color: appColors.red, fontSize: 12)
          )
        ),
      ],
    );
  }

  Widget _buildAllergiesSection() {
    final allergiesField = _getField("allergies_intolerances");
    final dynamicAllergies = allergiesField?.options ?? [];
    final hasDynamicAllergies = dynamicAllergies.isNotEmpty;

    final detailsField = _getField("allergy_details");

    return ProfileSectionCard(
      title: "Allergies & Intolerances",
      icon: appIcons.allergies,
      children: [
        buildRequiredLabel(allergiesField?.label ?? "Do you have any food allergy or food intolerance?"),
        const SizedBox(height: 12),
        if (hasDynamicAllergies)
          ...dynamicAllergies.map((e) => ProfileRadioOption(
            label: e.label ?? "",
            isSelected: _selectedAllergy == e.value,
            onTap: () {
              setState(() {
                _selectedAllergy = e.value;
                if (_allergyError != null || _allergyDetailsError != null) _validate();
              });
            },
          ))
        else
          ...widget.allergiesIntolerances.map((e) => ProfileRadioOption(
            label: e.title ?? "",
            isSelected: _selectedAllergy == e.uuid,
            onTap: () {
              setState(() {
                _selectedAllergy = e.uuid;
                if (_allergyError != null || _allergyDetailsError != null) _validate();
              });
            },
          )),
        if (_allergyError != null) Padding(
          padding: const EdgeInsets.only(top: 8),
          child: CommonText(_allergyError!,
            style: TextStyle(color: appColors.red, fontSize: 12)
          )
        ),
        if (_selectedAllergy != null && !_isNoKnownAllergy(_selectedAllergy)) ...[
          const SizedBox(height: 16),
          CommonText(detailsField?.label ?? "Specify foods & observed symptoms",
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: const Color(0xFF534343))
          ),
          const SizedBox(height: 6),
          CommonTextField(
            label: "",
            controller: _allergyDetailsController,
            maxLines: null,
            minLines: 3,
            borderColor: appColors.textFieldBgColor,
            hint: "e.g. Cow's milk causes bloating and mild skin flare-ups; peanuts provoke localized hives.",
            onChanged: (v) {
              if (_allergyDetailsError != null) _validate();
            },
          ),
          if (_allergyDetailsError != null) Padding(
            padding: const EdgeInsets.only(top: 4),
            child: CommonText(_allergyDetailsError!, style: TextStyle(
              color: appColors.red, fontSize: 12)
            )
          ),
        ],
      ],
    );
  }

  Widget _buildHormonalStageSection() {
    final hormonalField = _getField("hormonal_life_stage");
    final dynamicHormonal = hormonalField?.options ?? [];
    final hasDynamicHormonal = dynamicHormonal.isNotEmpty;

    return ProfileSectionCard(
      title: "Hormonal & Life Stage",
      icon: appIcons.lotas, // or pregnant_woman depending on user
      children: [
        buildRequiredLabel(hormonalField?.label ?? "Which reproductive or hormonal life stage best describes you currently?"),
        const SizedBox(height: 12),
        if (hasDynamicHormonal)
          ...dynamicHormonal.map((e) => ProfileRadioOption(
            label: e.label ?? "",
            isSelected: _selectedHormonalStage == e.value,
            onTap: () {
              setState(() {
                _selectedHormonalStage = e.value;
                if (_hormonalStageError != null) _validate();
              });
            },
          ))
        else
          ...widget.hormonalLifeStage.map((e) => ProfileRadioOption(
            label: e.title ?? "",
            isSelected: _selectedHormonalStage == e.uuid,
            onTap: () {
              setState(() {
                _selectedHormonalStage = e.uuid;
                if (_hormonalStageError != null) _validate();
              });
            },
          )),
        if (_hormonalStageError != null) Padding(
          padding: const EdgeInsets.only(top: 8),
          child: CommonText(_hormonalStageError!, style: TextStyle(
            color: appColors.red, fontSize: 12)
          )
        ),
      ],
    );
  }
}
