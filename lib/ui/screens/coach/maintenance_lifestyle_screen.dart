import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../main.dart';
import '../../../core/blocs/coach/maintenance_lifestyle/maintenance_lifestyle_bloc.dart';
import '../../../core/blocs/coach/maintenance_lifestyle/maintenance_lifestyle_event.dart';
import '../../../core/blocs/coach/maintenance_lifestyle/maintenance_lifestyle_state.dart';
import '../../../core/blocs/coach/save_protocol_form/save_protocol_form_bloc.dart';
import '../../../core/blocs/coach/save_protocol_form/save_protocol_form_event.dart';
import '../../../core/blocs/coach/save_protocol_form/save_protocol_form_state.dart';
import '../../../core/constants/urls.dart';
import '../../../core/constants/utils.dart';
import '../../../core/models/coach/maintenance_lifestyle_model.dart';
import '../../../core/services/loader_service.dart';
import '../../widgets/common_app_bar.dart';
import '../../widgets/common_button.dart';
import '../../widgets/common_text.dart';
import '../../widgets/common_text_field.dart';
import '../profile/widget/profile_section_card.dart';

class MaintenanceLifestyleScreen extends StatefulWidget {
  final String pathwayUuid;

  const MaintenanceLifestyleScreen({
    super.key,
    this.pathwayUuid = "",
  });

  @override
  State<MaintenanceLifestyleScreen> createState() => _MaintenanceLifestyleScreenState();
}

class _MaintenanceLifestyleScreenState extends State<MaintenanceLifestyleScreen> {
  MaintenanceLifestyleData? _protocolData;
  List<MaintenanceLifestyleFormField> _fields = [];

  // Section 1: Achieved Milestones
  final TextEditingController _milestonesController = TextEditingController();
  String? _milestonesError;

  // Section 2: Sustainable Equilibrium
  final TextEditingController _equilibriumController = TextEditingController();
  String? _equilibriumError;

  // Section 3: Maintenance Disruptions
  final Set<String> _selectedDisruptions = {};
  String? _disruptionsError;
  final TextEditingController _otherDisruptionsController = TextEditingController();

  // Section 4: Coaching Partnership
  final TextEditingController _partnershipController = TextEditingController();
  String? _partnershipError;

