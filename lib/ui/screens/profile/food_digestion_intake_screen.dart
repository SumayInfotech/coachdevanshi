import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../main.dart';
import '../../../core/blocs/profile/chapter_four/chapter_four_bloc.dart';
import '../../../core/blocs/profile/save_chapter/save_chapter_bloc.dart';
import '../../../core/constants/urls.dart';
import '../../../core/constants/utils.dart';
import '../../../core/models/profile/chapter_four_model.dart';
import '../../../core/models/profile/onboarding_masters_model.dart';
import '../../../core/services/loader_service.dart';
import '../../widgets/common_app_bar.dart';
import '../../widgets/common_text.dart';
import '../../widgets/common_text_field.dart';
import 'widget/profile_bottom_button.dart';
import 'widget/profile_chip.dart';
import 'widget/profile_radio_option.dart';
import 'widget/profile_section_card.dart';

class FoodDigestionIntakeScreen extends StatefulWidget {
  final List<OnboardingData> eatingPattern;
  final List<OnboardingData> culturalFastingPractices;
  final List<OnboardingData> foodEnvWhoCooks;
  final List<OnboardingData> foodEnvSupportLevel;
  final List<OnboardingData> foodEnvMealsOutPerWeek;
  final List<OnboardingData> intakeFruit;
  final List<OnboardingData> intakeVegetables;
  final List<OnboardingData> intakeWater;
  final List<OnboardingData> intakeCaffeine;
  final List<OnboardingData> intakeSugary;
  final List<OnboardingData> substanceHabits;
  final List<OnboardingData> digestiveHealth;

  const FoodDigestionIntakeScreen({
    super.key, required this.eatingPattern, required this.culturalFastingPractices,
    required this.foodEnvWhoCooks, required this.foodEnvSupportLevel,
    required this.foodEnvMealsOutPerWeek, required this.intakeFruit,
    required this.intakeVegetables, required this.intakeWater, required this.intakeCaffeine,
    required this.intakeSugary, required this.substanceHabits, required this.digestiveHealth
  });

  @override
  State<FoodDigestionIntakeScreen> createState() => _FoodDigestionIntakeScreenState();
}

class _FoodDigestionIntakeScreenState extends State<FoodDigestionIntakeScreen> {
  ChapterFourModel? chapterFourModel;

  // 1. Eating Pattern
  String? _selectedEatingPattern;
  final TextEditingController _eatingPatternOtherController = TextEditingController();
  String? _eatingPatternError;

  // 2. Cultural & Fasting Practices
  final Set<String> _selectedFasting = {};
  final TextEditingController _fastingOtherController = TextEditingController();
  String? _fastingError;

  // 3. Weekday Meal Rhythms
  final TextEditingController _firstFoodController = TextEditingController();
  final TextEditingController _breakfastController = TextEditingController();
  final TextEditingController _lunchController = TextEditingController();
  final TextEditingController _snackController = TextEditingController();
  final TextEditingController _dinnerController = TextEditingController();
  final TextEditingController _lateNightController = TextEditingController();
  final TextEditingController _mealTimingsController = TextEditingController();
  String? _rhythmsError;

  // 4. Weekend Routine
  final TextEditingController _weekendRoutineController = TextEditingController();

  // 5. Foods That Matter
  final TextEditingController _foodsEnjoyController = TextEditingController();
  final TextEditingController _foodsDislikeController = TextEditingController();
  final TextEditingController _foodsKeepController = TextEditingController();
  String? _foodsMatterError;

  // 6. Food Environment
  String? _selectedWhoCooks;
  final TextEditingController _whoCooksOtherController = TextEditingController();
  String? _whoCooksError;

  final TextEditingController _shareMealsController = TextEditingController();
  String? _selectedSupport;
  String? _selectedMealsOut;

  // 7. Daily Intake Overview
  String? _intakeFruit;
  String? _intakeVeg;
  String? _intakeWater;
  String? _intakeCaffeine;
  String? _intakeSugar;
  String? _intakeError;

  // 8. Substance Habits
  final Set<String> _selectedSubstances = {};
  final TextEditingController _substancesOtherController = TextEditingController();
  String? _substanceError;

  // 9. Digestive Health
  final Set<String> _selectedDigestion = {};
  final TextEditingController _digestionOtherController = TextEditingController();
  String? _digestionError;

  @override
  void initState() {
    super.initState();
    callChapterFourAPI();
  }

