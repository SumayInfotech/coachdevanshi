import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../main.dart';
import '../../../core/blocs/coach/gut_reset/gut_reset_bloc.dart';
import '../../../core/blocs/coach/gut_reset/gut_reset_event.dart';
import '../../../core/blocs/coach/gut_reset/gut_reset_state.dart';
import '../../../core/blocs/coach/save_protocol_form/save_protocol_form_bloc.dart';
import '../../../core/blocs/coach/save_protocol_form/save_protocol_form_event.dart';
import '../../../core/blocs/coach/save_protocol_form/save_protocol_form_state.dart';
import '../../../core/constants/urls.dart';
import '../../../core/constants/utils.dart';
import '../../../core/models/coach/gut_reset_model.dart';
import '../../../core/services/loader_service.dart';
import '../../widgets/common_app_bar.dart';
import '../../widgets/common_button.dart';
import '../../widgets/common_text.dart';
import '../../widgets/common_text_field.dart';
import '../profile/widget/profile_section_card.dart';

class GutResetProtocolScreen extends StatefulWidget {
  final String pathwayUuid;

  const GutResetProtocolScreen({
    super.key,
    this.pathwayUuid = "",
  });

  @override
  State<GutResetProtocolScreen> createState() => _GutResetProtocolScreenState();
}

class _GutResetProtocolScreenState extends State<GutResetProtocolScreen> {
  GutResetData? _protocolData;
  List<GutResetFormField> _fields = [];

  // 1. Primary Digestive Symptoms
  final Set<String> _selectedDigestiveSymptoms = {};
  String? _symptomsError;

  // 2. Onset & Frequency
  String? _selectedDuration;
  String? _onsetDurationError;

  String? _selectedFrequency;
  String? _occurrenceFrequencyError;

  // 3. Symptom Peak Timing
  final Set<String> _selectedPeakTiming = {};
  String? _peakTimingError;

  // 4. Bowel Cadence & Transit
  String? _bowelCadence;
  String? _bowelCadenceError;

  String? _evacuationCompleteness;
  String? _evacuationError;

  String? _stimulantReliance;
  String? _stimulantError;

  // 5. Trigger Foods & Situations
  final Set<String> _selectedTriggerFoods = {};
  final TextEditingController _otherTriggersController = TextEditingController();
  String? _triggerFoodsError;

  // 6. Prior Diagnosis, Tests or Care
  bool? _hasPriorDiagnosis;
  final TextEditingController _clinicalHistoryController = TextEditingController();
  String? _priorDiagnosisError;
  String? _clinicalHistoryError;

  // 7. Priority Relief Focus
  final TextEditingController _priorityReliefController = TextEditingController();

  // Fallback defaults in case offline/initial
  final List<GutResetOption> _defaultDigestiveSymptoms = [
    GutResetOption(value: "bloating_after_meals", label: "Bloating after meals"),
    GutResetOption(value: "bloating_all_day", label: "Bloating all day"),
    GutResetOption(value: "gas_flatulence", label: "Gas & flatulence"),
    GutResetOption(value: "frequent_burping", label: "Frequent burping"),
    GutResetOption(value: "acidity_reflux", label: "Acidity or reflux"),
    GutResetOption(value: "constipation", label: "Constipation"),
    GutResetOption(value: "loose_stools", label: "Loose stools"),
    GutResetOption(value: "alternating_pattern", label: "Alternating pattern"),
    GutResetOption(value: "abdominal_pain", label: "Abdominal pain"),
    GutResetOption(value: "nausea", label: "Nausea"),
    GutResetOption(value: "early_fullness", label: "Early fullness"),
    GutResetOption(value: "none", label: "None of these"),
  ];

  final List<GutResetOption> _defaultDurationOptions = [
    GutResetOption(value: "lt_3_months", label: "< 3 months"),
    GutResetOption(value: "3_6_months", label: "3 to 6 months"),
    GutResetOption(value: "6_12_months", label: "6 to 12 months"),
    GutResetOption(value: "1_plus_years", label: "1+ years"),
    GutResetOption(value: "5_plus_years", label: "5+ years / Chronic"),
  ];

  final List<GutResetOption> _defaultFrequencyOptions = [
    GutResetOption(value: "daily", label: "Daily / Constant"),
    GutResetOption(value: "multiple_weekly", label: "Multiple times / week"),
    GutResetOption(value: "weekly", label: "Weekly"),
    GutResetOption(value: "periodic", label: "Periodic flare-ups"),
  ];

