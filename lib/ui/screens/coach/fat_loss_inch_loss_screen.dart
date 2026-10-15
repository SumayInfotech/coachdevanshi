import 'package:flutter/material.dart';

import '../../../../main.dart';
import '../../../core/constants/utils.dart';
import '../../widgets/common_app_bar.dart';
import '../../widgets/common_button.dart';
import '../../widgets/common_text.dart';
import '../../widgets/common_text_field.dart';
import '../profile/widget/profile_section_card.dart';
import 'widget/habit_matrix_item.dart';

class FatLossInchLossScreen extends StatefulWidget {
  const FatLossInchLossScreen({super.key});

  @override
  State<FatLossInchLossScreen> createState() => _FatLossInchLossScreenState();
}

class _FatLossInchLossScreenState extends State<FatLossInchLossScreen> {
  // Section 1: Weight History & Natural Rhythms
  final TextEditingController _highestWeightController = TextEditingController(text: "74.0");
  final TextEditingController _highestYearController = TextEditingController(text: "2021");
  final TextEditingController _lowestWeightController = TextEditingController(text: "58.5");
  final TextEditingController _lowestYearController = TextEditingController(text: "2018");
  final TextEditingController _weightPeriodsController = TextEditingController();

  String? _highestWeightError;
  String? _lowestWeightError;

  // Section 2: Past Transitions & Biological Triggers
  final TextEditingController _pastTransitionsController = TextEditingController();
  String? _pastTransitionsError;

  // Section 3: Habit Readiness & Boundary Matrix
  String _eatingOutReady = "";
  String _lateNightEatingReady = "Could reduce with support";
  String _sweetsReady = "";
  String _packagedFoodsReady = "";
  String _alcoholReady = "";
  String _skippingMealsReady = "";
  String? _habitMatrixError;

  // Section 4: Sustainable Momentum & Maintenance
  final TextEditingController _momentumController = TextEditingController();
  String? _momentumError;

  bool _validate() {
    bool isValid = true;

    // Weight History
    if (_highestWeightController.text.trim().isEmpty) {
      _highestWeightError = "Required";
      isValid = false;
    } else {
      _highestWeightError = null;
    }
    if (_lowestWeightController.text.trim().isEmpty) {
      _lowestWeightError = "Required";
      isValid = false;
    } else {
      _lowestWeightError = null;
    }

    // Past Transitions
    if (_pastTransitionsController.text.trim().isEmpty) {
      _pastTransitionsError = "Required";
      isValid = false;
    } else {
      _pastTransitionsError = null;
    }

    // Habit Readiness
    if (_eatingOutReady.isEmpty || _lateNightEatingReady.isEmpty || 
        _sweetsReady.isEmpty || _packagedFoodsReady.isEmpty || 
        _alcoholReady.isEmpty || _skippingMealsReady.isEmpty) {
      _habitMatrixError = "Please select readiness for all habits";
      isValid = false;
    } else {
      _habitMatrixError = null;
    }

    // Momentum
    if (_momentumController.text.trim().isEmpty) {
      _momentumError = "Required";
      isValid = false;
    } else {
      _momentumError = null;
    }

    setState(() {});
    return isValid;
  }

  void _onSave() {
    if (_validate()) {
      showSnackBar(context: context, isError: false, message: 'Fat Loss and Inch Loss Submitted!');
      navigation.pop(context);
    } else {
      showSnackBar(context: context, isError: true, message: 'Please complete all required fields.');
    }
  }

