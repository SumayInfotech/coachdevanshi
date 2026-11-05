import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../main.dart';
import '../../../core/blocs/profile/location/location_bloc.dart';
import '../../../core/blocs/profile/chapter_one/chapter_one_bloc.dart';
import '../../../core/blocs/profile/save_chapter/save_chapter_bloc.dart';
import '../../../core/constants/urls.dart';
import '../../../core/constants/utils.dart';
import '../../../core/models/profile/location_model.dart';
import '../../../core/models/profile/chapter_one_model.dart';
import '../../../core/models/profile/onboarding_masters_model.dart';
import '../../../core/repository/profile_repo.dart';
import '../../../core/services/loader_service.dart';
import '../../widgets/common_app_bar.dart';
import '../../widgets/common_text.dart';
import '../../widgets/common_text_field.dart';
import '../bottom_bar_screen.dart';
import 'widget/profile_bottom_button.dart';
import 'widget/profile_section_card.dart';

class ProfileProgramSelectionScreen extends StatefulWidget {
  final List<OnboardingData>? coachingJourney;
  const ProfileProgramSelectionScreen({super.key, this.coachingJourney});

  @override
  State<ProfileProgramSelectionScreen> createState() => _ProfileProgramSelectionScreenState();
}

class _ProfileProgramSelectionScreenState extends State<ProfileProgramSelectionScreen> {

  late LocationBloc _stateBloc;
  late LocationBloc _cityBloc;

  ChapterOneModel? chapterOneModel;

  List<LocationData> stateList = [];
  List<LocationData> cityList = [];

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _countryController = TextEditingController(text: "India");
  // final TextEditingController _stateController = TextEditingController();
  // final TextEditingController _cityController = TextEditingController();
  final TextEditingController _dailyRhythmController = TextEditingController();

  DateTime? _selectedDob;
  String? _apiCityName;

  String? _fullNameError;
  String? _mobileError;
  String? _dobError;
  String? _stateError;
  String? _cityError;
  String? _dailyRhythmError;
  String? _journeyError;

  String selectedCountryCode = "+91";

  String _selectedGender = 'Female';
  String? _selectedJourney;
  String _selectedCountry = 'India';
  String? _selectedState, _selectedCity;
  String _autoDetectedTimeZone = "IST (UTC+5:30)";

  @override
  void initState() {
    super.initState();
    _detectTimeZone();
    _cityBloc = LocationBloc(profileRepo: ProfileRepo());
    callStateAPI();
    callChapterOneAPI();
    setData();
  }

  void _detectTimeZone() {
    final now = DateTime.now();
    final offset = now.timeZoneOffset;
    final isNegative = offset.isNegative;
    final totalMinutes = offset.inMinutes.abs();
    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;
    final sign = isNegative ? '-' : '+';
    final formattedMinutes = minutes == 0 ? '' : ':${minutes.toString().padLeft(2, '0')}';
    final utcOffset = totalMinutes == 0 ? 'UTC' : 'UTC$sign$hours$formattedMinutes';

    String name = now.timeZoneName.trim().replaceAll(RegExp(r'[()]'), '');
    if (name.contains(' ') && name.length > 5) {
      final words = name.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();
      final initials = words.map((w) => w[0].toUpperCase()).join();
      if (initials.isNotEmpty && initials.length <= 5) {
        name = initials;
      }
    }

    if (name.isNotEmpty &&
        !name.startsWith('+') &&
        !name.startsWith('-') &&
        !name.toUpperCase().startsWith('UTC')) {
      _autoDetectedTimeZone = "$name ($utcOffset)";
    } else {
      _autoDetectedTimeZone = utcOffset;
    }
    setState(() {});
  }


  void setData() {
    final user = userData.value;
    _fullNameController.text = user?.name ?? "";
    _emailController.text = user?.email ?? "";
    _mobileController.text = user?.mobile ?? "";
    _selectedState = user?.stateId?.toString();
    _selectedCity = user?.cityId?.toString();
    if (_selectedState != null && _selectedState!.isNotEmpty) {
      callCityAPI(stateId: _selectedState!);
    }
    setState(() { });
  }

