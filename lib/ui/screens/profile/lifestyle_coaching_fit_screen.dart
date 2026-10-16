import 'package:flutter/material.dart';

import '../../../../main.dart';
import '../../../core/constants/utils.dart';
import '../../widgets/common_app_bar.dart';
import '../../widgets/common_text.dart';
import '../../widgets/common_text_field.dart';
import 'mindset_sustainability_screen.dart';
import 'widget/profile_bottom_button.dart';
import 'widget/profile_chip.dart';
import 'widget/profile_radio_option.dart';
import 'widget/profile_section_card.dart';

class LifestyleCoachingFitScreen extends StatefulWidget {
  const LifestyleCoachingFitScreen({super.key});

  @override
  State<LifestyleCoachingFitScreen> createState() => _LifestyleCoachingFitScreenState();
}

class _LifestyleCoachingFitScreenState extends State<LifestyleCoachingFitScreen> {
  // --- Section 1: Sleep & Morning Rhythms ---
  final TextEditingController _bedtimeController = TextEditingController();
  final TextEditingController _wakeTimeController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  String? _sleepError;

  final List<String> _nightWakingOptions = ["Never", "Monthly", "1–2 times weekly", "3+ times weekly", "Most nights"];
  String? _selectedNightWaking;
  String? _nightWakingError;

  final List<String> _firstHourOptions = ["Ready to go", "Slow but okay", "Foggy and reluctant", "Need caffeine to function"];
  String? _selectedFirstHour;
  String? _firstHourError;

  // --- Section 2: Activity & Movement ---
  final List<String> _dailyActivityOptions = [
    "Mostly seated with little movement",
    "Mostly seated but some regular walking",
    "On my feet for part of the day",
    "Physically active work or high daily movement",
    "Activity varies significantly by day"
  ];
  String? _selectedDailyActivity;
  String? _dailyActivityError;

  final List<String> _avgStepsOptions = ["Not tracked", "Below 3,000", "3,000–4,999", "5,000–7,499", "7,500–9,999", "10,000–12,499", "12,500+"];
  String? _selectedAvgSteps;
  String? _avgStepsError;

  final List<String> _workoutsCountOptions = ["0", "1", "2", "3", "4", "5+"];
  String? _selectedWorkoutsCount;
  String? _workoutsCountError;

  final TextEditingController _workoutTypesController = TextEditingController();
  final TextEditingController _wearableController = TextEditingController();
  final TextEditingController _enjoyDislikeController = TextEditingController();
  String? _activityDetailsError;

  String? _selectedRealisticCapacity;
  String? _realisticCapacityError;

  // --- Section 3: Stress & Decompression ---
  final TextEditingController _stress1Controller = TextEditingController();
  final TextEditingController _stress2Controller = TextEditingController();
  final TextEditingController _stress3Controller = TextEditingController();
  String? _stressSourcesError;

  final List<String> _stressChangeOptions = [
    "Food choices or cravings", "Meal timing", "Sleep", "Movement",
    "Mood or patience", "Digestion", "Check-ins or communication",
    "Nothing noticeable", "Other"
  ];
  final Set<String> _selectedStressChanges = {};
  String? _stressChangeError;

  final TextEditingController _decompressionController = TextEditingController();
  String? _decompressionError;

  // --- Section 4: Readiness & Coaching Partnership ---
  int? _readinessScore;
  String? _readinessError;

  final List<String> _interruptionsOptions = [
    "Work pressure", "Travel", "Social events", "Family responsibilities",
    "Poor sleep", "Low energy", "Cravings or emotional eating", "Pain or illness",
    "Lack of food preparation", "All-or-nothing thinking", "Limited support at home", "Other"
  ];
  final Set<String> _selectedInterruptions = {};
  String? _interruptionsError;

