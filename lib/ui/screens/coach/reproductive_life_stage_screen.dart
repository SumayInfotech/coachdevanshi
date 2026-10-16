import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../../../main.dart';
import '../../../core/constants/utils.dart';
import '../../widgets/common_app_bar.dart';
import '../../widgets/common_button.dart';
import '../../widgets/common_text.dart';
import '../../widgets/common_text_field.dart';
import '../profile/widget/profile_section_card.dart';

class ReproductiveLifeStageScreen extends StatefulWidget {
  const ReproductiveLifeStageScreen({super.key});

  @override
  State<ReproductiveLifeStageScreen> createState() => _ReproductiveLifeStageScreenState();
}

class _ReproductiveLifeStageScreenState extends State<ReproductiveLifeStageScreen> {
  // Section 1: Menstrual Pattern
  final TextEditingController _cycleLengthController = TextEditingController();
  final TextEditingController _bleedingDurationController = TextEditingController();
  String? _cycleLengthError;
  String? _bleedingDurationError;
  bool _cycleLengthNotSure = false;
  
  String? _regularity;
  String? _regularityError;
  final List<String> _regularityOptions = [
    "Regular", "Sometimes irregular", "Irregular", "Currently absent (Amenorrhea)"
  ];

  final List<String> _cyclicalMarkersList = [
    "Cramps", "Heavy flow", "Clotting", "Mood changes", "Acne", "Bloating",
    "Breast tenderness", "Food cravings", "Fatigue or energy dip", "None"
  ];
  final Set<String> _selectedMarkers = {};
  String? _markersError;

  // Section 2: Trying to conceive or pregnancy module
  String? _underGynaecologistCare;
  String? _underGynaecologistCareError;
  final TextEditingController _clinicianController = TextEditingController();

  String? _doctorGuidance;
  final TextEditingController _physicianGuidanceController = TextEditingController();

  String? _pregnancyStatus;
  final List<String> _pregnancyStatusOptions = [
    "Currently Trying to Conceive (Pre-conception)",
    "Currently Pregnant"
  ];

  final TextEditingController _eddController = TextEditingController(text: "October 14, 2025");
  final TextEditingController _gestationalWeekController = TextEditingController(text: "18 Weeks (Second Trimester)");

  // Section 3: Perimenopause or Menopause Transitions
  final TextEditingController _lastMenstrualPeriodController = TextEditingController(text: "October 2024");
  String? _lastMenstrualPeriodError;
  bool _lastPeriodNotSure = false;

  final List<String> _menopausalChangesList = [
    "Hot flashes or night sweats", "Sleep disruption", "Mood changes",
    "Energy changes", "Joint discomfort", "Weight / body composition",
    "Vaginal or urinary symptoms", "None"
  ];
  final Set<String> _selectedMenopausalChanges = {};
  String? _menopausalChangesError;
  final TextEditingController _otherMenopausalChangesController = TextEditingController();

  bool _validate() {
    bool isValid = true;

    // Section 1
    if (_regularity == null) {
      _regularityError = "Required";
      isValid = false;
    } else {
      _regularityError = null;
    }

    if (_selectedMarkers.isEmpty) {
      _markersError = "Select at least 1 marker";
      isValid = false;
    } else {
      _markersError = null;
    }

    // Section 2
    if (_underGynaecologistCare == null) {
      _underGynaecologistCareError = "Required";
      isValid = false;
    } else {
      _underGynaecologistCareError = null;
    }

    // Section 3
    if (_selectedMenopausalChanges.isEmpty) {
      _menopausalChangesError = "Select at least 1 change";
      isValid = false;
    } else {
      _menopausalChangesError = null;
    }

    setState(() {});
    return isValid;
  }

  void _onSave() {
    if (_validate()) {
      showSnackBar(context: context, isError: false, message: 'Life Stage Protocol Submitted!');
      navigation.pop(context);
    } else {
      showSnackBar(context: context, isError: true, message: 'Please complete all required fields.');
    }
  }

