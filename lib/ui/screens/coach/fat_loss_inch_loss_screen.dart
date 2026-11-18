import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../main.dart';
import '../../../core/blocs/coach/fat_loss_inch_loss/fat_loss_inch_loss_bloc.dart';
import '../../../core/blocs/coach/fat_loss_inch_loss/fat_loss_inch_loss_event.dart';
import '../../../core/blocs/coach/fat_loss_inch_loss/fat_loss_inch_loss_state.dart';
import '../../../core/blocs/coach/save_protocol_form/save_protocol_form_bloc.dart';
import '../../../core/blocs/coach/save_protocol_form/save_protocol_form_event.dart';
import '../../../core/blocs/coach/save_protocol_form/save_protocol_form_state.dart';
import '../../../core/constants/urls.dart';
import '../../../core/constants/utils.dart';
import '../../../core/models/coach/fat_loss_inch_loss_model.dart';
import '../../../core/services/loader_service.dart';
import '../../widgets/common_app_bar.dart';
import '../../widgets/common_button.dart';
import '../../widgets/common_text.dart';
import '../../widgets/common_text_field.dart';
import '../profile/widget/profile_section_card.dart';
import 'widget/habit_matrix_item.dart';

class FatLossInchLossScreen extends StatefulWidget {
  final String pathwayUuid;

  const FatLossInchLossScreen({
    super.key,
    this.pathwayUuid = "",
  });

  @override
  State<FatLossInchLossScreen> createState() => _FatLossInchLossScreenState();
}

class _FatLossInchLossScreenState extends State<FatLossInchLossScreen> {
  FatLossInchLossData? _protocolData;
  List<FatLossInchLossFormField> _fields = [];

  // Section 1: Weight History & Natural Rhythms
  String _weightUnit = "kg";
  final TextEditingController _highestWeightController = TextEditingController();
  final TextEditingController _highestYearController = TextEditingController();
  final TextEditingController _lowestWeightController = TextEditingController();
  final TextEditingController _lowestYearController = TextEditingController();
  final TextEditingController _weightPeriodsController = TextEditingController();

  String? _highestWeightError;
  String? _lowestWeightError;

  // Section 2: Past Transitions & Biological Triggers
  final TextEditingController _pastTransitionsController = TextEditingController();
  String? _pastTransitionsError;

  // Section 3: Habit Readiness & Boundary Matrix
  String _eatingOutReady = "";
  String _lateNightEatingReady = "";
  String _sweetsReady = "";
  String _packagedFoodsReady = "";
  String _alcoholReady = "";
  String _skippingMealsReady = "";
  String? _habitMatrixError;

  // Section 4: Sustainable Momentum & Maintenance
  final TextEditingController _momentumController = TextEditingController();
  String? _momentumError;

  @override
  void initState() {
    super.initState();
    callGetProtocolFormAPI();
  }

