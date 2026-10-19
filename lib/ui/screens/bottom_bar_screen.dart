import 'dart:io';

import 'package:coach_devanshi_doshi/core/services/loader_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/blocs/auth/profile/profile_bloc.dart';
import '../../core/constants/urls.dart';
import '../../core/models/auth/user_model.dart';
import '../../main.dart';
import '../widgets/common_text.dart';
import 'check-in/daily_wellness_log_screen.dart';
import 'coach/select_pathway_screen.dart';
import 'home/home_screen.dart';
import 'profile/client_onboarding_introduction_screen.dart';
import 'profile/client_onboarding_screen.dart';
import 'progress/baseline_progress_screen.dart';

class BottomBarScreenIndex{
  static const int home = 0;
  static const int checkIn = 1;
  static const int progress = 2;
  static const int coach = 3;
  static const int profile = 4;
}

class BottomBarScreen extends StatefulWidget {
  const BottomBarScreen({super.key});

  @override
  State<BottomBarScreen> createState() => _BottomBarScreenState();
}

PageController bottomPageController = PageController();
ValueNotifier<UserData?> userData = ValueNotifier(null);

void callUserAPI({required BuildContext context}) {
  LoaderService.show(context);
  BlocProvider.of<ProfileBloc>(context).add(UserProfileEvent(url: Urls.profile));
}

class _BottomBarScreenState extends State<BottomBarScreen> {

  ValueNotifier<int> selectedBottomIndex = ValueNotifier(0);

  List<BottomBarItemData> currentMenu = [
    BottomBarItemData(label: "Home", icon: appIcons.home),
    BottomBarItemData(label: "Check-in", icon: appIcons.checkIn),
    BottomBarItemData(label: "Progress", icon: appIcons.progress),
    BottomBarItemData(label: "Coach", icon: appIcons.coach),
    BottomBarItemData(label: "Profile", icon: appIcons.profile),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      callUserAPI(context: context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if(state is ProfileSuccess) {
              LoaderService.hide();
              userData.value = state.model.data?.user;
              if(!(state.model.data?.user?.isProfileCompleted ?? false)) {
                navigation.pushAndRemoveUntilSlideAnimation(context, ClientOnboardingIntroductionScreen());
              }
            } else if(state is ProfileFailed) {
              LoaderService.hide();
            }
          },
        ),
      ],
      child: Scaffold(
        body: PageView(
          controller: bottomPageController,
          physics: const NeverScrollableScrollPhysics(),
          allowImplicitScrolling: false,
          children: [
            HomeScreen(),
            DailyWellnessLogScreen(),
            BaselineProgressScreen(),
            SelectPathwayScreen(),
            ClientOnboardingScreen(),
          ],
          onPageChanged: (value) {
            selectedBottomIndex.value = value;
            setState(() {});
          },
        ),
        bottomNavigationBar: Container(
          width: MediaQuery.of(context).size.width,
          height: Platform.isIOS ? 80 : 65,
          padding: EdgeInsets.only(
            bottom: Platform.isIOS ? 20 : 0,
          ),
          margin: EdgeInsets.only(
            bottom: MediaQuery.paddingOf(context).bottom,
          ),
          decoration: BoxDecoration(
            color: appColors.white,
            boxShadow: [
              BoxShadow(
                color: appColors.black.withValues(alpha: 0.15),
                blurRadius: 5,
                spreadRadius: 0,
              ),
            ],
          ),
          child: ValueListenableBuilder(
            valueListenable: selectedBottomIndex,
            builder: (context, selectedIndex, _) {
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: currentMenu.map((e) {
                    int index = currentMenu.indexOf(e);
                    return HomeMenu(
                      label: e.label,
                      onTap: () {
                        bottomPageController.jumpToPage(index);
                      },
                      icon: e.icon,
                      isSelected: selectedIndex == index,
                    );
                  }).toList(),
                ),
              );
            }
          ),
        ),
      ),
    );
  }
}

class HomeMenu extends StatelessWidget {
  final String icon;
  final String label;
  final bool isSelected;
  final GestureTapCallback onTap;

  const HomeMenu({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(icon, height: 24, width: 24, color: isSelected ? appColors.primary : appColors.unSelected),
          CommonText(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: isSelected ? appColors.primary : appColors.unSelected),
          ),
        ],
      ),
    );
  }
}

class BottomBarItemData {
  final String label;
  final String icon;

  BottomBarItemData({required this.label, required this.icon});
}