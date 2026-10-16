import 'package:flutter/material.dart';

import '../../../../main.dart';
import '../../../core/constants/utils.dart';
import '../../widgets/common_app_bar.dart';
import '../../widgets/common_text.dart';
import '../../widgets/common_text_field.dart';
import 'lifestyle_coaching_fit_screen.dart';
import 'widget/profile_bottom_button.dart';
import 'widget/profile_chip.dart';
import 'widget/profile_radio_option.dart';
import 'widget/profile_section_card.dart';

class FoodDigestionIntakeScreen extends StatefulWidget {
  const FoodDigestionIntakeScreen({super.key});

  @override
  State<FoodDigestionIntakeScreen> createState() => _FoodDigestionIntakeScreenState();
}

class _FoodDigestionIntakeScreenState extends State<FoodDigestionIntakeScreen> {
  // 1. Eating Pattern
  final List<String> _eatingPatternOptions = ["Vegetarian", "Vegan", "Eggitarian", "Non-vegetarian", "Pescatarian", "Other"];
  String? _selectedEatingPattern;
  String? _eatingPatternError;

  // 2. Cultural & Fasting Practices
  final List<String> _fastingOptions = [
    "Jain", "No onion or garlic", "Paryushan", "Navratri fasting",
    "Somvar or another regular fast", "Ramadan", "Other", "None"
  ];
  final Set<String> _selectedFasting = {};
  String? _fastingError;

  // 3. Weekday Meal Rhythms
  final TextEditingController _firstFoodController = TextEditingController();
  final TextEditingController _breakfastController = TextEditingController();
  final TextEditingController _lunchController = TextEditingController();
  final TextEditingController _snackController = TextEditingController();
  final TextEditingController _dinnerController = TextEditingController();
  final TextEditingController _lateNightController = TextEditingController();
  final TextEditingController _mealTimingsController = TextEditingController();
  String? _rhythmsError; // Track error broadly, or individually

  // 4. Weekend Routine
  final TextEditingController _weekendRoutineController = TextEditingController();

  // 5. Foods That Matter
  final TextEditingController _foodsEnjoyController = TextEditingController();
  final TextEditingController _foodsDislikeController = TextEditingController();
  final TextEditingController _foodsKeepController = TextEditingController();
  String? _foodsMatterError;

  // 6. Food Environment
  final List<String> _whoCooksOptions = ["Self", "Family", "Cook", "Canteen", "Delivery or combination"];
  String? _selectedWhoCooks;
  String? _whoCooksError;

  final TextEditingController _shareMealsController = TextEditingController();

  final List<String> _supportOptions = ["Supportive", "Neutral", "Resistant", "Not applicable"];
  String? _selectedSupport;

  String? _selectedMealsOut;
  final List<String> _mealsOutOptions = ["0–1", "2–3", "4–6", "7+"];

  // 7. Daily Intake Overview
  String? _intakeFruit;
  String? _intakeVeg;
  String? _intakeWater;
  String? _intakeCaffeine;
  String? _intakeSugar;
  String? _intakeError;

  // 8. Substance Habits
  final List<String> _substanceOptions = [
    "No", "Alcohol", "Cigarettes", "Vaping", "Recreational substances", "Prefer not to answer"
  ];
  final Set<String> _selectedSubstances = {};
  String? _substanceError;

  // 9. Digestive Health
  final List<String> _digestionOptions = [
    "Bloating", "Gas or frequent burping", "Acidity or reflux", "Constipation",
    "Loose stools", "Alternating constipation and loose stools", "Abdominal pain or cramps",
    "Nausea", "Feeling sleepy or very heavy after meals", "None"
  ];
  final Set<String> _selectedDigestion = {};
  String? _digestionError;

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