  bool _validate() {
    bool isValid = true;

    // Sleep
    if (_bedtimeController.text.trim().isEmpty || _wakeTimeController.text.trim().isEmpty || _durationController.text.trim().isEmpty) {
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
    if (_stress1Controller.text.trim().isEmpty || _stress2Controller.text.trim().isEmpty || _stress3Controller.text.trim().isEmpty) {
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
      appLog("Lifestyle & Coaching Fit Validated!");
      navigation.pushReplaceFadeAnimation(context, MindsetSustainabilityScreen());
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
              "CHAPTER 5 OF 6",
              style: TextStyle(
                fontSize: 11,
                color: appColors.primary,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.55,
              ),
            ),
            CommonText(
              "Lifestyle & Coaching Fit",
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
          _buildSleepSection(),
          const SizedBox(height: 24),
          _buildActivitySection(),
          const SizedBox(height: 24),
          _buildStressSection(),
          const SizedBox(height: 24),
          _buildReadinessSection(),
          const SizedBox(height: 24),
          ProfileBottomButton(
            onTap: _onSaveAndContinue,
          )
        ],
      ),
    );
  }

  Widget _buildNumberedListField(String number, String hint, TextEditingController controller) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CommonText(number, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: const Color(0xFF857373))),
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
    Widget buildTimeInput(String label, String hint, TextEditingController controller) {
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
            CommonText(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: const Color(0xFF534343))),
            const SizedBox(height: 6),
            CommonTextField(
              label: '',
              controller: controller,
              fillColor: appColors.white,
              hint: hint,
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
        buildTimeInput("Bedtime", "e.g., 10:45 PM", _bedtimeController),
        buildTimeInput("Wake time", "e.g., 6:30 AM", _wakeTimeController),
        buildTimeInput("Typical duration", "e.g., 7.5 hours", _durationController),
        if (_sleepError != null)
          Padding(padding: const EdgeInsets.only(bottom: 12), child: CommonText(_sleepError!, style: TextStyle(color: appColors.red, fontSize: 12))),

        const SizedBox(height: 8),
        CommonText("Night waking frequency", style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: const Color(0xFF534343))),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 12,
          children: _nightWakingOptions.map((e) => ProfileChip(
            label: e,
            isSelected: _selectedNightWaking == e,
            onTap: () {
              setState(() {
                _selectedNightWaking = e;
                if (_nightWakingError != null) _validate();
              });
            },
          )).toList(),
        ),
        if (_nightWakingError != null)
          Padding(padding: const EdgeInsets.only(top: 4), child: CommonText(_nightWakingError!, style: TextStyle(color: appColors.red, fontSize: 12))),

        const SizedBox(height: 16),
        CommonText("First hour after waking", style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: const Color(0xFF534343))),
        const SizedBox(height: 8),
        ..._firstHourOptions.map((e) => ProfileRadioOption(
          label: e,
          isSelected: _selectedFirstHour == e,
          onTap: () {
            setState(() {
              _selectedFirstHour = e;
              if (_firstHourError != null) _validate();
            });
          },
        )),
        if (_firstHourError != null)
          Padding(padding: const EdgeInsets.only(top: 4), child: CommonText(_firstHourError!, style: TextStyle(color: appColors.red, fontSize: 12))),
      ],
    );
  }

  Widget _buildActivitySection() {
    Widget buildNumPicker(String? selected, List<String> options, ValueChanged<String> onSelected) {
      return Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(color: appColors.textFieldBgColor, borderRadius: BorderRadius.circular(999)),
        child: Row(
          children: options.map((e) => Expanded(
            child: GestureDetector(
              onTap: () => onSelected(e),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 6),
                decoration: BoxDecoration(
                  color: selected == e ? appColors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(999),
                  boxShadow: selected == e ? [BoxShadow(color: appColors.black.withValues(alpha: 0.05), blurRadius: 1)] : null,
                ),
                child: CommonText(
                  e,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: selected == e ? appColors.primary : const Color(0xFF534343),
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
          CommonText(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: const Color(0xFF534343))),
          const SizedBox(height: 6),
          CommonTextField(
            controller: controller,
            label: "", // Dummy label to satisfy required prop, hide using styling if possible or leave empty
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
        ..._dailyActivityOptions.map((e) => ProfileRadioOption(
          label: e,
          isSelected: _selectedDailyActivity == e,
          onTap: () {
            setState(() {
              _selectedDailyActivity = e;
              if (_dailyActivityError != null) _validate();
            });
          },
        )),
        if (_dailyActivityError != null)
          Padding(padding: const EdgeInsets.only(top: 4, bottom: 12), child: CommonText(_dailyActivityError!, style: TextStyle(color: appColors.red, fontSize: 12))),

        const SizedBox(height: 8),
        CommonText("Average daily steps", style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: const Color(0xFF534343))),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 12,
          children: _avgStepsOptions.map((e) => ProfileChip(
            label: e,
            isSelected: _selectedAvgSteps == e,
            onTap: () {
              setState(() {
                _selectedAvgSteps = e;
                if (_avgStepsError != null) _validate();
              });
            },
          )).toList(),
        ),
        if (_avgStepsError != null)
          Padding(padding: const EdgeInsets.only(top: 8, bottom: 12), child: CommonText(_avgStepsError!, style: TextStyle(color: appColors.red, fontSize: 12))),

        const SizedBox(height: 16),
        CommonText("Current workouts per week", style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: const Color(0xFF534343))),
        const SizedBox(height: 8),
        buildNumPicker(_selectedWorkoutsCount, _workoutsCountOptions, (v) => setState(() { _selectedWorkoutsCount = v; if (_workoutsCountError != null) _validate(); })),
        if (_workoutsCountError != null)
          Padding(padding: const EdgeInsets.only(top: 4, bottom: 12), child: CommonText(_workoutsCountError!, style: TextStyle(color: appColors.red, fontSize: 12))),

        const SizedBox(height: 16),
        buildActivityInput("Movement or workout types", "e.g., Brisk walking, weekend trails", _workoutTypesController),
        buildActivityInput("Wearable or health app used", "e.g., Apple Watch SE", _wearableController),
        buildActivityInput("Any movement you enjoy or dislike", "e.g., Enjoy evening walks; dislike running", _enjoyDislikeController),

        const SizedBox(height: 8),
        CommonText("On an ordinary week, how many days could you realistically make time for intentional movement?", style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: const Color(0xFF534343))),
        const SizedBox(height: 8),
        buildNumPicker(_selectedRealisticCapacity, _workoutsCountOptions, (v) => setState(() { _selectedRealisticCapacity = v; if (_realisticCapacityError != null) _validate(); })),
        if (_realisticCapacityError != null)
          Padding(padding: const EdgeInsets.only(top: 4), child: CommonText(_realisticCapacityError!, style: TextStyle(color: appColors.red, fontSize: 12))),
      ],
    );
  }

  Widget _buildStressSection() {
    return ProfileSectionCard(
      title: "Stress & Decompression",
      icon: appIcons.heart,
      children: [
        CommonText("What are the three biggest sources of stress in your life right now, and what tends to change first when stress is high?", style: TextStyle(fontSize: 13, color: const Color(0xFF534343))),
        const SizedBox(height: 16),

        _buildNumberedListField("1.", "e.g., Back-to-back work meetings", _stress1Controller),
        _buildNumberedListField("2.", "e.g., Irregular travel or commuting", _stress2Controller),
        _buildNumberedListField("3.", "e.g., Managing family schedules", _stress3Controller),
        if (_stressSourcesError != null)
          Padding(padding: const EdgeInsets.only(bottom: 12), child: CommonText(_stressSourcesError!, style: TextStyle(color: appColors.red, fontSize: 12))),

        CommonText("What tends to change first when stress is high?", style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: const Color(0xFF534343))),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 12,
          children: _stressChangeOptions.map((e) => ProfileChip(
            label: e,
            isSelected: _selectedStressChanges.contains(e),
            onTap: () {
              setState(() {
                if (_selectedStressChanges.contains(e)) {
                  _selectedStressChanges.remove(e);
                } else {
                  _selectedStressChanges.add(e);
                }
                if (_stressChangeError != null) _validate();
              });
            },
          )).toList(),
        ),
        if (_stressChangeError != null)
          Padding(padding: const EdgeInsets.only(top: 8, bottom: 12), child: CommonText(_stressChangeError!, style: TextStyle(color: appColors.red, fontSize: 12))),

        const SizedBox(height: 16),
        CommonText("When you feel overwhelmed, what helps you come back down — if anything?", style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: const Color(0xFF534343))),
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
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "e.g., Stepping away to brew tea...",
              hintStyle: TextStyle(fontSize: 14, color: const Color(0xFF9A8687)),
              isDense: true,
            ),
            onChanged: (v) { if (_decompressionError != null) _validate(); },
          ),
        ),
        if (_decompressionError != null)
          Padding(padding: const EdgeInsets.only(top: 4), child: CommonText(_decompressionError!, style: TextStyle(color: appColors.red, fontSize: 12))),
      ],
    );
  }

  Widget _buildReadinessSection() {
    return ProfileSectionCard(
      title: "Readiness & Coaching Partnership",
      icon: appIcons.compass,
      children: [
        CommonText("How ready do you feel to make changes right now?", style: TextStyle(fontSize: 13, color: const Color(0xFF534343))),
        const SizedBox(height: 12),
        // 1 to 10 Grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.only(bottom: 5),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            childAspectRatio: 1.3,
            crossAxisSpacing: 6,
            mainAxisSpacing: 6,
          ),
          itemCount: 10,
          itemBuilder: (context, index) {
            int score = index + 1;
            bool isSelected = _readinessScore == score;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _readinessScore = score;
                  if (_readinessError != null) _validate();
                });
              },
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected ? appColors.primary : appColors.textFieldBgColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: isSelected ? [BoxShadow(color: appColors.black.withValues(alpha: 0.05), blurRadius: 1)] : null,
                ),
                child: CommonText(
                  score.toString(),
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
        if (_readinessError != null)
          Padding(padding: const EdgeInsets.only(top: 8), child: CommonText(_readinessError!, style: TextStyle(color: appColors.red, fontSize: 12))),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CommonText("1: Hesitant / exploring", style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: const Color(0xFF857373))),
            CommonText("10: Fully committed & ready", style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: const Color(0xFF857373))),
          ],
        ),

        const SizedBox(height: 24),
        CommonText("What most commonly interrupts your consistency?\n(Select up to 3)", style: TextStyle(fontSize: 13, color: const Color(0xFF1D1B1A))),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 12,
          children: _interruptionsOptions.map((e) => ProfileChip(
            label: e,
            isSelected: _selectedInterruptions.contains(e),
            onTap: () {
              setState(() {
                if (_selectedInterruptions.contains(e)) {
                  _selectedInterruptions.remove(e);
                } else {
                  if (_selectedInterruptions.length < 3) {
                    _selectedInterruptions.add(e);
                  } else {
                    appLog("Can only select up to 3 options");
                  }
                }
                if (_interruptionsError != null) _validate();
              });
            },
          )).toList(),
        ),
        if (_interruptionsError != null)
          Padding(padding: const EdgeInsets.only(top: 8), child: CommonText(_interruptionsError!, style: TextStyle(color: appColors.red, fontSize: 12))),
      ],
    );
  }
}
