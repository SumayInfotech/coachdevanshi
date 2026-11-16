import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../main.dart';
import '../../../core/blocs/coach/rooted_recovery_new_moms/rooted_recovery_new_moms_bloc.dart';
import '../../../core/blocs/coach/rooted_recovery_new_moms/rooted_recovery_new_moms_event.dart';
import '../../../core/blocs/coach/rooted_recovery_new_moms/rooted_recovery_new_moms_state.dart';
import '../../../core/blocs/coach/save_protocol_form/save_protocol_form_bloc.dart';
import '../../../core/blocs/coach/save_protocol_form/save_protocol_form_event.dart';
import '../../../core/blocs/coach/save_protocol_form/save_protocol_form_state.dart';
import '../../../core/constants/urls.dart';
import '../../../core/constants/utils.dart';
import '../../../core/models/coach/rooted_recovery_new_moms_model.dart';
import '../../../core/services/loader_service.dart';
import '../../widgets/common_app_bar.dart';
import '../../widgets/common_button.dart';
import '../../widgets/common_text.dart';
import '../../widgets/common_text_field.dart';
import '../profile/widget/profile_section_card.dart';

class RootedRecoveryScreen extends StatefulWidget {
  final String pathwayUuid;

  const RootedRecoveryScreen({
    super.key,
    this.pathwayUuid = "",
  });

  @override
  State<RootedRecoveryScreen> createState() => _RootedRecoveryScreenState();
}

class _RootedRecoveryScreenState extends State<RootedRecoveryScreen> {
  RootedRecoveryNewMomsData? _protocolData;
  List<RootedRecoveryNewMomsFormField> _fields = [];

  // Section 1: Delivery & Timeline
  final TextEditingController _deliveryDateController = TextEditingController();
  String? _deliveryDateError;
  String? _typeOfDelivery;
  String? _typeOfDeliveryError;

  // Section 2: Lactation & Feeding Support
  String? _feedingSupport;
  String? _feedingSupportError;

  // Section 3: Complications
  bool? _hasComplications;
  String? _hasComplicationsError;
  final TextEditingController _complicationsDetailsController = TextEditingController();
  String? _complicationsDetailsError;

  // Section 4: Medical Exercise Clearance
  String? _exerciseClearance;
  String? _exerciseClearanceError;

  // Section 5: Current Postpartum Sensations
  final Set<String> _selectedSensations = {};
  String? _sensationsError;

  // Section 6: Sleep Rhythms & Support
  final TextEditingController _sleepStretchController = TextEditingController();
  final TextEditingController _caregivingSupportController = TextEditingController();
  String? _sleepStretchError;

  // Section 7: Top Priority Outcomes (Max 2)
  final Set<String> _selectedPriorities = {};
  String? _prioritiesError;
  final TextEditingController _otherPriorityController = TextEditingController();

  // Fallbacks
  final List<RootedRecoveryNewMomsOption> _defaultDeliveryTypes = [
    RootedRecoveryNewMomsOption(value: "vaginal", label: "Vaginal Birth"),
    RootedRecoveryNewMomsOption(value: "assisted_vaginal", label: "Assisted Vaginal Birth"),
    RootedRecoveryNewMomsOption(value: "c_section", label: "C-section"),
    RootedRecoveryNewMomsOption(value: "prefer_not_to_answer", label: "Prefer Not to Answer"),
  ];

  final List<RootedRecoveryNewMomsOption> _defaultFeedingOptions = [
    RootedRecoveryNewMomsOption(value: "direct_or_pumping", label: "Direct feeding or exclusive pumping"),
    RootedRecoveryNewMomsOption(value: "combination", label: "Combination feeding"),
    RootedRecoveryNewMomsOption(value: "occasionally", label: "Occasionally"),
    RootedRecoveryNewMomsOption(value: "no", label: "No"),
  ];

