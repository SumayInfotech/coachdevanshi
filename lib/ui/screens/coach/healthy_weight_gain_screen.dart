import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../main.dart';
import '../../../core/blocs/coach/healthy_weight_gain/healthy_weight_gain_bloc.dart';
import '../../../core/blocs/coach/healthy_weight_gain/healthy_weight_gain_event.dart';
import '../../../core/blocs/coach/healthy_weight_gain/healthy_weight_gain_state.dart';
import '../../../core/blocs/coach/save_protocol_form/save_protocol_form_bloc.dart';
import '../../../core/blocs/coach/save_protocol_form/save_protocol_form_event.dart';
import '../../../core/blocs/coach/save_protocol_form/save_protocol_form_state.dart';
import '../../../core/constants/urls.dart';
import '../../../core/constants/utils.dart';
import '../../../core/models/coach/healthy_weight_gain_model.dart';
import '../../../core/services/loader_service.dart';
import '../../widgets/common_app_bar.dart';
import '../../widgets/common_button.dart';
import '../../widgets/common_text.dart';
import '../../widgets/common_text_field.dart';
import '../profile/widget/profile_section_card.dart';

class HealthyWeightGainScreen extends StatefulWidget {
  final String pathwayUuid;

  const HealthyWeightGainScreen({
    super.key,
    this.pathwayUuid = "",
  });

  @override
  State<HealthyWeightGainScreen> createState() => _HealthyWeightGainScreenState();
}

class _HealthyWeightGainScreenState extends State<HealthyWeightGainScreen> {
  HealthyWeightGainData? _protocolData;
  List<HealthyWeightGainFormField> _fields = [];

  // Section 1: Weight History Intentionality
  String? _weightIntentionality;
  String? _weightIntentionalityError;

  // Section 2: Six-Month Weight Trajectory
  bool _isKgSelected = true;
  String _weightUnit = "kg";
  final TextEditingController _startingWeightController = TextEditingController();
  final TextEditingController _currentWeightController = TextEditingController();
  String? _currentWeightError;
  String? _trajectoryNature;
  String? _trajectoryNatureError;

  // Section 3: Appetite & Digestive Sensations
  final Set<String> _selectedAppetiteSensations = {};
  String? _appetiteSensationsError;

  // Section 4: Personal Vision
  final Set<String> _selectedGoals = {};
  String? _goalsError;
  final TextEditingController _otherGoalsController = TextEditingController();

  // Fallbacks
  final List<HealthyWeightGainOption> _defaultIntentionalOptions = [
    HealthyWeightGainOption(value: "yes", label: "Yes"),
    HealthyWeightGainOption(value: "no", label: "No"),
    HealthyWeightGainOption(value: "partly", label: "Partly"),
    HealthyWeightGainOption(value: "not_sure", label: "Not sure"),
  ];

  final List<HealthyWeightGainOption> _defaultTrajectoryOptions = [
    HealthyWeightGainOption(value: "planned", label: "Planned change"),
    HealthyWeightGainOption(value: "unplanned", label: "Unplanned change"),
    HealthyWeightGainOption(value: "fluctuating", label: "Fluctuating / Unstable"),
  ];

  final List<HealthyWeightGainOption> _defaultAppetiteSensations = [
    HealthyWeightGainOption(value: "low_appetite", label: "Low appetite"),
    HealthyWeightGainOption(value: "feel_full_quickly", label: "Feel full very quickly"),
    HealthyWeightGainOption(value: "difficulty_swallowing", label: "Difficulty swallowing"),
    HealthyWeightGainOption(value: "nausea", label: "Nausea"),
    HealthyWeightGainOption(value: "digestive_discomfort", label: "Digestive discomfort"),
    HealthyWeightGainOption(value: "none", label: "None of these"),
  ];

