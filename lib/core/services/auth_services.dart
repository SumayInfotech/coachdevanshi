import 'dart:io';
import 'dart:async';

import 'package:coach_devanshi_doshi/core/services/preference_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../main.dart';

class AuthServices {

  static final GoogleSignIn googleSignIn = GoogleSignIn.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  /// DEFINE GOOGLE SCOPES
  static final List<String> scopes = <String>[
    'email', 'profile',
  ];

  static const androidServerClientId = "43351019791-65j5r7r3ali9g4ib8tefpfnjbgqfohvc.apps.googleusercontent.com";
  static const iosServerClientId = "43351019791-hq2tqguma1qp6jmsssuoajtk81f5s90t.apps.googleusercontent.com";

  /// DEFINE SERVER CLIENT IDS IF NECESSARY
  static String getServerClientId() {
    if(Platform.isIOS){
      return iosServerClientId;
    } else {
      return androidServerClientId;
    }
  }

  /// DEFINE INITIALIZATION OF GOOGLE FOR ANDROID
  static Future<void> initialize() async {
    try{
      final serverClientId = getServerClientId();
      appPrint("serverId : $serverClientId");
      unawaited(
        googleSignIn.initialize(
          serverClientId: serverClientId,
        ),
      );
      await googleSignIn.initialize();
    } catch (e) {
      appPrint("Google initialize Exception : $e");
    }
  }

  /// DEFINE SIGN METHOD FOR GOOGLE
  static Future<AuthUserData?> signInWithGoogle() async {
    try {
      /// Step 1: Google
      final GoogleSignInAccount googleUser = await googleSignIn.authenticate(scopeHint: scopes);

      /// Step 2: Google authentication tokens
      // final GoogleSignInClientAuthorization authorization = await googleUser.authorizationClient.authorizeScopes(scopes);

      /// Step 3: Build Firebase credential
      final OAuthCredential credential = GoogleAuthProvider.credential(
        // accessToken: authorization.accessToken,
        idToken: googleUser.authentication.idToken,
      );

      /// Step 4: Sign in with Firebase
      final UserCredential userCredential = await _auth.signInWithCredential(credential);

      final User? user = userCredential.user;

      if (user == null) return null;

      /// Step 5: Return structured user data
      final authToken = await user.getIdTokenResult(true);
      appLog("Google Auth Token ==>\n ${authToken.token}");
      AppPreferences.setString(AppPreferences.accessToken, authToken.token ?? "");

      final String fullName = (user.displayName?.isNotEmpty ?? false) ? user.displayName! : (user.email?.split("@").first ?? "");
      final List<String> nameParts = fullName.trim().split(RegExp(r"\s+"));
      final String firstName = nameParts.isNotEmpty ? nameParts.first : "Unknown";
      final String lastName = nameParts.length > 1 ? nameParts.sublist(1).join(" ") : "User";

      AuthUserData userData = AuthUserData(
        uuid: user.uid,
        name: fullName,
        firstName: firstName,
        lastName: lastName,
        email: user.email,
        photo: user.photoURL,
        isApple: Platform.isIOS.toString(),
        socialId: googleUser.id,
      );

      return userData;
    } on SocketException catch (e) {
      appLog("No Internet Connection: $e");
      return null;
    } catch (e) {
      await signOut();
      appLog("Google Sign-In Error: $e");
      return null;
    }
  }

  Future<String?> getAuthToken() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;
    return await user.getIdToken(true);
  }

  /// DEFINE SIGN METHOD FOR APPLE
  static Future<AuthUserData?> signInWithApple() async {
    try {

      /// Step 1: Request Apple credential
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      if (appleCredential.identityToken == null) {
        appLog("❌ identityToken is NULL → Apple config issue");
        return null;
      }


      /// Step 2: Build OAuth credential for Firebase
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      /// Step 3: Sign in with Firebase
      final UserCredential userCredential = await _auth.signInWithCredential(oauthCredential);

      final User? user = userCredential.user;
      if (user == null) {
        return null;
      }

      /// Step 4: Construct final return data
      final authToken = await user.getIdTokenResult(true);
      appLog("Apple Auth Token ==>\n ${authToken.token}");
      AppPreferences.setString(AppPreferences.accessToken, authToken.token ?? "");

      final fullName = user.displayName ?? appleCredential.givenName ?? "Unknown";
      // final String fullName = (user.displayName?.isNotEmpty ?? false) ? user.displayName! : (user.email?.split("@").first ?? "");
      final List<String> nameParts = fullName.trim().split(RegExp(r"\s+"));
      final String firstName = nameParts.isNotEmpty ? nameParts.first : "Unknown";
      final String lastName = nameParts.length > 1 ? nameParts.sublist(1).join(" ") : "User";

      AuthUserData userData = AuthUserData(
        uuid: user.uid,
        name: fullName,
        firstName: firstName,
        lastName: lastName,
        email: user.email,
        photo: user.photoURL,
        isApple: Platform.isIOS.toString(),
        socialId: appleCredential.userIdentifier,
      );

      return userData;
    } on SocketException catch (e) {
      appLog("No Internet Connection: $e");
      return null;
    } catch (e, st) {
      appLog("❌ Apple Sign-In Error: $e");
      appLog("📌 StackTrace: $st");
      await signOut();
      return null;
    }
  }

  /// DEFINE SIGN OUT METHOD FOR GOOGLE AND APPLE
  static Future<void> signOut() async {
    try {
      await googleSignIn.signOut();
      await _auth.signOut();
    } catch (e) {
      appLog("Logout Error: $e");
    }
  }
}

class AuthUserData {
  final String uuid;
  final String name;
  final String firstName;
  final String lastName;
  final String? email;
  final String? photo;
  final String isApple;
  final String? socialId;

  new({
    required this.uuid,
    required this.name,
    required this.firstName,
    required this.lastName,
    required this.isApple,
    this.email, this.photo,
    this.socialId
  });
}