  final List<GutResetOption> _defaultPeakTimingOptions = [
    GutResetOption(value: "immediately_after_eating", label: "Immediately after eating"),
    GutResetOption(value: "within_1_2_hours", label: "Within 1-2 hours"),
    GutResetOption(value: "by_evening", label: "By evening"),
    GutResetOption(value: "during_night", label: "During the night"),
    GutResetOption(value: "all_day", label: "All day uniformly"),
    GutResetOption(value: "stressful_periods", label: "During stressful periods"),
    GutResetOption(value: "menstrual_cycle", label: "Around menstrual cycle"),
    GutResetOption(value: "no_clear_pattern", label: "No clear pattern"),
  ];

  final List<GutResetOption> _defaultBowelCadenceOptions = [
    GutResetOption(value: "1_2_per_day", label: "1-2 times per day"),
    GutResetOption(value: "every_2_3_days", label: "Every 2-3 days"),
    GutResetOption(value: "3_plus_per_day", label: "3+ times per day"),
    GutResetOption(value: "irregular", label: "Irregular / Variable"),
  ];

  final List<GutResetOption> _defaultEvacuationOptions = [
    GutResetOption(value: "always", label: "Always"),
    GutResetOption(value: "sometimes", label: "Sometimes"),
    GutResetOption(value: "rarely", label: "Rarely"),
  ];

  final List<GutResetOption> _defaultStimulantOptions = [
    GutResetOption(value: "yes", label: "Yes - morning warm tea/coffee is essential"),
    GutResetOption(value: "no", label: "No - spontaneous morning rhythm without hot liquids"),
  ];

  final List<GutResetOption> _defaultTriggerOptions = [
    GutResetOption(value: "milk", label: "Milk"),
    GutResetOption(value: "curd_yoghurt", label: "Curd or yoghurt"),
    GutResetOption(value: "paneer", label: "Paneer"),
    GutResetOption(value: "wheat", label: "Wheat"),
    GutResetOption(value: "onion_garlic", label: "Onion or garlic"),
    GutResetOption(value: "beans_legumes", label: "Beans or legumes"),
    GutResetOption(value: "fried_food", label: "Fried food"),
    GutResetOption(value: "sweets", label: "Sweets"),
    GutResetOption(value: "coffee", label: "Coffee"),
    GutResetOption(value: "restaurant_meals", label: "Restaurant meals"),
    GutResetOption(value: "large_meals", label: "Large meals"),
    GutResetOption(value: "emotional_stress", label: "Emotional stress"),
    GutResetOption(value: "not_sure", label: "Not sure yet"),
    GutResetOption(value: "other", label: "Other"),
  ];

  @override
  void initState() {
    super.initState();
    callGetProtocolFormAPI();
  }

