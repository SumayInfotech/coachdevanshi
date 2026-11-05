import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../main.dart';
import '../../../core/blocs/profile/chapter_five/chapter_five_bloc.dart';
import '../../../core/blocs/profile/save_chapter/save_chapter_bloc.dart';
import '../../../core/constants/urls.dart';
import '../../../core/constants/utils.dart';
import '../../../core/models/profile/chapter_five_model.dart';
import '../../../core/models/profile/onboarding_masters_model.dart';
import '../../../core/services/loader_service.dart';
import '../../widgets/common_app_bar.dart';
import '../../widgets/common_text.dart';
import '../../widgets/common_text_field.dart';
import 'widget/profile_bottom_button.dart';
import 'widget/profile_chip.dart';
import 'widget/profile_radio_option.dart';
import 'widget/profile_section_card.dart';

class LifestyleCoachingFitScreen extends StatefulWidget {
  final List<OnboardingData> sleepNightWaking;
  final List<OnboardingData> sleepFirstHour;
  final List<OnboardingData> activityLevel;
  final List<OnboardingData> activityDailySteps;
  final List<OnboardingData> activityWorkoutsPerWeek;
  final List<OnboardingData> activityAvailableDays;
  final List<OnboardingData> stressFirstChanges;
  final List<OnboardingData> readinessScore;
  final List<OnboardingData> consistencyInterrupters;

  const LifestyleCoachingFitScreen({
    super.key, required this.sleepNightWaking, required this.sleepFirstHour,
    required this.activityLevel, required this.activityDailySteps,
    required this.activityWorkoutsPerWeek, required this.activityAvailableDays,
    required this.stressFirstChanges, required this.readinessScore,
    required this.consistencyInterrupters
  });

  @override
  State<LifestyleCoachingFitScreen> createState() => _LifestyleCoachingFitScreenState();
}

class _LifestyleCoachingFitScreenState extends State<LifestyleCoachingFitScreen> {
  ChapterFiveModel? chapterFiveModel;

  // --- Section 1: Sleep & Morning Rhythms ---
  final TextEditingController _bedtimeController = TextEditingController();
  final TextEditingController _wakeTimeController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  String? _sleepError;

  String? _selectedNightWaking;
  String? _nightWakingError;

  String? _selectedFirstHour;
  String? _firstHourError;

  // --- Section 2: Activity & Movement ---
  String? _selectedDailyActivity, _dailyActivityError;
  String? _selectedAvgSteps, _avgStepsError;
  String? _selectedWorkoutsCount, _workoutsCountError;

  final TextEditingController _workoutTypesController = TextEditingController();
  final TextEditingController _wearableController = TextEditingController();
  final TextEditingController _enjoyDislikeController = TextEditingController();

  String? _selectedRealisticCapacity;
  String? _realisticCapacityError;

  // --- Section 3: Stress & Decompression ---
  final TextEditingController _stress1Controller = TextEditingController();
  final TextEditingController _stress2Controller = TextEditingController();
  final TextEditingController _stress3Controller = TextEditingController();
  String? _stressSourcesError;

  final Set<String> _selectedStressChanges = {};
  String? _stressChangeError;

  final TextEditingController _decompressionController = TextEditingController();
  String? _decompressionError;

  // --- Section 4: Readiness & Coaching Partnership ---
  String? _readinessScore, _readinessError;

  final Set<String> _selectedInterruptions = {};
  String? _interruptionsError;

  @override
  void initState() {
    super.initState();
    callChapterFiveAPI();
  }

