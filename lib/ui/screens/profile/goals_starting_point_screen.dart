import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../main.dart';
import '../../../core/blocs/profile/chapter_two/chapter_two_bloc.dart';
import '../../../core/blocs/profile/save_chapter/save_chapter_bloc.dart';
import '../../../core/constants/urls.dart';
import '../../../core/constants/utils.dart';
import '../../../core/models/profile/chapter_two_model.dart';
import '../../../core/models/profile/onboarding_masters_model.dart';
import '../../../core/services/loader_service.dart';
import '../../widgets/common_app_bar.dart';
import '../../widgets/common_text.dart';
import '../../widgets/common_text_field.dart';
import 'widget/profile_bottom_button.dart';
import 'widget/profile_chip.dart';
import 'widget/profile_section_card.dart';
import 'widget/profile_text_area.dart';

class GoalsStartingPointScreen extends StatefulWidget {
  final List<OnboardingData> approachesTried;
  final List<OnboardingData> confidentAreas;

  const GoalsStartingPointScreen({super.key, required this.approachesTried, required this.confidentAreas});

  @override
  State<GoalsStartingPointScreen> createState() => _GoalsStartingPointScreenState();
}

class _GoalsStartingPointScreenState extends State<GoalsStartingPointScreen> {
  ChapterTwoModel? chapterTwoModel;

  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _learnedController = TextEditingController();
  final TextEditingController _confusingController = TextEditingController();
  final TextEditingController _helpedController = TextEditingController();
  final TextEditingController _approachesOtherController = TextEditingController();
  final TextEditingController _confidentOtherController = TextEditingController();

  String? _heightError;
  String? _weightError;
  String? _learnedError;
  String? _confusingError;
  String? _helpedError;
  String? _approachesError;
  String? _confidentError;

  bool _isCmSelected = true;
  bool _isKgSelected = true;

  final Set<String> _selectedApproaches = {};
  final Set<String> _selectedConfident = {};

  @override
  void initState() {
    super.initState();
    callChapterTwoAPI();
  }

