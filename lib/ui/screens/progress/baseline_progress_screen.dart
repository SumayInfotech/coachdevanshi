import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../main.dart';
import '../../../core/blocs/home/dashboard/dashboard_bloc.dart';
import '../../../core/blocs/progress/save_weekly_checkin/save_weekly_checkin_bloc.dart';
import '../../../core/blocs/progress/weekly_checkin/weekly_checkin_bloc.dart';
import '../../../core/constants/urls.dart';
import '../../../core/constants/utils.dart';
import '../../../core/models/progress/weekly_checkin_model.dart';
import '../../../core/services/loader_service.dart';
import '../../widgets/common_app_bar.dart';
import '../../widgets/common_button.dart';
import '../../widgets/common_text.dart';
import '../../widgets/common_text_field.dart';
import '../bottom_bar_screen.dart';
import '../profile/widget/profile_section_card.dart';
import 'track_weekly_progress_screen.dart';

class BaselineProgressScreen extends StatefulWidget {
  const BaselineProgressScreen({super.key});

  @override
  State<BaselineProgressScreen> createState() => _BaselineProgressScreenState();
}

class _BaselineProgressScreenState extends State<BaselineProgressScreen> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _chestController = TextEditingController();
  final TextEditingController _abdomenController = TextEditingController();
  final TextEditingController _hipController = TextEditingController();

  // Weekly Reflections Controllers
  final TextEditingController _selfConfidenceController = TextEditingController();
  final TextEditingController _periodStartController = TextEditingController();
  final TextEditingController _cycleLengthController = TextEditingController();
  final TextEditingController _cycleNotesController = TextEditingController();
  final TextEditingController _cravingFoodController = TextEditingController();
  final TextEditingController _travelDetailsController = TextEditingController();
  final TextEditingController _weeklyWinsController = TextEditingController();
  final TextEditingController _proudMomentsController = TextEditingController();
  final TextEditingController _obstaclesController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  DateTime? _selectedPeriodDate;
  String? _dateError;
  String? _weightError;
  String? _chestError;
  String? _abdomenError;
  String? _hipError;
  String? _selfConfidenceError;
  String? _cravingLevelError;
  String? _weeklyWinsError;
  String? _proudMomentsError;
  String? _obstaclesError;

  bool _isKgSelected = true;
  bool _isChestCmSelected = true;
  bool _isAbdomenCmSelected = true;
  bool _isHipCmSelected = true;

  String? _selectedCravingLevel;
  bool _didTravel = true;

  @override
  void initState() {
    super.initState();
    _dateController.text = DateFormat('MMMM dd, yyyy').format(_selectedDate);
    callWeeklyCheckinAPI();
  }

  void callWeeklyCheckinAPI() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      LoaderService.show(context);
      final String dateStr = DateFormat('yyyy-MM-dd').format(_selectedDate);
      BlocProvider.of<WeeklyCheckinBloc>(context).add(
        UserWeeklyCheckinEvent(url: Urls.weeklyCheck(date: dateStr)),
      );
    });
  }

  void _populateFromWeeklyCheckin(WeeklyCheckinModel model) {
    final data = model.data;
    if (data == null) {
      _clearForm();
      return;
    }

    if (data.recordDate != null && data.recordDate!.isNotEmpty) {
      try {
        _selectedDate = DateFormat('yyyy-MM-dd').parse(data.recordDate!);
        _dateController.text = DateFormat('MMMM dd, yyyy').format(_selectedDate);
      } catch (_) {}
    }

    if (data.weight != null) {
      _weightController.text = data.weight.toString();
    } else {
      _weightController.clear();
    }

    if (data.weightUnit != null) {
      _isKgSelected = data.weightUnit?.toLowerCase() == "kg";
    }

    if (data.measurements != null) {
      _chestController.text = data.measurements?.chest != null ? data.measurements!.chest.toString() : "";
      _abdomenController.text = data.measurements?.abdomen != null ? data.measurements!.abdomen.toString() : "";
      _hipController.text = data.measurements?.hip != null ? data.measurements!.hip.toString() : "";

      if (data.measurements?.unit != null) {
        final isCm = data.measurements?.unit?.toLowerCase() == "cm";
        _isChestCmSelected = isCm;
        _isAbdomenCmSelected = isCm;
        _isHipCmSelected = isCm;
      }
    } else {
      _chestController.clear();
      _abdomenController.clear();
      _hipController.clear();
    }

    _selfConfidenceController.text = data.selfConfidence ?? "";

    if (data.lastPeriodStart != null && data.lastPeriodStart!.isNotEmpty) {
      try {
        _selectedPeriodDate = DateFormat('yyyy-MM-dd').parse(data.lastPeriodStart!);
        _periodStartController.text = DateFormat('MM/dd/yyyy').format(_selectedPeriodDate!);
      } catch (_) {
        _periodStartController.text = data.lastPeriodStart!;
      }
    } else {
      _selectedPeriodDate = null;
      _periodStartController.clear();
    }

    _cycleLengthController.text = data.cycleDay ?? "";
    _cycleNotesController.text = data.cycleNotes ?? "";

    if (data.cravingsLevel != null) {
      final level = data.cravingsLevel!.toLowerCase();
      if (level.contains("none")) {
        _selectedCravingLevel = "None / Calm";
      } else if (level.contains("mild")) {
        _selectedCravingLevel = "Mild & manageable";
      } else if (level.contains("moderate")) {
        _selectedCravingLevel = "Moderate";
      } else if (level.contains("intense")) {
        _selectedCravingLevel = "Intense / late evening";
      } else {
        _selectedCravingLevel = data.cravingsLevel;
      }
    } else {
      _selectedCravingLevel = null;
    }

    _cravingFoodController.text = data.cravingsNotes ?? "";
    _didTravel = data.travelled ?? true;
    _travelDetailsController.text = data.travelNotes ?? "";
    _weeklyWinsController.text = data.wins ?? "";
    _proudMomentsController.text = data.proudMoments ?? "";
    _obstaclesController.text = data.struggles ?? "";
    _notesController.text = data.notes ?? "";

    setState(() {});
  }

  void _clearForm() {
    _weightController.clear();
    _chestController.clear();
    _abdomenController.clear();
    _hipController.clear();
    _selfConfidenceController.clear();
    _periodStartController.clear();
    _selectedPeriodDate = null;
    _cycleLengthController.clear();
    _cycleNotesController.clear();
    _selectedCravingLevel = null;
    _cravingFoodController.clear();
    _didTravel = true;
    _travelDetailsController.clear();
    _weeklyWinsController.clear();
    _proudMomentsController.clear();
    _obstaclesController.clear();
    _notesController.clear();
    _isKgSelected = true;
    _isChestCmSelected = true;
    _isAbdomenCmSelected = true;
    _isHipCmSelected = true;
    setState(() {});
  }

  bool _validate() {
    bool isValid = true;

    if (_dateController.text.trim().isEmpty) {
      _dateError = "Date is required";
      isValid = false;
    } else {
      _dateError = null;
    }

    if (_weightController.text.trim().isEmpty) {
      _weightError = "Weight is required";
      isValid = false;
    } else {
      _weightError = null;
    }

    if (_chestController.text.trim().isEmpty) {
      _chestError = "Chest measurement is required";
      isValid = false;
    } else {
      _chestError = null;
    }

    if (_abdomenController.text.trim().isEmpty) {
      _abdomenError = "Abdomen measurement is required";
      isValid = false;
    } else {
      _abdomenError = null;
    }

    if (_hipController.text.trim().isEmpty) {
      _hipError = "Hip measurement is required";
      isValid = false;
    } else {
      _hipError = null;
    }

    if (_selfConfidenceController.text.trim().isEmpty) {
      _selfConfidenceError = "Self-confidence reflection is required";
      isValid = false;
    } else {
      _selfConfidenceError = null;
    }

    if (_selectedCravingLevel == null) {
      _cravingLevelError = "Please select cravings level";
      isValid = false;
    } else {
      _cravingLevelError = null;
    }

    if (_weeklyWinsController.text.trim().isEmpty) {
      _weeklyWinsError = "Weekly win or positive outcome is required";
      isValid = false;
    } else {
      _weeklyWinsError = null;
    }

    if (_proudMomentsController.text.trim().isEmpty) {
      _proudMomentsError = "Proud moment reflection is required";
      isValid = false;
    } else {
      _proudMomentsError = null;
    }

    if (_obstaclesController.text.trim().isEmpty) {
      _obstaclesError = "Weekly obstacle or struggle is required";
      isValid = false;
    } else {
      _obstaclesError = null;
    }

    setState(() {});
    return isValid;
  }

  void _onSave() {
    if (_validate()) {
      LoaderService.show(context);

      String? cravingsLevel;
      if (_selectedCravingLevel != null) {
        final lower = _selectedCravingLevel!.toLowerCase();
        if (lower.contains("none")) {
          cravingsLevel = "none";
        } else if (lower.contains("mild")) {
          cravingsLevel = "mild";
        } else if (lower.contains("moderate")) {
          cravingsLevel = "moderate";
        } else if (lower.contains("intense")) {
          cravingsLevel = "intense";
        } else {
          cravingsLevel = lower;
        }
      }

      final double? weightVal = double.tryParse(_weightController.text.trim());
      final double? chestVal = double.tryParse(_chestController.text.trim());
      final double? abdomenVal = double.tryParse(_abdomenController.text.trim());
      final double? hipVal = double.tryParse(_hipController.text.trim());
      final String? lastPeriodDate = _selectedPeriodDate != null
          ? DateFormat('yyyy-MM-dd').format(_selectedPeriodDate!)
          : null;
      final String? cycleDay = _cycleLengthController.text.trim().isNotEmpty
          ? _cycleLengthController.text.trim()
          : null;
      final String? cravingsNotes = _cravingFoodController.text.trim().isNotEmpty
          ? _cravingFoodController.text.trim()
          : null;
      final String? travelNotes = _travelDetailsController.text.trim().isNotEmpty
          ? _travelDetailsController.text.trim()
          : null;
      final String? notes = _notesController.text.trim().isNotEmpty
          ? _notesController.text.trim()
          : null;

      final Map<String, dynamic> body = {
        "record_date": DateFormat('yyyy-MM-dd').format(_selectedDate),
        "weight": ?weightVal,
        "weight_unit": _isKgSelected ? "kg" : "lbs",
        "chest": ?chestVal,
        "abdomen": ?abdomenVal,
        "waist": ?abdomenVal,
        "hip": ?hipVal,
        "measurement_unit": _isChestCmSelected ? "cm" : "in",
        "self_confidence": _selfConfidenceController.text.trim(),
        "last_period_start": ?lastPeriodDate,
        "cycle_day": ?cycleDay,
        "cravings_level": ?cravingsLevel,
        "cravings_notes": ?cravingsNotes,
        "travelled": _didTravel,
        "travel_notes": ?travelNotes,
        "wins": _weeklyWinsController.text.trim(),
        "proud_moments": _proudMomentsController.text.trim(),
        "struggles": _obstaclesController.text.trim(),
        "notes": ?notes,
      };

      BlocProvider.of<SaveWeeklyCheckinBloc>(context).add(
        UserSaveWeeklyCheckinEvent(
          url: Urls.weeklyCheckins,
          body: body,
        ),
      );
    }
  }

  @override
  void dispose() {
    _dateController.dispose();
    _weightController.dispose();
    _chestController.dispose();
    _abdomenController.dispose();
    _hipController.dispose();

    _selfConfidenceController.dispose();
    _periodStartController.dispose();
    _cycleLengthController.dispose();
    _cycleNotesController.dispose();
    _cravingFoodController.dispose();
    _travelDetailsController.dispose();
    _weeklyWinsController.dispose();
    _proudMomentsController.dispose();
    _obstaclesController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _onBack() {
    if (Navigator.canPop(context)) {
      navigation.pop(context);
    } else {
      bottomPageController.jumpToPage(BottomBarScreenIndex.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<WeeklyCheckinBloc, WeeklyCheckinState>(
          listener: (context, state) {
            if (state is WeeklyCheckinSuccess) {
              LoaderService.hide();
              _populateFromWeeklyCheckin(state.model);
            } else if (state is WeeklyCheckinFailed) {
              LoaderService.hide();
              _clearForm();
            }
          },
        ),
        BlocListener<SaveWeeklyCheckinBloc, SaveWeeklyCheckinState>(
          listener: (context, state) {
            if (state is SaveWeeklyCheckinSuccess) {
              LoaderService.hide();
              showSnackBar(
                context: context,
                isError: false,
                message: state.model.message ?? "Weekly check-in saved successfully",
              );
              BlocProvider.of<DashboardBloc>(context).add(
                const UserDashboardEvent(url: Urls.dashboard),
              );
              navigation.pushSlideAnimation(context, const TrackWeeklyProgressScreen());
            } else if (state is SaveWeeklyCheckinFailed) {
              LoaderService.hide();
              showSnackBar(
                context: context,
                isError: true,
                message: state.message,
              );
            }
          },
        ),
      ],
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          _onBack();
        },
        child: Scaffold(
          backgroundColor: appColors.bgColor,
          appBar: CommonAppBar(
            appBarColor: appColors.bgColor.withValues(alpha: 0.85),
            centerTitle: true,
            leading: buildInkWell(
              onTap: _onBack,
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
              "Baseline & Progress",
              fontFamily: fontPlayfairDisplay,
              style: TextStyle(
                fontSize: 18,
                color: Color(0xFF1D1B1A),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            children: [
              // Measurement Date
              _buildDateSection(),
              const SizedBox(height: 24),

              // Section 1: Physical Measurements
              const CommonText(
                "Physical Measurements",
                fontFamily: fontPlayfairDisplay,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1D1B1A),
                ),
              ),
              const SizedBox(height: 4),
              const CommonText(
                "Take readings in the morning before meals for highest consistency.",
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF534343),
                ),
                fontFamily: fontFamilyPlusJakartaSans,
              ),
              const SizedBox(height: 16),

              // Weight Card
              _buildWeightSection(),
              const SizedBox(height: 16),

              // Chest Card
              _buildChestSection(),
              const SizedBox(height: 16),

              // Abdomen Card
              _buildAbdomenSection(),
              const SizedBox(height: 16),

              // Hip Card
              _buildHipSection(),
              const SizedBox(height: 28),

              // Section 2: Weekly Reflections
              const CommonText(
                "Weekly Reflections",
                fontFamily: fontPlayfairDisplay,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1D1B1A),
                ),
              ),
              const SizedBox(height: 4),
              const CommonText(
                "How your body, mind, and habits felt over the past 7 days.",
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF534343),
                ),
                fontFamily: fontFamilyPlusJakartaSans,
              ),
              const SizedBox(height: 16),

              // Self-Confidence & Body Relationship
              _buildSelfConfidenceSection(),
              const SizedBox(height: 16),

              // Menstrual Cycle Dynamics
              _buildMenstrualCycleSection(),
              const SizedBox(height: 16),

              // Cravings & Food Sensations
              _buildCravingsSection(),
              const SizedBox(height: 16),

              // Travel & Routine Shifts
              _buildTravelSection(),
              const SizedBox(height: 16),

              // Weekly Wins & Positive Outcomes
              _buildWeeklyWinsSection(),
              const SizedBox(height: 16),

              // Proud Moments to Celebrate
              _buildProudMomentsSection(),
              const SizedBox(height: 16),

              // Weekly Obstacles & Struggles
              _buildObstaclesSection(),
              const SizedBox(height: 16),

              // Notes or Remarks
              _buildNotesSection(),
              const SizedBox(height: 32),

              // Submit Button
              CommonButton(
                name: "Save & Submit Check-in",
                icon: Icons.arrow_forward_rounded,
                isIconFirst: false,
                imageSize: 16,
                btnColor: appColors.primary,
                radius: 999,
                fontSize: 14,
                fontWeight: FontWeight.w700,
                onTap: _onSave,
              ),
              SizedBox(height: bottomPadding(context) + 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToggleRow(
    String labelLeft,
    String labelRight,
    bool isLeftSelected,
    ValueChanged<bool> onChanged,
  ) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => onChanged(true),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: isLeftSelected ? const Color(0xFFFFDADB) : appColors.textFieldBgColor,
                borderRadius: BorderRadius.circular(999),
              ),
              child: CommonText(
                labelLeft,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isLeftSelected ? const Color(0xFF3A0910) : const Color(0xFF534343),
                ),
                fontFamily: fontFamilyPlusJakartaSans,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: GestureDetector(
            onTap: () => onChanged(false),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: !isLeftSelected ? const Color(0xFFFFDADB) : appColors.textFieldBgColor,
                borderRadius: BorderRadius.circular(999),
              ),
              child: CommonText(
                labelRight,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: !isLeftSelected ? const Color(0xFF3A0910) : const Color(0xFF534343),
                ),
                fontFamily: fontFamilyPlusJakartaSans,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextArea({
    required TextEditingController controller,
    required String hint,
    int minLines = 3,
    int maxLines = 4,
    String? error,
    ValueChanged<String>? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: appColors.textFieldBgColor,
            borderRadius: BorderRadius.circular(12),
            border: error != null ? Border.all(color: appColors.red) : null,
          ),
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            minLines: minLines,
            onChanged: onChanged,
            style: TextStyle(
              fontSize: 13,
              color: const Color(0xFF1D1B1A),
              fontFamily: fontFamilyPlusJakartaSans,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hint,
              hintStyle: const TextStyle(
                fontSize: 13,
                color: Color(0xFF857373),
              ),
              isDense: true,
            ),
          ),
        ),
        if (error != null)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 4),
            child: CommonText(
              error,
              style: TextStyle(color: appColors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('MMMM dd, yyyy').format(picked);
        if (_dateError != null) _validate();
      });
      callWeeklyCheckinAPI();
    }
  }

  Future<void> _selectPeriodDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedPeriodDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedPeriodDate = picked;
        _periodStartController.text = DateFormat('MM/dd/yyyy').format(picked);
      });
    }
  }

  Widget _buildDateSection() {
    return ProfileSectionCard(
      title: "Measurement Date",
      icon: appIcons.calender,
      children: [
        buildRequiredLabel("Date of record"),
        const SizedBox(height: 8),
        CommonTextField(
          label: '',
          controller: _dateController,
          hint: "October 24, 2024",
          fillColor: appColors.textFieldBgColor,
          borderColor: Colors.transparent,
          readOnly: true,
          onTap: () => _selectDate(context),
          suffixIcon: IconButton(
            icon: Icon(Icons.edit_calendar_outlined, size: 18, color: appColors.primary),
            onPressed: () => _selectDate(context),
          ),
          error: _dateError,
        ),
      ],
    );
  }

  Widget _buildWeightSection() {
    return ProfileSectionCard(
      title: "Weight *",
      icon: appIcons.weight,
      children: [
        _buildToggleRow("kg", "lbs", _isKgSelected, (v) => setState(() => _isKgSelected = v)),
        const SizedBox(height: 12),
        CommonTextField(
          label: '',
          controller: _weightController,
          hint: "e.g., 68.4",
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          fillColor: appColors.textFieldBgColor,
          borderColor: Colors.transparent,
          error: _weightError,
          onChanged: (v) {
            if (_weightError != null) _validate();
          },
        ),
      ],
    );
  }

  Widget _buildChestSection() {
    return ProfileSectionCard(
      title: "Chest",
      icon: appIcons.measurement,
      children: [
        buildRequiredLabel("Measure across the fullest part of the chest with relaxed posture."),
        const SizedBox(height: 10),
        _buildToggleRow("cm", "in", _isChestCmSelected, (v) => setState(() => _isChestCmSelected = v)),
        const SizedBox(height: 12),
        CommonTextField(
          label: '',
          controller: _chestController,
          hint: "e.g., 92.5",
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          fillColor: appColors.textFieldBgColor,
          borderColor: Colors.transparent,
          error: _chestError,
          onChanged: (v) {
            if (_chestError != null) _validate();
          },
        ),
      ],
    );
  }

  Widget _buildAbdomenSection() {
    return ProfileSectionCard(
      title: "Abdomen at Navel",
      icon: appIcons.healthyWeightGain,
      children: [
        buildRequiredLabel("Measure directly across your belly button without holding your breath."),
        const SizedBox(height: 10),
        _buildToggleRow("cm", "in", _isAbdomenCmSelected, (v) => setState(() => _isAbdomenCmSelected = v)),
        const SizedBox(height: 12),
        CommonTextField(
          label: '',
          controller: _abdomenController,
          hint: "e.g., 84.0",
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          fillColor: appColors.textFieldBgColor,
          borderColor: Colors.transparent,
          error: _abdomenError,
          onChanged: (v) {
            if (_abdomenError != null) _validate();
          },
        ),
      ],
    );
  }

  Widget _buildHipSection() {
    return ProfileSectionCard(
      title: "Hip",
      icon: appIcons.abdomen,
      children: [
        buildRequiredLabel("Stand with feet together and measure around the widest part of your hips."),
        const SizedBox(height: 10),
        _buildToggleRow("cm", "in", _isHipCmSelected, (v) => setState(() => _isHipCmSelected = v)),
        const SizedBox(height: 12),
        CommonTextField(
          label: '',
          controller: _hipController,
          hint: "e.g., 99.0",
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          fillColor: appColors.textFieldBgColor,
          borderColor: Colors.transparent,
          error: _hipError,
          onChanged: (v) {
            if (_hipError != null) _validate();
          },
        ),
      ],
    );
  }

  Widget _buildSelfConfidenceSection() {
    return ProfileSectionCard(
      title: "Self-Confidence & Body Relationship",
      fontSize: 14,
      icon: appIcons.smile,
      children: [
        buildRequiredLabel("Self Confidence / How you feel about yourselves / How clothes fit"),
        const SizedBox(height: 10),
        _buildTextArea(
          controller: _selfConfidenceController,
          hint: "e.g., Feeling significantly lighter around the waist, favourite linen trousers fit comfortably without pinching, feeling calm and confident in social gatherings",
          error: _selfConfidenceError,
          onChanged: (v) {
            if (_selfConfidenceError != null) _validate();
          },
        ),
      ],
    );
  }

  Widget _buildMenstrualCycleSection() {
    return ProfileSectionCard(
      title: "Menstrual Cycle Dynamics",
      fontSize: 14,
      icon: appIcons.calender,
      children: [
        const CommonText(
          "Menstrual Cycle if applicable (And Date and length)",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1D1B1A),
          ),
          fontFamily: fontFamilyPlusJakartaSans,
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CommonText(
                    "Last Period Start",
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFF534343),
                    ),
                    fontFamily: fontFamilyPlusJakartaSans,
                  ),
                  const SizedBox(height: 4),
                  CommonTextField(
                    label: '',
                    controller: _periodStartController,
                    hint: "mm/dd/yyyy",
                    fillColor: appColors.textFieldBgColor,
                    borderColor: Colors.transparent,
                    readOnly: true,
                    onTap: () => _selectPeriodDate(context),
                    suffixIcon: IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: Icon(
                        Icons.calendar_today_outlined,
                        size: 16,
                        color: appColors.primary,
                      ),
                      onPressed: () => _selectPeriodDate(context),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CommonText(
                    "Cycle Day / Length",
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFF534343),
                    ),
                    fontFamily: fontFamilyPlusJakartaSans,
                  ),
                  const SizedBox(height: 4),
                  CommonTextField(
                    label: '',
                    controller: _cycleLengthController,
                    hint: "e.g., Day 14 (28d)",
                    fillColor: appColors.textFieldBgColor,
                    borderColor: Colors.transparent,
                    keyboardType: .number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        CommonTextField(
          label: '',
          controller: _cycleNotesController,
          hint: "e.g., Cycle started on 22nd, mild fatigue for 2",
          fillColor: appColors.textFieldBgColor,
          borderColor: Colors.transparent,
        ),
      ],
    );
  }

  Widget _buildCravingsSection() {
    final levels = [
      "None / Calm",
      "Mild & manageable",
      "Moderate",
      "Intense / late evening",
    ];

    return ProfileSectionCard(
      title: "Cravings & Food Sensations",
      fontSize: 14,
      icon: appIcons.foodDigestion,
      children: [
        buildRequiredLabel("Cravings level and food you crave for"),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: levels.map((level) {
            final isSelected = _selectedCravingLevel == level;
            return GestureDetector(
              onTap: () => setState(() {
                _selectedCravingLevel = level;
                if (_cravingLevelError != null) _validate();
              }),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFFFFDADB) : appColors.textFieldBgColor,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: CommonText(
                  level,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? const Color(0xFF3A0910) : const Color(0xFF534343),
                  ),
                  fontFamily: fontFamilyPlusJakartaSans,
                ),
              ),
            );
          }).toList(),
        ),
        if (_cravingLevelError != null)
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 4),
            child: CommonText(
              _cravingLevelError!,
              style: TextStyle(color: appColors.red, fontSize: 12),
            ),
          ),
        const SizedBox(height: 10),
        CommonTextField(
          label: '',
          controller: _cravingFoodController,
          hint: "e.g., Craved warm dark chocolate around 4 PM",
          fillColor: appColors.textFieldBgColor,
          borderColor: Colors.transparent,
        ),
      ],
    );
  }

  Widget _buildTravelSection() {
    return ProfileSectionCard(
      title: "Travel & Routine Shifts",
      fontSize: 14,
      iconData: Icons.flight_takeoff_rounded,
      children: [
        buildRequiredLabel("Did you travel this week?"),
        const SizedBox(height: 10),
        _buildToggleRow(
          "No, stayed local",
          "Yes, travelled",
          !_didTravel,
          (v) => setState(() => _didTravel = !v),
        ),
        const SizedBox(height: 10),
        CommonTextField(
          label: '',
          controller: _travelDetailsController,
          hint: "e.g., 2-day work travel to Mumbai, stayed hyd",
          fillColor: appColors.textFieldBgColor,
          borderColor: Colors.transparent,
        ),
      ],
    );
  }

  Widget _buildWeeklyWinsSection() {
    return ProfileSectionCard(
      title: "Weekly Wins & Positive Outcomes",
      fontSize: 14,
      iconData: Icons.emoji_events_outlined,
      children: [
        buildRequiredLabel("List at least one success or positive outcome of this week"),
        const SizedBox(height: 10),
        _buildTextArea(
          controller: _weeklyWinsController,
          hint: "e.g., Honored my morning hydration ritual every single day, took 15-minute post-dinner walks without skipping",
          error: _weeklyWinsError,
          onChanged: (v) {
            if (_weeklyWinsError != null) _validate();
          },
        ),
      ],
    );
  }

  Widget _buildProudMomentsSection() {
    return ProfileSectionCard(
      title: "Proud Moments to Celebrate",
      fontSize: 14,
      iconData: Icons.celebration_outlined,
      children: [
        buildRequiredLabel("Anything amazing you did this week which made you feel proud on your self and want to share"),
        const SizedBox(height: 10),
        _buildTextArea(
          controller: _proudMomentsController,
          hint: "e.g., Paused before eating during a hectic team lunch and ate mindfully without guilt or rush...",
          error: _proudMomentsError,
          onChanged: (v) {
            if (_proudMomentsError != null) _validate();
          },
        ),
      ],
    );
  }

  Widget _buildObstaclesSection() {
    return ProfileSectionCard(
      title: "Weekly Obstacles & Struggles",
      fontSize: 14,
      icon: appIcons.flag,
      children: [
        buildRequiredLabel("List at least one thing you have struggled for this week"),
        const SizedBox(height: 10),
        _buildTextArea(
          controller: _obstaclesController,
          hint: "e.g., Late client call pushed dinner past 9:30 PM, making digestion feel slightly sluggish the next morning...",
          error: _obstaclesError,
          onChanged: (v) {
            if (_obstaclesError != null) _validate();
          },
        ),
      ],
    );
  }

  Widget _buildNotesSection() {
    return ProfileSectionCard(
      title: "Notes or Remarks",
      fontSize: 14,
      icon: appIcons.edit,
      children: [
        const CommonText(
          "(Anything else that you want me to know)",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color(0xFF534343),
          ),
          fontFamily: fontFamilyPlusJakartaSans,
        ),
        const SizedBox(height: 10),
        _buildTextArea(
          controller: _notesController,
          hint: "e.g., Looking forward to our Wednesday check-in; feeling positive about continuing this rhythm...",
        ),
      ],
    );
  }
}