  void callGetProtocolFormAPI() {
    if (widget.pathwayUuid.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        LoaderService.show(context);
        BlocProvider.of<GutResetBloc>(context).add(
          UserGetGutResetEvent(
            url: Urls.pathwaysProtocol(pathwayUuid: widget.pathwayUuid),
          ),
        );
      });
    }
  }

  void _populateAnswers(GutResetAnswers? answers) {
    if (answers == null) return;

    if (answers.primarySymptoms != null && answers.primarySymptoms!.isNotEmpty) {
      _selectedDigestiveSymptoms.clear();
      _selectedDigestiveSymptoms.addAll(answers.primarySymptoms!);
    }

    if (answers.symptomOnset != null && answers.symptomOnset!.isNotEmpty) {
      _selectedDuration = answers.symptomOnset;
    }

    if (answers.occurrenceFrequency != null && answers.occurrenceFrequency!.isNotEmpty) {
      _selectedFrequency = answers.occurrenceFrequency;
    }

    if (answers.symptomPeakTiming != null && answers.symptomPeakTiming!.isNotEmpty) {
      _selectedPeakTiming.clear();
      _selectedPeakTiming.addAll(answers.symptomPeakTiming!);
    }

    if (answers.bowelCadence != null && answers.bowelCadence!.isNotEmpty) {
      _bowelCadence = answers.bowelCadence;
    }

    if (answers.feelFullyEmptied != null && answers.feelFullyEmptied!.isNotEmpty) {
      _evacuationCompleteness = answers.feelFullyEmptied;
    }

    if (answers.needsStimulant != null && answers.needsStimulant!.isNotEmpty) {
      _stimulantReliance = answers.needsStimulant;
    }

    if (answers.triggerFoods != null && answers.triggerFoods!.isNotEmpty) {
      _selectedTriggerFoods.clear();
      _selectedTriggerFoods.addAll(answers.triggerFoods!);
    }

    if (answers.otherTriggers != null && answers.otherTriggers!.isNotEmpty) {
      _otherTriggersController.text = answers.otherTriggers!;
    }

    if (answers.priorDiagnosis != null) {
      _hasPriorDiagnosis = answers.priorDiagnosis;
    }

    if (answers.clinicalHistory != null && answers.clinicalHistory!.isNotEmpty) {
      _clinicalHistoryController.text = answers.clinicalHistory!;
    }

    if (answers.priorityReliefFocus != null && answers.priorityReliefFocus!.isNotEmpty) {
      _priorityReliefController.text = answers.priorityReliefFocus!;
    }
  }

  GutResetFormField? _getField(String key) {
    try {
      return _fields.firstWhere((f) => f.key == key);
    } catch (_) {
      return null;
    }
  }

  bool _validate() {
    bool isValid = true;

    final symptomsField = _getField("primary_symptoms");
    if ((symptomsField?.required ?? true) && _selectedDigestiveSymptoms.isEmpty) {
      _symptomsError = "Please select at least 1 symptom";
      isValid = false;
    } else {
      _symptomsError = null;
    }

    final onsetField = _getField("symptom_onset");
    if ((onsetField?.required ?? true) && _selectedDuration == null) {
      _onsetDurationError = "Please select onset duration";
      isValid = false;
    } else {
      _onsetDurationError = null;
    }

    final freqField = _getField("occurrence_frequency");
    if ((freqField?.required ?? true) && _selectedFrequency == null) {
      _occurrenceFrequencyError = "Please select occurrence frequency";
      isValid = false;
    } else {
      _occurrenceFrequencyError = null;
    }

    final peakField = _getField("symptom_peak_timing");
    if ((peakField?.required ?? true) && _selectedPeakTiming.isEmpty) {
      _peakTimingError = "Please select symptom peak timing";
      isValid = false;
    } else {
      _peakTimingError = null;
    }

    final cadenceField = _getField("bowel_cadence");
    if ((cadenceField?.required ?? true) && _bowelCadence == null) {
      _bowelCadenceError = "Please select bowel cadence";
      isValid = false;
    } else {
      _bowelCadenceError = null;
    }

    final emptyField = _getField("feel_fully_emptied");
    if ((emptyField?.required ?? true) && _evacuationCompleteness == null) {
      _evacuationError = "Please select evacuation completeness";
      isValid = false;
    } else {
      _evacuationError = null;
    }

    final stimulantField = _getField("needs_stimulant");
    if ((stimulantField?.required ?? true) && _stimulantReliance == null) {
      _stimulantError = "Please select stimulant reliance";
      isValid = false;
    } else {
      _stimulantError = null;
    }

    final triggerField = _getField("trigger_foods");
    if ((triggerField?.required ?? true) && _selectedTriggerFoods.isEmpty) {
      _triggerFoodsError = "Please select at least 1 trigger food/situation";
      isValid = false;
    } else {
      _triggerFoodsError = null;
    }

    final diagField = _getField("prior_diagnosis");
    if ((diagField?.required ?? true) && _hasPriorDiagnosis == null) {
      _priorDiagnosisError = "Please answer prior diagnosis";
      isValid = false;
    } else {
      _priorDiagnosisError = null;
    }

    final historyField = _getField("clinical_history");
    bool historyRequired = historyField?.required ?? false;
    if (historyField?.requiredIf != null &&
        historyField!.requiredIf!.field == "prior_diagnosis" &&
        historyField.requiredIf!.value == true &&
        _hasPriorDiagnosis == true) {
      historyRequired = true;
    }
    if (historyRequired && _clinicalHistoryController.text.trim().isEmpty) {
      _clinicalHistoryError = "Please provide clinical history & test findings";
      isValid = false;
    } else {
      _clinicalHistoryError = null;
    }

    setState(() {});
    return isValid;
  }

  String? _getOptionValue(String? selected, List<GutResetOption> options) {
    if (selected == null) return null;
    final found = options.firstWhere(
      (o) => o.value == selected || o.label == selected,
      orElse: () => GutResetOption(value: selected),
    );
    return found.value ?? selected;
  }

  List<String> _getOptionValues(Set<String> selectedSet, List<GutResetOption> options) {
    return selectedSet.map((item) {
      final found = options.firstWhere(
        (o) => o.value == item || o.label == item,
        orElse: () => GutResetOption(value: item),
      );
      return found.value ?? item;
    }).toList();
  }

  void _onSave() {
    if (!_validate()) {
      showSnackBar(context: context, isError: true, message: 'Please complete all required fields.');
      return;
    }

    if (widget.pathwayUuid.isEmpty) {
      showSnackBar(context: context, isError: true, message: 'Pathway ID is missing.');
      return;
    }

    final symptomsField = _getField("primary_symptoms");
    final onsetField = _getField("symptom_onset");
    final freqField = _getField("occurrence_frequency");
    final peakField = _getField("symptom_peak_timing");
    final cadenceField = _getField("bowel_cadence");
    final emptyField = _getField("feel_fully_emptied");
    final stimulantField = _getField("needs_stimulant");
    final triggerField = _getField("trigger_foods");

    final GutResetAnswers answers = GutResetAnswers(
      primarySymptoms: _getOptionValues(_selectedDigestiveSymptoms, symptomsField?.options ?? _defaultDigestiveSymptoms),
      symptomOnset: _getOptionValue(_selectedDuration, onsetField?.options ?? _defaultDurationOptions),
      occurrenceFrequency: _getOptionValue(_selectedFrequency, freqField?.options ?? _defaultFrequencyOptions),
      symptomPeakTiming: _getOptionValues(_selectedPeakTiming, peakField?.options ?? _defaultPeakTimingOptions),
      bowelCadence: _getOptionValue(_bowelCadence, cadenceField?.options ?? _defaultBowelCadenceOptions),
      feelFullyEmptied: _getOptionValue(_evacuationCompleteness, emptyField?.options ?? _defaultEvacuationOptions),
      needsStimulant: _getOptionValue(_stimulantReliance, stimulantField?.options ?? _defaultStimulantOptions),
      triggerFoods: _getOptionValues(_selectedTriggerFoods, triggerField?.options ?? _defaultTriggerOptions),
      otherTriggers: _otherTriggersController.text.trim().isNotEmpty ? _otherTriggersController.text.trim() : null,
      priorDiagnosis: _hasPriorDiagnosis ?? false,
      clinicalHistory: _clinicalHistoryController.text.trim().isNotEmpty ? _clinicalHistoryController.text.trim() : null,
      priorityReliefFocus: _priorityReliefController.text.trim().isNotEmpty ? _priorityReliefController.text.trim() : null,
    );

    final Map<String, dynamic> body = {
      "answers": answers.toJson(),
    };

    LoaderService.show(context);
    BlocProvider.of<SaveProtocolFormBloc>(context).add(
      UserSaveProtocolFormEvent(
        url: Urls.pathwaysProtocol(pathwayUuid: widget.pathwayUuid),
        body: body,
      ),
    );
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
    return MultiBlocListener(
      listeners: [
        BlocListener<GutResetBloc, GutResetState>(
          listener: (context, state) {
            if (state is GutResetSuccess) {
              LoaderService.hide();
              _protocolData = state.model.data;
              _fields = state.model.data?.fields ?? [];
              _populateAnswers(state.model.data?.answers);
              setState(() {});
            } else if (state is GutResetFailed) {
              LoaderService.hide();
              showSnackBar(context: context, isError: true, message: state.message);
            }
          },
        ),
        BlocListener<SaveProtocolFormBloc, SaveProtocolFormState>(
          listener: (context, state) {
            if (state is SaveProtocolFormSuccess) {
              LoaderService.hide();
              showSnackBar(
                context: context,
                isError: false,
                message: state.model.message ?? 'Gut Reset Protocol Submitted!',
              );
              navigation.pop(context);
            } else if (state is SaveProtocolFormFailed) {
              LoaderService.hide();
              showSnackBar(context: context, isError: true, message: state.message);
            }
          },
        ),
      ],
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          LoaderService.hide();
          navigation.pop(context);
        },
        child: Scaffold(
          backgroundColor: appColors.bgColor,
          appBar: CommonAppBar(
            appBarColor: appColors.bgColor.withValues(alpha: 0.85),
            centerTitle: true,
            leading: buildInkWell(
              onTap: () {
                LoaderService.hide();
                navigation.pop(context);
              },
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
              _protocolData?.title ?? "Gut Reset Protocol",
              fontFamily: fontPlayfairDisplay,
              style: const TextStyle(
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
        ),
      ),
    );
  }

  Widget _buildPrimarySymptomsSection() {
    final field = _getField("primary_symptoms");
    final label = field?.label ?? "Which digestive symptoms are affecting you most?";
    final max = field?.max ?? 4;
    final options = field?.options ?? _defaultDigestiveSymptoms;

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
                  buildRequiredLabel("$label (Select up to $max)", color: const Color(0xFF534343)),
                  const SizedBox(height: 4),
                  const CommonText(
                    "Mindful self-observation",
                    style: TextStyle(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      color: Color(0xFF576245),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
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
              child: CommonText(
                "Selected: ${_selectedDigestiveSymptoms.length}/$max",
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF8B484D),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((option) {
            final val = option.value ?? option.label ?? "";
            final isSelected = _selectedDigestiveSymptoms.contains(option.value) || _selectedDigestiveSymptoms.contains(option.label);
            final isNone = (option.value?.toLowerCase() == 'none') || (option.label?.toLowerCase() == 'none of these');
            double chipWidth = (MediaQuery.of(context).size.width - 40 - 40 - 8) / 2;
            return SizedBox(
              width: chipWidth,
              child: _buildCheckPill(option.label ?? option.value ?? "", isSelected, () {
                setState(() {
                  if (isSelected) {
                    _selectedDigestiveSymptoms.remove(option.value);
                    _selectedDigestiveSymptoms.remove(option.label);
                  } else {
                    if (isNone) {
                      _selectedDigestiveSymptoms.clear();
                      _selectedDigestiveSymptoms.add(val);
                    } else {
                      _selectedDigestiveSymptoms.remove('none');
                      _selectedDigestiveSymptoms.remove('None of these');
                      if (_selectedDigestiveSymptoms.length < max) {
                        _selectedDigestiveSymptoms.add(val);
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
    final onsetField = _getField("symptom_onset");
    final onsetLabel = onsetField?.label ?? "Symptom chronic / onset duration";
    final onsetOptions = onsetField?.options ?? _defaultDurationOptions;

    final freqField = _getField("occurrence_frequency");
    final freqLabel = freqField?.label ?? "Occurrence frequency";
    final freqOptions = freqField?.options ?? _defaultFrequencyOptions;

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
            CommonText(onsetLabel, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1D1B1A))),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: onsetOptions.map((item) {
            final isSelected = _selectedDuration == item.value || _selectedDuration == item.label;
            return _buildSimplePill(
              item.label ?? item.value ?? "",
              isSelected,
              () => setState(() {
                _selectedDuration = item.value ?? item.label;
                if (_onsetDurationError != null) _validate();
              }),
            );
          }).toList(),
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
            CommonText(freqLabel, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1D1B1A))),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: freqOptions.map((item) {
            final isSelected = _selectedFrequency == item.value || _selectedFrequency == item.label;
            double cardWidth = (MediaQuery.of(context).size.width - 40 - 40 - 8) / 2;
            return SizedBox(
              width: cardWidth,
              child: _buildOptionCard(
                item.label ?? item.value ?? "",
                isSelected,
                () => _onFreqSelected(item.value ?? item.label ?? ""),
              ),
            );
          }).toList(),
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
    final field = _getField("symptom_peak_timing");
    final label = field?.label ?? "When are symptoms usually strongest throughout the circadian cycle?";
    final options = field?.options ?? _defaultPeakTimingOptions;

    return ProfileSectionCard(
      title: "Symptom Peak Timing",
      icon: appIcons.clockFill,
      children: [
        buildRequiredLabel(label, color: const Color(0xFF534343)),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((item) {
            final isSelected = _selectedPeakTiming.contains(item.value) || _selectedPeakTiming.contains(item.label);
            final val = item.value ?? item.label ?? "";
            return _buildSimplePill(
              item.label ?? item.value ?? "",
              isSelected,
              () {
                setState(() {
                  if (isSelected) {
                    _selectedPeakTiming.remove(item.value);
                    _selectedPeakTiming.remove(item.label);
                  } else {
                    _selectedPeakTiming.add(val);
                  }
                  if (_peakTimingError != null) _validate();
                });
              },
            );
          }).toList(),
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
    final cadenceField = _getField("bowel_cadence");
    final cadenceLabel = cadenceField?.label ?? "Bowel movements cadence";
    final cadenceOptions = cadenceField?.options ?? _defaultBowelCadenceOptions;

    final emptyField = _getField("feel_fully_emptied");
    final emptyLabel = emptyField?.label ?? "Usually feel fully emptied?";
    final emptyOptions = emptyField?.options ?? _defaultEvacuationOptions;

    final stimulantField = _getField("needs_stimulant");
    final stimulantLabel = stimulantField?.label ?? "Need coffee, tea or stimulant to initiate transit?";
    final stimulantOptions = stimulantField?.options ?? _defaultStimulantOptions;

    return ProfileSectionCard(
      title: "Bowel Cadence & Transit",
      icon: appIcons.bowelCadence,
      children: [
        buildRequiredLabel(cadenceLabel, color: const Color(0xFF1D1B1A)),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: cadenceOptions.map((item) {
            final isSelected = _bowelCadence == item.value || _bowelCadence == item.label;
            double cardWidth = (MediaQuery.of(context).size.width - 40 - 40 - 8) / 2;
            return SizedBox(
              width: cardWidth,
              child: _buildOptionCard(
                item.label ?? item.value ?? "",
                isSelected,
                () => _onCadenceSelected(item.value ?? item.label ?? ""),
              ),
            );
          }).toList(),
        ),
        if (_bowelCadenceError != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: CommonText(_bowelCadenceError!, style: TextStyle(color: appColors.red, fontSize: 12)),
          ),
        const SizedBox(height: 16),
        buildRequiredLabel(emptyLabel, color: const Color(0xFF1D1B1A)),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: emptyOptions.map((item) {
            final isSelected = _evacuationCompleteness == item.value || _evacuationCompleteness == item.label;
            int count = emptyOptions.length;
            double cardWidth = count <= 3
                ? (MediaQuery.of(context).size.width - 40 - 40 - (8 * (count - 1))) / count
                : (MediaQuery.of(context).size.width - 40 - 40 - 8) / 2;
            return SizedBox(
              width: cardWidth,
              child: _buildOptionCard(
                item.label ?? item.value ?? "",
                isSelected,
                () => setState(() {
                  _evacuationCompleteness = item.value ?? item.label;
                  if (_evacuationError != null) _validate();
                }),
              ),
            );
          }).toList(),
        ),
        if (_evacuationError != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: CommonText(_evacuationError!, style: TextStyle(color: appColors.red, fontSize: 12)),
          ),
        const SizedBox(height: 16),
        buildRequiredLabel(stimulantLabel, color: const Color(0xFF1D1B1A)),
        const SizedBox(height: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: stimulantOptions.map((item) {
            final isSelected = _stimulantReliance == item.value || _stimulantReliance == item.label;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: _buildOptionCard(
                item.label ?? item.value ?? "",
                isSelected,
                () => setState(() {
                  _stimulantReliance = item.value ?? item.label;
                  if (_stimulantError != null) _validate();
                }),
              ),
            );
          }).toList(),
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
    final field = _getField("trigger_foods");
    final label = field?.label ?? "Which foods or situations seem to worsen your symptoms?";
    final options = field?.options ?? _defaultTriggerOptions;

    final otherField = _getField("other_triggers");
    final otherLabel = otherField?.label ?? "Other specific food or sensory triggers (optional)";

    final dairyGrainsValues = {'milk', 'curd_yoghurt', 'paneer', 'wheat'};
    final alliumsLegumesValues = {'onion_garlic', 'beans_legumes'};
    final prepDiningValues = {'fried_food', 'sweets', 'coffee', 'restaurant_meals', 'large_meals'};
    final systemicMindGutValues = {'emotional_stress', 'not_sure', 'other'};

    final dairyGrains = options.where((o) => dairyGrainsValues.contains(o.value?.toLowerCase())).toList();
    final alliumsLegumes = options.where((o) => alliumsLegumesValues.contains(o.value?.toLowerCase())).toList();
    final prepDining = options.where((o) => prepDiningValues.contains(o.value?.toLowerCase())).toList();
    final systemicMindGut = options.where((o) => systemicMindGutValues.contains(o.value?.toLowerCase())).toList();
    final otherOptions = options.where((o) =>
      !dairyGrainsValues.contains(o.value?.toLowerCase()) &&
      !alliumsLegumesValues.contains(o.value?.toLowerCase()) &&
      !prepDiningValues.contains(o.value?.toLowerCase()) &&
      !systemicMindGutValues.contains(o.value?.toLowerCase())
    ).toList();

    return ProfileSectionCard(
      title: "Trigger Foods & Situations",
      icon: appIcons.spoon,
      children: [
        buildRequiredLabel(label, color: const Color(0xFF534343)),
        const SizedBox(height: 16),
        if (dairyGrains.isNotEmpty) ...[
          _buildTriggerCategory("Dairy & Grains", dairyGrains),
          const SizedBox(height: 16),
        ],
        if (alliumsLegumes.isNotEmpty) ...[
          _buildTriggerCategory("Alliums & Legumes", alliumsLegumes),
          const SizedBox(height: 16),
        ],
        if (prepDining.isNotEmpty) ...[
          _buildTriggerCategory("Preparation & Dining Style", prepDining),
          const SizedBox(height: 16),
        ],
        if (systemicMindGut.isNotEmpty) ...[
          _buildTriggerCategory("Systemic & Mind-gut", systemicMindGut),
        ],
        if (otherOptions.isNotEmpty) ...[
          const SizedBox(height: 16),
          _buildTriggerCategory("Other Triggers", otherOptions),
        ],
        if (_triggerFoodsError != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: CommonText(_triggerFoodsError!, style: TextStyle(color: appColors.red, fontSize: 12)),
          ),
        const SizedBox(height: 20),
        CommonText(
          otherLabel,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF534343)),
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

  Widget _buildTriggerCategory(String title, List<GutResetOption> list) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonText(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF534343))),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: list.map((item) {
            final isSelected = _selectedTriggerFoods.contains(item.value) || _selectedTriggerFoods.contains(item.label);
            final val = item.value ?? item.label ?? "";
            return _buildSimplePill(
              item.label ?? item.value ?? "",
              isSelected,
              () {
                setState(() {
                  if (isSelected) {
                    _selectedTriggerFoods.remove(item.value);
                    _selectedTriggerFoods.remove(item.label);
                  } else {
                    _selectedTriggerFoods.add(val);
                  }
                  if (_triggerFoodsError != null) _validate();
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPriorDiagnosisSection() {
    final diagField = _getField("prior_diagnosis");
    final diagLabel = diagField?.label ?? "Have you had any medical diagnosis, clinical test, or prescription treatment for these symptoms?";

    final histField = _getField("clinical_history");
    final histLabel = histField?.label ?? "Clinical History & Test Findings";

    return ProfileSectionCard(
      title: "Prior Diagnosis, Tests or Care",
      icon: appIcons.priorDiagnosis,
      children: [
        buildRequiredLabel(diagLabel, color: const Color(0xFF534343)),
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
        CommonText(histLabel, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1D1B1A))),
        const SizedBox(height: 8),
        CommonTextField(
          label: "",
          controller: _clinicalHistoryController,
          hint: "e.g. Diagnosed with mild GERD by gastroenterologist in autumn 2023. Upper endoscopy was unremarkable.",
          maxLines: 4,
          borderColor: Colors.transparent,
          fillColor: const Color(0xFFF2EDEB),
        ),
        if (_clinicalHistoryError != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: CommonText(_clinicalHistoryError!, style: TextStyle(color: appColors.red, fontSize: 12)),
          ),
      ],
    );
  }

  Widget _buildPriorityReliefFocusSection() {
    final field = _getField("priority_relief_focus");
    final label = field?.label ?? "If we improved only one digestive concern during this program, which would make the biggest difference to your quality of life?";

    return ProfileSectionCard(
      title: "Priority Relief Focus",
      icon: appIcons.starsFill,
      children: [
        CommonText(
          label,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF534343)),
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