  void callChapterTwoAPI() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      LoaderService.show(context);
      BlocProvider.of<ChapterTwoBloc>(context).add(
        UserChapterTwoEvent(url: Urls.onboardingChapter(chapterId: "2")),
      );
    });
  }

  void _populateFromChapterTwo(ChapterTwoModel model) {
    final answers = model.data?.answers;
    if (answers != null) {
      if (answers.height != null) {
        _heightController.text = answers.height.toString();
      }
      if (answers.heightUnit != null && answers.heightUnit!.isNotEmpty) {
        _isCmSelected = answers.heightUnit!.toLowerCase() == "cm";
      }
      if (answers.weight != null) {
        _weightController.text = answers.weight.toString();
      }
      if (answers.weightUnit != null && answers.weightUnit!.isNotEmpty) {
        _isKgSelected = answers.weightUnit!.toLowerCase() == "kg" ||
            answers.weightUnit!.toLowerCase().contains("kilo");
      }
      if (answers.approachesTried != null && answers.approachesTried!.isNotEmpty) {
        _selectedApproaches.clear();
        _selectedApproaches.addAll(answers.approachesTried!);
      }
      if (answers.approachesTriedOther != null && answers.approachesTriedOther!.isNotEmpty) {
        _approachesOtherController.text = answers.approachesTriedOther!;
      }
      if (answers.approachesLearning != null && answers.approachesLearning!.isNotEmpty) {
        _learnedController.text = answers.approachesLearning!;
      }
      if (answers.confidentAreas != null && answers.confidentAreas!.isNotEmpty) {
        _selectedConfident.clear();
        _selectedConfident.addAll(answers.confidentAreas!);
      }
      if (answers.confidentAreasOther != null && answers.confidentAreasOther!.isNotEmpty) {
        _confidentOtherController.text = answers.confidentAreasOther!;
      }
      if (answers.confusingAreas != null && answers.confusingAreas!.isNotEmpty) {
        _confusingController.text = answers.confusingAreas!;
      }
      if (answers.whatHelped != null && answers.whatHelped!.isNotEmpty) {
        _helpedController.text = answers.whatHelped!;
      }
    }
  }

  Field? _getField(String key) {
    final fields = chapterTwoModel?.data?.fields ?? [];
    for (final f in fields) {
      if (f.key == key) return f;
    }
    return null;
  }

  bool _validate() {
    bool isValid = true;

    if (_heightController.text.trim().isEmpty) {
      _heightError = "Please enter your height";
      isValid = false;
    } else {
      _heightError = null;
    }

    if (_weightController.text.trim().isEmpty) {
      _weightError = "Please enter your weight";
      isValid = false;
    } else {
      _weightError = null;
    }

    if (_confusingController.text.trim().isEmpty) {
      _confusingError = "Please share what is confusing";
      isValid = false;
    } else {
      _confusingError = null;
    }

    if (_helpedController.text.trim().isEmpty) {
      _helpedError = "Please share what helped or stopped you";
      isValid = false;
    } else {
      _helpedError = null;
    }

    if (_selectedApproaches.isEmpty) {
      _approachesError = "Please select at least one approach";
      isValid = false;
    } else {
      _approachesError = null;
    }

    if (_selectedConfident.isEmpty) {
      _confidentError = "Please select at least one confident area";
      isValid = false;
    } else {
      _confidentError = null;
    }

    setState(() {});
    return isValid;
  }

  void _onSaveAndContinue() {
    if (_validate()) {
      LoaderService.show(context);

      final num? parsedHeight = num.tryParse(_heightController.text.trim());
      final dynamic heightValue = parsedHeight != null
          ? (parsedHeight % 1 == 0 ? parsedHeight.toInt() : parsedHeight)
          : _heightController.text.trim();

      final num? parsedWeight = num.tryParse(_weightController.text.trim());
      final dynamic weightValue = parsedWeight != null
          ? (parsedWeight % 1 == 0 ? parsedWeight.toInt() : parsedWeight)
          : _weightController.text.trim();

      BlocProvider.of<SaveChapterBloc>(context).add(
        UserSaveChapterEvent(
          url: Urls.onboardingChapter(chapterId: "2"),
          body: {
            "weight": weightValue,
            "weight_unit": _isKgSelected ? "kg" : "lbs",
            "answers": {
              "height": heightValue,
              "height_unit": _isCmSelected ? "cm" : "ft_in",
              "weight": weightValue,
              "weight_unit": _isKgSelected ? "kg" : "lbs",
              "approaches_tried": _selectedApproaches.toList(),
              "approaches_tried_other": _approachesOtherController.text.trim(),
              "approaches_learning": _learnedController.text.trim(),
              "confident_areas": _selectedConfident.toList(),
              "confident_areas_other": _confidentOtherController.text.trim(),
              "confusing_areas": _confusingController.text.trim(),
              "what_helped": _helpedController.text.trim(),
            }
          },
        ),
      );
    }
  }

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    _learnedController.dispose();
    _confusingController.dispose();
    _helpedController.dispose();
    _approachesOtherController.dispose();
    _confidentOtherController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ChapterTwoBloc, ChapterTwoState>(
          listener: (context, state) {
            if (state is ChapterTwoSuccess) {
              LoaderService.hide();
              chapterTwoModel = state.model;
              _populateFromChapterTwo(state.model);
              setState(() {});
            } else if (state is ChapterTwoFailed) {
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
                "CHAPTER ${chapterTwoModel?.data?.chapter ?? 2} OF ${chapterTwoModel?.data?.total ?? 6}",
                style: TextStyle(
                  fontSize: 11,
                  color: appColors.primary,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.55,
                ),
              ),
              CommonText(
                chapterTwoModel?.data?.title ?? "Goals & Starting Point",
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
            _buildBaselineMeasurements(),
            const SizedBox(height: 24),
            _buildWeightSection(),
            const SizedBox(height: 24),
            _buildExperienceSection(),
            const SizedBox(height: 24),
            ProfileBottomButton(
              name: "Save & Continue to Health & Safety",
              onTap: _onSaveAndContinue,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildBaselineMeasurements() {
    return ProfileSectionCard(
      title: "Baseline Measurements",
      icon: appIcons.measurement,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 13,
                  fontFamily: fontFamilyPlusJakartaSans,
                  color: Color(0xFF1D1B1A),
                  fontWeight: FontWeight.w600,
                ),
                children: [
                  const TextSpan(text: "Current height "),
                  TextSpan(text: "*", style: TextStyle(color: appColors.primary, fontWeight: FontWeight.normal)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: appColors.textFieldBgColor,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Row(
                children: [
                  _buildToggleBtn(label: "cm", isSelected: _isCmSelected, onTap: () => setState(() => _isCmSelected = true)),
                  _buildToggleBtn(label: "Feet & inches", isSelected: !_isCmSelected, onTap: () => setState(() => _isCmSelected = false)),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Container(
                height: 56,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: appColors.textFieldBgColor,
                  borderRadius: BorderRadius.circular(16),
                  border: _heightError != null ? Border.all(color: appColors.red) : null,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _heightController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [digitalWithDot],
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF1D1B1A),
                          fontFamily: fontFamilyPlusJakartaSans,
                          letterSpacing: -0.64,
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                          hintText: "165",
                          hintStyle: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF857373),
                            fontFamily: fontFamilyPlusJakartaSans,
                            letterSpacing: -0.64,
                          ),
                        ),
                        onChanged: (v) {
                          if (_heightError != null) _validate();
                        },
                      ),
                    ),
                    CommonText(
                      _isCmSelected ? "cm" : "ft",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF534343),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            Column(
              children: [
                _buildIncrementBtn(Icons.keyboard_arrow_up_rounded, () {
                  int val = int.tryParse(_heightController.text) ?? 0;
                  _heightController.text = (val + 1).toString();
                }),
                const SizedBox(height: 4),
                _buildIncrementBtn(Icons.keyboard_arrow_down_rounded, () {
                  int val = int.tryParse(_heightController.text) ?? 0;
                  if(val > 0){
                    _heightController.text = (val - 1).toString();
                  }
                }),
              ],
            ),
          ],
        ),
        if (_heightError != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 4),
            child: CommonText(
              _heightError!,
              style: TextStyle(color: appColors.red, fontSize: 12),
            ),
          ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.info_outline_rounded, color: Color(0xFF534343), size: 14),
            const SizedBox(width: 6),
            Expanded(
              child: CommonText(
                "Used for personalized caloric density and biological benchmarks.",
                style: TextStyle(
                  fontSize: 13,
                  color: const Color(0xFF534343),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildToggleBtn({required String label, required bool isSelected, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? appColors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
        ),
        child: CommonText(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected ? const Color(0xFF1D1B1A) : const Color(0xFF534343),
          ),
        ),
      ),
    );
  }

  Widget _buildIncrementBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 24,
        decoration: BoxDecoration(
          color: appColors.textFieldBgColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 16, color: const Color(0xFF1D1B1A)),
      ),
    );
  }

  Widget _buildWeightSection() {
    return ProfileSectionCard(
      title: "Weight",
      icon: appIcons.weight,
      children: [
        CommonTextField(
          label: '',
          controller: _weightController,
          hint: "e.g., 64.5",
          keyboardType: TextInputType.number,
          fillColor: appColors.textFieldBgColor,
          inputFormatters: [digitalWithDot],
          borderColor: Colors.transparent,
          error: _weightError,
          onChanged: (v) { if (_weightError != null) _validate(); },
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildUnitToggleBtn(
                label: "Kilograms (kg)",
                isSelected: _isKgSelected,
                onTap: () => setState(() => _isKgSelected = true),
              ),
            ),
            const SizedBox(width: 12),
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
    );
  }

  Widget _buildUnitToggleBtn({required String label, required bool isSelected, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFDADB) : appColors.textFieldBgColor,
          borderRadius: BorderRadius.circular(999),
        ),
        child: CommonText(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected ? const Color(0xFF381519) : const Color(0xFF534343),
          ),
        ),
      ),
    );
  }

  Widget _buildExperienceSection() {
    final approachesField = _getField("approaches_tried");
    final dynamicApproaches = approachesField?.options ?? [];
    final hasDynamicApproaches = dynamicApproaches.isNotEmpty;

    final confidentField = _getField("confident_areas");
    final dynamicConfident = confidentField?.options ?? [];
    final hasDynamicConfident = dynamicConfident.isNotEmpty;

    final learningField = _getField("approaches_learning");
    final confusingField = _getField("confusing_areas");
    final helpedField = _getField("what_helped");

    return ProfileSectionCard(
      title: "Experience & Foundations",
      icon: appIcons.book,
      children: [
        CommonText(
          "What have you already tried, and what knowledge are you bringing into this journey?",
          style: TextStyle(
            fontSize: 13,
            color: const Color(0xFF534343),
          ),
        ),
        const SizedBox(height: 24),

        // Approaches
        buildRequiredLabel(
          approachesField?.label ?? "Approaches you have tried",
          color: const Color(0xFF1D1B1A),
          isRequired: approachesField?.required ?? true,
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 12,
          children: hasDynamicApproaches
              ? dynamicApproaches.map((e) => ProfileChip(
                  label: e.label ?? "",
                  isSelected: _selectedApproaches.contains(e.value),
                  onTap: () {
                    setState(() {
                      if (_selectedApproaches.contains(e.value)) {
                        _selectedApproaches.remove(e.value);
                      } else {
                        if (e.value != null) _selectedApproaches.add(e.value!);
                      }
                      if (_approachesError != null) _validate();
                    });
                  },
                )).toList()
              : widget.approachesTried.map((e) => ProfileChip(
                  label: e.title ?? "",
                  isSelected: _selectedApproaches.contains(e.uuid),
                  onTap: () {
                    setState(() {
                      if (_selectedApproaches.contains(e.uuid)) {
                        _selectedApproaches.remove(e.uuid);
                      } else {
                        _selectedApproaches.add(e.uuid ?? "0");
                      }
                      if (_approachesError != null) _validate();
                    });
                  },
                )).toList(),
        ),
        if (_hasSelectedApproachesOther(dynamicApproaches)) ...[
          const SizedBox(height: 12),
          CommonTextField(
            label: "Please specify other approaches",
            hint: "Enter other approaches tried",
            controller: _approachesOtherController,
            fillColor: appColors.textFieldBgColor,
            borderColor: Colors.transparent,
            isRequired: false,
          ),
        ],
        if (_approachesError != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 4),
            child: CommonText(
              _approachesError!,
              style: TextStyle(color: appColors.red, fontSize: 12),
            ),
          ),
        const SizedBox(height: 24),

        // Learnings
        buildRequiredLabel(
          learningField?.label ?? "What did you understand or learn from those experiences?",
          isRequired: learningField?.required ?? false,
        ),
        const SizedBox(height: 12),
        ProfileTextArea(
          controller: _learnedController,
          hint: "e.g. Learned that extreme restriction leads to fatigue and binge cycles...",
          error: _learnedError,
          onChanged: (v) {
            setState(() {});
            if (_learnedError != null) _validate();
          },
        ),
        const SizedBox(height: 8),
        CommonText(
          "Reflect freely; honest notes help refine pacing",
          style: TextStyle(fontSize: 11, color: const Color(0xFF534343), fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 24),

        // Confident areas
        buildRequiredLabel(
          confidentField?.label ?? "Which areas do you already feel confident about?",
          color: const Color(0xFF1D1B1A),
          isRequired: confidentField?.required ?? true,
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 12,
          children: hasDynamicConfident
              ? dynamicConfident.map((e) => ProfileChip(
                  label: e.label ?? "",
                  isSelected: _selectedConfident.contains(e.value),
                  selectedBgColor: const Color(0xFFD8E5BF),
                  selectedTextColor: const Color(0xFF5B6749),
                  onTap: () {
                    setState(() {
                      if (_selectedConfident.contains(e.value)) {
                        _selectedConfident.remove(e.value);
                      } else {
                        if (e.value != null) _selectedConfident.add(e.value!);
                      }
                      if (_confidentError != null) _validate();
                    });
                  },
                )).toList()
              : widget.confidentAreas.map((e) => ProfileChip(
                  label: e.title ?? "",
                  isSelected: _selectedConfident.contains(e.uuid),
                  selectedBgColor: const Color(0xFFD8E5BF),
                  selectedTextColor: const Color(0xFF5B6749),
                  onTap: () {
                    setState(() {
                      if (_selectedConfident.contains(e.uuid)) {
                        _selectedConfident.remove(e.uuid);
                      } else {
                        _selectedConfident.add(e.uuid ?? "0");
                      }
                      if (_confidentError != null) _validate();
                    });
                  },
                )).toList(),
        ),
        if (_hasSelectedConfidentOther(dynamicConfident)) ...[
          const SizedBox(height: 12),
          CommonTextField(
            label: "Please specify other confident areas",
            hint: "Enter other areas of confidence",
            controller: _confidentOtherController,
            fillColor: appColors.textFieldBgColor,
            borderColor: Colors.transparent,
            isRequired: false,
          ),
        ],
        if (_confidentError != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 4),
            child: CommonText(
              _confidentError!,
              style: TextStyle(color: appColors.red, fontSize: 12),
            ),
          ),
        const SizedBox(height: 24),

        // Confusing
        buildRequiredLabel(
          confusingField?.label ?? "What still feels confusing or difficult?",
          color: const Color(0xFF1D1B1A),
          isRequired: confusingField?.required ?? true,
        ),
        const SizedBox(height: 12),
        ProfileTextArea(
          controller: _confusingController,
          hint: "e.g. Balancing evening meals when working late...",
          error: _confusingError,
          onChanged: (v) {
            setState(() {});
            if (_confusingError != null) _validate();
          },
        ),
        const SizedBox(height: 24),

        // What helped
        buildRequiredLabel(
          helpedField?.label ?? "What helped, what made you stop, and what contributed to progress returning?",
          color: const Color(0xFF1D1B1A),
          isRequired: helpedField?.required ?? true,
        ),
        const SizedBox(height: 12),
        ProfileTextArea(
          controller: _helpedController,
          hint: "e.g. Having accountability and structured groceries helped most...",
          error: _helpedError,
          onChanged: (v) {
            setState(() {});
            if (_helpedError != null) _validate();
          },
        ),
      ],
    );
  }

  bool _isOtherOption({String? value, String? label, String? title}) {
    final l = (label ?? title ?? value ?? '').trim().toLowerCase();
    final v = (value ?? '').trim().toLowerCase();
    return l == 'other' || l == 'others' || l.startsWith('other ') || l.startsWith('other(') || l.startsWith('other (') || v == 'other' || v == 'others';
  }

  bool _hasSelectedApproachesOther(List<Option> dynamicOptions) {
    for (final val in _selectedApproaches) {
      if (_isOtherOption(value: val)) return true;
      for (final opt in dynamicOptions) {
        if (opt.value == val && _isOtherOption(value: opt.value, label: opt.label)) return true;
      }
      for (final item in widget.approachesTried) {
        if (item.uuid == val && _isOtherOption(value: item.uuid, title: item.title)) return true;
      }
    }
    return false;
  }

  bool _hasSelectedConfidentOther(List<Option> dynamicOptions) {
    for (final val in _selectedConfident) {
      if (_isOtherOption(value: val)) return true;
      for (final opt in dynamicOptions) {
        if (opt.value == val && _isOtherOption(value: opt.value, label: opt.label)) return true;
      }
      for (final item in widget.confidentAreas) {
        if (item.uuid == val && _isOtherOption(value: item.uuid, title: item.title)) return true;
      }
    }
    return false;
  }
}
