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
import 'track_weekly_progress_screen.dart';

class BaselineProgressScreen extends StatefulWidget {
  const BaselineProgressScreen({super.key});

  @override
  State<BaselineProgressScreen> createState() => _BaselineProgressScreenState();
}

class _BaselineProgressScreenState extends State<BaselineProgressScreen> {
  final TextEditingController _dateController = TextEditingController(text: "October 24, 2024");
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _chestController = TextEditingController();
  final TextEditingController _abdomenController = TextEditingController();
  final TextEditingController _hipController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  String? _dateError;
  String? _weightError;
  String? _chestError;
  String? _abdomenError;
  String? _hipError;

  bool _isKgSelected = true;
  bool _isChestCmSelected = true;
  bool _isAbdomenCmSelected = true;
  bool _isHipCmSelected = true;

  @override
  void initState() {
    super.initState();
    _dateController.text = DateFormat('MMMM dd, yyyy').format(_selectedDate);
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

    setState(() {});
    return isValid;
  }

  void _onSave() {
    if (_validate()) {
      appLog("Baseline Progress Saved!");
      navigation.pushSlideAnimation(context, TrackWeeklyProgressScreen());
    }
  }

  @override
  void dispose() {
    _dateController.dispose();
    _weightController.dispose();
    _chestController.dispose();
    _abdomenController.dispose();
    _hipController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _onBack() {
    bottomPageController.jumpToPage(BottomBarScreenIndex.home);
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
        title: CommonText(
          "Baseline And Progress Measurements",
          style: TextStyle(
            fontSize: 16,
            color: const Color(0xFF1D1B1A),
            fontWeight: FontWeight.w600,
            fontFamily: "Playfair_Display",
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              children: [
                _buildDateSection(),
                const SizedBox(height: 16),
                _buildWeightSection(),
                const SizedBox(height: 16),
                _buildChestSection(),
                const SizedBox(height: 16),
                _buildAbdomenSection(),
                const SizedBox(height: 16),
                _buildHipSection(),
                const SizedBox(height: 16),
                _buildNotesSection(),
                const SizedBox(height: 32),
                CommonButton(
                  name: "Save",
                  icon: Icons.arrow_forward_rounded,
                  isIconFirst: false,
                  imageSize: 16,
                  btnColor: appColors.primary,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  onTap: _onSave,
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }

  Widget _buildSectionCard({required String title, required String icon, required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: appColors.white,
        borderRadius: BorderRadius.circular(16),
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
              Expanded(
                child: CommonText(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Playfair_Display",
                    color: const Color(0xFF1D1B1A),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _buildToggleRow(String labelLeft, String labelRight, bool isLeftSelected, ValueChanged<bool> onChanged) {
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
              ),
            ),
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
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('MMMM dd, yyyy').format(picked);
        if (_dateError != null) _validate();
      });
    }
  }

  Widget _buildDateSection() {
    return _buildSectionCard(
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
    return _buildSectionCard(
      title: "Weight",
      icon: appIcons.weight,
      children: [
        CommonTextField(
          label: '',
          controller: _weightController,
          hint: "e.g., 64.5",
          keyboardType: TextInputType.number,
          fillColor: appColors.textFieldBgColor,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          borderColor: Colors.transparent,
          error: _weightError,
          onChanged: (v) { if (_weightError != null) _validate(); },
        ),
        const SizedBox(height: 12),
        _buildToggleRow("Kilograms (kg)", "Pounds (lbs)", _isKgSelected, (v) => setState(() => _isKgSelected = v)),
      ],
    );
  }

  Widget _buildChestSection() {
    return _buildSectionCard(
      title: "Chest",
      icon: appIcons.measurement,
      children: [
        buildRequiredLabel("Measure around the fullest part of your chest with relaxed breathing."),
        const SizedBox(height: 8),
        CommonTextField(
          label: '',
          controller: _chestController,
          hint: "e.g., 88.0",
          keyboardType: TextInputType.number,
          fillColor: appColors.textFieldBgColor,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          borderColor: Colors.transparent,
          error: _chestError,
          onChanged: (v) { if (_chestError != null) _validate(); },
        ),
        const SizedBox(height: 12),
        _buildToggleRow("Centimetres (cm)", "Inches (in)", _isChestCmSelected, (v) => setState(() => _isChestCmSelected = v)),
      ],
    );
  }

  Widget _buildAbdomenSection() {
    return _buildSectionCard(
      title: "Abdomen at Navel",
      icon: appIcons.abdomen,
      children: [
        buildRequiredLabel("Measure horizontally across your navel/belly button without pulling the tape tight."),
        const SizedBox(height: 8),
        CommonTextField(
          label: '',
          controller: _abdomenController,
          hint: "e.g., 78.5",
          keyboardType: TextInputType.number,
          fillColor: appColors.textFieldBgColor,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          borderColor: Colors.transparent,
          error: _abdomenError,
          onChanged: (v) { if (_abdomenError != null) _validate(); },
        ),
        const SizedBox(height: 12),
        _buildToggleRow("Centimetres (cm)", "Inches (in)", _isAbdomenCmSelected, (v) => setState(() => _isAbdomenCmSelected = v)),
      ],
    );
  }

  Widget _buildHipSection() {
    return _buildSectionCard(
      title: "Hip",
      icon: appIcons.hip, // using related material icon
      children: [
        buildRequiredLabel("Measure around the widest point of your hips and buttocks."),
        const SizedBox(height: 8),
        CommonTextField(
          label: '',
          controller: _hipController,
          hint: "e.g., 96.0",
          keyboardType: TextInputType.number,
          fillColor: appColors.textFieldBgColor,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          borderColor: Colors.transparent,
          error: _hipError,
          onChanged: (v) { if (_hipError != null) _validate(); },
        ),
        const SizedBox(height: 12),
        _buildToggleRow("Centimetres (cm)", "Inches (in)", _isHipCmSelected, (v) => setState(() => _isHipCmSelected = v)),
      ],
    );
  }

  Widget _buildNotesSection() {
    return _buildSectionCard(
      title: "Notes or Context",
      icon: appIcons.edit,
      children: [
        CommonText("Any sensations, cycle timing, digestion notes, or context for your practitioner.", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: const Color(0xFF534343))),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: appColors.textFieldBgColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: _notesController,
            maxLines: 4,
            minLines: 3,
            style: TextStyle(fontSize: 14, color: const Color(0xFF1D1B1A), fontFamily: fontFamilyPlusJakartaSans),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "e.g., Measured first thing in the morning before breakfast, feeling lighter today...",
              hintStyle: TextStyle(fontSize: 14, color: const Color(0xFF857373)),
              isDense: true,
            ),
          ),
        ),
      ],
    );
  }
}
