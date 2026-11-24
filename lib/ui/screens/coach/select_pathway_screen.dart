import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../main.dart';
import '../../../core/blocs/coach/pathways/pathways_bloc.dart';
import '../../../core/blocs/coach/pathways/pathways_event.dart';
import '../../../core/blocs/coach/pathways/pathways_state.dart';
import '../../../core/constants/urls.dart';
import '../../../core/constants/utils.dart';
import '../../../core/models/coach/pathways_model.dart';
import '../../../core/services/loader_service.dart';
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
  final bool isBack;
  const SelectPathwayScreen({super.key, this.isBack = false});

  @override
  State<SelectPathwayScreen> createState() => _SelectPathwayScreenState();
}

class _SelectPathwayScreenState extends State<SelectPathwayScreen> {
  String? _selectedPathwayId;
  PathwayItem? _selectedPathway;
  bool showError = false;
  List<PathwayGroupItem> _groupsList = [];

  @override
  void initState() {
    super.initState();
    callGetPathwaysAPI();
  }

  void callGetPathwaysAPI() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      LoaderService.show(context);
      BlocProvider.of<PathwaysBloc>(context).add(
        const UserGetPathwaysEvent(url: Urls.pathways),
      );
    });
  }

  void _handlePreselection(PathwaysData? data) {
    if (data?.selectedPathwayUuid != null) {
      final selectedUuid = data!.selectedPathwayUuid!;
      for (var group in _groupsList) {
        final found = group.pathways?.firstWhere(
          (p) => p.uuid == selectedUuid,
          orElse: () => PathwayItem(),
        );
        if (found != null && found.uuid != null) {
          _selectedPathway = found;
          _selectedPathwayId = found.uuid;
          return;
        }
      }
    }

    for (var group in _groupsList) {
      final found = group.pathways?.firstWhere(
        (p) => p.isSelected == true,
        orElse: () => PathwayItem(),
      );
      if (found != null && found.uuid != null) {
        _selectedPathway = found;
        _selectedPathwayId = found.uuid;
        return;
      }
    }
  }

  void _onPathwaySelected(PathwayItem pathway) {
    setState(() {
      _selectedPathway = pathway;
      _selectedPathwayId = pathway.uuid ?? pathway.title ?? pathway.slug;
      showError = false;
    });
  }

  String _getPathwayIcon(String? slug, String? title) {
    final s = (slug ?? '').toLowerCase();
    final t = (title ?? '').toLowerCase();

    if (s.contains('gut-reset') || t.contains('gut reset')) {
      return appIcons.gutReset;
    } else if (s.contains('fat-loss') || t.contains('fat loss')) {
      return appIcons.measurement;
    } else if (s.contains('weight-gain') || t.contains('weight gain')) {
      return appIcons.up;
    } else if (s.contains('new-moms') || t.contains('new moms') || t.contains('rooted recovery')) {
      return appIcons.babySmile;
    } else if (s.contains('maintenance') || t.contains('maintenance')) {
      return appIcons.infinite;
    } else if (s.contains('reproductive') || t.contains('reproductive')) {
      return appIcons.fullCalender;
    } else {
      return appIcons.notApplicable;
    }
  }

  void _onContinue() {
    if (_selectedPathway == null && _selectedPathwayId == null) {
      setState(() {
        showError = true;
      });
      showSnackBar(context: context, isError: true, message: "Please select a pathway to continue.");
      return;
    }

    PathwayItem? selected = _selectedPathway;
    if (selected == null && _selectedPathwayId != null) {
      for (var group in _groupsList) {
        final found = group.pathways?.firstWhere(
          (p) => p.uuid == _selectedPathwayId || p.title == _selectedPathwayId || p.slug == _selectedPathwayId,
          orElse: () => PathwayItem(),
        );
        if (found != null && found.uuid != null) {
          selected = found;
          break;
        }
      }
    }

    final String pathwayUuid = selected?.uuid ?? "";
    final String slug = selected?.slug?.toLowerCase() ?? "";
    final String title = (selected?.title ?? _selectedPathwayId ?? "").toLowerCase();

    if (slug == "gut-reset" || title.contains("gut reset")) {
      navigation.push(context, GutResetProtocolScreen(pathwayUuid: pathwayUuid));
    } else if (slug == "fat-loss-inch-loss" || title.contains("fat loss")) {
      navigation.push(context, FatLossInchLossScreen(pathwayUuid: pathwayUuid));
    } else if (slug == "healthy-weight-gain" || title.contains("weight gain")) {
      navigation.push(context, HealthyWeightGainScreen(pathwayUuid: pathwayUuid));
    } else if (slug == "rooted-recovery-new-moms" || title.contains("rooted recovery") || title.contains("new moms")) {
      navigation.push(context, RootedRecoveryScreen(pathwayUuid: pathwayUuid));
    } else if (slug == "maintenance-lifestyle" || title.contains("maintenance")) {
      navigation.push(context, MaintenanceLifestyleScreen(pathwayUuid: pathwayUuid));
    } else if (slug == "reproductive-life-stage" || title.contains("reproductive")) {
      navigation.push(context, ReproductiveLifeStageScreen(pathwayUuid: pathwayUuid));
    }
  }

  void _onBack() {
    LoaderService.hide();
    if(widget.isBack){
      if (!mounted) return;
      navigation.pop(context);
    } else {
      bottomPageController.jumpToPage(BottomBarScreenIndex.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PathwaysBloc, PathwaysState>(
      listener: (context, state) {
        if (state is PathwaysSuccess) {
          LoaderService.hide();
          _groupsList = state.model.data?.groups ?? [];
          _handlePreselection(state.model.data);
          setState(() {});
        } else if (state is PathwaysFailed) {
          LoaderService.hide();
          showSnackBar(context: context, isError: true, message: state.message);
        }
      },
      child: PopScope(
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
              _buildPathwayGroups(),
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
        ),
      ),
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

  Widget _buildPathwayGroups() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _groupsList.map((group) {
        final pathways = group.pathways ?? [];
        if (pathways.isEmpty) return const SizedBox.shrink();
        final isHormonal = (group.group?.toLowerCase() == 'hormonal') ||
            (group.title?.toLowerCase().contains('hormonal') ?? false);
        return Padding(
          padding: const EdgeInsets.only(bottom: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonText(
                group.title ?? "",
                fontFamily: fontPlayfairDisplay,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1D1B1A),
                ),
              ),
              if (isHormonal) ...[
                const SizedBox(height: 4),
                const CommonText(
                  "Targeted protocols tuned to your reproductive biology, cycle phase, and life transitions.",
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF534343),
                    height: 20 / 13,
                  ),
                ),
              ],
              const SizedBox(height: 16),
              ...List.generate(pathways.length, (index) {
                final pathway = pathways[index];
                final bool isSelected = _selectedPathwayId == pathway.uuid ||
                    _selectedPathwayId == pathway.title ||
                    _selectedPathwayId == pathway.slug;
                return Padding(
                  padding: EdgeInsets.only(bottom: index == pathways.length - 1 ? 0 : 14),
                  child: PathwayCard(
                    title: pathway.title ?? "",
                    description: pathway.description ?? "",
                    icon: _getPathwayIcon(pathway.slug, pathway.title),
                    isSelected: isSelected,
                    tags: pathway.tags ?? [],
                    onTap: () => _onPathwaySelected(pathway),
                  ),
                );
              }),
            ],
          ),
        );
      }).toList(),
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
