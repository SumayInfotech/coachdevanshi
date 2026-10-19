import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../../../main.dart';
import '../../../core/constants/utils.dart';
import '../../widgets/common_app_bar.dart';
import '../../widgets/common_button.dart';
import '../../widgets/common_text.dart';
import '../../widgets/common_text_field.dart';
import '../bottom_bar_screen.dart';
import 'widget/check_in_section_card.dart';

class DailyWellnessLogScreen extends StatefulWidget {
  const DailyWellnessLogScreen({super.key});

  @override
  State<DailyWellnessLogScreen> createState() => _DailyWellnessLogScreenState();
}

class _DailyWellnessLogScreenState extends State<DailyWellnessLogScreen> {
  // Section 1: Date
  int _selectedDay = 1;
  final TextEditingController _dateController = TextEditingController(text: DateFormat('MMMM dd, yyyy').format(DateTime.now()));
  String? _dateError;

  // Section 2: Circadian Rhythm & Rest
  final TextEditingController _weightController = TextEditingController();
  bool _isKgSelected = true;
  final TextEditingController _wakeUpController = TextEditingController(text: "06:30 AM");
  final TextEditingController _bedtimeController = TextEditingController(text: "10:45 PM");
  String _sleepQuality = "Deep & Restorative";

  // Section 3: Movement & Hydration
  final TextEditingController _stepsController = TextEditingController(text: "8450");
  final TextEditingController _waterController = TextEditingController(text: "2.5");
  bool _isLitresSelected = true;

  // Section 4: Mindset & Rituals
  bool _isMeditationDone = true;
  final TextEditingController _meditationNotesController = TextEditingController();
  bool _isJournalingDone = true;
  final TextEditingController _journalingNotesController = TextEditingController();

  // Meals
  final TextEditingController _breakfastTimeController = TextEditingController(text: "8:30 AM");
  final TextEditingController _breakfastFoodController = TextEditingController();
  String? _breakfastTimeError;
  String? _breakfastFoodError;

  final TextEditingController _midMorningTimeController = TextEditingController(text: "11:00 AM");
  final TextEditingController _midMorningFoodController = TextEditingController();
  String? _midMorningTimeError;
  String? _midMorningFoodError;

  final TextEditingController _lunchTimeController = TextEditingController(text: "1:15 PM");
  final TextEditingController _lunchFoodController = TextEditingController();
  String? _lunchTimeError;
  String? _lunchFoodError;

  final TextEditingController _dinnerTimeController = TextEditingController(text: "8:00 PM");
  final TextEditingController _dinnerFoodController = TextEditingController();
  String? _dinnerTimeError;
  String? _dinnerFoodError;

  bool _validate() {
    bool isValid = true;

    if (_dateController.text.trim().isEmpty) {
      _dateError = "Please select a date";
      isValid = false;
    } else {
      _dateError = null;
    }

    // Breakfast
    if (_breakfastTimeController.text.trim().isEmpty) {
      _breakfastTimeError = "Required";
      isValid = false;
    } else {
      _breakfastTimeError = null;
    }
    if (_breakfastFoodController.text.trim().isEmpty) {
      _breakfastFoodError = "Required";
      isValid = false;
    } else {
      _breakfastFoodError = null;
    }

    // Mid-Morning
    if (_midMorningTimeController.text.trim().isEmpty) {
      _midMorningTimeError = "Required";
      isValid = false;
    } else {
      _midMorningTimeError = null;
    }
    if (_midMorningFoodController.text.trim().isEmpty) {
      _midMorningFoodError = "Required";
      isValid = false;
    } else {
      _midMorningFoodError = null;
    }

    // Lunch
    if (_lunchTimeController.text.trim().isEmpty) {
      _lunchTimeError = "Required";
      isValid = false;
    } else {
      _lunchTimeError = null;
    }
    if (_lunchFoodController.text.trim().isEmpty) {
      _lunchFoodError = "Required";
      isValid = false;
    } else {
      _lunchFoodError = null;
    }

    // Dinner
    if (_dinnerTimeController.text.trim().isEmpty) {
      _dinnerTimeError = "Required";
      isValid = false;
    } else {
      _dinnerTimeError = null;
    }
    if (_dinnerFoodController.text.trim().isEmpty) {
      _dinnerFoodError = "Required";
      isValid = false;
    } else {
      _dinnerFoodError = null;
    }

    setState(() {});
    return isValid;
  }