    if (_intakeFruit == null || _intakeVeg == null || _intakeWater == null || _intakeCaffeine == null || _intakeSugar == null) {
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
      appLog("Food & Digestion Form Validated!");
      navigation.pushReplaceFadeAnimation(context, LifestyleCoachingFitScreen());
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
              "CHAPTER 4 OF 6",
              style: TextStyle(
                fontSize: 11,
                color: appColors.primary,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.55,
              ),
            ),
            CommonText(
              "Food & Digestion",
              fontFamily: fontPlayfairDisplay,
              style: TextStyle(
                fontSize: 16,
                color: const Color(0xFF1D1B1A),
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
            onTap: _onSaveAndContinue,
          )
        ],
      ),
    );
  }

  Widget _buildIntakeRow(String label, List<String> options, String? selectedValue, ValueChanged<String> onSelected) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonText(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: const Color(0xFF1D1B1A))),
        const SizedBox(height: 6),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: options.map((e) => ProfileChip(
            label: e,
            isSelected: selectedValue == e,
            onTap: () => onSelected(e),
          )).toList(),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildEatingPatternSection() {
    return ProfileSectionCard(
      title: "Eating Pattern",
      icon: appIcons.eating,
      children: [
        buildRequiredLabel("Which eating pattern best describes you?"),
        const SizedBox(height: 12),
        ..._eatingPatternOptions.map((e) => ProfileRadioOption(
          label: e,
          isSelected: _selectedEatingPattern == e,
          onTap: () {
            setState(() {
              _selectedEatingPattern = e;
              if (_eatingPatternError != null) _validate();
            });
          },
        )),
        if (_eatingPatternError != null)
          Padding(padding: const EdgeInsets.only(top: 8), child: CommonText(_eatingPatternError!, style: TextStyle(color: appColors.red, fontSize: 12))),
      ],
    );
  }

  Widget _buildFastingSection() {
    return ProfileSectionCard(
      title: "Cultural & Fasting Practices",
      icon: appIcons.cultural,
      children: [
        buildRequiredLabel("Are there any religious, cultural or fasting practices your plan should accommodate?"),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 12,
          children: _fastingOptions.map((e) => ProfileChip(
            label: e,
            isSelected: _selectedFasting.contains(e),
            onTap: () {
              setState(() {
                if (e == "None") {
                  _selectedFasting.clear();
                  _selectedFasting.add(e);
                } else {
                  _selectedFasting.remove("None");
                  if (_selectedFasting.contains(e)) {
                    _selectedFasting.remove(e);
                  } else {
                    _selectedFasting.add(e);
                  }
                }
                if (_fastingError != null) _validate();
              });
            }
          )).toList(),
        ),
        if (_fastingError != null)
          Padding(padding: const EdgeInsets.only(top: 8), child: CommonText(_fastingError!, style: TextStyle(color: appColors.red, fontSize: 12))),
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
            CommonText(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: const Color(0xFF534343))),
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
        if (_rhythmsError != null)
          Padding(padding: const EdgeInsets.only(top: 8), child: CommonText(_rhythmsError!, style: TextStyle(color: appColors.red, fontSize: 12))),
      ],
    );
  }

  Widget _buildWeekendRoutineSection() {
    return ProfileSectionCard(
      title: "Weekend Routine",
      icon: appIcons.sofa,
      children: [
        CommonText("How is your weekend or eating-out routine different from weekdays?", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: const Color(0xFF534343))),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(color: appColors.textFieldBgColor, borderRadius: BorderRadius.circular(12)),
          child: TextField(
            controller: _weekendRoutineController,
            maxLines: 3,
            style: TextStyle(fontSize: 14, color: const Color(0xFF1D1B1A), fontFamily: fontFamilyPlusJakartaSans),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "e.g., Later breakfast around 11 AM...",
              hintStyle: TextStyle(fontSize: 14, color: const Color(0xFF9A8687)),
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
            CommonText(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: const Color(0xFF534343))),
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
                  hintStyle: TextStyle(fontSize: 14, color: const Color(0xFF9A8687)),
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
        if (_foodsMatterError != null)
          Padding(padding: const EdgeInsets.only(top: 4), child: CommonText(_foodsMatterError!, style: TextStyle(color: appColors.red, fontSize: 12))),
      ],
    );
  }

  Widget _buildFoodEnvironmentSection() {
    return ProfileSectionCard(
      title: "Food Environment",
      icon: appIcons.foodEnvironment,
      children: [
        buildRequiredLabel("What does your food environment look like?"),
        const SizedBox(height: 16),
        CommonText("Who usually cooks", style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: const Color(0xFF534343))),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 12,
          children: _whoCooksOptions.map((e) => ProfileChip(
            label: e,
            isSelected: _selectedWhoCooks == e,
            onTap: () => setState(() { _selectedWhoCooks = e; if (_whoCooksError != null) _validate(); }),
          )).toList(),
        ),
        const SizedBox(height: 16),
        CommonText("Who you share most meals with", style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: const Color(0xFF534343))),
        const SizedBox(height: 6),
        CommonTextField(
          label: '',
          controller: _shareMealsController,
          hint: "e.g., Family (partner and parents)",
          fillColor: appColors.textFieldBgColor,
          borderColor: Colors.transparent,
        ),
        const SizedBox(height: 16),
        CommonText("How supportive they are", style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: const Color(0xFF534343))),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 12,
          children: _supportOptions.map((e) => ProfileChip(
            label: e,
            isSelected: _selectedSupport == e,
            onTap: () => setState(() => _selectedSupport = e),
          )).toList(),
        ),
        const SizedBox(height: 16),
        CommonText("Meals ordered or eaten out per week", style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: const Color(0xFF534343))),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(color: appColors.textFieldBgColor, borderRadius: BorderRadius.circular(999)),
          child: Row(
            children: _mealsOutOptions.map((e) => Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _selectedMealsOut = e),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  decoration: BoxDecoration(
                    color: _selectedMealsOut == e ? appColors.white : Colors.transparent,
                    borderRadius: BorderRadius.circular(999),
                    boxShadow: _selectedMealsOut == e ? [BoxShadow(color: appColors.black.withValues(alpha: 0.05), blurRadius: 1)] : null,
                  ),
                  child: CommonText(
                    e,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: _selectedMealsOut == e ? appColors.primary : const Color(0xFF534343),
                    ),
                  ),
                ),
              ),
            )).toList(),
          ),
        ),
        if (_whoCooksError != null)
          Padding(padding: const EdgeInsets.only(top: 8), child: CommonText(_whoCooksError!, style: TextStyle(color: appColors.red, fontSize: 12))),
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
        _buildIntakeRow("Fruit", ["None", "1 serving", "2 servings", "3+"], _intakeFruit, (v) => setState(() { _intakeFruit = v; if (_intakeError != null) _validate(); })),
        _buildIntakeRow("Vegetables", ["None", "1 serving", "2 servings", "3+"], _intakeVeg, (v) => setState(() { _intakeVeg = v; if (_intakeError != null) _validate(); })),
        _buildIntakeRow("Water", ["Below 1 L", "1–2 L", "2–3 L", "3–4 L", "Above 4 L"], _intakeWater, (v) => setState(() { _intakeWater = v; if (_intakeError != null) _validate(); })),
        _buildIntakeRow("Caffeinated drinks", ["None", "1", "2", "3+"], _intakeCaffeine, (v) => setState(() { _intakeCaffeine = v; if (_intakeError != null) _validate(); })),
        _buildIntakeRow("Sugary foods or drinks", ["Rarely", "1–2 weekly", "3–4 weekly", "Daily"], _intakeSugar, (v) => setState(() { _intakeSugar = v; if (_intakeError != null) _validate(); })),
        if (_intakeError != null)
          Padding(padding: const EdgeInsets.only(top: 4), child: CommonText(_intakeError!, style: TextStyle(color: appColors.red, fontSize: 12))),
      ],
    );
  }

  Widget _buildSubstanceSection() {
    return ProfileSectionCard(
      title: "Substance Habits",
      icon: appIcons.substance,
      children: [
        buildRequiredLabel("Do you currently use alcohol, cigarettes, vaping products or recreational substances?"),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 12,
          children: _substanceOptions.map((e) => ProfileChip(
            label: e,
            isSelected: _selectedSubstances.contains(e),
            selectedBgColor: e == "No" ? const Color(0xFFD8E5BF) : null,
            selectedTextColor: e == "No" ? const Color(0xFF5B6749) : null,
            onTap: () {
              setState(() {
                if (e == "No" || e == "Prefer not to answer") {
                  _selectedSubstances.clear();
                  _selectedSubstances.add(e);
                } else {
                  _selectedSubstances.remove("No");
                  _selectedSubstances.remove("Prefer not to answer");
                  if (_selectedSubstances.contains(e)) {
                    _selectedSubstances.remove(e);
                  } else {
                    _selectedSubstances.add(e);
                  }
                }
                if (_substanceError != null) _validate();
              });
            }
          )).toList(),
        ),
        if (_substanceError != null)
          Padding(padding: const EdgeInsets.only(top: 8), child: CommonText(_substanceError!, style: TextStyle(color: appColors.red, fontSize: 12))),
      ],
    );
  }

  Widget _buildDigestiveSection() {
    return ProfileSectionCard(
      title: "Digestive Health",
      icon: appIcons.progress,
      children: [
        buildRequiredLabel("Do you currently experience any digestive concerns?"),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 12,
          children: _digestionOptions.map((e) => ProfileChip(
            label: e,
            isSelected: _selectedDigestion.contains(e),
            selectedBgColor: e == "None" ? const Color(0xFFD8E5BF) : null,
            selectedTextColor: e == "None" ? const Color(0xFF5B6749) : null,
            onTap: () {
              setState(() {
                if (e == "None") {
                  _selectedDigestion.clear();
                  _selectedDigestion.add(e);
                } else {
                  _selectedDigestion.remove("None");
                  if (_selectedDigestion.contains(e)) {
                    _selectedDigestion.remove(e);
                  } else {
                    _selectedDigestion.add(e);
                  }
                }
                if (_digestionError != null) _validate();
              });
            }
          )).toList(),
        ),
        if (_digestionError != null)
          Padding(padding: const EdgeInsets.only(top: 8), child: CommonText(_digestionError!, style: TextStyle(color: appColors.red, fontSize: 12))),
      ],
    );
  }
}