  final List<MaintenanceLifestyleOption> _defaultDisruptionsList = [
    MaintenanceLifestyleOption(value: "travel", label: "Travel"),
    MaintenanceLifestyleOption(value: "festivals_social", label: "Festivals or social events"),
    MaintenanceLifestyleOption(value: "work_pressure", label: "Work pressure"),
    MaintenanceLifestyleOption(value: "routine_changes", label: "Changes in routine"),
    MaintenanceLifestyleOption(value: "emotional_eating", label: "Emotional eating"),
    MaintenanceLifestyleOption(value: "poor_sleep", label: "Poor sleep"),
    MaintenanceLifestyleOption(value: "reduced_exercise", label: "Reduced exercise"),
    MaintenanceLifestyleOption(value: "meal_planning", label: "Meal planning"),
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
        BlocProvider.of<MaintenanceLifestyleBloc>(context).add(
          UserGetMaintenanceLifestyleEvent(
            url: Urls.pathwaysProtocol(pathwayUuid: widget.pathwayUuid),
          ),
        );
      });
    }
  }

  void _populateAnswers(MaintenanceLifestyleAnswers? answers) {
    if (answers == null) return;

    if (answers.achievedMilestones != null && answers.achievedMilestones!.isNotEmpty) {
      _milestonesController.text = answers.achievedMilestones!;
    }

    if (answers.sustainableEquilibrium != null && answers.sustainableEquilibrium!.isNotEmpty) {
      _equilibriumController.text = answers.sustainableEquilibrium!;
    }

    if (answers.maintenanceDisruptions != null && answers.maintenanceDisruptions!.isNotEmpty) {
      _selectedDisruptions.clear();
      _selectedDisruptions.addAll(answers.maintenanceDisruptions!);
    }

    if (answers.otherDisruption != null && answers.otherDisruption!.isNotEmpty) {
      _otherDisruptionsController.text = answers.otherDisruption!;
    }

    if (answers.coachingPartnership != null && answers.coachingPartnership!.isNotEmpty) {
      _partnershipController.text = answers.coachingPartnership!;
    }
  }

  MaintenanceLifestyleFormField? _getField(String key) {
    try {
      return _fields.firstWhere((f) => f.key == key);
    } catch (_) {
      return null;
    }
  }

  List<String> _getOptionValues(Set<String> selectedSet, List<MaintenanceLifestyleOption> options) {
    return selectedSet.map((item) {
      final found = options.firstWhere(
        (o) => o.value == item || o.label?.toLowerCase() == item.toLowerCase(),
        orElse: () => MaintenanceLifestyleOption(value: item),
      );
      return found.value ?? item;
    }).toList();
  }

  bool _validate() {
    bool isValid = true;

    final milestonesField = _getField("achieved_milestones");
    if ((milestonesField?.required ?? true) && _milestonesController.text.trim().isEmpty) {
      _milestonesError = "Required";
      isValid = false;
    } else {
      _milestonesError = null;
    }

    final equilibriumField = _getField("sustainable_equilibrium");
    if ((equilibriumField?.required ?? true) && _equilibriumController.text.trim().isEmpty) {
      _equilibriumError = "Required";
      isValid = false;
    } else {
      _equilibriumError = null;
    }

    final disruptionsField = _getField("maintenance_disruptions");
    if ((disruptionsField?.required ?? true) && _selectedDisruptions.isEmpty) {
      _disruptionsError = "Please select at least 1 disruption";
      isValid = false;
    } else {
      _disruptionsError = null;
    }

    final partnershipField = _getField("coaching_partnership");
    if ((partnershipField?.required ?? true) && _partnershipController.text.trim().isEmpty) {
      _partnershipError = "Required";
      isValid = false;
    } else {
      _partnershipError = null;
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

    final disruptionsField = _getField("maintenance_disruptions");

    final MaintenanceLifestyleAnswers answers = MaintenanceLifestyleAnswers(
      achievedMilestones: _milestonesController.text.trim().isNotEmpty
          ? _milestonesController.text.trim()
          : null,
      sustainableEquilibrium: _equilibriumController.text.trim().isNotEmpty
          ? _equilibriumController.text.trim()
          : null,
      maintenanceDisruptions: _getOptionValues(_selectedDisruptions, disruptionsField?.options ?? _defaultDisruptionsList),
      otherDisruption: _otherDisruptionsController.text.trim().isNotEmpty
          ? _otherDisruptionsController.text.trim()
          : null,
      coachingPartnership: _partnershipController.text.trim().isNotEmpty
          ? _partnershipController.text.trim()
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
    _milestonesController.dispose();
    _equilibriumController.dispose();
    _otherDisruptionsController.dispose();
    _partnershipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<MaintenanceLifestyleBloc, MaintenanceLifestyleState>(
          listener: (context, state) {
            if (state is MaintenanceLifestyleSuccess) {
              LoaderService.hide();
              _protocolData = state.model.data;
              _fields = state.model.data?.fields ?? [];
              _populateAnswers(state.model.data?.answers);
              setState(() {});
            } else if (state is MaintenanceLifestyleFailed) {
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
                message: state.model.message ?? 'Maintenance & Lifestyle Management Submitted!',
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
              _protocolData?.title ?? "Maintenance and Lifestyle Management",
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
        ),
      ),
    );
  }

  Widget _buildMilestonesSection() {
    final milestonesField = _getField("achieved_milestones");

    return ProfileSectionCard(
      title: "Achieved Milestones",
      icon: appIcons.achieved,
      children: [
        buildRequiredLabel(
          milestonesField?.label ?? "What progress have you already made, and for how long have you maintained it?",
          color: const Color(0xFF534343),
        ),
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
    final equilibriumField = _getField("sustainable_equilibrium");

    return ProfileSectionCard(
      title: "Sustainable Equilibrium",
      icon: appIcons.sustainable,
      children: [
        buildRequiredLabel(
          equilibriumField?.label ?? "What weight, measurement or routine range feels sustainable for you?",
          color: const Color(0xFF1D1B1A),
        ),
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
    final disruptionsField = _getField("maintenance_disruptions");
    final options = disruptionsField?.options ?? _defaultDisruptionsList;
    final otherField = _getField("other_disruption");

    return ProfileSectionCard(
      title: "Maintenance Disruptions",
      icon: appIcons.upStick,
      children: [
        buildRequiredLabel(
          disruptionsField?.label ?? "Which situations make maintenance most difficult? Select maximum up to 3",
          color: const Color(0xFF1D1B1A),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((opt) {
            final String val = opt.value ?? "";
            final String label = opt.label ?? val;
            final bool isSelected = _selectedDisruptions.contains(val) || _selectedDisruptions.contains(label);

            return _buildSelectionPill(
              label,
              isSelected,
              () {
                setState(() {
                  if (isSelected) {
                    _selectedDisruptions.remove(val);
                    _selectedDisruptions.remove(label);
                  } else {
                    if (_selectedDisruptions.length < 3) {
                      _selectedDisruptions.add(val);
                    }
                  }
                  if (_disruptionsError != null) _validate();
                });
              },
            );
          }).toList(),
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
          hint: "${otherField?.label ?? 'Other specific situation'} (optional)...",
          borderColor: Colors.transparent,
          fillColor: const Color(0xFFF8F2F0),
        ),
      ],
    );
  }

  Widget _buildPartnershipSection() {
    final partnershipField = _getField("coaching_partnership");

    return ProfileSectionCard(
      title: "Coaching Partnership",
      icon: appIcons.partnership,
      children: [
        buildRequiredLabel(
          partnershipField?.label ?? "What support would help you stay consistent without feeling controlled by a plan?",
          color: const Color(0xFF1D1B1A),
        ),
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
