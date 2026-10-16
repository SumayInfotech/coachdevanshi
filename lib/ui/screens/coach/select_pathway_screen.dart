import 'package:flutter/material.dart';

import '../../../../main.dart';
import '../../../core/constants/utils.dart';
import '../../widgets/common_app_bar.dart';
import '../../widgets/common_button.dart';
import '../../widgets/common_text.dart';
import '../bottom_bar_screen.dart';
import 'fat_loss_inch_loss_screen.dart';
import 'gut_reset_protocol_screen.dart';
import 'healthy_weight_gain_screen.dart';
import 'maintenance_lifestyle_screen.dart';
import 'reproductive_life_stage_screen.dart';
import 'rooted_recovery_screen.dart';
import 'widget/pathway_card.dart';

class SelectPathwayScreen extends StatefulWidget {
  const SelectPathwayScreen({super.key});

  @override
  State<SelectPathwayScreen> createState() => _SelectPathwayScreenState();
}

class _SelectPathwayScreenState extends State<SelectPathwayScreen> {
  String? _selectedPathwayId;
  bool _showError = false;

  void _onPathwaySelected(String id) {
    setState(() {
      _selectedPathwayId = id;
      _showError = false;
    });
  }

  void _onContinue() {
    if (_selectedPathwayId == null) {
      setState(() {
        _showError = true;
      });
      showSnackBar(context: context, isError: true, message: "Please select a pathway to continue.");
      return;
    }

    if(_selectedPathwayId == "Gut Reset"){
      navigation.push(context, const GutResetProtocolScreen());
    } else if(_selectedPathwayId == "Fat Loss and Inch Loss"){
      navigation.push(context, const FatLossInchLossScreen());
    } else if(_selectedPathwayId == "Healthy Weight Gain"){
      navigation.push(context, const HealthyWeightGainScreen());
    } else if(_selectedPathwayId == "Rooted Recovery for New Moms"){
      navigation.push(context, const RootedRecoveryScreen());
    } else if(_selectedPathwayId == "Maintenance & Lifestyle"){
      navigation.push(context, const MaintenanceLifestyleScreen());
    } else if(_selectedPathwayId == "Reproductive Life-Stage Modules"){
      navigation.push(context, const ReproductiveLifeStageScreen());
    }
  }