  final List<HealthyWeightGainOption> _defaultGoalsList = [
    HealthyWeightGainOption(value: "more_strength", label: "More strength"),
    HealthyWeightGainOption(value: "more_muscle", label: "More muscle"),
    HealthyWeightGainOption(value: "better_energy", label: "Better energy"),
    HealthyWeightGainOption(value: "improved_appetite", label: "Improved appetite"),
    HealthyWeightGainOption(value: "healthy_weight_restoration", label: "Healthy weight restoration"),
    HealthyWeightGainOption(value: "sports_performance", label: "Sports performance"),
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
        BlocProvider.of<HealthyWeightGainBloc>(context).add(
          UserGetHealthyWeightGainEvent(
            url: Urls.pathwaysProtocol(pathwayUuid: widget.pathwayUuid),
          ),
        );
      });
    }
  }

  void _populateAnswers(HealthyWeightGainAnswers? answers) {
    if (answers == null) return;

    if (answers.weightLossIntentional != null && answers.weightLossIntentional!.isNotEmpty) {
      _weightIntentionality = answers.weightLossIntentional;
    }

    if (answers.weightUnit != null && answers.weightUnit!.isNotEmpty) {
      _weightUnit = answers.weightUnit!;
      _isKgSelected = _weightUnit.toLowerCase() == "kg";
    }

    if (answers.startingWeight6m != null) {
      _startingWeightController.text = answers.startingWeight6m.toString();
    }

    if (answers.currentWeight != null) {
      _currentWeightController.text = answers.currentWeight.toString();
    }

    if (answers.trajectoryNature != null && answers.trajectoryNature!.isNotEmpty) {
      _trajectoryNature = answers.trajectoryNature;
    }

    if (answers.appetiteSensations != null && answers.appetiteSensations!.isNotEmpty) {
      _selectedAppetiteSensations.clear();
      _selectedAppetiteSensations.addAll(answers.appetiteSensations!);
    }

    if (answers.weightGainGoals != null && answers.weightGainGoals!.isNotEmpty) {
      _selectedGoals.clear();
      _selectedGoals.addAll(answers.weightGainGoals!);
    }

    if (answers.otherGoals != null && answers.otherGoals!.isNotEmpty) {
      _otherGoalsController.text = answers.otherGoals!;
    }
  }

  HealthyWeightGainFormField? _getField(String key) {
    try {
      return _fields.firstWhere((f) => f.key == key);
    } catch (_) {
      return null;
    }
  }

  bool _validate() {
    bool isValid = true;

    // Weight Intentionality
    final intentionalField = _getField("weight_loss_intentional");
    if ((intentionalField?.required ?? true) &&
        (_weightIntentionality == null || _weightIntentionality!.isEmpty)) {
      _weightIntentionalityError = "Required";
      isValid = false;
    } else {
      _weightIntentionalityError = null;
    }

    // Current Weight
    final currentWeightField = _getField("current_weight");
    if ((currentWeightField?.required ?? true) &&
        _currentWeightController.text.trim().isEmpty) {
      _currentWeightError = "Required";
      isValid = false;
    } else {
      _currentWeightError = null;
    }

    // Trajectory Nature
    final trajectoryField = _getField("trajectory_nature");
    if ((trajectoryField?.required ?? true) &&
        (_trajectoryNature == null || _trajectoryNature!.isEmpty)) {
      _trajectoryNatureError = "Required";
      isValid = false;
    } else {
      _trajectoryNatureError = null;
    }

    // Appetite Sensations
    final appetiteField = _getField("appetite_sensations");
    if ((appetiteField?.required ?? true) && _selectedAppetiteSensations.isEmpty) {
      _appetiteSensationsError = "Please select at least 1 sensation";
      isValid = false;
    } else {
      _appetiteSensationsError = null;
    }

    // Personal Vision Goals (max 3 allowed)
    final goalsField = _getField("weight_gain_goals");
    if ((goalsField?.required ?? true) && _selectedGoals.isEmpty) {
      _goalsError = "Please select at least 1 goal";
      isValid = false;
    } else {
      _goalsError = null;
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

    final HealthyWeightGainAnswers answers = HealthyWeightGainAnswers(
      weightLossIntentional: _weightIntentionality,
      weightUnit: _weightUnit,
      startingWeight6m: num.tryParse(_startingWeightController.text.trim()),
      currentWeight: num.tryParse(_currentWeightController.text.trim()),
      trajectoryNature: _trajectoryNature,
      appetiteSensations: _selectedAppetiteSensations.toList(),
      weightGainGoals: _selectedGoals.toList(),
      otherGoals: _otherGoalsController.text.trim().isNotEmpty ? _otherGoalsController.text.trim() : null,
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
    _startingWeightController.dispose();
    _currentWeightController.dispose();
    _otherGoalsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<HealthyWeightGainBloc, HealthyWeightGainState>(
          listener: (context, state) {
            if (state is HealthyWeightGainSuccess) {
              LoaderService.hide();
              _protocolData = state.model.data;
              _fields = state.model.data?.fields ?? [];
              _populateAnswers(state.model.data?.answers);
              setState(() {});
            } else if (state is HealthyWeightGainFailed) {
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
                message: state.model.message ?? 'Healthy Weight Gain Protocol Submitted!',
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
              _protocolData?.title ?? "Healthy Weight Gain Protocol",
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
              _buildIntentionalitySection(),
              const SizedBox(height: 24),
              _buildWeightTrajectorySection(),
              const SizedBox(height: 24),
              _buildAppetiteSensationsSection(),
              const SizedBox(height: 24),
              _buildPersonalVisionSection(),
              const SizedBox(height: 32),
              CommonButton(
                name: "Save & Submit Weight Gain Protocol",
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

  Widget _buildIntentionalitySection() {
    final intentionalField = _getField("weight_loss_intentional");
    final options = intentionalField?.options ?? _defaultIntentionalOptions;

    return ProfileSectionCard(
      title: intentionalField?.label ?? "Is your current low weight or recent weight loss intentional?",
      icon: appIcons.error,
      children: [
        buildRequiredLabel("Helps your care team tailor metabolic replenishment and caloric safety bounds.", color: const Color(0xFF534343)),
        const SizedBox(height: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: options.map((opt) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _buildRadioRow(opt),
            );
          }).toList(),
        ),
        if (_weightIntentionalityError != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 4),
            child: CommonText(_weightIntentionalityError!, style: TextStyle(color: appColors.red, fontSize: 12)),
          ),
        const SizedBox(height: 20),
        _buildClinicalPriorityNote(),
      ],
    );
  }

  Widget _buildRadioRow(HealthyWeightGainOption option) {
    final String val = option.value ?? "";
    final String label = option.label ?? val;
    bool isSelected = _weightIntentionality == val || _weightIntentionality?.toLowerCase() == label.toLowerCase();

    return GestureDetector(
      onTap: () {
        setState(() {
          _weightIntentionality = val;
          if (_weightIntentionalityError != null) _validate();
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
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
            CommonText(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? const Color(0xFF713439) : const Color(0xFF1D1B1A),
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

  Widget _buildClinicalPriorityNote() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFDADB).withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(appIcons.clinicalShield, height: 22, color: const Color(0xFF534343)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CommonText(
                  "CLINICAL PRIORITY NOTE",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF8B484D),
                    letterSpacing: 0.275,
                  ),
                ),
                const SizedBox(height: 4),
                const CommonText(
                  "Unplanned or unintentional weight shifts are flagged for compassionate clinical review by our medical nutritionist before protocol formulation to ensure complete hormonal and metabolic safety.",
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF534343),
                    height: 21.13 / 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeightTrajectorySection() {
    final trajectoryField = _getField("trajectory_nature");
    final trajectoryOptions = trajectoryField?.options ?? _defaultTrajectoryOptions;

    return ProfileSectionCard(
      title: "Six-Month Weight Trajectory",
      icon: appIcons.down,
      children: [
        buildRequiredLabel("How has your weight changed during the past six months?", color: const Color(0xFF534343)),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFFEDE7E5),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildUnitToggleBtn("Kilograms (kg)", _isKgSelected, () {
                    setState(() {
                      _isKgSelected = true;
                      _weightUnit = "kg";
                    });
                  }),
                  _buildUnitToggleBtn("Pounds (lbs)", !_isKgSelected, () {
                    setState(() {
                      _isKgSelected = false;
                      _weightUnit = "lbs";
                    });
                  }),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: const TextSpan(
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  fontFamily: fontFamilyPlusJakartaSans,
                ),
                children: [
                  TextSpan(
                    text: "Approximate Starting Weight (6 Months Ago)",
                    style: TextStyle(color: Color(0xFF1D1B1A)),
                  ),
                  TextSpan(
                    text: " Optional",
                    style: TextStyle(color: Color(0xFF9A8687)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            CommonTextField(
              label: "",
              controller: _startingWeightController,
              isRequired: false,
              isDense: true,
              borderColor: Colors.transparent,
              fillColor: const Color(0xFFF8F2F0),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [digitalWithDot],
              suffixText: _weightUnit.toUpperCase(),
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF1D1B1A)),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const CommonText("Current Weight", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1D1B1A))),
                const CommonText("Today", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF8B484D))),
              ],
            ),
            const SizedBox(height: 6),
            CommonTextField(
              label: "",
              controller: _currentWeightController,
              isRequired: false,
              isDense: true,
              borderColor: _currentWeightError != null ? appColors.red : Colors.transparent,
              fillColor: const Color(0xFFF8F2F0),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [digitalWithDot],
              suffixText: _weightUnit.toUpperCase(),
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF1D1B1A)),
              onChanged: (v) {
                setState(() {});
                if (_currentWeightError != null) _validate();
              },
            ),
            if (_currentWeightError != null)
              Padding(
                padding: const EdgeInsets.only(top: 4, left: 4),
                child: CommonText(_currentWeightError!, style: TextStyle(color: appColors.red, fontSize: 12)),
              ),
          ],
        ),
        const SizedBox(height: 20),
        const CommonText("Trajectory Nature", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1D1B1A))),
        const SizedBox(height: 10),
        Column(
          children: trajectoryOptions.map((opt) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _buildTrajectoryOption(opt),
            );
          }).toList(),
        ),
        if (_trajectoryNatureError != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 4),
            child: CommonText(_trajectoryNatureError!, style: TextStyle(color: appColors.red, fontSize: 12)),
          ),
      ],
    );
  }

  Widget _buildUnitToggleBtn(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF8B484D) : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
        ),
        child: CommonText(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected ? Colors.white : const Color(0xFF534343),
          ),
        ),
      ),
    );
  }

  Widget _buildTrajectoryOption(HealthyWeightGainOption option) {
    final String val = option.value ?? "";
    final String label = option.label ?? val;
    bool isSelected = _trajectoryNature == val || _trajectoryNature?.toLowerCase() == label.toLowerCase();

    return GestureDetector(
      onTap: () {
        setState(() {
          _trajectoryNature = val;
          if (_trajectoryNatureError != null) _validate();
        });
      },
      child: Container(
        padding: const EdgeInsets.all(14),
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
            CommonText(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? const Color(0xFF713439) : const Color(0xFF1D1B1A),
              ),
            ),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? const Color(0xFF8B484D) : Colors.white,
                border: isSelected ? null : Border.all(color: const Color(0xFF9A8687)),
              ),
              child: isSelected ? const Icon(Icons.check, size: 14, color: Colors.white) : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppetiteSensationsSection() {
    final appetiteField = _getField("appetite_sensations");
    final options = appetiteField?.options ?? _defaultAppetiteSensations;

    return ProfileSectionCard(
      title: "Appetite & Digestive Sensations",
      icon: appIcons.cup,
      children: [
        buildRequiredLabel("Select all sensations that currently affect your meal capacity", color: const Color(0xFF534343)),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((opt) {
            final String val = opt.value ?? "";
            final String label = opt.label ?? val;
            final bool isSelected = _selectedAppetiteSensations.contains(val) ||
                _selectedAppetiteSensations.contains(label);

            return _buildSelectionPill(
              label,
              isSelected,
              () {
                setState(() {
                  if (isSelected) {
                    _selectedAppetiteSensations.remove(val);
                    _selectedAppetiteSensations.remove(label);
                  } else {
                    if (val == "none" || label.toLowerCase() == "none of these") {
                      _selectedAppetiteSensations.clear();
                      _selectedAppetiteSensations.add(val);
                    } else {
                      _selectedAppetiteSensations.remove("none");
                      _selectedAppetiteSensations.remove("None of these");
                      _selectedAppetiteSensations.add(val);
                    }
                  }
                  if (_appetiteSensationsError != null) _validate();
                });
              },
            );
          }).toList(),
        ),
        if (_appetiteSensationsError != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: CommonText(_appetiteSensationsError!, style: TextStyle(color: appColors.red, fontSize: 12)),
          ),
      ],
    );
  }

  Widget _buildPersonalVisionSection() {
    final goalsField = _getField("weight_gain_goals");
    final options = goalsField?.options ?? _defaultGoalsList;
    final otherGoalsField = _getField("other_goals");

    return ProfileSectionCard(
      title: goalsField?.label ?? "What would healthy weight gain mean for you?",
      icon: appIcons.sparkle,
      children: [
        buildRequiredLabel("Select up to 3 core goals that will guide your nourishment curriculum:", color: const Color(0xFF534343)),
        const SizedBox(height: 16),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: options.map((opt) {
            final String val = opt.value ?? "";
            final String label = opt.label ?? val;
            final bool isSelected = _selectedGoals.contains(val) || _selectedGoals.contains(label);
            final double chipWidth = (MediaQuery.of(context).size.width - 40 - 40 - 10) / 2;

            return SizedBox(
              width: chipWidth,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      _selectedGoals.remove(val);
                      _selectedGoals.remove(label);
                    } else {
                      if (_selectedGoals.length < 3) {
                        _selectedGoals.add(val);
                      }
                    }
                    if (_goalsError != null) _validate();
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFFFFDADB).withValues(alpha: 0.4) : const Color(0xFFF8F2F0),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: CommonText(
                    label,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: isSelected ? const Color(0xFF713439) : const Color(0xFF1D1B1A),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        if (_goalsError != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: CommonText(_goalsError!, style: TextStyle(color: appColors.red, fontSize: 12)),
          ),
        const SizedBox(height: 20),
        RichText(
          text: TextSpan(
            style: const TextStyle(
              fontSize: 13,
              fontFamily: fontFamilyPlusJakartaSans,
            ),
            children: [
              TextSpan(
                text: otherGoalsField?.label ?? "Other specific personal goals",
                style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF1D1B1A)),
              ),
              const TextSpan(text: " (optional)", style: TextStyle(color: Color(0xFF857373))),
            ],
          ),
        ),
        const SizedBox(height: 8),
        CommonTextField(
          label: "",
          controller: _otherGoalsController,
          hint: "e.g., Feeling resilient and overcoming fatigue during afternoon work meetings...",
          maxLines: 4,
          borderColor: Colors.transparent,
          fillColor: const Color(0xFFF8F2F0),
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
          color: isSelected ? const Color(0xFFFFDADB) : const Color(0xFFF8F2F0),
          borderRadius: BorderRadius.circular(999),
        ),
        child: CommonText(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: isSelected ? const Color(0xFF713439) : const Color(0xFF534343),
          ),
        ),
      ),
    );
  }
}