  Future<void> _selectYear(BuildContext context, TextEditingController controller) async {
    final int currentYear = DateTime.now().year;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const CommonText("Select Year", style: TextStyle(fontWeight: FontWeight.bold)),
          content: SizedBox(
            width: 300,
            height: 300,
            child: YearPicker(
              firstDate: DateTime(currentYear - 100),
              lastDate: DateTime(currentYear + 5),
              selectedDate: DateTime(int.tryParse(controller.text) ?? currentYear),
              onChanged: (DateTime dateTime) {
                controller.text = dateTime.year.toString();
                Navigator.pop(context);
              },
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _highestWeightController.dispose();
    _highestYearController.dispose();
    _lowestWeightController.dispose();
    _lowestYearController.dispose();
    _weightPeriodsController.dispose();
    _pastTransitionsController.dispose();
    _momentumController.dispose();
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
        title: const CommonText(
          "Fat Loss Inch Loss Protocol",
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF1D1B1A),
            fontWeight: FontWeight.w600,
            fontFamily: "Playfair_Display",
            letterSpacing: 0.24,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        children: [
          _buildWeightHistorySection(),
          const SizedBox(height: 24),
          _buildPastTransitionsSection(),
          const SizedBox(height: 24),
          _buildHabitReadinessSection(),
          const SizedBox(height: 24),
          _buildSustainableMomentumSection(),
          const SizedBox(height: 32),
          CommonButton(
            name: "Save & Submit Fat Loss Protocol",
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
    );
  }

  Widget _buildWeightHistorySection() {
    return ProfileSectionCard(
      title: "Weight History & Natural Rhythms",
      icon: appIcons.weight,
      children: [
        const CommonText(
          "What has your weight pattern looked like over the past few years?",
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF534343), height: 20/13),
        ),
        const SizedBox(height: 16),
        _buildWeightYearRow(
          title: "Highest Adult Weight",
          weightController: _highestWeightController,
          yearController: _highestYearController,
          error: _highestWeightError,
        ),
        const SizedBox(height: 8),
        _buildWeightYearRow(
          title: "Lowest Adult Weight",
          weightController: _lowestWeightController,
          yearController: _lowestYearController,
          error: _lowestWeightError,
        ),
        const SizedBox(height: 16),
        const CommonText("Periods of major gain or loss", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1D1B1A))),
        const SizedBox(height: 6),
        CommonTextField(
          label: "",
          controller: _weightPeriodsController,
          hint: "e.g., Gained around 6 kg during job transition in 2021 with frequent travel and irregular dinners; lost 4 kg during lock down",
          maxLines: 4,
          borderColor: Colors.transparent,
          fillColor: const Color(0xFFF8F2F0),
        ),
      ],
    );
  }

  Widget _buildWeightYearRow({
    required String title,
    required TextEditingController weightController,
    required TextEditingController yearController,
    String? error,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F2F0),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonText(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1D1B1A))),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: CommonTextField(
                  label: "",
                  controller: weightController,
                  isRequired: false,
                  isDense: true,
                  borderColor: error != null ? appColors.red : Colors.transparent,
                  fillColor: appColors.white,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [digitalWithDot],
                  suffixText: "kg",
                  onChanged: (v) {
                    setState(() {});
                    if (error != null) _validate();
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: CommonTextField(
                  label: "",
                  controller: yearController,
                  isRequired: false,
                  isDense: true,
                  readOnly: true,
                  onTap: () => _selectYear(context, yearController),
                  borderColor: Colors.transparent,
                  fillColor: appColors.white,
                  keyboardType: TextInputType.number,
                  prefixIcon: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CommonText("Year", style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Color(0xFF534343))),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (error != null)
            Padding(
              padding: const EdgeInsets.only(top: 4, left: 4),
              child: CommonText(error, style: TextStyle(color: appColors.red, fontSize: 12)),
            ),
        ],
      ),
    );
  }

  Widget _buildPastTransitionsSection() {
    return ProfileSectionCard(
      title: "Past Transitions & Biological Triggers",
      icon: appIcons.resetCheck,
      children: [
        buildRequiredLabel("When weight or habits returned before, what do you believe was happening in your body, routine or life?", color: const Color(0xFF534343)),
        const SizedBox(height: 16),
        CommonTextField(
          label: "",
          controller: _pastTransitionsController,
          hint: "e.g., Extreme calorie cutting made me burn out and crave sweets in the late evening; when work stress peaked, lack of sleep triggered mindless snacking and fatigue.",
          maxLines: 5,
          borderColor: _pastTransitionsError != null ? appColors.red : Colors.transparent,
          fillColor: const Color(0xFFF8F2F0),
          onChanged: (v) {
            setState(() {});
            if (_pastTransitionsError != null) _validate();
          },
        ),
        if (_pastTransitionsError != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 4),
            child: CommonText(_pastTransitionsError!, style: TextStyle(color: appColors.red, fontSize: 12)),
          ),
      ],
    );
  }

  Widget _buildHabitReadinessSection() {
    return ProfileSectionCard(
      title: "Habit Readiness & Boundary Matrix",
      icon: appIcons.control,
      children: [
        buildRequiredLabel("Which changes feel manageable now, and which feel very difficult?", color: const Color(0xFF534343)),
        const SizedBox(height: 16),
        HabitMatrixItem(
          title: "1. Eating out",
          selectedValue: _eatingOutReady,
          onChanged: (v) {
            setState(() {
              _eatingOutReady = v;
              if (_habitMatrixError != null) _validate();
            });
          },
        ),
        const SizedBox(height: 16),
        HabitMatrixItem(
          title: "2. Late-night eating",
          selectedValue: _lateNightEatingReady,
          onChanged: (v) {
            setState(() {
              _lateNightEatingReady = v;
              if (_habitMatrixError != null) _validate();
            });
          },
        ),
        const SizedBox(height: 16),
        HabitMatrixItem(
          title: "3. Sweets & Confectionery",
          selectedValue: _sweetsReady,
          onChanged: (v) {
            setState(() {
              _sweetsReady = v;
              if (_habitMatrixError != null) _validate();
            });
          },
        ),
        const SizedBox(height: 16),
        HabitMatrixItem(
          title: "4. Packaged & Processed foods",
          selectedValue: _packagedFoodsReady,
          onChanged: (v) {
            setState(() {
              _packagedFoodsReady = v;
              if (_habitMatrixError != null) _validate();
            });
          },
        ),
        const SizedBox(height: 16),
        HabitMatrixItem(
          title: "5. Alcohol consumption",
          selectedValue: _alcoholReady,
          onChanged: (v) {
            setState(() {
              _alcoholReady = v;
              if (_habitMatrixError != null) _validate();
            });
          },
        ),
        const SizedBox(height: 16),
        HabitMatrixItem(
          title: "6. Skipping meals",
          selectedValue: _skippingMealsReady,
          onChanged: (v) {
            setState(() {
              _skippingMealsReady = v;
              if (_habitMatrixError != null) _validate();
            });
          },
        ),
        if (_habitMatrixError != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: CommonText(_habitMatrixError!, style: TextStyle(color: appColors.red, fontSize: 12)),
          ),
      ],
    );
  }

  Widget _buildSustainableMomentumSection() {
    return ProfileSectionCard(
      title: "Sustainable Momentum & Maintenance",
      icon: appIcons.flag, // Placeholder
      children: [
        buildRequiredLabel("Once you reach your goal, what would help you maintain it?", color: const Color(0xFF534343)),
        const SizedBox(height: 16),
        CommonTextField(
          label: "",
          controller: _momentumController,
          hint: "e.g., Having a flexible 80/20 guideline for dining out, continuous habit accountability, gentle strength training routine",
          maxLines: 4,
          borderColor: _momentumError != null ? appColors.red : Colors.transparent,
          fillColor: const Color(0xFFF8F2F0),
          onChanged: (v) {
            setState(() {});
            if (_momentumError != null) _validate();
          },
        ),
        if (_momentumError != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 4),
            child: CommonText(_momentumError!, style: TextStyle(color: appColors.red, fontSize: 12)),
          ),
      ],
    );
  }
}