  final List<RootedRecoveryNewMomsOption> _defaultExerciseClearanceOptions = [
    RootedRecoveryNewMomsOption(value: "yes", label: "Yes"),
    RootedRecoveryNewMomsOption(value: "no", label: "No"),
    RootedRecoveryNewMomsOption(value: "not_discussed", label: "Not yet discussed"),
    RootedRecoveryNewMomsOption(value: "not_relevant", label: "Exercise clearance is not currently relevant"),
  ];

  final List<RootedRecoveryNewMomsOption> _defaultSensationsList = [
    RootedRecoveryNewMomsOption(value: "pelvic_floor", label: "Pelvic-floor heaviness or leaking"),
    RootedRecoveryNewMomsOption(value: "diastasis", label: "Abdominal separation or diastase concern"),
    RootedRecoveryNewMomsOption(value: "c_section_discomfort", label: "C-section or scar discomfort"),
    RootedRecoveryNewMomsOption(value: "back_hip_pelvic_pain", label: "Back, hip or pelvic pain"),
    RootedRecoveryNewMomsOption(value: "low_mood", label: "Very low mood, anxiety or feeling unable to cope"),
    RootedRecoveryNewMomsOption(value: "none", label: "None of these"),
  ];

  final List<RootedRecoveryNewMomsOption> _defaultPrioritiesList = [
    RootedRecoveryNewMomsOption(value: "recovery", label: "Recovery"),
    RootedRecoveryNewMomsOption(value: "energy", label: "Energy"),
    RootedRecoveryNewMomsOption(value: "strength", label: "Strength"),
    RootedRecoveryNewMomsOption(value: "milk_supply", label: "Milk Supply"),
    RootedRecoveryNewMomsOption(value: "digestion", label: "Digestion"),
    RootedRecoveryNewMomsOption(value: "gentle_inch_loss", label: "Gentle Inch Loss"),
    RootedRecoveryNewMomsOption(value: "sleep_routine", label: "Sleep & Routine"),
    RootedRecoveryNewMomsOption(value: "feeling_myself", label: "Feeling Myself"),
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
        BlocProvider.of<RootedRecoveryNewMomsBloc>(context).add(
          UserGetRootedRecoveryNewMomsEvent(
            url: Urls.pathwaysProtocol(pathwayUuid: widget.pathwayUuid),
          ),
        );
      });
    }
  }

  void _populateAnswers(RootedRecoveryNewMomsAnswers? answers) {
    if (answers == null) return;

    if (answers.deliveryDate != null && answers.deliveryDate!.isNotEmpty) {
      _deliveryDateController.text = answers.deliveryDate!;
    }

    if (answers.deliveryType != null && answers.deliveryType!.isNotEmpty) {
      _typeOfDelivery = answers.deliveryType;
    }

    if (answers.feedingStatus != null && answers.feedingStatus!.isNotEmpty) {
      _feedingSupport = answers.feedingStatus;
    }

    if (answers.hasComplications != null) {
      _hasComplications = answers.hasComplications;
    }

    if (answers.complicationDetails != null && answers.complicationDetails!.isNotEmpty) {
      _complicationsDetailsController.text = answers.complicationDetails!;
    }

    if (answers.exerciseClearance != null && answers.exerciseClearance!.isNotEmpty) {
      _exerciseClearance = answers.exerciseClearance;
    }

    if (answers.postpartumSensations != null && answers.postpartumSensations!.isNotEmpty) {
      _selectedSensations.clear();
      _selectedSensations.addAll(answers.postpartumSensations!);
    }

    if (answers.longestSleepStretch != null && answers.longestSleepStretch!.isNotEmpty) {
      _sleepStretchController.text = answers.longestSleepStretch!;
    }

    if (answers.caregivingSupport != null && answers.caregivingSupport!.isNotEmpty) {
      _caregivingSupportController.text = answers.caregivingSupport!;
    }

    if (answers.topPriorities != null && answers.topPriorities!.isNotEmpty) {
      _selectedPriorities.clear();
      _selectedPriorities.addAll(answers.topPriorities!);
    }

    if (answers.otherPriority != null && answers.otherPriority!.isNotEmpty) {
      _otherPriorityController.text = answers.otherPriority!;
    }
  }

  RootedRecoveryNewMomsFormField? _getField(String key) {
    try {
      return _fields.firstWhere((f) => f.key == key);
    } catch (_) {
      return null;
    }
  }

  String? _getOptionValue(String? selected, List<RootedRecoveryNewMomsOption> options) {
    if (selected == null) return null;
    final found = options.firstWhere(
      (o) => o.value == selected || o.label?.toLowerCase() == selected.toLowerCase(),
      orElse: () => RootedRecoveryNewMomsOption(value: selected),
    );
    return found.value ?? selected;
  }

  List<String> _getOptionValues(Set<String> selectedSet, List<RootedRecoveryNewMomsOption> options) {
    return selectedSet.map((item) {
      final found = options.firstWhere(
        (o) => o.value == item || o.label?.toLowerCase() == item.toLowerCase(),
        orElse: () => RootedRecoveryNewMomsOption(value: item),
      );
      return found.value ?? item;
    }).toList();
  }

  bool _validate() {
    bool isValid = true;

    // Delivery Date
    final deliveryDateField = _getField("delivery_date");
    if ((deliveryDateField?.required ?? true) && _deliveryDateController.text.trim().isEmpty) {
      _deliveryDateError = "Required";
      isValid = false;
    } else {
      _deliveryDateError = null;
    }

    // Delivery Type
    final deliveryTypeField = _getField("delivery_type");
    if ((deliveryTypeField?.required ?? true) && (_typeOfDelivery == null || _typeOfDelivery!.isEmpty)) {
      _typeOfDeliveryError = "Required";
      isValid = false;
    } else {
      _typeOfDeliveryError = null;
    }

    // Feeding Status
    final feedingField = _getField("feeding_status");
    if ((feedingField?.required ?? true) && (_feedingSupport == null || _feedingSupport!.isEmpty)) {
      _feedingSupportError = "Required";
      isValid = false;
    } else {
      _feedingSupportError = null;
    }

    // Complications
    final complicationsField = _getField("has_complications");
    if ((complicationsField?.required ?? true) && _hasComplications == null) {
      _hasComplicationsError = "Required";
      isValid = false;
    } else {
      _hasComplicationsError = null;
    }

    // Complication Details
    final detailsField = _getField("complication_details");
    bool detailsRequired = detailsField?.required ?? false;
    if (detailsField?.requiredIf != null &&
        detailsField!.requiredIf!.field == "has_complications" &&
        detailsField.requiredIf!.value == true &&
        _hasComplications == true) {
      detailsRequired = true;
    }
    if (detailsRequired && _complicationsDetailsController.text.trim().isEmpty) {
      _complicationsDetailsError = "Required";
      isValid = false;
    } else {
      _complicationsDetailsError = null;
    }

    // Exercise Clearance
    final clearanceField = _getField("exercise_clearance");
    if ((clearanceField?.required ?? true) && (_exerciseClearance == null || _exerciseClearance!.isEmpty)) {
      _exerciseClearanceError = "Required";
      isValid = false;
    } else {
      _exerciseClearanceError = null;
    }

    // Postpartum Sensations
    final sensationsField = _getField("postpartum_sensations");
    if ((sensationsField?.required ?? true) && _selectedSensations.isEmpty) {
      _sensationsError = "Please select at least one";
      isValid = false;
    } else {
      _sensationsError = null;
    }

    // Longest Sleep Stretch
    final sleepField = _getField("longest_sleep_stretch");
    if ((sleepField?.required ?? true) && _sleepStretchController.text.trim().isEmpty) {
      _sleepStretchError = "Required";
      isValid = false;
    } else {
      _sleepStretchError = null;
    }

    // Top Priorities (max 2)
    final prioritiesField = _getField("top_priorities");
    if ((prioritiesField?.required ?? true) && _selectedPriorities.isEmpty) {
      _prioritiesError = "Select at least 1 priority";
      isValid = false;
    } else {
      _prioritiesError = null;
    }

    setState(() {});
    return isValid;
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

    final deliveryTypeField = _getField("delivery_type");
    final feedingField = _getField("feeding_status");
    final clearanceField = _getField("exercise_clearance");
    final sensationsField = _getField("postpartum_sensations");
    final prioritiesField = _getField("top_priorities");

    final RootedRecoveryNewMomsAnswers answers = RootedRecoveryNewMomsAnswers(
      deliveryDate: _deliveryDateController.text.trim().isNotEmpty ? _deliveryDateController.text.trim() : null,
      deliveryType: _getOptionValue(_typeOfDelivery, deliveryTypeField?.options ?? _defaultDeliveryTypes),
      feedingStatus: _getOptionValue(_feedingSupport, feedingField?.options ?? _defaultFeedingOptions),
      hasComplications: _hasComplications ?? false,
      complicationDetails: _complicationsDetailsController.text.trim().isNotEmpty
          ? _complicationsDetailsController.text.trim()
          : null,
      exerciseClearance: _getOptionValue(_exerciseClearance, clearanceField?.options ?? _defaultExerciseClearanceOptions),
      postpartumSensations: _getOptionValues(_selectedSensations, sensationsField?.options ?? _defaultSensationsList),
      longestSleepStretch: _sleepStretchController.text.trim().isNotEmpty
          ? _sleepStretchController.text.trim()
          : null,
      caregivingSupport: _caregivingSupportController.text.trim().isNotEmpty
          ? _caregivingSupportController.text.trim()
          : null,
      topPriorities: _getOptionValues(_selectedPriorities, prioritiesField?.options ?? _defaultPrioritiesList),
      otherPriority: _otherPriorityController.text.trim().isNotEmpty
          ? _otherPriorityController.text.trim()
          : null,
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
    _deliveryDateController.dispose();
    _complicationsDetailsController.dispose();
    _sleepStretchController.dispose();
    _caregivingSupportController.dispose();
    _otherPriorityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<RootedRecoveryNewMomsBloc, RootedRecoveryNewMomsState>(
          listener: (context, state) {
            if (state is RootedRecoveryNewMomsSuccess) {
              LoaderService.hide();
              _protocolData = state.model.data;
              _fields = state.model.data?.fields ?? [];
              _populateAnswers(state.model.data?.answers);
              setState(() {});
            } else if (state is RootedRecoveryNewMomsFailed) {
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
                message: state.model.message ?? 'Rooted Recovery for New Moms Submitted!',
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
              _protocolData?.title ?? "Rooted Recovery for New Moms",
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
        ),
      ),
    );
  }

  Widget _buildDeliveryAndTimeline() {
    final deliveryTypeField = _getField("delivery_type");
    final deliveryTypes = deliveryTypeField?.options ?? _defaultDeliveryTypes;

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
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF1D1B1A)),
          onTap: () async {
            DateTime? picked = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime.now(),
            );
            if (picked != null) {
              setState(() {
                _deliveryDateController.text = DateFormat('yyyy-MM-dd').format(picked);
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
          children: deliveryTypes.map((opt) {
            final String val = opt.value ?? "";
            final String label = opt.label ?? val;
            return _buildRadioRow(val, label, _typeOfDelivery, (newVal) {
              setState(() {
                _typeOfDelivery = newVal;
                if (_typeOfDeliveryError != null) _validate();
              });
            });
          }).toList(),
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
    final feedingField = _getField("feeding_status");
    final feedingOptions = feedingField?.options ?? _defaultFeedingOptions;

    return ProfileSectionCard(
      title: "Lactation & Feeding Support",
      icon: appIcons.drop,
      children: [
        buildRequiredLabel("Are you currently breastfeeding or expressing milk?", color: const Color(0xFF534343)),
        const SizedBox(height: 16),
        Column(
          children: feedingOptions.map((opt) {
            final String val = opt.value ?? "";
            final String label = opt.label ?? val;
            return _buildRadioRow(val, label, _feedingSupport, (newVal) {
              setState(() {
                _feedingSupport = newVal;
                if (_feedingSupportError != null) _validate();
              });
            });
          }).toList(),
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
          borderColor: _complicationsDetailsError != null ? appColors.red : Colors.transparent,
          fillColor: const Color(0xFFF8F2F0),
          onChanged: (v) {
            setState(() {});
            if (_complicationsDetailsError != null) _validate();
          },
        ),
        if (_complicationsDetailsError != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 4),
            child: CommonText(_complicationsDetailsError!, style: TextStyle(color: appColors.red, fontSize: 12)),
          ),
      ],
    );
  }

  Widget _buildMedicalClearance() {
    final clearanceField = _getField("exercise_clearance");
    final clearanceOptions = clearanceField?.options ?? _defaultExerciseClearanceOptions;

    return ProfileSectionCard(
      title: "Medical Exercise Clearance",
      icon: appIcons.movement,
      children: [
        buildRequiredLabel("Have you received formal medical clearance from your OB-GYN or midwife to begin or resume intentional exercise?", color: const Color(0xFF534343)),
        const SizedBox(height: 16),
        Column(
          children: clearanceOptions.map((opt) {
            final String val = opt.value ?? "";
            final String label = opt.label ?? val;
            return _buildRadioRow(val, label, _exerciseClearance, (newVal) {
              setState(() {
                _exerciseClearance = newVal;
                if (_exerciseClearanceError != null) _validate();
              });
            });
          }).toList(),
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
    final sensationsField = _getField("postpartum_sensations");
    final sensations = sensationsField?.options ?? _defaultSensationsList;

    return ProfileSectionCard(
      title: "Current Postpartum Sensations",
      icon: appIcons.maintenance,
      children: [
        buildRequiredLabel("Are you currently experiencing any physical or emotional symptoms?", color: const Color(0xFF534343)),
        const SizedBox(height: 16),
        Column(
          children: sensations.map((opt) {
            final String val = opt.value ?? "";
            final String label = opt.label ?? val;
            final bool isSelected = _selectedSensations.contains(val) || _selectedSensations.contains(label);

            return _buildCheckboxRow(label, isSelected, () {
              setState(() {
                if (isSelected) {
                  _selectedSensations.remove(val);
                  _selectedSensations.remove(label);
                } else {
                  if (val == "none" || label.toLowerCase() == "none of these") {
                    _selectedSensations.clear();
                    _selectedSensations.add(val);
                  } else {
                    _selectedSensations.remove("none");
                    _selectedSensations.remove("None of these");
                    _selectedSensations.add(val);
                  }
                }
                if (_sensationsError != null) _validate();
              });
            });
          }).toList(),
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
    final prioritiesField = _getField("top_priorities");
    final priorities = prioritiesField?.options ?? _defaultPrioritiesList;

    return ProfileSectionCard(
      title: "What are your top two priorities right now?",
      icon: appIcons.compass,
      children: [
        buildRequiredLabel("Choose up to 2 primary areas to anchor your first 6 weeks of maternal nourishment:", color: const Color(0xFF534343)),
        const SizedBox(height: 16),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: priorities.map((opt) {
            final String val = opt.value ?? "";
            final String label = opt.label ?? val;
            final bool isSelected = _selectedPriorities.contains(val) || _selectedPriorities.contains(label);
            final double chipWidth = (MediaQuery.of(context).size.width - 40 - 40 - 10) / 2;

            return SizedBox(
              width: chipWidth,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      _selectedPriorities.remove(val);
                      _selectedPriorities.remove(label);
                    } else {
                      if (_selectedPriorities.length < 2) {
                        _selectedPriorities.add(val);
                      }
                    }
                    if (_prioritiesError != null) _validate();
                  });
                },
                child: Container(
                  height: 54,
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
                          label,
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
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            border: Border.all(color: const Color(0xFF857373)),
                          ),
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

  Widget _buildRadioRow(String val, String label, String? groupValue, ValueChanged<String> onChanged) {
    bool isSelected = groupValue == val || groupValue?.toLowerCase() == label.toLowerCase();
    return GestureDetector(
      onTap: () => onChanged(val),
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
                label,
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

  Widget _buildCheckboxRow(String label, bool isSelected, VoidCallback onTap) {
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
                label,
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
