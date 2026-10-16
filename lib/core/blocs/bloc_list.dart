import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/single_child_widget.dart';

import '../repository/auth_repo.dart';
import '../repository/profile_repo.dart';

import 'auth/login/login_bloc.dart';
import 'auth/logout/logout_bloc.dart';
import 'auth/profile/profile_bloc.dart';
import 'auth/resend_sign_up_otp/resend_sign_up_otp_bloc.dart';
import 'auth/sign_up/sign_up_bloc.dart';
import 'auth/social_login/social_login_bloc.dart';
import 'auth/verify_otp/verify_otp_bloc.dart';
import 'profile/location/location_bloc.dart';
import 'profile/onboarding_masters/onboarding_masters_bloc.dart';

List<SingleChildWidget> blocProviders() {

  final AuthRepo authRepo = AuthRepo();
  final ProfileRepo profileRepo = ProfileRepo();

  return [

    /// Auth Blocs
    ...[
      BlocProvider(
        create: (context) => SignUpBloc(authRepo: authRepo),
      ),
      BlocProvider(
        create: (context) => SocialLoginBloc(authRepo: authRepo),
      ),
      BlocProvider(
        create: (context) => LoginBloc(authRepo: authRepo),
      ),
      BlocProvider(
        create: (context) => VerifyOTPBloc(authRepo: authRepo),
      ),
      BlocProvider(
        create: (context) => ResendSignUpOtpBloc(authRepo: authRepo),
      ),
      BlocProvider(
        create: (context) => ProfileBloc(authRepo: authRepo),
      ),
      BlocProvider(
        create: (context) => LogoutBloc(authRepo: authRepo),
      ),
    ],

    /// Profile Blocs
    ...[
      BlocProvider(
        create: (context) => LocationBloc(profileRepo: profileRepo),
      ),
      BlocProvider(
        create: (context) => OnboardingMastersBloc(profileRepo: profileRepo),
      ),
    ],
  ];
}