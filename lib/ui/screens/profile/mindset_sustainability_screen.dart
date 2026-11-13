import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../main.dart';
import '../../../core/blocs/profile/chapter_six/chapter_six_bloc.dart';
import '../../../core/blocs/profile/save_chapter/save_chapter_bloc.dart';
import '../../../core/constants/urls.dart';
import '../../../core/constants/utils.dart';
import '../../../core/models/profile/chapter_six_model.dart';
import '../../../core/models/profile/onboarding_masters_model.dart';
import '../../../core/services/loader_service.dart';
import '../../widgets/common_app_bar.dart';
import '../../widgets/common_text.dart';
import '../../widgets/common_text_field.dart';
import 'widget/profile_bottom_button.dart';
import 'widget/profile_chip.dart';
import 'widget/profile_section_card.dart';
import 'widget/profile_text_area.dart';

class MindsetSustainabilityScreen extends StatefulWidget {
  final List<OnboardingData> goalMindset;

  const MindsetSustainabilityScreen({super.key, required this.goalMindset});

  @override
  State<MindsetSustainabilityScreen> createState() => _MindsetSustainabilityScreenState();
}

class _MindsetSustainabilityScreenState extends State<MindsetSustainabilityScreen> {
  ChapterSixModel? chapterSixModel;

  // 1. Goal-Oriented Mindset
  final Set<String> _selectedMindsets = {};
  final TextEditingController _goalMindsetOtherController = TextEditingController();
  String? _mindsetError;

  // 2. Navigating Slow Progress
  final TextEditingController _slowProgressController = TextEditingController();
  String? _slowProgressError;

  // 3. Starting Points & Boundaries
  final TextEditingController _startChangeController = TextEditingController();
  final TextEditingController _notReadyChangeController = TextEditingController();
  String? _startChangeError;
  String? _notReadyChangeError;

  // 4. Your Vision of Success
  final TextEditingController _visionController = TextEditingController();
  String? _visionError;

