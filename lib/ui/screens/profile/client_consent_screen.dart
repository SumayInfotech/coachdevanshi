import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../../main.dart';
import '../../../core/constants/utils.dart';
import '../../widgets/common_app_bar.dart';
import '../../widgets/common_text.dart';
import '../../widgets/common_button.dart';
import '../../widgets/common_web_view.dart';

class ClientConsentScreen extends StatefulWidget {
  const ClientConsentScreen({super.key});

  @override
  State<ClientConsentScreen> createState() => _ClientConsentScreenState();
}

class _ClientConsentScreenState extends State<ClientConsentScreen> {
  bool _agree1 = false;
  bool _agree2 = false;
  bool _agree3 = false;
  bool _agree4 = false;
  bool _agreeOptional = false;

  bool _showErrors = false;

  bool _validate() {
    if (_agree1 && _agree2 && _agree3 && _agree4) {
      setState(() => _showErrors = false);
      return true;
    } else {
      setState(() => _showErrors = true);
      return false;
    }
  }

  void _onSubmit() {
    if (_validate()) {
      appLog("Consent Form Validated!");
      navigation.pop(context);
    }
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
          "Client Consent & Agreement",
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
          _buildAgreementCard(
            isRequired: true,
            isChecked: _agree1,
            showError: _showErrors && !_agree1,
            onChanged: (v) => setState(() => _agree1 = v),
            content: const CommonText(
              "I confirm that the information provided is accurate to the best of my knowledge and I will update my coach if my health, medication, pregnancy status or medical advice changes.",
              style: TextStyle(
                fontSize: 13,
                fontFamily: fontFamilyPlusJakartaSans,
                color: Color(0xFF1D1B1A),
                height: 20.63 / 13,
              ),
            ),
          ),
          const SizedBox(height: 14),
          _buildAgreementCard(
            isRequired: true,
            isChecked: _agree2,
            showError: _showErrors && !_agree2,
            onChanged: (v) => setState(() => _agree2 = v),
            content: const CommonText(
              "I understand that nutrition and lifestyle coaching does not diagnose or treat medical conditions and does not replace care from a doctor or other qualified healthcare professional.",
              style: TextStyle(
                fontSize: 13,
                fontFamily: fontFamilyPlusJakartaSans,
                color: Color(0xFF1D1B1A),
                height: 20.63 / 13,
              ),
            ),
          ),
          const SizedBox(height: 14),
          _buildAgreementCard(
            isRequired: true,
            isChecked: _agree3,
            showError: _showErrors && !_agree3,
            onChanged: (v) => setState(() => _agree3 = v),
            content: RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 13,
                  fontFamily: fontFamilyPlusJakartaSans,
                  color: Color(0xFF1D1B1A),
                  height: 20.63 / 13,
                ),
                children: [
                  const TextSpan(text: "I consent to my information being used to create, deliver and monitor my coaching plan, as explained in the "),
                  TextSpan(
                    text: "Privacy Notice",
                    style: const TextStyle(
                      color: Color(0xFF8B484D),
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()..onTap = () {
                      navigation.pushSlideAnimation(context, const CommonWebView(title: "Privacy Notice", url: "https://www.google.com/"));
                    },
                  ),
                  const WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: Padding(
                      padding: EdgeInsets.only(left: 4.0),
                      child: Icon(Icons.north_east, size: 11, color: Color(0xFF8B484D)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          _buildAgreementCard(
            isRequired: true,
            isChecked: _agree4,
            showError: _showErrors && !_agree4,
            onChanged: (v) => setState(() => _agree4 = v),
            content: const CommonText(
              "I agree to receive coaching and service-related communication through the contact details I provided.",
              style: TextStyle(
                fontSize: 13,
                fontFamily: fontFamilyPlusJakartaSans,
                color: Color(0xFF1D1B1A),
                height: 20.63 / 13,
              ),
            ),
          ),
          const SizedBox(height: 24),
          _buildAgreementCard(
            isRequired: false,
            isChecked: _agreeOptional,
            onChanged: (v) => setState(() => _agreeOptional = v),
            content: const CommonText(
              "I would like to receive offers, newsletters or promotional updates",
              style: TextStyle(
                fontSize: 13,
                fontFamily: fontFamilyPlusJakartaSans,
                color: Color(0xFF1D1B1A),
                height: 20.63 / 13,
              ),
            ),
          ),
          const SizedBox(height: 28),
          _buildInfoCard(),
          const SizedBox(height: 32),
          CommonButton(
            name: "Complete Onboarding & Submit",
            onTap: _onSubmit,
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

  Widget _buildAgreementCard({
    required bool isRequired,
    required bool isChecked,
    required ValueChanged<bool> onChanged,
    required Widget content,
    bool showError = false,
  }) {
    return GestureDetector(
      onTap: () => onChanged(!isChecked),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: appColors.white,
          borderRadius: BorderRadius.circular(12),
          border: showError ? Border.all(color: appColors.red) : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 1,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 20,
              height: 20,
              margin: const EdgeInsets.only(top: 2),
              decoration: BoxDecoration(
                color: isChecked
                    ? const Color(0xFF8B484D)
                    : const Color(0xFFEDE7E5),
                borderRadius: BorderRadius.circular(6),
              ),
              child: isChecked
                  ? Icon(Icons.check, size: 14, color: appColors.white)
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: isRequired
                          ? const Color(0xFFFFDADB).withValues(alpha: 0.6)
                          : const Color(0xFFD8E5BF).withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: CommonText(
                      isRequired ? "Required" : "Optional",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: isRequired ? const Color(0xFF8B484D) : const Color(0xFF576245),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  content,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F2F0),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: const BoxDecoration(
              color: Color(0xFFEDE7E5),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.visibility_off_outlined, size: 14, color: Color(0xFF534343)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: RichText(
              text: const TextSpan(
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: fontFamilyPlusJakartaSans,
                  color: Color(0xFF534343),
                  height: 21.13 / 13,
                ),
                children: [
                  TextSpan(
                    text: "Private Telemetry Note: ",
                    style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF1D1B1A)),
                  ),
                  TextSpan(
                    text: "Progress photos and blood work reports remain under strict, isolated permissions. They are never published, shared with third parties, or required for baseline nutrition guidance.",
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