  void callGetProtocolFormAPI() {
    if (widget.pathwayUuid.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        LoaderService.show(context);
        BlocProvider.of<FatLossInchLossBloc>(context).add(
          UserGetFatLossInchLossEvent(
            url: Urls.pathwaysProtocol(pathwayUuid: widget.pathwayUuid),
          ),
        );
      });
    }
  }

  void _populateAnswers(FatLossInchLossAnswers? answers) {
    if (answers == null) return;

    if (answers.weightUnit != null && answers.weightUnit!.isNotEmpty) {
      _weightUnit = answers.weightUnit!;
    }

    if (answers.highestWeight != null) {
      _highestWeightController.text = answers.highestWeight.toString();
    }
    if (answers.highestWeightYear != null) {
      _highestYearController.text = answers.highestWeightYear.toString();
    }
    if (answers.lowestWeight != null) {
      _lowestWeightController.text = answers.lowestWeight.toString();
    }
    if (answers.lowestWeightYear != null) {
      _lowestYearController.text = answers.lowestWeightYear.toString();
    }
    if (answers.majorWeightPeriods != null && answers.majorWeightPeriods!.isNotEmpty) {
      _weightPeriodsController.text = answers.majorWeightPeriods!;
    }
    if (answers.pastTransitions != null && answers.pastTransitions!.isNotEmpty) {
      _pastTransitionsController.text = answers.pastTransitions!;
    }

    if (answers.habitReadiness != null) {
      final habits = answers.habitReadiness!;
      if (habits.eatingOut != null) _eatingOutReady = habits.eatingOut!;
      if (habits.lateNightEating != null) _lateNightEatingReady = habits.lateNightEating!;
      if (habits.sweets != null) _sweetsReady = habits.sweets!;
      if (habits.packagedFoods != null) _packagedFoodsReady = habits.packagedFoods!;
      if (habits.alcohol != null) _alcoholReady = habits.alcohol!;
      if (habits.skippingMeals != null) _skippingMealsReady = habits.skippingMeals!;
    }

    if (answers.maintenanceSupport != null && answers.maintenanceSupport!.isNotEmpty) {
      _momentumController.text = answers.maintenanceSupport!;
    }
  }

  FatLossInchLossFormField? _getField(String key) {
    try {
      return _fields.firstWhere((f) => f.key == key);
    } catch (_) {
      return null;
    }
  }

  FatLossInchLossFormField? _getNestedField(String groupKey, String key) {
    try {
      final group = _getField(groupKey);
      return group?.fields?.firstWhere((f) => f.key == key);
    } catch (_) {
      return null;
    }
  }

  List<HabitMatrixOption>? _getHabitOptions(String subFieldKey) {
    final field = _getNestedField("habit_readiness", subFieldKey);
    if (field?.options != null && field!.options!.isNotEmpty) {
      return field.options!
          .map((o) => HabitMatrixOption(value: o.value ?? "", label: o.label ?? ""))
          .toList();
    }
    return null;
  }

  bool _validate() {
    bool isValid = true;

    // Weight History
    final highestField = _getField("highest_weight");
    if ((highestField?.required ?? false) && _highestWeightController.text.trim().isEmpty) {
      _highestWeightError = "Required";
      isValid = false;
    } else {
      _highestWeightError = null;
    }

    final lowestField = _getField("lowest_weight");
    if ((lowestField?.required ?? false) && _lowestWeightController.text.trim().isEmpty) {
      _lowestWeightError = "Required";
      isValid = false;
    } else {
      _lowestWeightError = null;
    }

    // Past Transitions
    final pastTransitionsField = _getField("past_transitions");
    if ((pastTransitionsField?.required ?? true) && _pastTransitionsController.text.trim().isEmpty) {
      _pastTransitionsError = "Required";
      isValid = false;
    } else {
      _pastTransitionsError = null;
    }

    // Habit Readiness
    if (_eatingOutReady.isEmpty ||
        _lateNightEatingReady.isEmpty ||
        _sweetsReady.isEmpty ||
        _packagedFoodsReady.isEmpty ||
        _alcoholReady.isEmpty ||
        _skippingMealsReady.isEmpty) {
      _habitMatrixError = "Please select readiness for all habits";
      isValid = false;
    } else {
      _habitMatrixError = null;
    }

    // Sustainable Momentum
    final maintenanceField = _getField("maintenance_support");
    if ((maintenanceField?.required ?? true) && _momentumController.text.trim().isEmpty) {
      _momentumError = "Required";
      isValid = false;
    } else {
      _momentumError = null;
    }

    setState(() {});
    return isValid;
  }

  void _onSave() {
    if (!_validate()) {
      showSnackBar(context: context, isError: true, message: 'Please complete all required fields.');
      return;
    }

    if (widget.pathwayUuid.isEmpty) {
      showSnackBar(context: context, isError: true, message: 'Pathway ID is missing.');
      return;
    }

    final FatLossInchLossAnswers answers = FatLossInchLossAnswers(
      weightUnit: _weightUnit,
      highestWeight: num.tryParse(_highestWeightController.text.trim()),
      highestWeightYear: int.tryParse(_highestYearController.text.trim()),
      lowestWeight: num.tryParse(_lowestWeightController.text.trim()),
      lowestWeightYear: int.tryParse(_lowestYearController.text.trim()),
      majorWeightPeriods: _weightPeriodsController.text.trim().isNotEmpty
          ? _weightPeriodsController.text.trim()
          : null,
      pastTransitions: _pastTransitionsController.text.trim().isNotEmpty
          ? _pastTransitionsController.text.trim()
          : null,
      habitReadiness: HabitReadinessAnswers(
        eatingOut: _eatingOutReady.isNotEmpty ? _eatingOutReady : null,
        lateNightEating: _lateNightEatingReady.isNotEmpty ? _lateNightEatingReady : null,
        sweets: _sweetsReady.isNotEmpty ? _sweetsReady : null,
        packagedFoods: _packagedFoodsReady.isNotEmpty ? _packagedFoodsReady : null,
        alcohol: _alcoholReady.isNotEmpty ? _alcoholReady : null,
        skippingMeals: _skippingMealsReady.isNotEmpty ? _skippingMealsReady : null,
      ),
      maintenanceSupport: _momentumController.text.trim().isNotEmpty
          ? _momentumController.text.trim()
          : null,
    );

    final Map<String, dynamic> body = {
      "answers": answers.toJson(),
    };

    LoaderService.show(context);
    BlocProvider.of<SaveProtocolFormBloc>(context).add(
      UserSaveProtocolFormEvent(
        url: Urls.pathwaysProtocol(pathwayUuid: widget.pathwayUuid),
        body: body,
      ),
    );
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
    return MultiBlocListener(
      listeners: [
        BlocListener<FatLossInchLossBloc, FatLossInchLossState>(
          listener: (context, state) {
            if (state is FatLossInchLossSuccess) {
              LoaderService.hide();
              _protocolData = state.model.data;
              _fields = state.model.data?.fields ?? [];
              _populateAnswers(state.model.data?.answers);
              setState(() {});
            } else if (state is FatLossInchLossFailed) {
              LoaderService.hide();
              showSnackBar(context: context, isError: true, message: state.message);
            }
          },
        ),
        BlocListener<SaveProtocolFormBloc, SaveProtocolFormState>(
          listener: (context, state) {
            if (state is SaveProtocolFormSuccess) {
              LoaderService.hide();
              showSnackBar(
                context: context,
                isError: false,
                message: state.model.message ?? 'Fat Loss and Inch Loss Submitted!',
              );
              navigation.pop(context);
            } else if (state is SaveProtocolFormFailed) {
              LoaderService.hide();
              showSnackBar(context: context, isError: true, message: state.message);
            }
          },
        ),
      ],
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          LoaderService.hide();
          navigation.pop(context);
        },
        child: Scaffold(
          backgroundColor: appColors.bgColor,
          appBar: CommonAppBar(
            appBarColor: appColors.bgColor.withValues(alpha: 0.85),
            centerTitle: true,
            leading: buildInkWell(
              onTap: () {
                LoaderService.hide();
                navigation.pop(context);
              },
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
              _protocolData?.title ?? "Fat Loss Inch Loss Protocol",
              fontFamily: fontPlayfairDisplay,
              style: const TextStyle(
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
        ),
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
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF534343), height: 20 / 13),
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
                  hint: "0",
                  borderColor: error != null ? appColors.red : Colors.transparent,
                  fillColor: appColors.white,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [digitalWithDot],
                  suffixText: _weightUnit,
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
          options: _getHabitOptions("eating_out"),
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
          options: _getHabitOptions("late_night_eating"),
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
          options: _getHabitOptions("sweets"),
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
          options: _getHabitOptions("packaged_foods"),
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
          options: _getHabitOptions("alcohol"),
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
          options: _getHabitOptions("skipping_meals"),
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
      icon: appIcons.flag,
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