  void _onSave() {
    if (_validate()) {
      appLog("Daily Check-in Validated and Saved!");
      _onBack();
    }
  }

  @override
  void dispose() {
    _dateController.dispose();
    _weightController.dispose();
    _wakeUpController.dispose();
    _bedtimeController.dispose();
    _stepsController.dispose();
    _waterController.dispose();
    _meditationNotesController.dispose();
    _journalingNotesController.dispose();
    _breakfastTimeController.dispose();
    _breakfastFoodController.dispose();
    _midMorningTimeController.dispose();
    _midMorningFoodController.dispose();
    _lunchTimeController.dispose();
    _lunchFoodController.dispose();
    _dinnerTimeController.dispose();
    _dinnerFoodController.dispose();
    super.dispose();
  }

  void _onBack() {
    // Jump to HomeScreen tab instead of popping the route
    bottomPageController.jumpToPage(BottomBarScreenIndex.home);
  }

  Future<void> _selectTime(TextEditingController controller) async {
    final String currentTimeText = controller.text.trim();
    TimeOfDay initialTime = TimeOfDay.now();

    if (currentTimeText.isNotEmpty) {
      try {
        final DateTime parsedTime = DateFormat.jm().parse(currentTimeText);
        initialTime = TimeOfDay.fromDateTime(parsedTime);
      } catch (e) {
        appLog("Error parsing time: $e");
      }
    }

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    if (picked != null) {
      final now = DateTime.now();
      final dt = DateTime(now.year, now.month, now.day, picked.hour, picked.minute);
      setState(() => controller.text = DateFormat('hh:mm a').format(dt));
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
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
            "Daily Wellness Log",
            fontFamily: fontPlayfairDisplay,
            style: TextStyle(
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
            _buildDateSelection(),
            const SizedBox(height: 24),
            _buildCircadianRhythm(),
            const SizedBox(height: 24),
            _buildMovementAndHydration(),
            const SizedBox(height: 24),
            _buildMindsetAndRituals(),
            const SizedBox(height: 24),
            _buildMealCard(
              title: "Morning / Breakfast",
              icon: appIcons.morning,
              timeController: _breakfastTimeController,
              foodController: _breakfastFoodController,
              timeError: _breakfastTimeError,
              foodError: _breakfastFoodError,
              foodHint: "e.g., 2 sourdough toasts with avocado, poached egg, and warm cinnamon latte",
            ),
            const SizedBox(height: 16),
            _buildMealCard(
              title: "Mid-Morning Nourishment",
              icon: appIcons.afternoon, // Or snacks
              timeController: _midMorningTimeController,
              foodController: _midMorningFoodController,
              timeError: _midMorningTimeError,
              foodError: _midMorningFoodError,
              foodHint: "e.g. Green tea & a small bowl of roasted walnuts",
            ),
            const SizedBox(height: 16),
            _buildMealCard(
              title: "Afternoon / Lunch",
              icon: appIcons.afternoon,
              timeController: _lunchTimeController,
              foodController: _lunchFoodController,
              timeError: _lunchTimeError,
              foodError: _lunchFoodError,
              foodHint: "e.g., Dal, brown rice, stir-fried spinach and cucumber raita",
            ),
            const SizedBox(height: 16),
            _buildMealCard(
              title: "Evening / Dinner",
              icon: appIcons.evening,
              timeController: _dinnerTimeController,
              foodController: _dinnerFoodController,
              timeError: _dinnerTimeError,
              foodError: _dinnerFoodError,
              foodHint: "e.g., Grilled paneer with roasted vegetables and warm herbal broth",
            ),
            const SizedBox(height: 32),
            CommonButton(
              name: "Save Daily Check-in",
              onTap: _onSave,
              icon: Icons.arrow_forward_rounded,
              isIconFirst: false,
              btnColor: const Color(0xFF8B484D),
              fontColor: appColors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              radius: 999,
            ),
            const SizedBox(height: 24),
          ],
        ),
      )
    );
  }

  Widget _buildDateSelection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: appColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: appColors.black.withValues(alpha: 0.05),
            offset: const Offset(0, 1),
            blurRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildRequiredLabel("Select Day to Log", color: const Color(0xFF534343)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(7, (index) {
              int day = index + 1;
              bool isSelected = _selectedDay == day;
              return GestureDetector(
                onTap: () => setState(() => _selectedDay = day),
                child: Container(
                  width: 40,
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF8B484D) : const Color(0xFFF8F2F0),
                    borderRadius: BorderRadius.circular(8),
                    border: isSelected ? null : Border.all(color: const Color(0xFF576245).withValues(alpha: 0.3)),
                    boxShadow: isSelected
                        ? [BoxShadow(color: Colors.black.withValues(alpha: 0.05), offset: const Offset(0, 1), blurRadius: 1)]
                        : null,
                  ),
                  child: CommonText(
                    "D$day",
                    style: TextStyle(
                      fontSize: isSelected ? 15 : 12,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? appColors.white : (day > 5 ? const Color(0xFF713439) : const Color(0xFF534343)),
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 24),
          CommonTextField(
            label: "Date of Record",
            controller: _dateController,
            isRequired: true,
            hint: "Select Date",
            readOnly: true,
            error: _dateError,
            borderColor: Colors.transparent,
            fillColor: const Color(0xFFF8F2F0),
            suffixIcon: const Icon(Icons.calendar_today_outlined, size: 16, color: Color(0xFF1D1B1A)),
            onTap: () async {
              DateTime? picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2101),
              );
              if (picked != null) {
                setState(() {
                  _dateController.text = DateFormat('MMMM dd, yyyy').format(picked);
                  if (_dateError != null) _validate();
                });
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCircadianRhythm() {
    return CheckInSectionCard(
      title: "Circadian Rhythm & Rest",
      icon: appIcons.halfOutlineMoon,
      iconBgColor: const Color(0xFFFFDADB),
      iconColor: const Color(0xFF8B484D),
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF8F2F0),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.asset(appIcons.weight, height: 16, color: appColors.primary),
                  const SizedBox(width: 8),
                  const CommonText(
                    "Morning Weight",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1D1B1A),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              CommonTextField(
                label: "",
                controller: _weightController,
                isRequired: false,
                hint: "e.g., 64.5",
                isDense: true,
                borderColor: Colors.transparent,
                fillColor: appColors.white,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [digitalWithDot],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildUnitToggleBtn(
                      label: "Kilograms (kg)",
                      isSelected: _isKgSelected,
                      onTap: () => setState(() => _isKgSelected = true),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildUnitToggleBtn(
                      label: "Pounds (lbs)",
                      isSelected: !_isKgSelected,
                      onTap: () => setState(() => _isKgSelected = false),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F2F0),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Image.asset(appIcons.morning, height: 14, color: const Color(0xFF576245)),
                        const SizedBox(width: 6),
                        const CommonText(
                          "WAKE UP",
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF576245), letterSpacing: 0.5),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    CommonTextField(
                      label: "",
                      controller: _wakeUpController,
                      isRequired: false,
                      isDense: true,
                      readOnly: true,
                      borderColor: Colors.transparent,
                      fillColor: appColors.white,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1D1B1A)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      onTap: () => _selectTime(_wakeUpController),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F2F0),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Image.asset(appIcons.halfOutlineMoon, height: 14, color: const Color(0xFF8E464C)),
                        const SizedBox(width: 6),
                        const CommonText(
                          "BEDTIME",
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF8E464C), letterSpacing: 0.5),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    CommonTextField(
                      label: "",
                      controller: _bedtimeController,
                      isRequired: false,
                      isDense: true,
                      readOnly: true,
                      borderColor: Colors.transparent,
                      fillColor: appColors.white,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1D1B1A)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      onTap: () => _selectTime(_bedtimeController),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const CommonText(
              "Sleep Quality Experience",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF1D1B1A)),
            ),
            const CommonText(
              "7.5 hrs logged",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF8B484D)),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildSleepQualityChip("Deep & Restorative", Icons.check_circle_outline, const Color(0xFFD8E5BF), const Color(0xFF5B6749)),
            _buildSleepQualityChip("Moderately refreshed", Icons.sentiment_satisfied, const Color(0xFFF8F2F0), const Color(0xFF534343)),
            _buildSleepQualityChip("Light / Restless", Icons.bedtime_outlined, const Color(0xFFF8F2F0), const Color(0xFF534343)),
            _buildSleepQualityChip("Interrupted", Icons.warning_amber_rounded, const Color(0xFFF8F2F0), const Color(0xFF534343)),
          ],
        ),
      ],
    );
  }

  Widget _buildSleepQualityChip(String label, IconData icon, Color bgColor, Color textColor) {
    bool isSelected = _sleepQuality == label;
    return GestureDetector(
      onTap: () => setState(() => _sleepQuality = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFD8E5BF) : const Color(0xFFF8F2F0),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: isSelected ? const Color(0xFF5B6749) : const Color(0xFF534343)),
            const SizedBox(width: 6),
            CommonText(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: isSelected ? const Color(0xFF5B6749) : const Color(0xFF534343),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMovementAndHydration() {
    return CheckInSectionCard(
      title: "Movement & Hydration",
      icon: appIcons.movement,
      iconBgColor: const Color(0xFFD8E5BF),
      iconColor: const Color(0xFF5B6749),
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF8F2F0),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.directions_walk_rounded, size: 16, color: appColors.primary),
                  const SizedBox(width: 8),
                  const CommonText(
                    "Steps completed today",
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1D1B1A)),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              CommonTextField(
                label: "",
                controller: _stepsController,
                isRequired: false,
                isDense: true,
                borderColor: Colors.transparent,
                fillColor: appColors.white,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF1D1B1A)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF8F2F0),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.water_drop_outlined, size: 16, color: appColors.primary),
                  const SizedBox(width: 8),
                  const CommonText(
                    "Water Intake",
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1D1B1A)),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              CommonTextField(
                label: "",
                controller: _waterController,
                isRequired: false,
                isDense: true,
                borderColor: Colors.transparent,
                fillColor: appColors.white,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [digitalWithDot],
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF1D1B1A)),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildUnitToggleBtn(
                      label: "Litres",
                      isSelected: _isLitresSelected,
                      onTap: () => setState(() => _isLitresSelected = true),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildUnitToggleBtn(
                      label: "Glasses",
                      isSelected: !_isLitresSelected,
                      onTap: () => setState(() => _isLitresSelected = false),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMindsetAndRituals() {
    return CheckInSectionCard(
      title: "Mindset & Rituals",
      icon: appIcons.mindset,
      iconBgColor: const Color(0xFFFFDADA),
      iconColor: const Color(0xFF8B484D),
      children: [
        _buildRitualCard(
          title: "Meditation done today",
          icon: appIcons.mindset,
          isDone: _isMeditationDone,
          onDoneChanged: (v) => setState(() => _isMeditationDone = v),
          notesTitle: "Meditation Notes or Duration",
          notesHint: "e.g. 15 mins restorative box-breathing",
          notesController: _meditationNotesController,
        ),
        const SizedBox(height: 16),
        _buildRitualCard(
          title: "Journaling done today",
          icon: appIcons.note,
          isDone: _isJournalingDone,
          onDoneChanged: (v) => setState(() => _isJournalingDone = v),
          notesTitle: "Journaling & Expressive Notes",
          notesHint: "e.g. Morning gratitude for crisp morning light. Evening reflection on releasing anxiety around work milestones.",
          notesController: _journalingNotesController,
        ),
      ],
    );
  }

  Widget _buildRitualCard({
    required String title,
    required String icon,
    required bool isDone,
    required ValueChanged<bool> onDoneChanged,
    required String notesTitle,
    required String notesHint,
    required TextEditingController notesController,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F2F0),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(icon, height: 16, color: const Color(0xFF1D1B1A)),
              const SizedBox(width: 8),
              CommonText(
                title,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1D1B1A)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => onDoneChanged(true),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      color: isDone ? const Color(0xFFFFDADB) : const Color(0xFFEDE7E5),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: isDone
                          ? [BoxShadow(color: Colors.black.withValues(alpha: 0.05), offset: const Offset(0, 1), blurRadius: 1)]
                          : null,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CommonText(
                          "Yes",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isDone ? const Color(0xFF713439) : const Color(0xFF1D1B1A),
                          ),
                        ),
                        if (isDone)
                          Container(
                            width: 20,
                            height: 20,
                            decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFF8B484D)),
                            child: const Icon(Icons.check, size: 12, color: Colors.white),
                          )
                        else
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white, border: Border.all(color: const Color(0xFFE7E1DF))),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: GestureDetector(
                  onTap: () => onDoneChanged(false),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      color: !isDone ? const Color(0xFFFFDADB) : const Color(0xFFEDE7E5),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: !isDone
                          ? [BoxShadow(color: Colors.black.withValues(alpha: 0.05), offset: const Offset(0, 1), blurRadius: 1)]
                          : null,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CommonText(
                          "No",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: !isDone ? const Color(0xFF713439) : const Color(0xFF1D1B1A),
                          ),
                        ),
                        if (!isDone)
                          Container(
                            width: 20,
                            height: 20,
                            decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFF8B484D)),
                            child: const Icon(Icons.check, size: 12, color: Colors.white),
                          )
                        else
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white, border: Border.all(color: const Color(0xFFE7E1DF))),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          CommonText(
            notesTitle,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1D1B1A)),
          ),
          const SizedBox(height: 8),
          CommonTextField(
            label: "",
            controller: notesController,
            isRequired: false,
            hint: notesHint,
            maxLines: 3,
            borderColor: Colors.transparent,
            fillColor: appColors.white,
          ),
        ],
      ),
    );
  }

  Widget _buildMealCard({
    required String title,
    required String icon,
    required TextEditingController timeController,
    required TextEditingController foodController,
    required String? timeError,
    required String? foodError,
    required String foodHint,
  }) {
    return CheckInSectionCard(
      title: title,
      icon: icon,
      children: [
        buildRequiredLabel("Time Taken", color: const Color(0xFF534343)),
        const SizedBox(height: 6),
        CommonTextField(
          label: "",
          controller: timeController,
          isRequired: false,
          isDense: true,
          readOnly: true,
          borderColor: timeError != null ? appColors.red : Colors.transparent,
          fillColor: const Color(0xFFF8F2F0),
          prefixIcon: const Icon(Icons.access_time, size: 16, color: Color(0xFF534343)),
          onTap: () => _selectTime(timeController),
        ),
        if (timeError != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 4),
            child: CommonText(timeError, style: TextStyle(color: appColors.red, fontSize: 12)),
          ),
        const SizedBox(height: 16),
        buildRequiredLabel("Food & Beverage Items", color: const Color(0xFF534343)),
        const SizedBox(height: 6),
        CommonTextField(
          label: "",
          controller: foodController,
          isRequired: false,
          hint: foodHint,
          maxLines: 3,
          borderColor: foodError != null ? appColors.red : Colors.transparent,
          fillColor: const Color(0xFFF8F2F0),
          onChanged: (v) {
            setState(() {});
            if (foodError != null) _validate();
          },
        ),
        if (foodError != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 4),
            child: CommonText(foodError, style: TextStyle(color: appColors.red, fontSize: 12)),
          ),
      ],
    );
  }

  Widget _buildUnitToggleBtn({required String label, required bool isSelected, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFDADB) : const Color(0xFFE7E1DF),
          borderRadius: BorderRadius.circular(999),
          boxShadow: isSelected
              ? [BoxShadow(color: Colors.black.withValues(alpha: 0.05), offset: const Offset(0, 1), blurRadius: 1)]
              : null,
        ),
        child: CommonText(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected ? const Color(0xFF3A0910) : const Color(0xFF534343),
          ),
        ),
      ),
    );
  }
}
