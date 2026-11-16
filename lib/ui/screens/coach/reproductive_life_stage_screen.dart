import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../main.dart';
import '../../../core/blocs/coach/reproductive_life_stage/reproductive_life_stage_bloc.dart';
import '../../../core/blocs/coach/reproductive_life_stage/reproductive_life_stage_event.dart';
import '../../../core/blocs/coach/reproductive_life_stage/reproductive_life_stage_state.dart';
import '../../../core/blocs/coach/save_protocol_form/save_protocol_form_bloc.dart';
import '../../../core/blocs/coach/save_protocol_form/save_protocol_form_event.dart';
import '../../../core/blocs/coach/save_protocol_form/save_protocol_form_state.dart';
import '../../../core/constants/urls.dart';
import '../../../core/constants/utils.dart';
import '../../../core/models/coach/reproductive_life_stage_model.dart';
import '../../../core/services/loader_service.dart';
import '../../widgets/common_app_bar.dart';
import '../../widgets/common_button.dart';
import '../../widgets/common_text.dart';
import '../../widgets/common_text_field.dart';
import '../profile/widget/profile_section_card.dart';

class ReproductiveLifeStageScreen extends StatefulWidget {
  final String pathwayUuid;

  const ReproductiveLifeStageScreen({
    super.key,
    this.pathwayUuid = "",
  });

  @override
  State<ReproductiveLifeStageScreen> createState() => _ReproductiveLifeStageScreenState();
}

class _ReproductiveLifeStageScreenState extends State<ReproductiveLifeStageScreen> {
  ReproductiveLifeStageData? _protocolData;
  List<ReproductiveLifeStageFormField> _fields = [];

  // Section 1: Menstrual Pattern
  final TextEditingController _cycleLengthController = TextEditingController();
  final TextEditingController _bleedingDurationController = TextEditingController();
  bool _cycleLengthNotSure = false;

  String? _regularity;
  String? _regularityError;

  final Set<String> _selectedMarkers = {};
  String? _markersError;

  // Section 2: Trying to conceive or pregnancy module
  bool? _underGynaecologistCare;
  String? _underGynaecologistCareError;
  final TextEditingController _clinicianController = TextEditingController();

  bool? _doctorGuidance;
  final TextEditingController _physicianGuidanceController = TextEditingController();

  String? _pregnancyStatus;

  final TextEditingController _eddController = TextEditingController();
  final TextEditingController _gestationalWeekController = TextEditingController();

  // Section 3: Perimenopause or Menopause Transitions
  final TextEditingController _lastMenstrualPeriodController = TextEditingController();
  String? _lastMenstrualPeriodError;
  bool _lastPeriodNotSure = false;

  final Set<String> _selectedMenopausalChanges = {};
  String? _menopausalChangesError;
  final TextEditingController _otherMenopausalChangesController = TextEditingController();

  // Fallback defaults
  final List<ReproductiveLifeStageOption> _defaultRegularityOptions = [
    ReproductiveLifeStageOption(value: "regular", label: "Regular"),
    ReproductiveLifeStageOption(value: "sometimes_irregular", label: "Sometimes irregular"),
    ReproductiveLifeStageOption(value: "irregular", label: "Irregular"),
    ReproductiveLifeStageOption(value: "absent", label: "Currently absent (Amenorrhea)"),
  ];

  final List<ReproductiveLifeStageOption> _defaultCyclicalMarkersList = [
    ReproductiveLifeStageOption(value: "cramps", label: "Cramps"),
    ReproductiveLifeStageOption(value: "heavy_flow", label: "Heavy flow"),
    ReproductiveLifeStageOption(value: "clotting", label: "Clotting"),
    ReproductiveLifeStageOption(value: "mood_changes", label: "Mood changes"),
    ReproductiveLifeStageOption(value: "acne", label: "Acne"),
    ReproductiveLifeStageOption(value: "bloating", label: "Bloating"),
    ReproductiveLifeStageOption(value: "breast_tenderness", label: "Breast tenderness"),
    ReproductiveLifeStageOption(value: "food_cravings", label: "Food cravings"),
    ReproductiveLifeStageOption(value: "fatigue", label: "Fatigue or energy dip"),
    ReproductiveLifeStageOption(value: "none", label: "None"),
  ];

