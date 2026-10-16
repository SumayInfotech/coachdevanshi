import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../main.dart';
import '../../../core/constants/utils.dart';
import '../../widgets/common_app_bar.dart';
import '../../widgets/common_button.dart';
import '../../widgets/common_text.dart';
import '../../widgets/common_text_field.dart';

class ThreeDayFoodDiaryScreen extends StatefulWidget {
  const ThreeDayFoodDiaryScreen({super.key});

  @override
  State<ThreeDayFoodDiaryScreen> createState() => _ThreeDayFoodDiaryScreenState();
}

class _ThreeDayFoodDiaryScreenState extends State<ThreeDayFoodDiaryScreen> {
  int _selectedDayIndex = 0;

  final TextEditingController _dateController = TextEditingController(text: DateFormat('MMMM dd, yyyy').format(DateTime.now()));
  DateTime _selectedDate = DateTime.now();
  String? _dateError;

  // Meal 1
  final TextEditingController _m1TimeController = TextEditingController(text: "8:30 AM");
  final TextEditingController _m1FoodController = TextEditingController();
  String? _m1TimeError;
  String? _m1FoodError;

  // Meal 2
  final TextEditingController _m2TimeController = TextEditingController(text: "1:15 PM");
  final TextEditingController _m2FoodController = TextEditingController();
  String? _m2TimeError;
  String? _m2FoodError;

  // Meal 3
  final TextEditingController _m3TimeController = TextEditingController(text: "8:00 PM");
  final TextEditingController _m3FoodController = TextEditingController();
  String? _m3TimeError;
  String? _m3FoodError;

  // Snacks
  final TextEditingController _snacksController = TextEditingController();

  // Reflections
  final List<String> _sensationsList = [
    "Bloating", "✓ Light & energized", "Brain fog",
    "Acid reflux", "✓ Calm & nourished", "Sluggish"
  ];
  final Set<String> _selectedSensations = {};

  final TextEditingController _notesController = TextEditingController();

  bool _validate() {
    bool isValid = true;

    if (_dateController.text.trim().isEmpty) {
      _dateError = "Required";
      isValid = false;
    } else {
      _dateError = null;
    }

    if (_m1TimeController.text.trim().isEmpty) {
      _m1TimeError = "Required";
      isValid = false;
    } else {
      _m1TimeError = null;
    }

    if (_m1FoodController.text.trim().isEmpty) {
      _m1FoodError = "Required";
      isValid = false;
    } else {
      _m1FoodError = null;
    }

    if (_m2TimeController.text.trim().isEmpty) {
      _m2TimeError = "Required";
      isValid = false;
    } else {
      _m2TimeError = null;
    }

    if (_m2FoodController.text.trim().isEmpty) {
      _m2FoodError = "Required";
      isValid = false;
    } else {
      _m2FoodError = null;
    }

    if (_m3TimeController.text.trim().isEmpty) {
      _m3TimeError = "Required";
      isValid = false;
    } else {
      _m3TimeError = null;
    }

    if (_m3FoodController.text.trim().isEmpty) {
      _m3FoodError = "Required";
      isValid = false;
    } else {
      _m3FoodError = null;
    }

    setState(() {});
    return isValid;
  }