  void callChapterFiveAPI() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      LoaderService.show(context);
      BlocProvider.of<ChapterFiveBloc>(context).add(
        UserChapterFiveEvent(url: Urls.onboardingChapter(chapterId: "5")),
      );
    });
  }

  void _populateFromChapterFive(ChapterFiveModel model) {
    final answers = model.data?.answers;
    if (answers != null) {
      if (answers.bedtime != null) {
        _bedtimeController.text = answers.bedtime!;
      }
      if (answers.wakeTime != null) {
        _wakeTimeController.text = answers.wakeTime!;
      }
      if (answers.sleepDuration != null) {
        _durationController.text = answers.sleepDuration!;
      }
      if (answers.sleepNightWaking != null && answers.sleepNightWaking!.isNotEmpty) {
        _selectedNightWaking = answers.sleepNightWaking;
      }
      if (answers.sleepFirstHour != null && answers.sleepFirstHour!.isNotEmpty) {
        _selectedFirstHour = answers.sleepFirstHour;
      }
      if (answers.activityLevel != null && answers.activityLevel!.isNotEmpty) {
        _selectedDailyActivity = answers.activityLevel;
      }
      if (answers.activityDailySteps != null && answers.activityDailySteps!.isNotEmpty) {
        _selectedAvgSteps = answers.activityDailySteps;
      }
      if (answers.activityWorkoutsPerWeek != null && answers.activityWorkoutsPerWeek!.isNotEmpty) {
        _selectedWorkoutsCount = answers.activityWorkoutsPerWeek;
      }
      if (answers.movementTypes != null) {
        _workoutTypesController.text = answers.movementTypes!;
      }
      if (answers.wearableUsed != null) {
        _wearableController.text = answers.wearableUsed!;
      }
      if (answers.movementPreferences != null) {
        _enjoyDislikeController.text = answers.movementPreferences!;
      }
      if (answers.activityAvailableDays != null && answers.activityAvailableDays!.isNotEmpty) {
        _selectedRealisticCapacity = answers.activityAvailableDays;
      }
      if (answers.stressSources != null && answers.stressSources!.isNotEmpty) {
        if (answers.stressSources!.isNotEmpty) _stress1Controller.text = answers.stressSources![0];
        if (answers.stressSources!.length > 1) _stress2Controller.text = answers.stressSources![1];
        if (answers.stressSources!.length > 2) _stress3Controller.text = answers.stressSources![2];
      }
      if (answers.stressFirstChanges != null && answers.stressFirstChanges!.isNotEmpty) {
        _selectedStressChanges.clear();
        _selectedStressChanges.addAll(answers.stressFirstChanges!);
      }
      if (answers.stressRecovery != null) {
        _decompressionController.text = answers.stressRecovery!;
      }
      if (answers.readinessScore != null && answers.readinessScore!.isNotEmpty) {
        _readinessScore = answers.readinessScore;
      }
      if (answers.consistencyInterrupters != null && answers.consistencyInterrupters!.isNotEmpty) {
        _selectedInterruptions.clear();
        _selectedInterruptions.addAll(answers.consistencyInterrupters!);
      }
    }
  }

  Field? _getField(String key) {
    final fields = chapterFiveModel?.data?.fields ?? [];
    for (final f in fields) {
      if (f.key == key) return f;
    }
    return null;
  }

  Future<void> _selectTime(TextEditingController controller) async {
    final String currentTimeText = controller.text.trim();
    TimeOfDay initialTime = TimeOfDay.now();

    if (currentTimeText.isNotEmpty) {
      try {
        final DateTime parsedTime = DateFormat.jm().parse(currentTimeText);
        initialTime = TimeOfDay.fromDateTime(parsedTime);
      } catch (e) {
        appLog(name: "Time Parse Exception", e.toString());
      }
    }

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    if (picked != null && mounted) {
      final now = DateTime.now();
      final dt = DateTime(now.year, now.month, now.day, picked.hour, picked.minute);
      setState(() {
        controller.text = DateFormat('hh:mm a').format(dt);
        if (_sleepError != null) _validate();
      });
    }
  }

  bool _validate() {
    bool isValid = true;

    // Sleep
    if (_bedtimeController.text.trim().isEmpty || _wakeTimeController.text.trim().isEmpty
        || _durationController.text.trim().isEmpty) {
      _sleepError = "Please complete sleep details";
      isValid = false;
    } else {
      _sleepError = null;
    }

    if (_selectedNightWaking == null) {
      _nightWakingError = "Please select night waking frequency";
      isValid = false;
    } else {
      _nightWakingError = null;
    }

    if (_selectedFirstHour == null) {
      _firstHourError = "Please select first hour feeling";
      isValid = false;
    } else {
      _firstHourError = null;
    }

    // Activity
    if (_selectedDailyActivity == null) {
      _dailyActivityError = "Please select daily activity";
      isValid = false;
    } else {
      _dailyActivityError = null;
    }

    if (_selectedAvgSteps == null) {
      _avgStepsError = "Please select average daily steps";
      isValid = false;
    } else {
      _avgStepsError = null;
    }

    if (_selectedWorkoutsCount == null) {
      _workoutsCountError = "Please select current workouts per week";
      isValid = false;
    } else {
      _workoutsCountError = null;
    }

    if (_selectedRealisticCapacity == null) {
      _realisticCapacityError = "Please select realistic movement capacity";
      isValid = false;
    } else {
      _realisticCapacityError = null;
    }

    // Stress
    if (_stress1Controller.text.trim().isEmpty
        || _stress2Controller.text.trim().isEmpty
        || _stress3Controller.text.trim().isEmpty) {
      _stressSourcesError = "Please enter 3 sources of stress";
      isValid = false;
    } else {
      _stressSourcesError = null;
    }

    if (_selectedStressChanges.isEmpty) {
      _stressChangeError = "Please select what changes first";
      isValid = false;
    } else {
      _stressChangeError = null;
    }

    if (_decompressionController.text.trim().isEmpty) {
      _decompressionError = "Please share what helps you come back down";
      isValid = false;
    } else {
      _decompressionError = null;
    }

    // Readiness
    if (_readinessScore == null) {
      _readinessError = "Please select a readiness score";
      isValid = false;
    } else {
      _readinessError = null;
    }

    if (_selectedInterruptions.isEmpty) {
      _interruptionsError = "Please select at least 1 option";
      isValid = false;
    } else {
      _interruptionsError = null;
    }

    setState(() {});
    return isValid;
  }

  void _onSaveAndContinue() {
    if (_validate()) {
      LoaderService.show(context);

      final List<String> stressSources = [];
      if (_stress1Controller.text.trim().isNotEmpty) stressSources.add(_stress1Controller.text.trim());
      if (_stress2Controller.text.trim().isNotEmpty) stressSources.add(_stress2Controller.text.trim());
      if (_stress3Controller.text.trim().isNotEmpty) stressSources.add(_stress3Controller.text.trim());

      BlocProvider.of<SaveChapterBloc>(context).add(
        UserSaveChapterEvent(
          url: Urls.onboardingChapter(chapterId: "5"),
          body: {
            "answers": {
              "bedtime": _bedtimeController.text.trim(),
              "wake_time": _wakeTimeController.text.trim(),
              "sleep_duration": _durationController.text.trim(),
              "sleep_night_waking": _selectedNightWaking ?? "",
              "sleep_first_hour": _selectedFirstHour ?? "",
              "activity_level": _selectedDailyActivity ?? "",
              "activity_daily_steps": _selectedAvgSteps ?? "",
              "activity_workouts_per_week": _selectedWorkoutsCount ?? "",
              "movement_types": _workoutTypesController.text.trim(),
              "wearable_used": _wearableController.text.trim(),
              "movement_preferences": _enjoyDislikeController.text.trim(),
              "activity_available_days": _selectedRealisticCapacity ?? "",
              "stress_sources": stressSources,
              "stress_first_changes": _selectedStressChanges.toList(),
              "stress_recovery": _decompressionController.text.trim(),
              "readiness_score": _readinessScore ?? "",
              "consistency_interrupters": _selectedInterruptions.toList()
            }
          },
        ),
      );
    }
  }

  @override
  void dispose() {
    _bedtimeController.dispose();
    _wakeTimeController.dispose();
    _durationController.dispose();
    _workoutTypesController.dispose();
    _wearableController.dispose();
    _enjoyDislikeController.dispose();
    _stress1Controller.dispose();
    _stress2Controller.dispose();
    _stress3Controller.dispose();
    _decompressionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ChapterFiveBloc, ChapterFiveState>(
          listener: (context, state) {
            if (state is ChapterFiveSuccess) {
              LoaderService.hide();
              chapterFiveModel = state.model;
              _populateFromChapterFive(state.model);
              setState(() {});
            } else if (state is ChapterFiveFailed) {
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
                "CHAPTER ${chapterFiveModel?.data?.chapter ?? 5} OF ${chapterFiveModel?.data?.total ?? 6}",
                style: TextStyle(
                  fontSize: 11,
                  color: appColors.primary,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.55,
                ),
              ),
              CommonText(
                chapterFiveModel?.data?.title ?? "Lifestyle & Coaching Fit",
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
            _buildSleepSection(),
            const SizedBox(height: 24),
            _buildActivitySection(),
            const SizedBox(height: 24),
            _buildStressSection(),
            const SizedBox(height: 24),
            _buildReadinessSection(),
            const SizedBox(height: 24),
            ProfileBottomButton(
              name: "Save & Continue to Mindset & Sustainability",
              onTap: _onSaveAndContinue,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildNumberedListField(String number, String hint, TextEditingController controller) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CommonText(number, style: const TextStyle(
            fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF857373)
          )),
          const SizedBox(width: 8),
          Expanded(
            child: CommonTextField(
              controller: controller,
              label: "",
              hint: hint,
              fillColor: appColors.textFieldBgColor,
              borderColor: Colors.transparent,
              onChanged: (v) { if (_stressSourcesError != null) _validate(); },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSleepSection() {
    final dynamicNightWaking = _getField("sleep_night_waking")?.options ?? [];
    final hasDynamicNightWaking = dynamicNightWaking.isNotEmpty;

    final dynamicFirstHour = _getField("sleep_first_hour")?.options ?? [];
    final hasDynamicFirstHour = dynamicFirstHour.isNotEmpty;

    Widget buildTimeInput({
      required String label,
      required String hint,
      required TextEditingController controller,
      bool isTimePicker = false,
      TextInputType? keyboardType,
      List<TextInputFormatter>? inputFormatters,
    }) {
      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: appColors.textFieldBgColor,
          borderRadius: BorderRadius.circular(12),
          border: _sleepError != null ? Border.all(color: appColors.red) : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonText(label, style: const TextStyle(
              fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF534343)
            )),
            const SizedBox(height: 6),
            CommonTextField(
              label: '',
              controller: controller,
              readOnly: isTimePicker,
              fillColor: appColors.white,
              hint: hint,
              keyboardType: keyboardType,
              inputFormatters: inputFormatters,
              suffixIcon: isTimePicker
                  ? Icon(
                      Icons.access_time_rounded,
                      size: 20,
                      color: appColors.primary,
                    )
                  : null,
              onTap: isTimePicker ? () => _selectTime(controller) : null,
              onChanged: (v) { if (_sleepError != null) _validate(); },
            ),
          ],
        ),
      );
    }

    return ProfileSectionCard(
      title: "Sleep & Morning Rhythms",
      icon: appIcons.halfOutlineMoon,
      children: [
        buildRequiredLabel("What are your usual sleep and wake times, and how many hours do you typically sleep?"),
        const SizedBox(height: 12),
        buildTimeInput(
          label: "Bedtime",
          hint: "e.g., 10:45 PM",
          controller: _bedtimeController,
          isTimePicker: true,
        ),
        buildTimeInput(
          label: "Wake time",
          hint: "e.g., 6:30 AM",
          controller: _wakeTimeController,
          isTimePicker: true,
        ),
        buildTimeInput(
          label: "Typical duration",
          hint: "e.g., 7.5 hours",
          controller: _durationController,
          isTimePicker: false,
          keyboardType: .number,
          inputFormatters: [digitalWithDot]
        ),
        if (_sleepError != null) Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: CommonText(_sleepError!,
            style: TextStyle(color: appColors.red, fontSize: 12)
          )
        ),

        const SizedBox(height: 8),
        const CommonText(
          "Night waking frequency",
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF534343))
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 12,
          children: hasDynamicNightWaking
              ? dynamicNightWaking.map((e) => ProfileChip(
                  label: e.label ?? "",
                  isSelected: _selectedNightWaking == e.value,
                  onTap: () {
                    setState(() {
                      _selectedNightWaking = e.value;
                      if (_nightWakingError != null) _validate();
                    });
                  },
                )).toList()
              : widget.sleepNightWaking.map((e) => ProfileChip(
                  label: e.title ?? "",
                  isSelected: _selectedNightWaking == e.uuid,
                  onTap: () {
                    setState(() {
                      _selectedNightWaking = e.uuid;
                      if (_nightWakingError != null) _validate();
                    });
                  },
                )).toList(),
        ),
        if (_nightWakingError != null) Padding(
          padding: const EdgeInsets.only(top: 4),
          child: CommonText(_nightWakingError!,
            style: TextStyle(color: appColors.red, fontSize: 12)
          )
        ),

        const SizedBox(height: 16),
        const CommonText("First hour after waking", style: TextStyle(
          fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF534343)
        )),
        const SizedBox(height: 8),
        if (hasDynamicFirstHour)
          ...dynamicFirstHour.map((e) => ProfileRadioOption(
            label: e.label ?? "",
            isSelected: _selectedFirstHour == e.value,
            onTap: () {
              setState(() {
                _selectedFirstHour = e.value;
                if (_firstHourError != null) _validate();
              });
            },
          ))
        else
          ...widget.sleepFirstHour.map((e) => ProfileRadioOption(
            label: e.title ?? "",
            isSelected: _selectedFirstHour == e.uuid,
            onTap: () {
              setState(() {
                _selectedFirstHour = e.uuid;
                if (_firstHourError != null) _validate();
              });
            },
          )),
        if (_firstHourError != null) Padding(
          padding: const EdgeInsets.only(top: 4),
          child: CommonText(_firstHourError!,
            style: TextStyle(color: appColors.red, fontSize: 12)
          )
        ),
      ],
    );
  }

  Widget _buildActivitySection() {
    final dynamicActivityLevel = _getField("activity_level")?.options ?? [];
    final hasDynamicActivityLevel = dynamicActivityLevel.isNotEmpty;

    final dynamicSteps = _getField("activity_daily_steps")?.options ?? [];
    final hasDynamicSteps = dynamicSteps.isNotEmpty;

    Widget buildNumPicker(String? selected, String fieldKey, List<OnboardingData> fallbackOptions, ValueChanged<String> onSelected) {
      final dynamicOptions = _getField(fieldKey)?.options ?? [];
      final hasDynamic = dynamicOptions.isNotEmpty;

      return Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(color: appColors.textFieldBgColor, borderRadius: BorderRadius.circular(999)),
        child: Row(
          children: hasDynamic
              ? dynamicOptions.map((e) => Expanded(
                  child: GestureDetector(
                    onTap: () => onSelected(e.value ?? "0"),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                        color: selected == e.value ? appColors.white : Colors.transparent,
                        borderRadius: BorderRadius.circular(999),
                        boxShadow: selected == e.value ? [BoxShadow(
                          color: appColors.black.withValues(alpha: 0.05), blurRadius: 1
                        )] : null,
                      ),
                      child: CommonText(
                        e.label ?? "",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: selected == e.value ? appColors.primary : const Color(0xFF534343),
                        ),
                      ),
                    ),
                  ),
                )).toList()
              : fallbackOptions.map((e) => Expanded(
                  child: GestureDetector(
                    onTap: () => onSelected(e.uuid ?? "0"),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                        color: selected == e.uuid ? appColors.white : Colors.transparent,
                        borderRadius: BorderRadius.circular(999),
                        boxShadow: selected == e.uuid ? [BoxShadow(
                          color: appColors.black.withValues(alpha: 0.05), blurRadius: 1
                        )] : null,
                      ),
                      child: CommonText(
                        e.title ?? "",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: selected == e.uuid ? appColors.primary : const Color(0xFF534343),
                        ),
                      ),
                    ),
                  ),
                )).toList(),
        ),
      );
    }

    Widget buildActivityInput(String label, String hint, TextEditingController controller) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonText(label, style: const TextStyle(
            fontSize: 11, fontWeight: FontWeight.w500, color: Color(0xFF534343)
          )),
          const SizedBox(height: 6),
          CommonTextField(
            controller: controller,
            label: "",
            hint: hint,
            fillColor: appColors.textFieldBgColor,
            borderColor: Colors.transparent,
          ),
          const SizedBox(height: 12),
        ],
      );
    }

    return ProfileSectionCard(
      title: "Activity & Movement",
      icon: appIcons.homeStepsIcon,
      children: [
        buildRequiredLabel("Which description best matches your usual daily activity?"),
        const SizedBox(height: 12),
        if (hasDynamicActivityLevel)
          ...dynamicActivityLevel.map((e) => ProfileRadioOption(
            label: e.label ?? "",
            isSelected: _selectedDailyActivity == e.value,
            onTap: () {
              setState(() {
                _selectedDailyActivity = e.value;
                if (_dailyActivityError != null) _validate();
              });
            },
          ))
        else
          ...widget.activityLevel.map((e) => ProfileRadioOption(
            label: e.title ?? "",
            isSelected: _selectedDailyActivity == e.uuid,
            onTap: () {
              setState(() {
                _selectedDailyActivity = e.uuid;
                if (_dailyActivityError != null) _validate();
              });
            },
          )),
        if (_dailyActivityError != null) Padding(
          padding: const EdgeInsets.only(top: 4, bottom: 12),
          child: CommonText(_dailyActivityError!,
            style: TextStyle(color: appColors.red, fontSize: 12)
          )
        ),

        const SizedBox(height: 8),
        const CommonText("Average daily steps", style: TextStyle(
          fontSize: 11, fontWeight: FontWeight.w500, color: Color(0xFF534343)
        )),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 12,
          children: hasDynamicSteps
              ? dynamicSteps.map((e) => ProfileChip(
                  label: e.label ?? "",
                  isSelected: _selectedAvgSteps == e.value,
                  onTap: () {
                    setState(() {
                      _selectedAvgSteps = e.value;
                      if (_avgStepsError != null) _validate();
                    });
                  },
                )).toList()
              : widget.activityDailySteps.map((e) => ProfileChip(
                  label: e.title ?? "",
                  isSelected: _selectedAvgSteps == e.uuid,
                  onTap: () {
                    setState(() {
                      _selectedAvgSteps = e.uuid;
                      if (_avgStepsError != null) _validate();
                    });
                  },
                )).toList(),
        ),
        if (_avgStepsError != null) Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 12),
          child: CommonText(_avgStepsError!,
            style: TextStyle(color: appColors.red, fontSize: 12)
          )
        ),

        const SizedBox(height: 16),
        const CommonText("Current workouts per week", style: TextStyle(
          fontSize: 11, fontWeight: FontWeight.w500, color: Color(0xFF534343)
        )),
        const SizedBox(height: 8),
        buildNumPicker(
          _selectedWorkoutsCount, "activity_workouts_per_week", widget.activityWorkoutsPerWeek,
          (v) => setState(() {
            _selectedWorkoutsCount = v;
            if (_workoutsCountError != null) _validate();
          })
        ),
        if (_workoutsCountError != null) Padding(
          padding: const EdgeInsets.only(top: 4, bottom: 12),
          child: CommonText(_workoutsCountError!,
            style: TextStyle(color: appColors.red, fontSize: 12)
          )
        ),

        const SizedBox(height: 16),
        buildActivityInput("Movement or workout types", "e.g., Brisk walking, weekend trails", _workoutTypesController),
        buildActivityInput("Wearable or health app used", "e.g., Apple Watch SE", _wearableController),
        buildActivityInput("Any movement you enjoy or dislike", "e.g., Enjoy evening walks; dislike running", _enjoyDislikeController),

        const SizedBox(height: 8),
        const CommonText(
          "On an ordinary week, how many days could you realistically make time for intentional movement?",
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Color(0xFF534343))
        ),
        const SizedBox(height: 8),
        buildNumPicker(
          _selectedRealisticCapacity, "activity_available_days", widget.activityAvailableDays,
          (v) => setState(() {
            _selectedRealisticCapacity = v;
            if (_realisticCapacityError != null) _validate();
          })
        ),
        if (_realisticCapacityError != null) Padding(
          padding: const EdgeInsets.only(top: 4),
          child: CommonText(_realisticCapacityError!,
            style: TextStyle(color: appColors.red, fontSize: 12)
          )
        ),
      ],
    );
  }

  Widget _buildStressSection() {
    final dynamicStressChanges = _getField("stress_first_changes")?.options ?? [];
    final hasDynamicStressChanges = dynamicStressChanges.isNotEmpty;

    return ProfileSectionCard(
      title: "Stress & Decompression",
      icon: appIcons.heart,
      children: [
        const CommonText(
          "What are the three biggest sources of stress in your life right now, and what tends to change first when stress is high?",
          style: TextStyle(fontSize: 13, color: Color(0xFF534343))
        ),
        const SizedBox(height: 16),

        _buildNumberedListField("1.", "e.g., Back-to-back work meetings", _stress1Controller),
        _buildNumberedListField("2.", "e.g., Irregular travel or commuting", _stress2Controller),
        _buildNumberedListField("3.", "e.g., Managing family schedules", _stress3Controller),
        if (_stressSourcesError != null) Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: CommonText(_stressSourcesError!,
            style: TextStyle(color: appColors.red, fontSize: 12)
          )
        ),

        const CommonText(
          "What tends to change first when stress is high?",
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Color(0xFF534343))
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 12,
          children: hasDynamicStressChanges
              ? dynamicStressChanges.map((e) => ProfileChip(
                  label: e.label ?? "",
                  isSelected: _selectedStressChanges.contains(e.value),
                  onTap: () {
                    setState(() {
                      final lower = (e.label ?? "").toLowerCase();
                      final isNone = lower == "nothing noticeable";
                      if (isNone) {
                        _selectedStressChanges.clear();
                        if (e.value != null) _selectedStressChanges.add(e.value!);
                      } else {
                        for (final opt in dynamicStressChanges) {
                          if ((opt.label ?? "").toLowerCase() == "nothing noticeable") {
                            _selectedStressChanges.remove(opt.value);
                          }
                        }
                        if (_selectedStressChanges.contains(e.value)) {
                          _selectedStressChanges.remove(e.value);
                        } else {
                          if (e.value != null) _selectedStressChanges.add(e.value!);
                        }
                      }
                      if (_stressChangeError != null) _validate();
                    });
                  },
                )).toList()
              : widget.stressFirstChanges.map((e) => ProfileChip(
                  label: e.title ?? "",
                  isSelected: _selectedStressChanges.contains(e.uuid),
                  onTap: () {
                    setState(() {
                      final lower = (e.title ?? "").toLowerCase();
                      final isNone = lower == "nothing noticeable";
                      if (isNone) {
                        _selectedStressChanges.clear();
                        if (e.uuid != null) _selectedStressChanges.add(e.uuid!);
                      } else {
                        for (final item in widget.stressFirstChanges) {
                          if ((item.title ?? "").toLowerCase() == "nothing noticeable") {
                            _selectedStressChanges.remove(item.uuid);
                          }
                        }
                        if (_selectedStressChanges.contains(e.uuid)) {
                          _selectedStressChanges.remove(e.uuid);
                        } else {
                          _selectedStressChanges.add(e.uuid ?? "0");
                        }
                      }
                      if (_stressChangeError != null) _validate();
                    });
                  },
                )).toList(),
        ),
        if (_stressChangeError != null) Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 12),
          child: CommonText(_stressChangeError!,
            style: TextStyle(color: appColors.red, fontSize: 12)
          )
        ),

        const SizedBox(height: 16),
        const CommonText(
          "When you feel overwhelmed, what helps you come back down — if anything?",
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Color(0xFF534343))
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: appColors.textFieldBgColor,
            borderRadius: BorderRadius.circular(12),
            border: _decompressionError != null ? Border.all(color: appColors.red) : null,
          ),
          child: TextField(
            controller: _decompressionController,
            maxLines: 3,
            style: TextStyle(fontSize: 14, color: const Color(0xFF1D1B1A), fontFamily: fontFamilyPlusJakartaSans),
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: "e.g., Stepping away to brew tea...",
              hintStyle: TextStyle(fontSize: 14, color: Color(0xFF9A8687)),
              isDense: true,
            ),
            onChanged: (v) { if (_decompressionError != null) _validate(); },
          ),
        ),
        if (_decompressionError != null) Padding(
          padding: const EdgeInsets.only(top: 4),
          child: CommonText(_decompressionError!,
            style: TextStyle(color: appColors.red, fontSize: 12)
          )
        ),
      ],
    );
  }

  Widget _buildReadinessSection() {
    final dynamicReadiness = _getField("readiness_score")?.options ?? [];
    final hasDynamicReadiness = dynamicReadiness.isNotEmpty;

    final dynamicInterruptions = _getField("consistency_interrupters")?.options ?? [];
    final hasDynamicInterruptions = dynamicInterruptions.isNotEmpty;

    return ProfileSectionCard(
      title: "Readiness & Coaching Partnership",
      icon: appIcons.compass,
      children: [
        const CommonText(
          "How ready do you feel to make changes right now?",
          style: TextStyle(fontSize: 13, color: Color(0xFF534343))
        ),
        const SizedBox(height: 12),
        // 1 to 10 Grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 5),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            childAspectRatio: 1.3,
            crossAxisSpacing: 6,
            mainAxisSpacing: 6,
          ),
          itemCount: hasDynamicReadiness ? dynamicReadiness.length : widget.readinessScore.length,
          itemBuilder: (context, index) {
            final label = hasDynamicReadiness
                ? (dynamicReadiness[index].label ?? "")
                : (widget.readinessScore[index].title ?? "");
            final value = hasDynamicReadiness
                ? dynamicReadiness[index].value
                : widget.readinessScore[index].uuid;
            bool isSelected = _readinessScore == value;

            return GestureDetector(
              onTap: () {
                setState(() {
                  _readinessScore = value;
                  if (_readinessError != null) _validate();
                });
              },
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected ? appColors.primary : appColors.textFieldBgColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: isSelected ? [BoxShadow(
                    color: appColors.black.withValues(alpha: 0.05), blurRadius: 1
                  )] : null,
                ),
                child: CommonText(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                    color: isSelected ? appColors.white : const Color(0xFF534343),
                  ),
                ),
              ),
            );
          },
        ),
        if (_readinessError != null) Padding(
          padding: const EdgeInsets.only(top: 8),
          child: CommonText(_readinessError!,
            style: TextStyle(color: appColors.red, fontSize: 12)
          )
        ),

        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CommonText(
              "1: Hesitant / exploring",
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Color(0xFF857373))
            ),
            CommonText(
              "10: Fully committed & ready",
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Color(0xFF857373))
            ),
          ],
        ),

        const SizedBox(height: 24),
        const CommonText(
          "What most commonly interrupts your consistency?\n(Select up to 3)",
          style: TextStyle(fontSize: 13, color: Color(0xFF1D1B1A))
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 12,
          children: hasDynamicInterruptions
              ? dynamicInterruptions.map((e) => ProfileChip(
                  label: e.label ?? "",
                  isSelected: _selectedInterruptions.contains(e.value),
                  onTap: () {
                    setState(() {
                      if (_selectedInterruptions.contains(e.value)) {
                        _selectedInterruptions.remove(e.value);
                      } else {
                        if (_selectedInterruptions.length < 3) {
                          if (e.value != null) _selectedInterruptions.add(e.value!);
                        } else {
                          appLog("Can only select up to 3 options");
                        }
                      }
                      if (_interruptionsError != null) _validate();
                    });
                  },
                )).toList()
              : widget.consistencyInterrupters.map((e) => ProfileChip(
                  label: e.title ?? "",
                  isSelected: _selectedInterruptions.contains(e.uuid),
                  onTap: () {
                    setState(() {
                      if (_selectedInterruptions.contains(e.uuid)) {
                        _selectedInterruptions.remove(e.uuid);
                      } else {
                        if (_selectedInterruptions.length < 3) {
                          _selectedInterruptions.add(e.uuid ?? "0");
                        } else {
                          appLog("Can only select up to 3 options");
                        }
                      }
                      if (_interruptionsError != null) _validate();
                    });
                  },
                )).toList(),
        ),
        if (_interruptionsError != null) Padding(
          padding: const EdgeInsets.only(top: 8),
          child: CommonText(_interruptionsError!,
            style: TextStyle(color: appColors.red, fontSize: 12)
          )
        ),
      ],
    );
  }
}