  void callStateAPI() {
    _stateBloc = LocationBloc(profileRepo: ProfileRepo());
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      LoaderService.show(context);
      _stateBloc.add(UserLocationEvent(
        url: Urls.getLocation,
        body: {}
      ));
    });
  }

  void callCityAPI({required String stateId}) {
    LoaderService.show(context);
    _cityBloc.add(UserLocationEvent(
      url: Urls.getLocation,
      body: {
        "state_id" : stateId
      }
    ));
  }

  void callChapterOneAPI() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      LoaderService.show(context);
      BlocProvider.of<ChapterOneBloc>(context).add(
        UserChapterOneEvent(url: Urls.onboardingChapter(chapterId: "1")),
      );
    });
  }

  void _populateFromChapterOne(ChapterOneModel model) {
    final answers = model.data?.answers;
    if (answers != null) {
      if (answers.email != null && answers.email!.isNotEmpty) {
        _emailController.text = answers.email!;
      }
      if (answers.fullName != null && answers.fullName!.isNotEmpty) {
        _fullNameController.text = answers.fullName!;
      }
      if (answers.nickname != null && answers.nickname!.isNotEmpty) {
        _nicknameController.text = answers.nickname!;
      }
      if (answers.mobile != null && answers.mobile!.isNotEmpty) {
        _mobileController.text = answers.mobile!;
      }
      if (answers.phoneCode != null && answers.phoneCode!.isNotEmpty) {
        selectedCountryCode = answers.phoneCode!;
      }
      if (answers.dob != null) {
        _selectedDob = answers.dob;
        _dobController.text =
            "${answers.dob!.month.toString().padLeft(2, '0')} / ${answers.dob!.day.toString().padLeft(2, '0')} / ${answers.dob!.year}";
      }
      if (answers.gender != null && answers.gender!.isNotEmpty) {
        _selectedGender = answers.gender!;
      }
      if (answers.country != null && answers.country!.isNotEmpty) {
        _selectedCountry = answers.country!;
        _countryController.text = answers.country!;
      }
      if (answers.stateId != null && answers.stateId.toString().isNotEmpty) {
        _selectedState = answers.stateId.toString();
        callCityAPI(stateId: _selectedState!);
      }
      if (answers.cityId != null && answers.cityId.toString().isNotEmpty) {
        _selectedCity = answers.cityId.toString();
      }
      if (answers.city != null && answers.city!.isNotEmpty) {
        _apiCityName = answers.city;
        _matchCityFromAnswers();
      }
      if (answers.timezone != null && answers.timezone!.isNotEmpty) {
        _autoDetectedTimeZone = answers.timezone!;
      }
      if (answers.dailyRhythm != null && answers.dailyRhythm!.isNotEmpty) {
        _dailyRhythmController.text = answers.dailyRhythm!;
      }
      if (answers.coachingJourney != null && answers.coachingJourney!.isNotEmpty) {
        _selectedJourney = answers.coachingJourney;
      }
    }
  }

  void _matchCityFromAnswers() {
    if (_apiCityName != null && cityList.isNotEmpty) {
      for (final c in cityList) {
        if (c.name?.trim().toLowerCase() == _apiCityName?.trim().toLowerCase() ||
            c.id.toString() == _apiCityName?.trim()) {
          _selectedCity = c.id.toString();
          break;
        }
      }
    }
  }

  Field? _getField(String key) {
    final fields = chapterOneModel?.data?.fields ?? [];
    for (final f in fields) {
      if (f.key == key) return f;
    }
    return null;
  }

  IconData _getGenderIcon(String value) {
    final val = value.toLowerCase();
    if (val.contains("female")) {
      return Icons.female_rounded;
    } else if (val.contains("male")) {
      return Icons.male_rounded;
    } else {
      return Icons.transgender_rounded;
    }
  }

  bool _validate() {
    bool isValid = true;

    if (_fullNameController.text.trim().isEmpty) {
      _fullNameError = "Please enter your full name";
      isValid = false;
    } else {
      _fullNameError = null;
    }

    if (_mobileController.text.length < 10) {
      _mobileError = "Please enter a valid 10-digit mobile number";
      isValid = false;
    } else {
      _mobileError = null;
    }

    if (_dobController.text.trim().isEmpty) {
      _dobError = "Please enter your date of birth";
      isValid = false;
    } else {
      _dobError = null;
    }

    if (_selectedState == null) {
      _stateError = "Please enter your State";
      isValid = false;
    } else {
      _stateError = null;
    }

    if (_selectedCity == null) {
      _cityError = "Please enter your city";
      isValid = false;
    } else {
      _cityError = null;
    }

    if (_dailyRhythmController.text.trim().length < 50) {
      _dailyRhythmError = "Please enter at least 50 characters";
      isValid = false;
    } else {
      _dailyRhythmError = null;
    }

    if (_selectedJourney == null) {
      _journeyError = "Please select a coaching journey";
      isValid = false;
    } else {
      _journeyError = null;
    }

    setState(() {});
    return isValid;
  }

  void _onSaveAndContinue() {
    if (_validate()) {
      LoaderService.show(context);

      String genderValue = _selectedGender;
      final genderField = _getField("gender");
      if (genderField != null) {
        for (final opt in genderField.options) {
          if ((opt.value?.toLowerCase() == _selectedGender.toLowerCase()) ||
              (opt.label?.toLowerCase() == _selectedGender.toLowerCase())) {
            genderValue = opt.value ?? _selectedGender;
            break;
          }
        }
      }

      String dobString = "";
      if (_selectedDob != null) {
        dobString =
            "${_selectedDob!.year.toString().padLeft(4, '0')}-${_selectedDob!.month.toString().padLeft(2, '0')}-${_selectedDob!.day.toString().padLeft(2, '0')}";
      } else {
        dobString = _dobController.text.trim();
      }

      final matchingCity = cityList.where((c) => c.id.toString() == _selectedCity).firstOrNull;
      final cityToSave = matchingCity?.name ?? _apiCityName ?? _selectedCity ?? "";

      BlocProvider.of<SaveChapterBloc>(context).add(
        UserSaveChapterEvent(
          url: Urls.onboardingChapter(chapterId: "1"),
          body: {
            "answers": {
              "email": _emailController.text.trim(),
              "full_name": _fullNameController.text.trim(),
              "nickname": _nicknameController.text.trim(),
              "phone_code": selectedCountryCode,
              "mobile": _mobileController.text.trim(),
              "dob": dobString,
              "gender": genderValue,
              "city": cityToSave,
              "city_id": _selectedCity,
              "state_id": _selectedState,
              "country": _selectedCountry,
              "timezone": _autoDetectedTimeZone,
              "daily_rhythm": _dailyRhythmController.text.trim(),
              "coaching_journey": _selectedJourney
            }
          },
        ),
      );
    }
  }


  @override
  void dispose() {
    _emailController.dispose();
    _fullNameController.dispose();
    _nicknameController.dispose();
    _mobileController.dispose();
    _dobController.dispose();
    _countryController.dispose();
    // _stateController.dispose();
    // _cityController.dispose();
    _dailyRhythmController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocListener<LocationBloc, LocationState>(
          bloc: _stateBloc,
          listener: (context, state) {
            if(state is LocationSuccess) {
              stateList = state.model.data;
              if (_selectedState != null && _selectedState!.isNotEmpty) {
                callCityAPI(stateId: _selectedState!);
              }
              setState(() { });
              LoaderService.hide();
            } else if(state is LocationFailed) {
              LoaderService.hide();
              showSnackBar(context: context, isError: true, message: state.message);
            }
          },
        ),
        BlocListener<LocationBloc, LocationState>(
          bloc: _cityBloc,
          listener: (context, state) {
            if(state is LocationSuccess) {
              LoaderService.hide();
              cityList = state.model.data;
              _matchCityFromAnswers();
              setState(() { });
            } else if(state is LocationFailed) {
              LoaderService.hide();
              showSnackBar(context: context, isError: true, message: state.message);
            }
          },
        ),
        BlocListener<ChapterOneBloc, ChapterOneState>(
          listener: (context, state) {
            if (state is ChapterOneSuccess) {
              LoaderService.hide();
              chapterOneModel = state.model;
              _populateFromChapterOne(state.model);
              setState(() {});
            } else if (state is ChapterOneFailed) {
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
                "CHAPTER ${chapterOneModel?.data?.chapter ?? 1} OF ${chapterOneModel?.data?.total ?? 6}",
                style: TextStyle(
                  fontSize: 11,
                  color: appColors.primary,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.55,
                ),
              ),
              CommonText(
                chapterOneModel?.data?.title ?? "Profile & Program",
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
            _buildPersonalDetailsSection(),
            const SizedBox(height: 24),
            _buildBiologicalContextSection(),
            const SizedBox(height: 24),
            _buildLocationSection(),
            const SizedBox(height: 24),
            _buildDailyLifeSection(),
            const SizedBox(height: 24),
            _buildCoachingJourneySection(),
            const SizedBox(height: 24),
            ProfileBottomButton(
              name: "Save & Continue to Goals & Starting Point",
              onTap: _onSaveAndContinue,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalDetailsSection() {
    return ProfileSectionCard(
      title: "Personal Details",
      icon: appIcons.personalDetail,
      children: [
        CommonTextField(
          label: "Email address",
          controller: _emailController,
          isRequired: true,
          hint: "",
          readOnly: _emailController.text.isNotEmpty,
          borderColor: Colors.transparent,
          prefixIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Image.asset(appIcons.email, color: Color(0xFF857373), height: 18, width: 18),
          ),
        ),
        const SizedBox(height: 16),
        CommonTextField(
          label: "Full name",
          controller: _fullNameController,
          isRequired: true,
          hint: "Enter your full name",
          error: _fullNameError,
          borderColor: Colors.transparent,
          prefixIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Image.asset(appIcons.profileProgram, color: Color(0xFF857373), height: 18, width: 18),
          ),
          onChanged: (v) {
            if (_fullNameError != null) _validate();
          },
        ),
        const SizedBox(height: 16),
        CommonTextField(
          label: "What name would you like us to use?",
          controller: _nicknameController,
          isRequired: false,
          hint: "Enter Nickname",
          borderColor: Colors.transparent,
          prefixIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Image.asset(appIcons.smile, color: Color(0xFF857373), height: 18, width: 18),
          ),
        ),
        const SizedBox(height: 4),
        CommonText(
          "Optional — what friends or coaches call you",
          style: TextStyle(fontSize: 11, color: const Color(0xFF534343), fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 16),
        CommonTextField(
          label: "Mobile number",
          controller: _mobileController,
          isRequired: true,
          hint: "Enter Mobile No.",
          keyboardType: TextInputType.phone,
          error: _mobileError,
          readOnly: _mobileController.text.isNotEmpty,
          borderColor: Colors.transparent,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10),
          ],
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 4, right: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CountryCodePicker(
                  key: ValueKey(selectedCountryCode),
                  onChanged: (countryCode) {
                    selectedCountryCode = countryCode.dialCode ?? "+91";
                  },
                  initialSelection: selectedCountryCode,
                  favorite: const ['+91', 'IN'],
                  showCountryOnly: false,
                  showOnlyCountryWhenClosed: false,
                  flagWidth: 25,
                  alignLeft: false,
                  padding: EdgeInsets.zero,
                  textStyle: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1D1B1A),
                  ),
                ),
                const SizedBox(width: 4),
                Container(height: 24, width: 1, color: const Color(0xFFE7E1DF)),
              ],
            ),
          ),
          onChanged: (v) {
            if (_mobileError != null) _validate();
          },
        ),
        const SizedBox(height: 16),
        CommonTextField(
          label: "Date of Birth",
          controller: _dobController,
          isRequired: true,
          readOnly: true,
          hint: "MM / DD / YYYY",
          error: _dobError,
          borderColor: Colors.transparent,
          fillColor: appColors.textFieldBgColor,
          prefixIcon: const Icon(Icons.calendar_today_rounded, color: Color(0xFF857373), size: 20),
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: _selectedDob ?? DateTime.now().subtract(const Duration(days: 365 * 25)),
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
            );
            if (pickedDate != null) {
              _selectedDob = pickedDate;
              String formattedDate =
                  "${pickedDate.month.toString().padLeft(2, '0')} / ${pickedDate.day.toString().padLeft(2, '0')} / ${pickedDate.year}";
              setState(() {
                _dobController.text = formattedDate;
                if (_dobError != null) _validate();
              });
            }
          },
        ),
      ],
    );
  }

  Widget _buildBiologicalContextSection() {
    final genderField = _getField("gender");
    final genderOptions = (genderField != null && genderField.options.isNotEmpty)
        ? genderField.options
        : [
            Option(value: "female", label: "Female", description: null, image: null),
            Option(value: "male", label: "Male", description: null, image: null),
            Option(value: "prefer_not_to_answer", label: "Prefer not to answer", description: null, image: null),
          ];

    return ProfileSectionCard(
      title: genderField?.label ?? "Biological Context",
      icon: appIcons.progress,
      children: [
        RichText(
          text: TextSpan(
            style: const TextStyle(
              fontSize: 13,
              fontFamily: fontFamilyPlusJakartaSans,
              color: Color(0xFF534343),
            ),
            children: [
              const TextSpan(
                text: "For health planning and calculations, please select one from below? ",
                style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF1D1B1A)),
              ),
              TextSpan(
                text: "*",
                style: TextStyle(color: appColors.primary),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        for (int i = 0; i < genderOptions.length; i++) ...[
          if (i > 0) const SizedBox(height: 10),
          _buildSelectionPill(
            label: genderOptions[i].label ?? "",
            icon: _getGenderIcon(genderOptions[i].value ?? genderOptions[i].label ?? ""),
            isSelected: (_selectedGender.toLowerCase() == (genderOptions[i].value ?? "").toLowerCase()) ||
                (_selectedGender.toLowerCase() == (genderOptions[i].label ?? "").toLowerCase()),
            onTap: () => setState(() => _selectedGender = genderOptions[i].label ?? genderOptions[i].value ?? ""),
          ),
        ],
      ],
    );
  }

  Widget _buildSelectionPill({
    required String label, required IconData icon, required bool isSelected, required VoidCallback onTap
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFDADB) : appColors.textFieldBgColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: isSelected ? [BoxShadow(
            color: appColors.black.withValues(alpha: 0.05),
            offset: const Offset(0, 1), blurRadius: 1
          )] : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, color: isSelected ? const Color(0xFF713439) : const Color(0xFF1D1B1A), size: 16),
                const SizedBox(width: 12),
                CommonText(label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? const Color(0xFF713439) : const Color(0xFF1D1B1A),
                  ),
                ),
              ],
            ),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? appColors.primary : appColors.white,
                border: isSelected ? null : Border.all(color: const Color(0xFFE7E1DF)),
              ),
              child: isSelected ? Icon(Icons.check, size: 12, color: appColors.white) : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationSection() {
    return ProfileSectionCard(
      title: "Location",
      icon: appIcons.world,
      children: [
        RichText(
          text: TextSpan(
            style: const TextStyle(
              fontSize: 13,
              fontFamily: fontFamilyPlusJakartaSans,
              color: Color(0xFF534343),
            ),
            children: [
              const TextSpan(text: "Where are you currently based? "),
              TextSpan(text: "*", style: TextStyle(color: appColors.primary)),
            ],
          ),
        ),
        const SizedBox(height: 12),
        CommonTextField(
          label: "Country",
          controller: _countryController,
          isRequired: false,
          hint: "",
          readOnly: true,
          borderColor: Colors.transparent,
          // suffixIcon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF1D1B1A), size: 18),
        ),
        const SizedBox(height: 12),
        Row(
          spacing: 12,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: mandatoryText(
                      text: "State",
                      isRequired: false,
                    ),
                  ),
                  DropdownButtonFormField<String>(
                    key: ValueKey(_selectedState),
                    initialValue: stateList.any((state) => state.id.toString() == _selectedState) ? _selectedState : null,
                    isExpanded: true,
                    hint: const Text(
                      "Select State",
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: fontFamilyPlusJakartaSans,
                        color: Color(0xFF857373),
                      ),
                    ),
                    decoration: buildInputDecoration(
                      isDense: false,
                      borderColor: Colors.transparent,
                      error: _stateError,
                    ),
                    icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF1D1B1A), size: 18),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF1D1B1A),
                      fontFamily: fontFamilyPlusJakartaSans,
                    ),
                    items: stateList.map((state) {
                      return DropdownMenuItem<String>(
                        value: state.id.toString(),
                        child: Text(state.name ?? ""),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedState = value;
                        _selectedCity = null;
                        cityList.clear();
                      });
                      if (value != null) {
                        callCityAPI(stateId: value.toString());
                      }
                      if (_stateError != null) _validate();
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: mandatoryText(
                      text: "City",
                      isRequired: false,
                    ),
                  ),
                  DropdownButtonFormField<String>(
                    key: ValueKey(_selectedCity),
                    initialValue: cityList.any((city) => city.id.toString() == _selectedCity) ? _selectedCity : null,
                    isExpanded: true,
                    hint: const Text(
                      "Select City",
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: fontFamilyPlusJakartaSans,
                        color: Color(0xFF857373),
                      ),
                    ),
                    decoration: buildInputDecoration(
                      isDense: false,
                      borderColor: Colors.transparent,
                      error: _cityError,
                    ),
                    icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF1D1B1A), size: 18),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF1D1B1A),
                      fontFamily: fontFamilyPlusJakartaSans,
                    ),
                    items: cityList.map((city) {
                      return DropdownMenuItem<String>(
                        value: city.id.toString(),
                        child: Text(city.name ?? ""),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCity = value;
                      });
                      if (_cityError != null) _validate();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: appColors.textFieldBgColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF2EDEB),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.access_time_rounded, color: Color(0xFF576245), size: 16),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CommonText("TIME ZONE",
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF576245),
                              letterSpacing: 0.55,
                            ),
                          ),
                          CommonText("Auto-detected: $_autoDetectedTimeZone",
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF1D1B1A),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: _detectTimeZone,
                child: const Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Icon(Icons.refresh_rounded, color: Color(0xFF576245), size: 16),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDailyLifeSection() {
    return ProfileSectionCard(
      title: "Daily Life & Schedule",
      icon: appIcons.dailyLifeSchedule,
      children: [
        RichText(
          text: TextSpan(
            style: const TextStyle(
              fontSize: 13,
              fontFamily: fontFamilyPlusJakartaSans,
              color: Color(0xFF1D1B1A),
            ),
            children: [
              const TextSpan(text: "Your Daily Rhythm ", style: TextStyle(fontWeight: FontWeight.w600)),
              TextSpan(text: "*", style: TextStyle(color: appColors.primary, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        const SizedBox(height: 4),
        CommonText(
          "Share your commitments, typical sleep/wake times, desk vs. active hours, or family responsibilities so we fit wellness into your real life.",
          style: TextStyle(
            fontSize: 13,
            color: const Color(0xFF534343),
            height: 20 / 13,
          ),
        ),
        const SizedBox(height: 12),
        CommonTextField(
          label: "",
          controller: _dailyRhythmController,
          maxLines: null,
          minLines: 5,
          keyboardType: TextInputType.multiline,
          borderColor: appColors.textFieldBgColor,
          hint: "e.g. I work a hybrid job 9:30-6:30 with a commute on weekdays. Usually wake up by 6:30 AM, prepare meals with family, have chai around 5 PM, and wind down by 10:30 PM...",
          style: TextStyle(
            fontSize: 15,
            color: const Color(0xFF1D1B1A),
            fontFamily: fontFamilyPlusJakartaSans,
          ),
          onChanged: (v) {
            setState(() {});
            if (_dailyRhythmError != null) _validate();
          },
        ),
        if (_dailyRhythmError != null) Padding(
          padding: const EdgeInsets.only(top: 4, left: 4),
          child: CommonText(_dailyRhythmError!,
            style: TextStyle(color: appColors.red, fontSize: 12),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset(appIcons.edit, height: 12, width: 12, color: const Color(0xFF576245)),
                const SizedBox(width: 4),
                CommonText("Min 50 characters",
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF576245),
                  ),
                ),
              ],
            ),
            CommonText("${_dailyRhythmController.text.length} chars",
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF857373),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCoachingJourneySection() {
    final journeyField = _getField("coaching_journey");
    final dynamicJourneyOptions = journeyField?.options ?? [];
    final hasDynamicOptions = dynamicJourneyOptions.isNotEmpty;
    final hasFallbackOptions = (widget.coachingJourney != null && widget.coachingJourney!.isNotEmpty);

    return ProfileSectionCard(
      title: "Coaching Journey",
      icon: appIcons.coachingJourney,
      children: [
        RichText(
          text: TextSpan(
            style: const TextStyle(
              fontSize: 13,
              fontFamily: fontFamilyPlusJakartaSans,
              color: Color(0xFF534343),
            ),
            children: [
              TextSpan(text: journeyField?.label ?? "Which coaching journey are you joining? "),
              TextSpan(text: "*", style: TextStyle(color: appColors.primary)),
            ],
          ),
        ),
        const SizedBox(height: 12),

        if (!hasDynamicOptions && !hasFallbackOptions)
          errorTextWidget(title: "No coaching journey found!")
        else if (hasDynamicOptions)
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 12),
            itemCount: dynamicJourneyOptions.length,
            itemBuilder: (context, index) {
              final item = dynamicJourneyOptions[index];
              return _buildJourneyPill(
                title: item.label ?? "",
                subtitle: item.description ?? "",
                icon: item.image ?? "",
                isSelected: _selectedJourney == item.value,
                onTap: () => setState(() {
                  _selectedJourney = item.value;
                  if (_journeyError != null) _validate();
                }),
              );
            },
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 12),
            itemCount: widget.coachingJourney!.length,
            itemBuilder: (context, index) {
              final item = widget.coachingJourney![index];
              return _buildJourneyPill(
                title: item.title ?? "",
                subtitle: item.description ?? "",
                icon: item.image ?? "",
                isSelected: _selectedJourney == item.uuid,
                onTap: () => setState(() {
                  _selectedJourney = item.uuid;
                  if (_journeyError != null) _validate();
                }),
              );
            },
          ),

        if (_journeyError != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: CommonText(
              _journeyError!,
              style: TextStyle(color: appColors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }

  Widget _buildJourneyPill({
    required String title,
    required String subtitle,
    required String icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFFFDADB) : appColors.textFieldBgColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: appColors.black.withValues(alpha: 0.05),
                      offset: const Offset(0, 1),
                      blurRadius: 1,
                    )
                  ]
                : null,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isSelected ? appColors.primary : const Color(0xFFD8C1C2),
                  shape: BoxShape.circle,
                ),
                child: icon.startsWith("http")
                    ? Image.network(
                        icon,
                        color: isSelected ? appColors.white : const Color(0xFF1D1B1A),
                        errorBuilder: (context, error, stackTrace) => Icon(
                          Icons.fitness_center_rounded,
                          size: 18,
                          color: isSelected ? appColors.white : const Color(0xFF1D1B1A),
                        ),
                      )
                    : Image.asset(
                        icon,
                        color: isSelected ? appColors.white : const Color(0xFF1D1B1A),
                        errorBuilder: (context, error, stackTrace) => Icon(
                          Icons.fitness_center_rounded,
                          size: 18,
                          color: isSelected ? appColors.white : const Color(0xFF1D1B1A),
                        ),
                      ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonText(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1D1B1A),
                      ),
                    ),
                    const SizedBox(height: 4),
                    CommonText(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF534343),
                        height: 17.88 / 13,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              Container(
                width: 20,
                height: 20,
                margin: const EdgeInsets.only(top: 4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? appColors.primary : appColors.white,
                  border: isSelected ? null : Border.all(color: const Color(0xFFE7E1DF)),
                ),
                child: isSelected ? Icon(Icons.check, size: 12, color: appColors.white) : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