  void _onBack() {
    bottomPageController.jumpToPage(BottomBarScreenIndex.home);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
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
            "Select Your Pathway",
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
          padding: EdgeInsets.only(left: 20, right: 20, top: 16, bottom: bottomPadding(context)),
          children: [
            _buildInsightBanner(),
            const SizedBox(height: 24),
            _buildCoreCoachingTracks(),
            const SizedBox(height: 32),
            _buildHormonalJourneys(),
            const SizedBox(height: 32),
            _buildFormsCallout(),
            const SizedBox(height: 32),
            CommonButton(
              name: "Continue with Selected Pathway",
              onTap: _onContinue,
              icon: Icons.arrow_forward_rounded,
              isIconFirst: false,
              btnColor: const Color(0xFF8B484D),
              fontColor: appColors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              radius: 999,
            )
          ],
        ),
      )
    );
  }

  Widget _buildInsightBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFDBE7C2).withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, 1),
            blurRadius: 2,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            padding: EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Color(0xFF576245),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Color(0x0C000000),
                  offset: Offset(0, 1),
                  blurRadius: 1,
                ),
              ],
            ),
            child: Image.asset(appIcons.stars, color: Colors.white),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: CommonText(
              "Based on your clinical intake and biological rhythms, we've matched your starting foundation. Explore our foundational coaching programs and specialized hormonal tracks below.",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF576245),
                letterSpacing: 0.6,
                height: 20 / 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoreCoachingTracks() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CommonText(
          "Core Coaching Tracks",
          fontFamily: fontPlayfairDisplay,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1D1B1A),
          ),
        ),
        const SizedBox(height: 16),
        PathwayCard(
          title: "Gut Reset",
          description: "Microbiome rebalancing, gut motility, acid reflux relief & anti-inflammatory whole-food protocols designed to restore digestion from within.",
          icon: appIcons.gutReset,
          isSelected: _selectedPathwayId == "Gut Reset",
          tags: const ["8–12 Weeks", "High Recommendation", "Microbiome Tuning"],
          onTap: () => _onPathwaySelected("Gut Reset"),
        ),
        const SizedBox(height: 14),
        PathwayCard(
          title: "Fat Loss and Inch Loss",
          description: "Sustainable metabolic tuning, inch-loss cadence & mindful body recomp with zero restriction or punitive calorie deficits.",
          icon: appIcons.measurement,
          isSelected: _selectedPathwayId == "Fat Loss and Inch Loss",
          tags: const ["12–16 Weeks", "Metabolic Sync"],
          onTap: () => _onPathwaySelected("Fat Loss and Inch Loss"),
        ),
        const SizedBox(height: 14),
        PathwayCard(
          title: "Healthy Weight Gain",
          description: "Nourishing caloric density, gut absorption optimization & lean muscle recovery crafted for delicate appetites.",
          icon: appIcons.up,
          isSelected: _selectedPathwayId == "Healthy Weight Gain",
          tags: const ["12 Weeks", "Vitality"],
          onTap: () => _onPathwaySelected("Healthy Weight Gain"),
        ),
        const SizedBox(height: 14),
        PathwayCard(
          title: "Rooted Recovery for New Moms",
          description: "Postpartum restorative nourishment, tissue healing, warm digestive broths & gentle hormonal rebalancing.",
          icon: appIcons.babySmile,
          isSelected: _selectedPathwayId == "Rooted Recovery for New Moms",
          tags: const ["Specialized", "Postpartum Safe"],
          onTap: () => _onPathwaySelected("Rooted Recovery for New Moms"),
        ),
        const SizedBox(height: 14),
        PathwayCard(
          title: "Maintenance & Lifestyle",
          description: "Long-term intuitive rhythm, dining out flexibility, metabolic resilience & joyful habit sustaining.",
          icon: appIcons.infinite,
          isSelected: _selectedPathwayId == "Maintenance & Lifestyle",
          tags: const ["Ongoing", "Lifestyle Integration"],
          onTap: () => _onPathwaySelected("Maintenance & Lifestyle"),
        ),
      ],
    );
  }

  Widget _buildHormonalJourneys() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CommonText(
          "Hormonal & Life-Stage Journeys",
          fontFamily: fontPlayfairDisplay,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1D1B1A),
          ),
        ),
        const SizedBox(height: 4),
        const CommonText(
          "Targeted protocols tuned to your reproductive biology, cycle phase, and life transitions.",
          style: TextStyle(
            fontSize: 13,
            color: Color(0xFF534343),
            height: 20 / 13,
          ),
        ),
        const SizedBox(height: 16),
        PathwayCard(
          title: "Reproductive Life-Stage Modules",
          description: "Specialized clinical evaluation calibrated to your hormonal journey, menstrual rhythm, preconception, pregnancy, postpartum recovery, or menopausal transition.",
          icon: appIcons.fullCalender,
          isSelected: _selectedPathwayId == "Reproductive Life-Stage Modules",
          tags: const ["Cycle Syncing", "Maternal Care", "Perimenopause", "Post-Op Recovery"],
          onTap: () => _onPathwaySelected("Reproductive Life-Stage Modules"),
        ),
        const SizedBox(height: 14),
        PathwayCard(
          title: "Not applicable or Prefer Not to Answer",
          description: "Bypass hormonal staging; your clinical team will personalize foundational metabolic guidance.",
          icon: appIcons.notApplicable,
          isSelected: _selectedPathwayId == "Not applicable or Prefer Not to Answer",
          tags: const ["General Foundation", "Flexible Focus"],
          onTap: () => _onPathwaySelected("Not applicable or Prefer Not to Answer"),
        ),
      ],
    );
  }

  Widget _buildFormsCallout() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F2F0),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
              color: Color(0xFFF2EDEB),
              shape: BoxShape.circle,
            ),
            child: Image.asset(appIcons.taskDone, color: Color(0xFF534343)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CommonText(
                  "Custom Protocol Forms",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1D1B1A),
                    letterSpacing: 0.24,
                  ),
                ),
                const SizedBox(height: 4),
                const CommonText(
                  "Each program features its own specialized medical & nutritional questionnaire. Selecting your pathway unlocks your program-specific questionnaire so our team can begin formulating your personalized meal rhythm.",
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF534343),
                    height: 21.13 / 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