  void callChapterFourAPI() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      LoaderService.show(context);
      BlocProvider.of<ChapterFourBloc>(context).add(
        UserChapterFourEvent(url: Urls.onboardingChapter(chapterId: "4")),
      );
    });
  }

  void _populateFromChapterFour(ChapterFourModel model) {
    final answers = model.data?.answers;
    if (answers != null) {
      if (answers.eatingPattern != null && answers.eatingPattern!.isNotEmpty) {
        _selectedEatingPattern = answers.eatingPattern;
      }
      if (answers.eatingPatternOther != null && answers.eatingPatternOther!.isNotEmpty) {
        _eatingPatternOtherController.text = answers.eatingPatternOther!;
      }
      if (answers.culturalFastingPractices != null && answers.culturalFastingPractices!.isNotEmpty) {
        _selectedFasting.clear();
        _selectedFasting.addAll(answers.culturalFastingPractices!);
      }
      if (answers.culturalFastingPracticesOther != null && answers.culturalFastingPracticesOther!.isNotEmpty) {
        _fastingOtherController.text = answers.culturalFastingPracticesOther!;
      }
      if (answers.weekdayMeals != null) {
        _firstFoodController.text = answers.weekdayMeals!.firstIntake ?? "";
        _breakfastController.text = answers.weekdayMeals!.breakfast ?? "";
        _lunchController.text = answers.weekdayMeals!.lunch ?? "";
        _snackController.text = answers.weekdayMeals!.eveningSnack ?? "";
        _dinnerController.text = answers.weekdayMeals!.dinner ?? "";
        _lateNightController.text = answers.weekdayMeals!.lateNight ?? "";
        _mealTimingsController.text = answers.weekdayMeals!.mealTimings ?? "";
      }
      if (answers.weekendRoutine != null) {
        _weekendRoutineController.text = answers.weekendRoutine!;
      }
      if (answers.foodsEnjoyed != null) {
        _foodsEnjoyController.text = answers.foodsEnjoyed!;
      }
      if (answers.foodsDisliked != null) {
        _foodsDislikeController.text = answers.foodsDisliked!;
      }
      if (answers.foodsNotReadyToGiveUp != null) {
        _foodsKeepController.text = answers.foodsNotReadyToGiveUp!;
      }
      if (answers.foodEnvWhoCooks != null && answers.foodEnvWhoCooks!.isNotEmpty) {
        _selectedWhoCooks = answers.foodEnvWhoCooks;
      }
      if (answers.foodEnvWhoCooksOther != null && answers.foodEnvWhoCooksOther!.isNotEmpty) {
        _whoCooksOtherController.text = answers.foodEnvWhoCooksOther!;
      }
      if (answers.foodEnvShareMealsWith != null) {
        _shareMealsController.text = answers.foodEnvShareMealsWith!;
      }
      if (answers.foodEnvSupportLevel != null && answers.foodEnvSupportLevel!.isNotEmpty) {
        _selectedSupport = answers.foodEnvSupportLevel;
      }
      if (answers.foodEnvMealsOutPerWeek != null && answers.foodEnvMealsOutPerWeek!.isNotEmpty) {
        _selectedMealsOut = answers.foodEnvMealsOutPerWeek;
      }
      if (answers.intakeFruit != null && answers.intakeFruit!.isNotEmpty) {
        _intakeFruit = answers.intakeFruit;
      }
      if (answers.intakeVegetables != null && answers.intakeVegetables!.isNotEmpty) {
        _intakeVeg = answers.intakeVegetables;
      }
      if (answers.intakeWater != null && answers.intakeWater!.isNotEmpty) {
        _intakeWater = answers.intakeWater;
      }
      if (answers.intakeCaffeine != null && answers.intakeCaffeine!.isNotEmpty) {
        _intakeCaffeine = answers.intakeCaffeine;
      }
      if (answers.intakeSugary != null && answers.intakeSugary!.isNotEmpty) {
        _intakeSugar = answers.intakeSugary;
      }
      if (answers.substanceHabits != null && answers.substanceHabits!.isNotEmpty) {
        _selectedSubstances.clear();
        _selectedSubstances.addAll(answers.substanceHabits!);
      }
      if (answers.substanceHabitsOther != null && answers.substanceHabitsOther!.isNotEmpty) {
        _substancesOtherController.text = answers.substanceHabitsOther!;
      }
      if (answers.digestiveHealth != null && answers.digestiveHealth!.isNotEmpty) {
        _selectedDigestion.clear();
        _selectedDigestion.addAll(answers.digestiveHealth!);
      }
      if (answers.digestiveHealthOther != null && answers.digestiveHealthOther!.isNotEmpty) {
        _digestionOtherController.text = answers.digestiveHealthOther!;
      }
    }
  }

  Field? _getField(String key) {
    final fields = chapterFourModel?.data?.fields ?? [];
    for (final f in fields) {
      if (f.key == key) return f;
    }
    return null;
  }

  bool _validate() {
    bool isValid = true;

    if (_selectedEatingPattern == null) {
      _eatingPatternError = "Please select an eating pattern";
      isValid = false;
    } else {
      _eatingPatternError = null;
    }

    if (_selectedFasting.isEmpty) {
      _fastingError = "Please select at least one option";
      isValid = false;
    } else {
      _fastingError = null;
    }

    if (_firstFoodController.text.trim().isEmpty || _breakfastController.text.trim().isEmpty ||
        _lunchController.text.trim().isEmpty || _dinnerController.text.trim().isEmpty ||
        _mealTimingsController.text.trim().isEmpty) {
      _rhythmsError = "Please complete your weekday meal rhythms";
      isValid = false;
    } else {
      _rhythmsError = null;
    }

    if (_foodsEnjoyController.text.trim().isEmpty) {
      _foodsMatterError = "Please list the foods that matter";
      isValid = false;
    } else {
      _foodsMatterError = null;
    }

    if (_selectedWhoCooks == null) {
      _whoCooksError = "Please specify your food environment";
      isValid = false;
    } else {
      _whoCooksError = null;
    }

    if (_intakeFruit == null || _intakeVeg == null || _intakeWater == null
        || _intakeCaffeine == null || _intakeSugar == null) {
      _intakeError = "Please complete daily intake overview";
      isValid = false;
    } else {
      _intakeError = null;
    }

    if (_selectedSubstances.isEmpty) {
      _substanceError = "Please select substance habits";
      isValid = false;
    } else {
      _substanceError = null;
    }

    if (_selectedDigestion.isEmpty) {
      _digestionError = "Please select digestive health concerns";
      isValid = false;
    } else {
      _digestionError = null;
    }

    setState(() {});
    return isValid;
  }

  void _onSaveAndContinue() {
    if (_validate()) {
      LoaderService.show(context);
      BlocProvider.of<SaveChapterBloc>(context).add(
        UserSaveChapterEvent(
          url: Urls.onboardingChapter(chapterId: "4"),
          body: {
            "answers": {
              "eating_pattern": _selectedEatingPattern ?? "",
              "eating_pattern_other": _eatingPatternOtherController.text.trim(),
              "cultural_fasting_practices": _selectedFasting.toList(),
              "cultural_fasting_practices_other": _fastingOtherController.text.trim(),
              "weekday_meals": {
                "first_intake": _firstFoodController.text.trim(),
                "breakfast": _breakfastController.text.trim(),
                "lunch": _lunchController.text.trim(),
                "evening_snack": _snackController.text.trim(),
                "dinner": _dinnerController.text.trim(),
                "late_night": _lateNightController.text.trim(),
                "meal_timings": _mealTimingsController.text.trim()
              },
              "weekend_routine": _weekendRoutineController.text.trim(),
              "foods_enjoyed": _foodsEnjoyController.text.trim(),
              "foods_disliked": _foodsDislikeController.text.trim(),
              "foods_not_ready_to_give_up": _foodsKeepController.text.trim(),
              "food_env_who_cooks": _selectedWhoCooks ?? "",
              "food_env_who_cooks_other": _whoCooksOtherController.text.trim(),
              "food_env_share_meals_with": _shareMealsController.text.trim(),
              "food_env_support_level": _selectedSupport ?? "",
              "food_env_meals_out_per_week": _selectedMealsOut ?? "",
              "intake_fruit": _intakeFruit ?? "",
              "intake_vegetables": _intakeVeg ?? "",
              "intake_water": _intakeWater ?? "",
              "intake_caffeine": _intakeCaffeine ?? "",
              "intake_sugary": _intakeSugar ?? "",
              "substance_habits": _selectedSubstances.toList(),
              "substance_habits_other": _substancesOtherController.text.trim(),
              "digestive_health": _selectedDigestion.toList(),
              "digestive_health_other": _digestionOtherController.text.trim(),
            }
          },
        ),
      );
    }
  }

  @override
  void dispose() {
    _firstFoodController.dispose();
    _breakfastController.dispose();
    _lunchController.dispose();
    _snackController.dispose();
    _dinnerController.dispose();
    _lateNightController.dispose();
    _mealTimingsController.dispose();
    _weekendRoutineController.dispose();
    _foodsEnjoyController.dispose();
    _foodsDislikeController.dispose();
    _foodsKeepController.dispose();
    _shareMealsController.dispose();
    _eatingPatternOtherController.dispose();
    _fastingOtherController.dispose();
    _whoCooksOtherController.dispose();
    _substancesOtherController.dispose();
    _digestionOtherController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ChapterFourBloc, ChapterFourState>(
          listener: (context, state) {
            if (state is ChapterFourSuccess) {
              LoaderService.hide();
              chapterFourModel = state.model;
              _populateFromChapterFour(state.model);
              setState(() {});
            } else if (state is ChapterFourFailed) {
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
                "CHAPTER ${chapterFourModel?.data?.chapter ?? 4} OF ${chapterFourModel?.data?.total ?? 6}",
                style: TextStyle(
                  fontSize: 11,
                  color: appColors.primary,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.55,
                ),
              ),
              CommonText(
                chapterFourModel?.data?.title ?? "Food & Digestion",
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
            _buildEatingPatternSection(),
            const SizedBox(height: 24),
            _buildFastingSection(),
            const SizedBox(height: 24),
            _buildWeekdayRhythmsSection(),
            const SizedBox(height: 24),
            _buildWeekendRoutineSection(),
            const SizedBox(height: 24),
            _buildFoodsMatterSection(),
            const SizedBox(height: 24),
            _buildFoodEnvironmentSection(),
            const SizedBox(height: 24),
            _buildDailyIntakeSection(),
            const SizedBox(height: 24),
            _buildSubstanceSection(),
            const SizedBox(height: 24),
            _buildDigestiveSection(),
            const SizedBox(height: 24),
            ProfileBottomButton(
              name: "Save & Continue to Lifestyle & Coaching Fit",
              onTap: _onSaveAndContinue,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildIntakeRow(String label, String fieldKey, List<OnboardingData> fallbackOptions, String? selectedValue, ValueChanged<String> onSelected) {
    final dynamicOptions = _getField(fieldKey)?.options ?? [];
    final hasDynamic = dynamicOptions.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonText(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Color(0xFF1D1B1A))),
        const SizedBox(height: 6),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: hasDynamic
              ? dynamicOptions.map((e) => ProfileChip(
                  label: e.label ?? "",
                  isSelected: selectedValue == e.value,
                  onTap: () => onSelected(e.value ?? "0"),
                )).toList()
              : fallbackOptions.map((e) => ProfileChip(
                  label: e.title ?? "",
                  isSelected: selectedValue == e.uuid,
                  onTap: () => onSelected(e.uuid ?? "0"),
                )).toList(),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildEatingPatternSection() {
    final dynamicEating = _getField("eating_pattern")?.options ?? [];
    final hasDynamicEating = dynamicEating.isNotEmpty;

    return ProfileSectionCard(
      title: "Eating Pattern",
      icon: appIcons.eating,
      children: [
        buildRequiredLabel("Which eating pattern best describes you?"),
        const SizedBox(height: 12),
        if (hasDynamicEating)
          ...dynamicEating.map((e) => ProfileRadioOption(
            label: e.label ?? "",
            isSelected: _selectedEatingPattern == e.value,
            onTap: () {
              setState(() {
                _selectedEatingPattern = e.value;
                if (_eatingPatternError != null) _validate();
              });
            },
          ))
        else
          ...widget.eatingPattern.map((e) => ProfileRadioOption(
            label: e.title ?? "",
            isSelected: _selectedEatingPattern == e.uuid,
            onTap: () {
              setState(() {
                _selectedEatingPattern = e.uuid;
                if (_eatingPatternError != null) _validate();
              });
            },
          )),
        if (_isSingleOtherSelected(_selectedEatingPattern, dynamicEating, widget.eatingPattern)) ...[
          const SizedBox(height: 12),
          CommonTextField(
            label: "Please specify eating pattern",
            hint: "Enter your eating pattern",
            controller: _eatingPatternOtherController,
            fillColor: appColors.textFieldBgColor,
            borderColor: Colors.transparent,
            isRequired: false,
          ),
        ],
        if (_eatingPatternError != null) Padding(
          padding: const EdgeInsets.only(top: 8),
          child: CommonText(_eatingPatternError!,
            style: TextStyle(color: appColors.red, fontSize: 12)
          )
        ),
      ],
    );
  }

  Widget _buildFastingSection() {
    final dynamicFasting = _getField("cultural_fasting_practices")?.options ?? [];
    final hasDynamicFasting = dynamicFasting.isNotEmpty;

    return ProfileSectionCard(
      title: "Cultural & Fasting Practices",
      icon: appIcons.cultural,
      children: [
        buildRequiredLabel("Are there any religious, cultural or fasting practices your plan should accommodate?"),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 12,
          children: hasDynamicFasting
              ? dynamicFasting.map((e) => ProfileChip(
                  label: e.label ?? "",
                  isSelected: _selectedFasting.contains(e.value),
                  onTap: () {
                    setState(() {
                      final isNone = (e.label?.toLowerCase() == "none");
                      if (isNone) {
                        _selectedFasting.clear();
                        if (e.value != null) _selectedFasting.add(e.value!);
                      } else {
                        for (final opt in dynamicFasting) {
                          if (opt.label?.toLowerCase() == "none") {
                            _selectedFasting.remove(opt.value);
                          }
                        }
                        if (_selectedFasting.contains(e.value)) {
                          _selectedFasting.remove(e.value);
                        } else {
                          if (e.value != null) _selectedFasting.add(e.value!);
                        }
                      }
                      if (_fastingError != null) _validate();
                    });
                  },
                )).toList()
              : widget.culturalFastingPractices.map((e) => ProfileChip(
                  label: e.title ?? "",
                  isSelected: _selectedFasting.contains(e.uuid),
                  onTap: () {
                    setState(() {
                      final isNone = (e.title?.toLowerCase() == "none");
                      if (isNone) {
                        _selectedFasting.clear();
                        if (e.uuid != null) _selectedFasting.add(e.uuid!);
                      } else {
                        for (final item in widget.culturalFastingPractices) {
                          if (item.title?.toLowerCase() == "none") {
                            _selectedFasting.remove(item.uuid);
                          }
                        }
                        if (_selectedFasting.contains(e.uuid)) {
                          _selectedFasting.remove(e.uuid);
                        } else {
                          _selectedFasting.add(e.uuid ?? "0");
                        }
                      }
                      if (_fastingError != null) _validate();
                    });
                  },
                )).toList(),
        ),
        if (_hasSelectedOther(_selectedFasting, dynamicFasting, widget.culturalFastingPractices)) ...[
          const SizedBox(height: 12),
          CommonTextField(
            label: "Please specify fasting practices",
            hint: "Enter cultural or fasting practices",
            controller: _fastingOtherController,
            fillColor: appColors.textFieldBgColor,
            borderColor: Colors.transparent,
            isRequired: false,
          ),
        ],
        if (_fastingError != null) Padding(
          padding: const EdgeInsets.only(top: 8),
          child: CommonText(_fastingError!,
            style: TextStyle(color: appColors.red, fontSize: 12)
          )
        ),
      ],
    );
  }

  Widget _buildWeekdayRhythmsSection() {
    Widget buildRhythmInput(String label, String hint, TextEditingController controller) {
      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: appColors.textFieldBgColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonText(label,
              style: const TextStyle(
                fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF534343)
              )
            ),
            const SizedBox(height: 6),
            CommonTextField(
              label: '',
              controller: controller,
              fillColor: appColors.white,
              hint: hint,
              onChanged: (v) { if (_rhythmsError != null) _validate(); },
            ),
          ],
        ),
      );
    }

    return ProfileSectionCard(
      title: "Weekday Meal Rhythms",
      icon: appIcons.clock,
      children: [
        buildRequiredLabel("What does a usual weekday of eating look like?"),
        const SizedBox(height: 12),
        buildRhythmInput("First food or drink after waking", "e.g., Warm water with lemon...", _firstFoodController),
        buildRhythmInput("Breakfast", "e.g., Poha or eggs with chai", _breakfastController),
        buildRhythmInput("Lunch", "e.g., Dal, roti, seasonal sabzi", _lunchController),
        buildRhythmInput("Evening snack", "e.g., Roasted makhana or fruit", _snackController),
        buildRhythmInput("Dinner", "e.g., Khichdi or vegetable soup", _dinnerController),
        buildRhythmInput("Late-night food or drinks", "e.g., Herbal tea or warm milk", _lateNightController),
        buildRhythmInput("Usual meal timings", "e.g., Breakfast 8:30 AM · Lunch 1:30 PM", _mealTimingsController),
        if (_rhythmsError != null) Padding(
          padding: const EdgeInsets.only(top: 8),
          child: CommonText(_rhythmsError!,
            style: TextStyle(color: appColors.red, fontSize: 12)
          )
        ),
      ],
    );
  }

  Widget _buildWeekendRoutineSection() {
    return ProfileSectionCard(
      title: "Weekend Routine",
      icon: appIcons.sofa,
      children: [
        const CommonText(
          "How is your weekend or eating-out routine different from weekdays?",
          style: TextStyle(
            fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF534343)
          )
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(color: appColors.textFieldBgColor, borderRadius: BorderRadius.circular(12)),
          child: TextField(
            controller: _weekendRoutineController,
            maxLines: 3,
            style: TextStyle(fontSize: 14, color: const Color(0xFF1D1B1A), fontFamily: fontFamilyPlusJakartaSans),
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: "e.g., Later breakfast around 11 AM...",
              hintStyle: TextStyle(fontSize: 14, color: Color(0xFF9A8687)),
              isDense: true,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFoodsMatterSection() {
    Widget buildFoodsInput(String label, String hint, TextEditingController controller) {
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
            CommonText(label,
              style: const TextStyle(
                fontSize: 11, fontWeight: FontWeight.w500, color: Color(0xFF534343)
              )
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(color: appColors.white, borderRadius: BorderRadius.circular(8)),
              child: TextField(
                controller: controller,
                maxLines: 2,
                style: TextStyle(fontSize: 14, color: const Color(0xFF1D1B1A), fontFamily: fontFamilyPlusJakartaSans),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: hint,
                  hintStyle: const TextStyle(fontSize: 14, color: Color(0xFF9A8687)),
                  isDense: true,
                ),
                onChanged: (v) { if (_foodsMatterError != null) _validate(); },
              ),
            ),
          ],
        ),
      );
    }

    return ProfileSectionCard(
      title: "Foods That Matter",
      icon: appIcons.heart,
      children: [
        buildRequiredLabel("Tell us the foods that matter in your plan"),
        const SizedBox(height: 12),
        buildFoodsInput("Foods you enjoy and eat often", "e.g., Paneer, lentils, dark chocolate", _foodsEnjoyController),
        buildFoodsInput("Foods you dislike or avoid", "e.g., Bitter gourd, excessive oil", _foodsDislikeController),
        buildFoodsInput("Foods or drinks you are not ready to give up", "e.g., Morning masala chai", _foodsKeepController),
        if (_foodsMatterError != null) Padding(
          padding: const EdgeInsets.only(top: 4),
          child: CommonText(_foodsMatterError!,
            style: TextStyle(color: appColors.red, fontSize: 12)
          )
        ),
      ],
    );
  }

  Widget _buildFoodEnvironmentSection() {
    final dynamicWhoCooks = _getField("food_env_who_cooks")?.options ?? [];
    final hasDynamicWhoCooks = dynamicWhoCooks.isNotEmpty;

    final dynamicSupport = _getField("food_env_support_level")?.options ?? [];
    final hasDynamicSupport = dynamicSupport.isNotEmpty;

    final dynamicMealsOut = _getField("food_env_meals_out_per_week")?.options ?? [];
    final hasDynamicMealsOut = dynamicMealsOut.isNotEmpty;

    return ProfileSectionCard(
      title: "Food Environment",
      icon: appIcons.foodEnvironment,
      children: [
        buildRequiredLabel("What does your food environment look like?"),
        const SizedBox(height: 16),
        CommonText("Who usually cooks",
          style: const TextStyle(
            fontSize: 11, fontWeight: FontWeight.w500, color: Color(0xFF534343)
          )
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 12,
          children: hasDynamicWhoCooks
              ? dynamicWhoCooks.map((e) => ProfileChip(
                  label: e.label ?? "",
                  isSelected: _selectedWhoCooks == e.value,
                  onTap: () => setState(() {
                    _selectedWhoCooks = e.value;
                    if (_whoCooksError != null) _validate();
                  }),
                )).toList()
              : widget.foodEnvWhoCooks.map((e) => ProfileChip(
                  label: e.title ?? "",
                  isSelected: _selectedWhoCooks == e.uuid,
                  onTap: () => setState(() {
                    _selectedWhoCooks = e.uuid;
                    if (_whoCooksError != null) _validate();
                  }),
                )).toList(),
        ),
        if (_isSingleOtherSelected(_selectedWhoCooks, dynamicWhoCooks, widget.foodEnvWhoCooks)) ...[
          const SizedBox(height: 12),
          CommonTextField(
            label: "Please specify who usually cooks",
            hint: "Enter who prepares most meals",
            controller: _whoCooksOtherController,
            fillColor: appColors.textFieldBgColor,
            borderColor: Colors.transparent,
            isRequired: false,
          ),
        ],
        const SizedBox(height: 16),
        CommonText("Who you share most meals with",
          style: const TextStyle(
            fontSize: 11, fontWeight: FontWeight.w500, color: Color(0xFF534343)
          )
        ),
        const SizedBox(height: 6),
        CommonTextField(
          label: '',
          controller: _shareMealsController,
          hint: "e.g., Family (partner and parents)",
          fillColor: appColors.textFieldBgColor,
          borderColor: Colors.transparent,
        ),
        const SizedBox(height: 16),
        CommonText("How supportive they are",
          style: const TextStyle(
            fontSize: 11, fontWeight: FontWeight.w500, color: Color(0xFF534343)
          )
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 12,
          children: hasDynamicSupport
              ? dynamicSupport.map((e) => ProfileChip(
                  label: e.label ?? "",
                  isSelected: _selectedSupport == e.value,
                  onTap: () => setState(() => _selectedSupport = e.value),
                )).toList()
              : widget.foodEnvSupportLevel.map((e) => ProfileChip(
                  label: e.title ?? "",
                  isSelected: _selectedSupport == e.uuid,
                  onTap: () => setState(() => _selectedSupport = e.uuid),
                )).toList(),
        ),
        const SizedBox(height: 16),
        CommonText("Meals ordered or eaten out per week",
          style: const TextStyle(
            fontSize: 11, fontWeight: FontWeight.w500, color: Color(0xFF534343)
          )
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(color: appColors.textFieldBgColor, borderRadius: BorderRadius.circular(999)),
          child: Row(
            children: hasDynamicMealsOut
                ? dynamicMealsOut.map((e) => Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedMealsOut = e.value),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        decoration: BoxDecoration(
                          color: _selectedMealsOut == e.value ? appColors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(999),
                          boxShadow: _selectedMealsOut == e.value ? [BoxShadow(
                            color: appColors.black.withValues(alpha: 0.05), blurRadius: 1
                          )] : null,
                        ),
                        child: CommonText(
                          e.label ?? "",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: _selectedMealsOut == e.value ? appColors.primary : const Color(0xFF534343),
                          ),
                        ),
                      ),
                    ),
                  )).toList()
                : widget.foodEnvMealsOutPerWeek.map((e) => Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedMealsOut = e.uuid),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        decoration: BoxDecoration(
                          color: _selectedMealsOut == e.uuid ? appColors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(999),
                          boxShadow: _selectedMealsOut == e.uuid ? [BoxShadow(
                            color: appColors.black.withValues(alpha: 0.05), blurRadius: 1
                          )] : null,
                        ),
                        child: CommonText(
                          e.title ?? "",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: _selectedMealsOut == e.uuid ? appColors.primary : const Color(0xFF534343),
                          ),
                        ),
                      ),
                    ),
                  )).toList(),
          ),
        ),
        if (_whoCooksError != null) Padding(
          padding: const EdgeInsets.only(top: 8),
          child: CommonText(_whoCooksError!,
            style: TextStyle(color: appColors.red, fontSize: 12)
          )
        ),
      ],
    );
  }

  Widget _buildDailyIntakeSection() {
    return ProfileSectionCard(
      title: "Daily Intake Overview",
      icon: appIcons.dailyIntake,
      children: [
        buildRequiredLabel("On a usual day, what is your approximate intake?"),
        const SizedBox(height: 16),
        _buildIntakeRow(
          "Fruit", "intake_fruit", widget.intakeFruit, _intakeFruit,
          (v) => setState(() {
            _intakeFruit = v;
            if (_intakeError != null) _validate();
          })
        ),
        _buildIntakeRow(
          "Vegetables", "intake_vegetables", widget.intakeVegetables, _intakeVeg,
          (v) => setState(() {
            _intakeVeg = v;
            if (_intakeError != null) _validate();
          })
        ),
        _buildIntakeRow(
          "Water", "intake_water", widget.intakeWater, _intakeWater,
          (v) => setState(() {
            _intakeWater = v;
            if (_intakeError != null) _validate();
          })
        ),
        _buildIntakeRow(
          "Caffeinated drinks", "intake_caffeine", widget.intakeCaffeine, _intakeCaffeine,
          (v) => setState(() {
            _intakeCaffeine = v;
            if (_intakeError != null) _validate();
          })
        ),
        _buildIntakeRow(
          "Sugary foods or drinks", "intake_sugary", widget.intakeSugary, _intakeSugar,
          (v) => setState(() {
            _intakeSugar = v;
            if (_intakeError != null) _validate();
          })
        ),
        if (_intakeError != null) Padding(
          padding: const EdgeInsets.only(top: 4),
          child: CommonText(_intakeError!,
            style: TextStyle(color: appColors.red, fontSize: 12)
          )
        ),
      ],
    );
  }

  Widget _buildSubstanceSection() {
    final dynamicSubstances = _getField("substance_habits")?.options ?? [];
    final hasDynamicSubstances = dynamicSubstances.isNotEmpty;

    return ProfileSectionCard(
      title: "Substance Habits",
      icon: appIcons.substance,
      children: [
        buildRequiredLabel("Do you currently use alcohol, cigarettes, vaping products or recreational substances?"),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 12,
          children: hasDynamicSubstances
              ? dynamicSubstances.map((e) => ProfileChip(
                  label: e.label ?? "",
                  isSelected: _selectedSubstances.contains(e.value),
                  onTap: () {
                    setState(() {
                      final lower = (e.label ?? "").toLowerCase();
                      final isExclusive = lower == "no" || lower == "prefer not to answer";
                      if (isExclusive) {
                        _selectedSubstances.clear();
                        if (e.value != null) _selectedSubstances.add(e.value!);
                      } else {
                        for (final opt in dynamicSubstances) {
                          final optLower = (opt.label ?? "").toLowerCase();
                          if (optLower == "no" || optLower == "prefer not to answer") {
                            _selectedSubstances.remove(opt.value);
                          }
                        }
                        if (_selectedSubstances.contains(e.value)) {
                          _selectedSubstances.remove(e.value);
                        } else {
                          if (e.value != null) _selectedSubstances.add(e.value!);
                        }
                      }
                      if (_substanceError != null) _validate();
                    });
                  },
                )).toList()
              : widget.substanceHabits.map((e) => ProfileChip(
                  label: e.title ?? "",
                  isSelected: _selectedSubstances.contains(e.uuid),
                  onTap: () {
                    setState(() {
                      final lower = (e.title ?? "").toLowerCase();
                      final isExclusive = lower == "no" || lower == "prefer not to answer";
                      if (isExclusive) {
                        _selectedSubstances.clear();
                        if (e.uuid != null) _selectedSubstances.add(e.uuid!);
                      } else {
                        for (final item in widget.substanceHabits) {
                          final itemLower = (item.title ?? "").toLowerCase();
                          if (itemLower == "no" || itemLower == "prefer not to answer") {
                            _selectedSubstances.remove(item.uuid);
                          }
                        }
                        if (_selectedSubstances.contains(e.uuid)) {
                          _selectedSubstances.remove(e.uuid);
                        } else {
                          _selectedSubstances.add(e.uuid ?? "0");
                        }
                      }
                      if (_substanceError != null) _validate();
                    });
                  },
                )).toList(),
        ),
        if (_hasSelectedOther(_selectedSubstances, dynamicSubstances, widget.substanceHabits)) ...[
          const SizedBox(height: 12),
          CommonTextField(
            label: "Please specify other substances",
            hint: "Enter other substance details",
            controller: _substancesOtherController,
            fillColor: appColors.textFieldBgColor,
            borderColor: Colors.transparent,
            isRequired: false,
          ),
        ],
        if (_substanceError != null) Padding(
          padding: const EdgeInsets.only(top: 8),
          child: CommonText(_substanceError!,
            style: TextStyle(color: appColors.red, fontSize: 12)
          )
        ),
      ],
    );
  }

  Widget _buildDigestiveSection() {
    final dynamicDigestion = _getField("digestive_health")?.options ?? [];
    final hasDynamicDigestion = dynamicDigestion.isNotEmpty;

    return ProfileSectionCard(
      title: "Digestive Health",
      icon: appIcons.progress,
      children: [
        buildRequiredLabel("Do you currently experience any digestive concerns?"),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 12,
          children: hasDynamicDigestion
              ? dynamicDigestion.map((e) => ProfileChip(
                  label: e.label ?? "",
                  isSelected: _selectedDigestion.contains(e.value),
                  onTap: () {
                    setState(() {
                      final isNone = (e.label ?? "").toLowerCase() == "none";
                      if (isNone) {
                        _selectedDigestion.clear();
                        if (e.value != null) _selectedDigestion.add(e.value!);
                      } else {
                        for (final opt in dynamicDigestion) {
                          if ((opt.label ?? "").toLowerCase() == "none") {
                            _selectedDigestion.remove(opt.value);
                          }
                        }
                        if (_selectedDigestion.contains(e.value)) {
                          _selectedDigestion.remove(e.value);
                        } else {
                          if (e.value != null) _selectedDigestion.add(e.value!);
                        }
                      }
                      if (_digestionError != null) _validate();
                    });
                  },
                )).toList()
              : widget.digestiveHealth.map((e) => ProfileChip(
                  label: e.title ?? "",
                  isSelected: _selectedDigestion.contains(e.uuid),
                  onTap: () {
                    setState(() {
                      final isNone = (e.title ?? "").toLowerCase() == "none";
                      if (isNone) {
                        _selectedDigestion.clear();
                        if (e.uuid != null) _selectedDigestion.add(e.uuid!);
                      } else {
                        for (final item in widget.digestiveHealth) {
                          if ((item.title ?? "").toLowerCase() == "none") {
                            _selectedDigestion.remove(item.uuid);
                          }
                        }
                        if (_selectedDigestion.contains(e.uuid)) {
                          _selectedDigestion.remove(e.uuid);
                        } else {
                          _selectedDigestion.add(e.uuid ?? "0");
                        }
                      }
                      if (_digestionError != null) _validate();
                    });
                  },
                )).toList(),
        ),
        if (_hasSelectedOther(_selectedDigestion, dynamicDigestion, widget.digestiveHealth)) ...[
          const SizedBox(height: 12),
          CommonTextField(
            label: "Please specify other digestive concerns",
            hint: "Enter other digestive issues",
            controller: _digestionOtherController,
            fillColor: appColors.textFieldBgColor,
            borderColor: Colors.transparent,
            isRequired: false,
          ),
        ],
        if (_digestionError != null) Padding(
          padding: const EdgeInsets.only(top: 8),
          child: CommonText(_digestionError!,
            style: TextStyle(color: appColors.red, fontSize: 12)
          )
        ),
      ],
    );
  }

  bool _isOtherOption({String? value, String? label, String? title}) {
    final l = (label ?? title ?? value ?? '').trim().toLowerCase();
    final v = (value ?? '').trim().toLowerCase();
    return l == 'other' || l == 'others' || l.startsWith('other ') || l.startsWith('other(') || l.startsWith('other (') || v == 'other' || v == 'others';
  }

  bool _hasSelectedOther(Set<String> selectedValues, List<Option> dynamicOptions, List<OnboardingData> fallbackOptions) {
    for (final val in selectedValues) {
      if (_isOtherOption(value: val)) return true;
      for (final opt in dynamicOptions) {
        if (opt.value == val && _isOtherOption(value: opt.value, label: opt.label)) return true;
      }
      for (final item in fallbackOptions) {
        if (item.uuid == val && _isOtherOption(value: item.uuid, title: item.title)) return true;
      }
    }
    return false;
  }

  bool _isSingleOtherSelected(String? selectedValue, List<Option> dynamicOptions, List<OnboardingData> fallbackOptions) {
    if (selectedValue == null) return false;
    if (_isOtherOption(value: selectedValue)) return true;
    for (final opt in dynamicOptions) {
      if (opt.value == selectedValue && _isOtherOption(value: opt.value, label: opt.label)) return true;
    }
    for (final item in fallbackOptions) {
      if (item.uuid == selectedValue && _isOtherOption(value: item.uuid, title: item.title)) return true;
    }
    return false;
  }
}