  // 5. Open Reflections
  final TextEditingController _reflectionsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    callChapterSixAPI();
  }

  void callChapterSixAPI() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      LoaderService.show(context);
      BlocProvider.of<ChapterSixBloc>(context).add(
        UserChapterSixEvent(url: Urls.onboardingChapter(chapterId: "6")),
      );
    });
  }

  void _populateFromChapterSix(ChapterSixModel model) {
    final answers = model.data?.answers;
    if (answers != null) {
      if (answers.goalMindset != null && answers.goalMindset!.isNotEmpty) {
        _selectedMindsets.clear();
        _selectedMindsets.addAll(answers.goalMindset!);
      }
      if (answers.goalMindsetOther != null) {
        _goalMindsetOtherController.text = answers.goalMindsetOther!;
      }
      if (answers.slowProgressResponse != null) {
        _slowProgressController.text = answers.slowProgressResponse!;
      }
      if (answers.oneChangeToStart != null) {
        _startChangeController.text = answers.oneChangeToStart!;
      }
      if (answers.notReadyToChange != null) {
        _notReadyChangeController.text = answers.notReadyToChange!;
      }
      if (answers.visionOfSuccess != null) {
        _visionController.text = answers.visionOfSuccess!;
      }
      if (answers.openReflections != null) {
        _reflectionsController.text = answers.openReflections!;
      }
    }
  }

  Field? _getField(String key) {
    final fields = chapterSixModel?.data?.fields ?? [];
    for (final f in fields) {
      if (f.key == key) return f;
    }
    return null;
  }

  bool _validate() {
    bool isValid = true;

    if (_selectedMindsets.isEmpty) {
      _mindsetError = "Please select up to 3 options";
      isValid = false;
    } else {
      _mindsetError = null;
    }

    if (_slowProgressController.text.trim().isEmpty) {
      _slowProgressError = "This field is required";
      isValid = false;
    } else {
      _slowProgressError = null;
    }

    if (_startChangeController.text.trim().isEmpty) {
      _startChangeError = "This field is required";
      isValid = false;
    } else {
      _startChangeError = null;
    }

    if (_notReadyChangeController.text.trim().isEmpty) {
      _notReadyChangeError = "This field is required";
      isValid = false;
    } else {
      _notReadyChangeError = null;
    }

    if (_visionController.text.trim().isEmpty) {
      _visionError = "This field is required";
      isValid = false;
    } else {
      _visionError = null;
    }

    setState(() {});
    return isValid;
  }

  void _onSaveAndReview() {
    if (_validate()) {
      LoaderService.show(context);
      BlocProvider.of<SaveChapterBloc>(context).add(
        UserSaveChapterEvent(
          url: Urls.onboardingChapter(chapterId: "6"),
          body: {
            "answers": {
              "goal_mindset": _selectedMindsets.toList(),
              "goal_mindset_other": _goalMindsetOtherController.text.trim(),
              "slow_progress_response": _slowProgressController.text.trim(),
              "one_change_to_start": _startChangeController.text.trim(),
              "not_ready_to_change": _notReadyChangeController.text.trim(),
              "vision_of_success": _visionController.text.trim(),
              "open_reflections": _reflectionsController.text.trim(),
            }
          },
        ),
      );
    }
  }

  @override
  void dispose() {
    _goalMindsetOtherController.dispose();
    _slowProgressController.dispose();
    _startChangeController.dispose();
    _notReadyChangeController.dispose();
    _visionController.dispose();
    _reflectionsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ChapterSixBloc, ChapterSixState>(
          listener: (context, state) {
            if (state is ChapterSixSuccess) {
              LoaderService.hide();
              chapterSixModel = state.model;
              _populateFromChapterSix(state.model);
              setState(() {});
            } else if (state is ChapterSixFailed) {
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
                "CHAPTER ${chapterSixModel?.data?.chapter ?? 6} OF ${chapterSixModel?.data?.total ?? 6}",
                style: TextStyle(
                  fontSize: 11,
                  color: appColors.primary,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.55,
                ),
              ),
              CommonText(
                chapterSixModel?.data?.title ?? "Mindset & Sustainability",
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
            _buildMindsetSection(),
            const SizedBox(height: 24),
            _buildSlowProgressSection(),
            const SizedBox(height: 24),
            _buildBoundariesSection(),
            const SizedBox(height: 24),
            _buildVisionSection(),
            const SizedBox(height: 24),
            _buildReflectionsSection(),
            const SizedBox(height: 24),
            ProfileBottomButton(
              name: "Save & Review",
              onTap: _onSaveAndReview,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildMindsetSection() {
    final dynamicMindsets = _getField("goal_mindset")?.options ?? [];
    final hasDynamicMindsets = dynamicMindsets.isNotEmpty;

    return ProfileSectionCard(
      title: "Goal-Oriented Mindset",
      icon: appIcons.mindset,
      children: [
        buildRequiredLabel(
          "Which statements sound most like you when you are working toward a goal?",
          subtext: "(Select up to 3)",
          color: const Color(0xFF1D1B1A)
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 12,
          children: hasDynamicMindsets
              ? dynamicMindsets.map((e) => ProfileChip(
                  label: e.label ?? "",
                  isSelected: _selectedMindsets.contains(e.value),
                  onTap: () {
                    setState(() {
                      if (_selectedMindsets.contains(e.value)) {
                        _selectedMindsets.remove(e.value);
                      } else {
                        if (_selectedMindsets.length < 3) {
                          if (e.value != null) _selectedMindsets.add(e.value!);
                        } else {
                          showSnackBar(context: context, isError: true, message: "Can only select up to 3 option");
                          appLog("Can only select up to 3 options");
                        }
                      }
                      if (_mindsetError != null) _validate();
                    });
                  },
                )).toList()
              : widget.goalMindset.map((e) => ProfileChip(
                  label: e.title ?? "",
                  isSelected: _selectedMindsets.contains(e.uuid),
                  onTap: () {
                    setState(() {
                      if (_selectedMindsets.contains(e.uuid)) {
                        _selectedMindsets.remove(e.uuid);
                      } else {
                        if (_selectedMindsets.length < 3) {
                          _selectedMindsets.add(e.uuid ?? "0");
                        } else {
                          showSnackBar(context: context, isError: true, message: "Can only select up to 3 option");
                          appLog("Can only select up to 3 options");
                        }
                      }
                      if (_mindsetError != null) _validate();
                    });
                  },
                )).toList(),
        ),
        if (_hasSelectedGoalMindsetOther(dynamicMindsets)) ...[
          const SizedBox(height: 12),
          CommonTextField(
            label: "Please specify",
            controller: _goalMindsetOtherController,
            hint: "Please specify your goal mindset",
            fillColor: appColors.textFieldBgColor,
            borderColor: Colors.transparent,
            isRequired: false,
          ),
        ],
        if (_mindsetError != null) Padding(
          padding: const EdgeInsets.only(top: 8),
          child: CommonText(_mindsetError!,
            style: TextStyle(color: appColors.red, fontSize: 12)
          )
        ),
      ],
    );
  }

  bool _isOtherOption({String? value, String? label, String? title}) {
    final l = (label ?? title ?? value ?? '').trim().toLowerCase();
    final v = (value ?? '').trim().toLowerCase();
    return l == 'other' ||
        l == 'others' ||
        l.startsWith('other ') ||
        l.startsWith('other(') ||
        l.startsWith('other (') ||
        v == 'other' ||
        v == 'others';
  }

  bool _hasSelectedGoalMindsetOther(List<Option> dynamicMindsets) {
    if (dynamicMindsets.isNotEmpty) {
      for (final opt in dynamicMindsets) {
        if (_selectedMindsets.contains(opt.value) &&
            _isOtherOption(value: opt.value, label: opt.label)) {
          return true;
        }
      }
    } else {
      for (final item in widget.goalMindset) {
        if (_selectedMindsets.contains(item.uuid) &&
            _isOtherOption(value: item.uuid, title: item.title)) {
          return true;
        }
      }
    }
    return false;
  }

  Widget _buildSlowProgressSection() {
    return ProfileSectionCard(
      title: "Navigating Slow Progress",
      icon: appIcons.navigating,
      children: [
        buildRequiredLabel(
          "When progress is slower than you hoped, what tends to happen in your head — and what do you usually do next?",
          color: const Color(0xFF1D1B1A)
        ),
        const SizedBox(height: 12),
        ProfileTextArea(
          controller: _slowProgressController,
          hint: "e.g., I start questioning whether anything is working and feel tempted to restart from scratch or restrict more heavily...",
          error: _slowProgressError,
          onChanged: (v) {
            setState(() {});
            if (_slowProgressError != null) _validate();
          },
        ),
        if (_slowProgressError != null) Padding(
          padding: const EdgeInsets.only(top: 4),
          child: CommonText(_slowProgressError!,
            style: TextStyle(color: appColors.red, fontSize: 12)
          )
        ),
      ],
    );
  }

  Widget _buildBoundariesSection() {
    return ProfileSectionCard(
      title: "Starting Points & Boundaries",
      icon: appIcons.flag,
      children: [
        buildRequiredLabel(
          "What is one change you could genuinely start this week, and one thing you are not ready to change yet?",
          color: const Color(0xFF1D1B1A)
        ),
        const SizedBox(height: 16),
        const CommonText(
          "One change you could genuinely start this week",
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF534343))
        ),
        const SizedBox(height: 6),
        CommonTextField(
          label: '',
          controller: _startChangeController,
          hint: "e.g., Drinking 2 liters of water daily...",
          fillColor: appColors.textFieldBgColor,
          borderColor: Colors.transparent,
          onChanged: (v) { if (_startChangeError != null) _validate(); },
        ),
        if (_startChangeError != null) Padding(
          padding: const EdgeInsets.only(top: 4, bottom: 8),
          child: CommonText(_startChangeError!, style: TextStyle(color: appColors.red, fontSize: 12))
        ),
        
        const SizedBox(height: 12),
        const CommonText(
          "One thing you are not ready to change yet",
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF534343))
        ),
        const SizedBox(height: 6),
        CommonTextField(
          label: '',
          controller: _notReadyChangeController,
          hint: "e.g., My morning milk tea with sugar...",
          fillColor: appColors.textFieldBgColor,
          borderColor: Colors.transparent,
          onChanged: (v) { if (_notReadyChangeError != null) _validate(); },
        ),
        if (_notReadyChangeError != null) Padding(
          padding: const EdgeInsets.only(top: 4),
          child: CommonText(_notReadyChangeError!,
            style: TextStyle(color: appColors.red, fontSize: 12)
          )
        ),
      ],
    );
  }

  Widget _buildVisionSection() {
    return ProfileSectionCard(
      title: "Your Vision of Success",
      icon: appIcons.stars,
      children: [
        buildRequiredLabel(
          "If coaching worked well for you, what would feel different in your body, your routine and your life?",
          color: const Color(0xFF1D1B1A)
        ),
        const SizedBox(height: 12),
        ProfileTextArea(
          controller: _visionController,
          hint: "e.g., Waking up with steady energy without afternoon crashes, feeling calm around food choices...",
          error: _visionError,
          onChanged: (v) {
            setState(() {});
            if (_visionError != null) _validate();
          },
        ),
        if (_visionError != null) Padding(
          padding: const EdgeInsets.only(top: 4),
          child: CommonText(_visionError!,
            style: TextStyle(color: appColors.red, fontSize: 12)
          )
        ),
      ],
    );
  }

  Widget _buildReflectionsSection() {
    return ProfileSectionCard(
      title: "Open Reflections",
      icon: appIcons.edit,
      children: [
        const CommonText(
          "Is there anything important about your health, body, food or lifestyle that we have not asked?",
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF534343))
        ),
        const SizedBox(height: 12),
        ProfileTextArea(
          controller: _reflectionsController,
          hint: "e.g., Any past experiences with diets, specific daily rhythms, travel schedules...",
        ),
      ],
    );
  }
}