  void _onSave() {
    if (_validate()) {
      appLog("Food Diary Saved!");
      navigation.pop(context);
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('MMMM dd, yyyy').format(picked);
        if (_dateError != null) _validate();
      });
    }
  }

  Future<void> _selectTime(TextEditingController controller) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null && mounted) {
      setState(() {
        controller.text = picked.format(context);
      });
    }
  }

  @override
  void dispose() {
    _dateController.dispose();
    _m1TimeController.dispose();
    _m1FoodController.dispose();
    _m2TimeController.dispose();
    _m2FoodController.dispose();
    _m3TimeController.dispose();
    _m3FoodController.dispose();
    _snacksController.dispose();
    _notesController.dispose();
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
        title: CommonText(
          "Daily Wellness Log",
          fontFamily: fontPlayfairDisplay,
          style: TextStyle(
            fontSize: 16,
            color: const Color(0xFF1D1B1A),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              children: [
                _buildDaySelector(),
                const SizedBox(height: 16),
                _buildDateRecordCard(),
                const SizedBox(height: 24),
                _buildMealCard(
                  title: "Morning / Breakfast",
                  icon: appIcons.morning,
                  timeController: _m1TimeController,
                  foodController: _m1FoodController,
                  timeError: _m1TimeError,
                  foodError: _m1FoodError,
                  foodHint: "e.g., 2 sourdough toasts with avocado, poached egg...",
                ),
                const SizedBox(height: 20),
                _buildMealCard(
                  title: "Afternoon / Lunch",
                  icon: appIcons.afternoon,
                  timeController: _m2TimeController,
                  foodController: _m2FoodController,
                  timeError: _m2TimeError,
                  foodError: _m2FoodError,
                  foodHint: "e.g., Dal, brown rice, stir-fried spinach...",
                ),
                const SizedBox(height: 20),
                _buildMealCard(
                  title: "Evening / Dinner",
                  icon: appIcons.evening,
                  timeController: _m3TimeController,
                  foodController: _m3FoodController,
                  timeError: _m3TimeError,
                  foodError: _m3FoodError,
                  foodHint: "e.g., Grilled paneer with roasted vegetables...",
                ),
                const SizedBox(height: 20),
                _buildSnacksCard(),
                const SizedBox(height: 20),
                _buildReflectionsCard(),
                const SizedBox(height: 24),
                CommonButton(
                  name: "Save Food Diary Entry",
                  icon: Icons.arrow_forward_rounded,
                  isIconFirst: false,
                  imageSize: 16,
                  btnColor: appColors.primary,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  onTap: _onSave,
                ),
                const SizedBox(height: 16),
                Center(
                  child: CommonText(
                    "You can update or edit your entries anytime before your\ncoaching review.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: const Color(0xFF534343),
                    ),
                  ),
                ),
                SizedBox(height: bottomPadding(context)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDaySelector() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CommonText(
              "Select Day to Log",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF534343),
                letterSpacing: 0.24,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0x80DBE7C2), // approx 0.5 opacity
                borderRadius: BorderRadius.circular(999),
              ),
              child: CommonText(
                "Day ${_selectedDayIndex + 1} of 3",
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF576245),
                ),
              ),
            )
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: appColors.textFieldBgColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              _buildDayTab(0, "Day 1", "Weekday"),
              _buildDayTab(1, "Day 2", "Weekday"),
              _buildDayTab(2, "Day 3", "Weekend", isRequired: true),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDayTab(int index, String title, String subtitle, {bool isRequired = false}) {
    bool isSelected = _selectedDayIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedDayIndex = index),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? appColors.white : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                boxShadow: isSelected ? [BoxShadow(color: appColors.black.withValues(alpha: 0.05), blurRadius: 1)] : null,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CommonText(
                        title,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                          color: isSelected ? appColors.primary : const Color(0xFF1D1B1A),
                        ),
                      ),
                      if (isRequired && !isSelected) ...[
                        const SizedBox(width: 4),
                        Container(width: 6, height: 6, decoration: BoxDecoration(shape: BoxShape.circle, color: const Color(0xFF8E464C))),
                      ]
                    ],
                  ),
                  CommonText(
                    subtitle,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: isSelected ? const Color(0xFF534343) : const Color(0xFF857373),
                    ),
                  ),
                ],
              ),
            ),
            if (isRequired)
              Positioned(
                top: -8,
                right: -6,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFF8E464C),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: const CommonText(
                    "Required",
                    style: TextStyle(fontSize: 9, color: Colors.white),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateRecordCard() {
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
        children: [
          Row(
            children: [
              Icon(Icons.calendar_today_outlined, color: appColors.primary, size: 16),
              const SizedBox(width: 8),
              buildRequiredLabel("Date of Record"),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFEDE7E5),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: CommonText(
                  _selectedDayIndex == 2 ? "Weekend" : "Weekday",
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: const Color(0xFF534343)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          CommonTextField(
            label: '',
            controller: _dateController,
            hint: "October 25, 2024",
            fillColor: appColors.textFieldBgColor,
            borderColor: Colors.transparent,
            readOnly: true,
            suffixIcon: Icon(Icons.edit_calendar_outlined, size: 18, color: appColors.primary),
            error: _dateError,
            onTap: _selectDate,
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
    String? timeError,
    String? foodError,
    required String foodHint,
  }) {
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
          Row(
            children: [
              Image.asset(icon, height: 20, width: 20, color: appColors.primary),
              const SizedBox(width: 8),
              CommonText(
                title,
                fontFamily: fontPlayfairDisplay,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF1D1B1A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          buildRequiredLabel("Time Taken"),
          const SizedBox(height: 6),
          CommonTextField(
            label: '',
            controller: timeController,
            hint: "e.g., 8:30 AM",
            fillColor: appColors.textFieldBgColor,
            borderColor: Colors.transparent,
            readOnly: true,
            prefixIcon: const Icon(Icons.access_time_rounded, size: 16, color: Color(0xFF857373)),
            error: timeError,
            onTap: () => _selectTime(timeController),
          ),
          const SizedBox(height: 16),
          buildRequiredLabel("Food & Beverage Items"),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: appColors.textFieldBgColor,
              borderRadius: BorderRadius.circular(12),
              border: foodError != null ? Border.all(color: appColors.red) : null,
            ),
            child: TextField(
              controller: foodController,
              maxLines: 4,
              minLines: 3,
              style: TextStyle(fontSize: 14, color: const Color(0xFF1D1B1A), fontFamily: fontFamilyPlusJakartaSans),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: foodHint,
                hintStyle: TextStyle(fontSize: 14, color: const Color(0xFF857373)),
                isDense: true,
              ),
              onChanged: (v) {
                if (foodError != null) _validate();
              },
            ),
          ),
          if (foodError != null)
            Padding(padding: const EdgeInsets.only(top: 4), child: CommonText(foodError, style: TextStyle(color: appColors.red, fontSize: 12))),
        ],
      ),
    );
  }

  Widget _buildSnacksCard() {
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
          Row(
            children: [
              Image.asset(appIcons.snacks, height: 20, width: 20, color: appColors.primary),
              const SizedBox(width: 8),
              CommonText(
                "Snacks & Beverages",
                fontFamily: fontPlayfairDisplay,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF1D1B1A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          CommonText("Mid-day Bites, Hydration & Nourishment", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: const Color(0xFF534343))),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: appColors.textFieldBgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              controller: _snacksController,
              maxLines: 4,
              minLines: 2,
              style: TextStyle(fontSize: 14, color: const Color(0xFF1D1B1A), fontFamily: fontFamilyPlusJakartaSans),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "e.g., Handful of walnuts, 1 apple with nut butter, 3L water throughout day",
                hintStyle: TextStyle(fontSize: 14, color: const Color(0xFF857373)),
                isDense: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReflectionsCard() {
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
          Row(
            children: [
              Image.asset(appIcons.digestive, height: 20, width: 20, color: appColors.primary),
              const SizedBox(width: 8),
              Expanded(
                child: CommonText(
                  "Digestive & Emotional Reflections",
                  fontFamily: fontPlayfairDisplay,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF1D1B1A),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          CommonText("Noticeable Bodily or Gut Sensations", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: const Color(0xFF534343))),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 12,
            children: _sensationsList.map((e) => GestureDetector(
              onTap: () {
                setState(() {
                  if (_selectedSensations.contains(e)) {
                    _selectedSensations.remove(e);
                  } else {
                    _selectedSensations.add(e);
                  }
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _selectedSensations.contains(e) ? const Color(0xFFDBE7C2) : const Color(0xFFEDE7E5),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: CommonText(
                  e,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: _selectedSensations.contains(e) ? const Color(0xFF151E07) : const Color(0xFF1D1B1A),
                  ),
                ),
              ),
            )).toList(),
          ),
          const SizedBox(height: 16),
          CommonText("Context & Environment Notes", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: const Color(0xFF534343))),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: appColors.textFieldBgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              controller: _notesController,
              maxLines: 4,
              minLines: 2,
              style: TextStyle(fontSize: 14, color: const Color(0xFF1D1B1A), fontFamily: fontFamilyPlusJakartaSans),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "e.g., Felt calm during lunch, rushed dinner due to late team meeting...",
                hintStyle: TextStyle(fontSize: 14, color: const Color(0xFF857373)),
                isDense: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