  final List<ReproductiveLifeStageOption> _defaultPregnancyStatusOptions = [
    ReproductiveLifeStageOption(value: "trying_to_conceive", label: "Currently Trying to Conceive (Pre-conception)"),
    ReproductiveLifeStageOption(value: "pregnant", label: "Currently Pregnant"),
  ];

  final List<ReproductiveLifeStageOption> _defaultMenopausalChangesList = [
    ReproductiveLifeStageOption(value: "hot_flashes", label: "Hot flashes or night sweats"),
    ReproductiveLifeStageOption(value: "sleep_disruption", label: "Sleep disruption"),
    ReproductiveLifeStageOption(value: "mood_changes", label: "Mood changes"),
    ReproductiveLifeStageOption(value: "energy_changes", label: "Energy changes"),
    ReproductiveLifeStageOption(value: "joint_discomfort", label: "Joint discomfort"),
    ReproductiveLifeStageOption(value: "weight_body_comp", label: "Weight / body composition"),
    ReproductiveLifeStageOption(value: "vaginal_urinary", label: "Vaginal or urinary symptoms"),
    ReproductiveLifeStageOption(value: "none", label: "None"),
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
        BlocProvider.of<ReproductiveLifeStageBloc>(context).add(
          UserGetReproductiveLifeStageEvent(
            url: Urls.pathwaysProtocol(pathwayUuid: widget.pathwayUuid),
          ),
        );
      });
    }
  }

  void _populateAnswers(ReproductiveLifeStageAnswers? answers) {
    if (answers == null) return;

    if (answers.avgCycleLength != null && answers.avgCycleLength!.isNotEmpty) {
      _cycleLengthController.text = answers.avgCycleLength!;
    }

    if (answers.cycleLengthNotSure != null) {
      _cycleLengthNotSure = answers.cycleLengthNotSure!;
    }

    if (answers.bleedingDuration != null && answers.bleedingDuration!.isNotEmpty) {
      _bleedingDurationController.text = answers.bleedingDuration!;
    }

    if (answers.cycleRegularity != null && answers.cycleRegularity!.isNotEmpty) {
      _regularity = answers.cycleRegularity;
    }

    if (answers.cyclicalMarkers != null && answers.cyclicalMarkers!.isNotEmpty) {
      _selectedMarkers.clear();
      _selectedMarkers.addAll(answers.cyclicalMarkers!);
    }

    if (answers.underGynaeCare != null) {
      _underGynaecologistCare = answers.underGynaeCare;
    }

    if (answers.attendingClinician != null && answers.attendingClinician!.isNotEmpty) {
      _clinicianController.text = answers.attendingClinician!;
    }

    if (answers.hasDoctorGuidance != null) {
      _doctorGuidance = answers.hasDoctorGuidance;
    }

    if (answers.doctorGuidanceDetails != null && answers.doctorGuidanceDetails!.isNotEmpty) {
      _physicianGuidanceController.text = answers.doctorGuidanceDetails!;
    }

    if (answers.conceptionStatus != null && answers.conceptionStatus!.isNotEmpty) {
      _pregnancyStatus = answers.conceptionStatus;
    }

    if (answers.estimatedDueDate != null && answers.estimatedDueDate!.isNotEmpty) {
      _eddController.text = answers.estimatedDueDate!;
    }

    if (answers.gestationalWeek != null && answers.gestationalWeek!.isNotEmpty) {
      _gestationalWeekController.text = answers.gestationalWeek!;
    }

    if (answers.lastMenstrualPeriod != null && answers.lastMenstrualPeriod!.isNotEmpty) {
      _lastMenstrualPeriodController.text = answers.lastMenstrualPeriod!;
    }

    if (answers.lmpNotSure != null) {
      _lastPeriodNotSure = answers.lmpNotSure!;
    }

    if (answers.menopauseChanges != null && answers.menopauseChanges!.isNotEmpty) {
      _selectedMenopausalChanges.clear();
      _selectedMenopausalChanges.addAll(answers.menopauseChanges!);
    }

    if (answers.otherCyclicalNotes != null && answers.otherCyclicalNotes!.isNotEmpty) {
      _otherMenopausalChangesController.text = answers.otherCyclicalNotes!;
    }
  }

  ReproductiveLifeStageFormField? _getField(String key) {
    try {
      return _fields.firstWhere((f) => f.key == key);
    } catch (_) {
      return null;
    }
  }

  String? _getOptionValue(String? selected, List<ReproductiveLifeStageOption> options) {
    if (selected == null) return null;
    final found = options.firstWhere(
      (o) => o.value == selected || o.label?.toLowerCase() == selected.toLowerCase(),
      orElse: () => ReproductiveLifeStageOption(value: selected),
    );
    return found.value ?? selected;
  }

  List<String> _getOptionValues(Set<String> selectedSet, List<ReproductiveLifeStageOption> options) {
    return selectedSet.map((item) {
      final found = options.firstWhere(
        (o) => o.value == item || o.label?.toLowerCase() == item.toLowerCase(),
        orElse: () => ReproductiveLifeStageOption(value: item),
      );
      return found.value ?? item;
    }).toList();
  }

  bool _validate() {
    bool isValid = true;

    // Regularity
    final regularityField = _getField("cycle_regularity");
    if ((regularityField?.required ?? true) && (_regularity == null || _regularity!.isEmpty)) {
      _regularityError = "Required";
      isValid = false;
    } else {
      _regularityError = null;
    }

    // Cyclical Markers
    final markersField = _getField("cyclical_markers");
    if ((markersField?.required ?? true) && _selectedMarkers.isEmpty) {
      _markersError = "Select at least 1 marker";
      isValid = false;
    } else {
      _markersError = null;
    }

    // Under Gynaecologist Care
    final careField = _getField("under_gynae_care");
    if ((careField?.required ?? false) && _underGynaecologistCare == null) {
      _underGynaecologistCareError = "Required";
      isValid = false;
    } else {
      _underGynaecologistCareError = null;
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

    final regularityField = _getField("cycle_regularity");
    final markersField = _getField("cyclical_markers");
    final pregnancyStatusField = _getField("conception_status");
    final menopauseChangesField = _getField("menopause_changes");

    final ReproductiveLifeStageAnswers answers = ReproductiveLifeStageAnswers(
      avgCycleLength: _cycleLengthController.text.trim().isNotEmpty ? _cycleLengthController.text.trim() : null,
      cycleLengthNotSure: _cycleLengthNotSure,
      bleedingDuration: _bleedingDurationController.text.trim().isNotEmpty ? _bleedingDurationController.text.trim() : null,
      cycleRegularity: _getOptionValue(_regularity, regularityField?.options ?? _defaultRegularityOptions),
      cyclicalMarkers: _getOptionValues(_selectedMarkers, markersField?.options ?? _defaultCyclicalMarkersList),
      underGynaeCare: _underGynaecologistCare,
      attendingClinician: _clinicianController.text.trim().isNotEmpty ? _clinicianController.text.trim() : null,
      hasDoctorGuidance: _doctorGuidance,
      doctorGuidanceDetails: _physicianGuidanceController.text.trim().isNotEmpty ? _physicianGuidanceController.text.trim() : null,
      conceptionStatus: _getOptionValue(_pregnancyStatus, pregnancyStatusField?.options ?? _defaultPregnancyStatusOptions),
      estimatedDueDate: _eddController.text.trim().isNotEmpty ? _eddController.text.trim() : null,
      gestationalWeek: _gestationalWeekController.text.trim().isNotEmpty ? _gestationalWeekController.text.trim() : null,
      lastMenstrualPeriod: _lastMenstrualPeriodController.text.trim().isNotEmpty ? _lastMenstrualPeriodController.text.trim() : null,
      lmpNotSure: _lastPeriodNotSure,
      menopauseChanges: _getOptionValues(_selectedMenopausalChanges, menopauseChangesField?.options ?? _defaultMenopausalChangesList),
      otherCyclicalNotes: _otherMenopausalChangesController.text.trim().isNotEmpty ? _otherMenopausalChangesController.text.trim() : null,
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
    _cycleLengthController.dispose();
    _bleedingDurationController.dispose();
    _clinicianController.dispose();
    _physicianGuidanceController.dispose();
    _eddController.dispose();
    _gestationalWeekController.dispose();
    _lastMenstrualPeriodController.dispose();
    _otherMenopausalChangesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ReproductiveLifeStageBloc, ReproductiveLifeStageState>(
          listener: (context, state) {
            if (state is ReproductiveLifeStageSuccess) {
              LoaderService.hide();
              _protocolData = state.model.data;
              _fields = state.model.data?.fields ?? [];
              _populateAnswers(state.model.data?.answers);
              setState(() {});
            } else if (state is ReproductiveLifeStageFailed) {
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
                message: state.model.message ?? 'Life Stage Protocol Submitted!',
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
              _protocolData?.title ?? "Reproductive Life Stage Modules",
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
              _buildMenstrualPattern(),
              const SizedBox(height: 24),
              _buildPregnancyModule(),
              const SizedBox(height: 24),
              _buildMenopauseTransitions(),
              const SizedBox(height: 32),
              CommonButton(
                name: "Save & Submit Life Stage Protocols",
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

  Widget _buildMenstrualPattern() {
    final regularityField = _getField("cycle_regularity");
    final regularityOptions = regularityField?.options ?? _defaultRegularityOptions;
    final markersField = _getField("cyclical_markers");
    final markers = markersField?.options ?? _defaultCyclicalMarkersList;

    return ProfileSectionCard(
      title: "What is your usual menstrual pattern?",
      icon: appIcons.fullCalender,
      children: [
        buildRequiredLabel("What is your usual menstrual pattern?", color: const Color(0xFF534343)),
        const SizedBox(height: 16),
        const CommonText("Average cycle length", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1D1B1A))),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: CommonTextField(
                label: "",
                controller: _cycleLengthController,
                hint: "e.g. 28 days",
                borderColor: Colors.transparent,
                fillColor: const Color(0xFFF8F2F0),
                readOnly: _cycleLengthNotSure,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => setState(() {
                _cycleLengthNotSure = !_cycleLengthNotSure;
                if (_cycleLengthNotSure) _cycleLengthController.clear();
              }),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: _cycleLengthNotSure ? const Color(0xFFE7E1DF) : const Color(0xFFF2EDEB),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CommonText(
                  "Not sure",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: _cycleLengthNotSure ? const Color(0xFF1D1B1A) : const Color(0xFF534343),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const CommonText("Bleeding duration", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1D1B1A))),
        const SizedBox(height: 8),
        CommonTextField(
          label: "",
          controller: _bleedingDurationController,
          hint: "e.g. 4-5 days",
          borderColor: Colors.transparent,
          fillColor: const Color(0xFFF8F2F0),
        ),
        const SizedBox(height: 16),
        const CommonText("Regularity", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1D1B1A))),
        const SizedBox(height: 8),
        Column(
          children: regularityOptions.map((opt) {
            final String val = opt.value ?? "";
            final String label = opt.label ?? val;
            return _buildRadioRow(val, label, _regularity, (newVal) {
              setState(() {
                _regularity = newVal;
                if (_regularityError != null) _validate();
              });
            });
          }).toList(),
        ),
        if (_regularityError != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 4),
            child: CommonText(_regularityError!, style: TextStyle(color: appColors.red, fontSize: 12)),
          ),
        const SizedBox(height: 24),
        Container(height: 1, color: const Color(0xFFF2EDEB)),
        const SizedBox(height: 24),
        buildRequiredLabel("Select all noticeable cyclical physical or emotional markers.", color: const Color(0xFF534343)),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: markers.map((opt) {
            final String val = opt.value ?? "";
            final String label = opt.label ?? val;
            final bool isSelected = _selectedMarkers.contains(val) || _selectedMarkers.contains(label);

            return _buildSelectionPill(
              label,
              isSelected,
              () {
                setState(() {
                  if (isSelected) {
                    _selectedMarkers.remove(val);
                    _selectedMarkers.remove(label);
                  } else {
                    if (val == "none" || label.toLowerCase() == "none") {
                      _selectedMarkers.clear();
                      _selectedMarkers.add(val);
                    } else {
                      _selectedMarkers.remove("none");
                      _selectedMarkers.remove("None");
                      _selectedMarkers.add(val);
                    }
                  }
                  if (_markersError != null) _validate();
                });
              },
            );
          }).toList(),
        ),
        if (_markersError != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: CommonText(_markersError!, style: TextStyle(color: appColors.red, fontSize: 12)),
          ),
      ],
    );
  }

  Widget _buildPregnancyModule() {
    final pregnancyField = _getField("conception_status");
    final pregnancyOptions = pregnancyField?.options ?? _defaultPregnancyStatusOptions;

    return ProfileSectionCard(
      title: "Trying to conceive or pregnancy module",
      icon: appIcons.pregnancy,
      children: [
        buildRequiredLabel("Are you currently under the care of a gynaecologist or obstetrician?", color: const Color(0xFF1D1B1A)),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildToggleBtn("Yes", _underGynaecologistCare == true, () {
                setState(() {
                  _underGynaecologistCare = true;
                  if (_underGynaecologistCareError != null) _validate();
                });
              }),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildToggleBtn("No", _underGynaecologistCare == false, () {
                setState(() {
                  _underGynaecologistCare = false;
                  if (_underGynaecologistCareError != null) _validate();
                });
              }),
            ),
          ],
        ),
        if (_underGynaecologistCareError != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 4),
            child: CommonText(_underGynaecologistCareError!, style: TextStyle(color: appColors.red, fontSize: 12)),
          ),
        const SizedBox(height: 20),
        const CommonText("Attending Clinician / Hospital (Optional)", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1D1B1A))),
        const SizedBox(height: 8),
        CommonTextField(
          label: "",
          controller: _clinicianController,
          hint: "e.g. Dr. Ananya Roy, Apollo Hospital",
          borderColor: Colors.transparent,
          fillColor: const Color(0xFFF8F2F0),
        ),
        const SizedBox(height: 20),
        const CommonText("Has your doctor given any nutrition, activity, or weight guidance we should follow?", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1D1B1A))),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildToggleBtn("Yes", _doctorGuidance == true, () => setState(() => _doctorGuidance = true)),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildToggleBtn("No", _doctorGuidance == false, () => setState(() => _doctorGuidance = false)),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const CommonText("Physician Guidance Details", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1D1B1A))),
        const SizedBox(height: 8),
        CommonTextField(
          label: "",
          controller: _physicianGuidanceController,
          hint: "e.g. Advised gentle iron supplementation, maintain pelvic stability exercises, and keep morning fasted glucose steady.",
          maxLines: 4,
          borderColor: Colors.transparent,
          fillColor: const Color(0xFFF8F2F0),
        ),
        const SizedBox(height: 24),
        const CommonText("Estimated due date or current week of pregnancy?", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1D1B1A))),
        const SizedBox(height: 12),
        Column(
          children: pregnancyOptions.map((opt) {
            final String val = opt.value ?? "";
            final String label = opt.label ?? val;
            return _buildRadioRow(val, label, _pregnancyStatus, (newVal) {
              setState(() {
                _pregnancyStatus = newVal;
              });
            });
          }).toList(),
        ),
        const SizedBox(height: 16),
        const CommonText("Estimated Due Date (EDD)", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1D1B1A))),
        const SizedBox(height: 8),
        CommonTextField(
          label: "",
          controller: _eddController,
          hint: "Select Date",
          readOnly: true,
          borderColor: Colors.transparent,
          fillColor: const Color(0xFFF8F2F0),
          suffixIcon: const Icon(Icons.calendar_today_outlined, size: 16, color: Color(0xFF857373)),
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF1D1B1A)),
          onTap: () async {
            DateTime? picked = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 300)),
            );
            if (picked != null) {
              setState(() {
                _eddController.text = DateFormat('yyyy-MM-dd').format(picked);
              });
            }
          },
        ),
        const SizedBox(height: 16),
        const CommonText("Current Gestational Week", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1D1B1A))),
        const SizedBox(height: 8),
        CommonTextField(
          label: "",
          controller: _gestationalWeekController,
          hint: "",
          borderColor: Colors.transparent,
          fillColor: const Color(0xFFF8F2F0),
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF1D1B1A)),
        ),
      ],
    );
  }

  Widget _buildMenopauseTransitions() {
    final menopauseField = _getField("menopause_changes");
    final changes = menopauseField?.options ?? _defaultMenopausalChangesList;

    return ProfileSectionCard(
      title: "Perimenopause or Menopause Transitions",
      icon: appIcons.time,
      children: [
        buildRequiredLabel("When was your last menstrual period, approximately?", color: const Color(0xFF1D1B1A)),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: CommonTextField(
                label: "",
                controller: _lastMenstrualPeriodController,
                hint: "Select Date",
                readOnly: true,
                borderColor: _lastMenstrualPeriodError != null ? appColors.red : Colors.transparent,
                fillColor: const Color(0xFFF8F2F0),
                suffixIcon: const Icon(Icons.calendar_today_outlined, size: 16, color: Color(0xFF8B484D)),
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF1D1B1A)),
                onTap: _lastPeriodNotSure
                    ? null
                    : () async {
                        DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null) {
                          setState(() {
                            _lastMenstrualPeriodController.text = DateFormat('yyyy-MM-dd').format(picked);
                          });
                        }
                      },
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => setState(() {
                _lastPeriodNotSure = !_lastPeriodNotSure;
                if (_lastPeriodNotSure) _lastMenstrualPeriodController.clear();
              }),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: _lastPeriodNotSure ? const Color(0xFFE7E1DF) : const Color(0xFFF2EDEB),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CommonText(
                  "Not sure",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: _lastPeriodNotSure ? const Color(0xFF1D1B1A) : const Color(0xFF534343),
                  ),
                ),
              ),
            ),
          ],
        ),
        if (_lastMenstrualPeriodError != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 4),
            child: CommonText(_lastMenstrualPeriodError!, style: TextStyle(color: appColors.red, fontSize: 12)),
          ),
        const SizedBox(height: 24),
        buildRequiredLabel("Which changes are currently affecting you?", color: const Color(0xFF1D1B1A)),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: changes.map((opt) {
            final String val = opt.value ?? "";
            final String label = opt.label ?? val;
            final bool isSelected = _selectedMenopausalChanges.contains(val) ||
                _selectedMenopausalChanges.contains(label);

            return _buildSelectionPill(
              label,
              isSelected,
              () {
                setState(() {
                  if (isSelected) {
                    _selectedMenopausalChanges.remove(val);
                    _selectedMenopausalChanges.remove(label);
                  } else {
                    if (val == "none" || label.toLowerCase() == "none") {
                      _selectedMenopausalChanges.clear();
                      _selectedMenopausalChanges.add(val);
                    } else {
                      _selectedMenopausalChanges.remove("none");
                      _selectedMenopausalChanges.remove("None");
                      _selectedMenopausalChanges.add(val);
                    }
                  }
                  if (_menopausalChangesError != null) _validate();
                });
              },
            );
          }).toList(),
        ),
        if (_menopausalChangesError != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: CommonText(_menopausalChangesError!, style: TextStyle(color: appColors.red, fontSize: 12)),
          ),
        const SizedBox(height: 24),
        const CommonText("Other cyclical changes or notes", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF534343))),
        const SizedBox(height: 8),
        CommonTextField(
          label: "",
          controller: _otherMenopausalChangesController,
          hint: "e.g., Brain fog during mid-afternoon",
          maxLines: 3,
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
            color: isSelected ? const Color(0xFF3A0910) : const Color(0xFF1D1B1A),
          ),
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
          color: isSelected ? const Color(0xFFFFDADB).withValues(alpha: 0.4) : const Color(0xFFF2EDEB),
          borderRadius: BorderRadius.circular(999),
        ),
        child: CommonText(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isSelected ? const Color(0xFF713439) : const Color(0xFF1D1B1A),
          ),
        ),
      ),
    );
  }
}