  @override
  void dispose() {
    _cycleLengthController.dispose();
    _bleedingDurationController.dispose();
    _clinicianController.dispose();
    _physicianGuidanceController.dispose();
    _eddController.dispose();
    _gestationalWeekController.dispose();
    _lastMenstrualPeriodController.dispose();
    _otherMenopausalChangesController.dispose();
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
          "Reproductive Life Stage Modules",
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
          _buildMenstrualPattern(),
          const SizedBox(height: 24),
          _buildPregnancyModule(),
          const SizedBox(height: 24),
          _buildMenopauseTransitions(),
          const SizedBox(height: 32),
          CommonButton(
            name: "Save & Submit Life Stage Protocols",
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

  Widget _buildMenstrualPattern() {
    return ProfileSectionCard(
      title: "What is your usual menstrual pattern?",
      icon: appIcons.fullCalender,
      children: [
        buildRequiredLabel("What is your usual menstrual pattern?", color: const Color(0xFF534343)),
        const SizedBox(height: 16),
        const CommonText("Average cycle length", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1D1B1A))),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: CommonTextField(
                label: "",
                controller: _cycleLengthController,
                hint: "e.g. 28 days",
                borderColor: Colors.transparent,
                fillColor: const Color(0xFFF8F2F0),
                readOnly: _cycleLengthNotSure,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => setState(() {
                _cycleLengthNotSure = !_cycleLengthNotSure;
                if (_cycleLengthNotSure) _cycleLengthController.clear();
              }),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: _cycleLengthNotSure ? const Color(0xFFE7E1DF) : const Color(0xFFF2EDEB),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CommonText(
                  "Not sure",
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: _cycleLengthNotSure ? const Color(0xFF1D1B1A) : const Color(0xFF534343)),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const CommonText("Bleeding duration", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1D1B1A))),
        const SizedBox(height: 8),
        CommonTextField(
          label: "",
          controller: _bleedingDurationController,
          hint: "e.g. 4-5 days",
          borderColor: Colors.transparent,
          fillColor: const Color(0xFFF8F2F0),
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        ),
        const SizedBox(height: 16),
        const CommonText("Regularity", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1D1B1A))),
        const SizedBox(height: 8),
        Column(
          children: _regularityOptions.map((type) => _buildRadioRow(type, _regularity, (val) {
            setState(() {
              _regularity = val;
              if (_regularityError != null) _validate();
            });
          })).toList(),
        ),
        if (_regularityError != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 4),
            child: CommonText(_regularityError!, style: TextStyle(color: appColors.red, fontSize: 12)),
          ),
        const SizedBox(height: 24),
        Container(height: 1, color: const Color(0xFFF2EDEB)),
        const SizedBox(height: 24),
        buildRequiredLabel("Select all noticeable cyclical physical or emotional markers.", color: const Color(0xFF534343)),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _cyclicalMarkersList.map((item) => _buildSelectionPill(
            item,
            _selectedMarkers.contains(item),
            () {
              setState(() {
                if (_selectedMarkers.contains(item)) {
                  _selectedMarkers.remove(item);
                } else {
                  if (item == "None") {
                    _selectedMarkers.clear();
                    _selectedMarkers.add(item);
                  } else {
                    _selectedMarkers.remove("None");
                    _selectedMarkers.add(item);
                  }
                }
                if (_markersError != null) _validate();
              });
            },
          )).toList(),
        ),
        if (_markersError != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: CommonText(_markersError!, style: TextStyle(color: appColors.red, fontSize: 12)),
          ),
      ],
    );
  }

  Widget _buildPregnancyModule() {
    return ProfileSectionCard(
      title: "Trying to conceive or pregnancy module",
      icon: appIcons.pregnancy,
      children: [
        buildRequiredLabel("Are you currently under the care of a gynaecologist or obstetrician?", color: const Color(0xFF1D1B1A)),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildToggleBtn("Yes", _underGynaecologistCare == "Yes", () {
                setState(() {
                  _underGynaecologistCare = "Yes";
                  if (_underGynaecologistCareError != null) _validate();
                });
              }),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildToggleBtn("No", _underGynaecologistCare == "No", () {
                setState(() {
                  _underGynaecologistCare = "No";
                  if (_underGynaecologistCareError != null) _validate();
                });
              }),
            ),
          ],
        ),
        if (_underGynaecologistCareError != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 4),
            child: CommonText(_underGynaecologistCareError!, style: TextStyle(color: appColors.red, fontSize: 12)),
          ),
        const SizedBox(height: 20),
        const CommonText("Attending Clinician / Hospital (Optional)", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1D1B1A))),
        const SizedBox(height: 8),
        CommonTextField(
          label: "",
          controller: _clinicianController,
          hint: "e.g. Dr. Ananya Roy, Apollo Hospital",
          borderColor: Colors.transparent,
          fillColor: const Color(0xFFF8F2F0),
        ),
        const SizedBox(height: 20),
        const CommonText("Has your doctor given any nutrition, activity, or weight guidance we should follow?", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1D1B1A))),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildToggleBtn("Yes", _doctorGuidance == "Yes", () => setState(() => _doctorGuidance = "Yes")),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildToggleBtn("No", _doctorGuidance == "No", () => setState(() => _doctorGuidance = "No")),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const CommonText("Physician Guidance Details", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1D1B1A))),
        const SizedBox(height: 8),
        CommonTextField(
          label: "",
          controller: _physicianGuidanceController,
          hint: "e.g. Advised gentle iron supplementation, maintain pelvic stability exercises, and keep morning fasted glucose steady.",
          maxLines: 4,
          borderColor: Colors.transparent,
          fillColor: const Color(0xFFF8F2F0),
        ),
        const SizedBox(height: 24),
        const CommonText("Estimated due date or current week of pregnancy?", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1D1B1A))),
        const SizedBox(height: 12),
        Column(
          children: _pregnancyStatusOptions.map((type) => _buildRadioRow(type, _pregnancyStatus, (val) {
            setState(() {
              _pregnancyStatus = val;
            });
          })).toList(),
        ),
        const SizedBox(height: 16),
        const CommonText("Estimated Due Date (EDD)", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1D1B1A))),
        const SizedBox(height: 8),
        CommonTextField(
          label: "",
          controller: _eddController,
          hint: "Select Date",
          readOnly: true,
          borderColor: Colors.transparent,
          fillColor: const Color(0xFFF8F2F0),
          suffixIcon: const Icon(Icons.calendar_today_outlined, size: 16, color: Color(0xFF857373)),
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF857373)),
          onTap: () async {
            DateTime? picked = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 300)),
            );
            if (picked != null) {
              setState(() {
                _eddController.text = DateFormat('MMMM dd, yyyy').format(picked);
              });
            }
          },
        ),
        const SizedBox(height: 16),
        const CommonText("Current Gestational Week", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1D1B1A))),
        const SizedBox(height: 8),
        CommonTextField(
          label: "",
          controller: _gestationalWeekController,
          hint: "",
          borderColor: Colors.transparent,
          fillColor: const Color(0xFFF8F2F0),
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF857373)),
        ),
      ],
    );
  }

  Widget _buildMenopauseTransitions() {
    return ProfileSectionCard(
      title: "Perimenopause or Menopause Transitions",
      icon: appIcons.time,
      children: [
        buildRequiredLabel("When was your last menstrual period, approximately?", color: const Color(0xFF1D1B1A)),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: CommonTextField(
                label: "",
                controller: _lastMenstrualPeriodController,
                hint: "e.g. October 2024",
                readOnly: true,
                borderColor: _lastMenstrualPeriodError != null ? appColors.red : Colors.transparent,
                fillColor: const Color(0xFFF8F2F0),
                suffixIcon: const Icon(Icons.calendar_today_outlined, size: 16, color: Color(0xFF8B484D)),
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF857373)),
                onTap: _lastPeriodNotSure
                    ? null
                    : () async {
                        DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null) {
                          setState(() {
                            _lastMenstrualPeriodController.text = DateFormat('MMMM yyyy').format(picked);
                          });
                        }
                      },
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => setState(() {
                _lastPeriodNotSure = !_lastPeriodNotSure;
                if (_lastPeriodNotSure) _lastMenstrualPeriodController.clear();
              }),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: _lastPeriodNotSure ? const Color(0xFFE7E1DF) : const Color(0xFFF2EDEB),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CommonText(
                  "Not sure",
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: _lastPeriodNotSure ? const Color(0xFF1D1B1A) : const Color(0xFF534343)),
                ),
              ),
            ),
          ],
        ),
        if (_lastMenstrualPeriodError != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 4),
            child: CommonText(_lastMenstrualPeriodError!, style: TextStyle(color: appColors.red, fontSize: 12)),
          ),
        const SizedBox(height: 24),
        buildRequiredLabel("Which changes are currently affecting you?", color: const Color(0xFF1D1B1A)),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _menopausalChangesList.map((item) => _buildSelectionPill(
            item,
            _selectedMenopausalChanges.contains(item),
            () {
              setState(() {
                if (_selectedMenopausalChanges.contains(item)) {
                  _selectedMenopausalChanges.remove(item);
                } else {
                  if (item == "None") {
                    _selectedMenopausalChanges.clear();
                    _selectedMenopausalChanges.add(item);
                  } else {
                    _selectedMenopausalChanges.remove("None");
                    _selectedMenopausalChanges.add(item);
                  }
                }
                if (_menopausalChangesError != null) _validate();
              });
            },
          )).toList(),
        ),
        if (_menopausalChangesError != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: CommonText(_menopausalChangesError!, style: TextStyle(color: appColors.red, fontSize: 12)),
          ),
        const SizedBox(height: 24),
        const CommonText("Other cyclical changes or notes", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF534343))),
        const SizedBox(height: 8),
        CommonTextField(
          label: "",
          controller: _otherMenopausalChangesController,
          hint: "e.g., Brain fog during mid-afternoon",
          maxLines: 3,
          borderColor: Colors.transparent,
          fillColor: const Color(0xFFF8F2F0),
        ),
      ],
    );
  }

  // --- Reusable Control Helpers ---

  Widget _buildRadioRow(String value, String? groupValue, ValueChanged<String> onChanged) {
    bool isSelected = groupValue == value;
    return GestureDetector(
      onTap: () => onChanged(value),
      child: Container(
        padding: const EdgeInsets.all(14),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFDADB).withValues(alpha: 0.4) : const Color(0xFFF8F2F0),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: CommonText(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w500 : FontWeight.w500,
                  color: isSelected ? const Color(0xFF8B484D) : const Color(0xFF1D1B1A),
                ),
              ),
            ),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? const Color(0xFF8B484D) : Colors.white,
                border: isSelected ? null : Border.all(color: const Color(0xFF857373)),
              ),
              child: isSelected ? const Icon(Icons.check, size: 14, color: Colors.white) : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectionPill(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFDADB).withValues(alpha: 0.8) : const Color(0xFFF2EDEB),
          borderRadius: BorderRadius.circular(999),
        ),
        child: CommonText(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: isSelected ? const Color(0xFF3A0910) : const Color(0xFF1D1B1A),
          ),
        ),
      ),
    );
  }

  Widget _buildToggleBtn(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFDADB).withValues(alpha: 0.4) : const Color(0xFFF2EDEB),
          borderRadius: BorderRadius.circular(999),
        ),
        child: CommonText(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isSelected ? const Color(0xFF713439) : const Color(0xFF1D1B1A),
          ),
        ),
      ),
    );
  }
}
