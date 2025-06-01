import 'dart:developer';
import 'package:talent_mesh/common/app_enums.dart';
import 'package:talent_mesh/common/models/user_model.dart';
import 'package:talent_mesh/common/navigation/app_routes.dart';
import 'package:talent_mesh/common/navigation/routes.dart';
import 'package:talent_mesh/common/utils/extensions/string_extensions.dart';
import 'package:talent_mesh/common/utils/locator.dart';
import 'package:talent_mesh/common/utils/utils.dart';
import 'package:talent_mesh/pages/authentication/domain/authentication_state.dart';
import 'package:talent_mesh/pages/onboarding/models/candidate_profile_model.dart';
import 'package:talent_mesh/pages/onboarding/models/recruiter_profile_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  AuthenticationCubit() : super(const AuthenticationState.init());

  final FirebaseAuth _firebaseAuth = dependencyLocator<FirebaseAuth>();
  final FirebaseFirestore _firestore = dependencyLocator<FirebaseFirestore>();

  void checkAuthStatus() {
    Future.delayed((const Duration(seconds: 2)), () async {
      final currentUser = _firebaseAuth.currentUser;
      if (currentUser != null) {
        await _fetchUserDetails(id: currentUser.uid);
        final user = getUser();

        if (user.role?.userRole == Role.admin) {
          AppRoutes.appRouter.pushReplacement(Routes.dashboard);
          return;
        }

        /// if user has completed onboarding
        /// take them to dashboard
        /// otherwise onboarding
        if (user.onboardingStep == 3) {
          AppRoutes.appRouter.pushReplacement(Routes.dashboard);
        } else {
          if (user.role?.userRole == Role.candidate) {
            //disable back button
            AppRoutes.appRouter.pushReplacement(
              Routes.candidateOnboarding,
              extra: false,
            );
          } else if (user.role?.userRole == Role.recruiter) {
            AppRoutes.appRouter.pushReplacement(
              Routes.recruiterOnboarding,
              extra: false,
            );
          }
        }
      } else {
        AppRoutes.appRouter.pushReplacement(Routes.signin);
      }
    });
  }

  void resetState() {
    emit(const AuthenticationState.init());
  }

  void onChangeRole(Role role) {
    if (role != state.signupRole) {
      emit(state.copyWith(signupRole: role));
    }
  }

  bool _validateSignupDetails({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) {
    return _validateEmail(email) &&
        _validateName(name) &&
        _validatePassword(
          password: password,
          confirmPassword: confirmPassword,
        ) &&
        state.signupRole != null;
  }

  bool _validateName(String name) {
    if (name.isNotEmpty) {
      return true;
    }
    return false;
  }

  bool _validateEmail(String email) {
    if (email.isNotEmpty &&
        RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      return true;
    }
    return false;
  }

  bool _validatePassword({
    required String password,
    required String confirmPassword,
  }) {
    if (password.isNotEmpty &&
        confirmPassword.isNotEmpty &&
        password == confirmPassword) {
      return true;
    }
    return false;
  }

  //-----Sign Up using email & password with validations
  Future<void> onSignup({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    emit(state.copyWith(signupApiStatus: ApiStatus.loading));
    if (_validateSignupDetails(
      name: name,
      email: email,
      password: password,
      confirmPassword: confirmPassword,
    )) {
      try {
        await _signupWithEmailPassword(
          email: email,
          password: password,
          name: name,
        );
        emit(state.copyWith(signupApiStatus: ApiStatus.success));
        // AppRoutes.appRouter.pushReplacement(Routes.onboarding);
      } catch (error) {
        emit(state.copyWith(signupApiStatus: ApiStatus.failure));
        log('Error while creating new account- ${error.toString()}');
        Utils.showToast(message: error.toString());
      }
    } else {
      Utils.showToast(message: 'Please enter valid details');
    }
    emit(state.copyWith(signupApiStatus: ApiStatus.success));
  }

  Future<void> _signupWithEmailPassword({
    required String email,
    required String password,
    required String name,
    String? profileImage,
  }) async {
    await _firebaseAuth
        .createUserWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then(
      (value) async {
        await _postUserDetails(
          user: value.user,
          userModel: UserModel(
            uid: value.user?.uid ?? '',
            name: name,
            profileImage: profileImage ?? '',
            email: email,
            role: state.signupRole?.name ?? '',
            createdAt: DateTime.now(),
            lastLogin: DateTime.now(),
            onboardingStep: 0,
          ),
        ).then((value) async {
          await signIn(
            email: email,
            password: password,
            isFromSignup: true,
          );
        });
      },
    );
  }

  Future<void> _postUserDetails({
    required User? user,
    required UserModel userModel,
  }) async {
    if (user != null) {
      await userDetailDocumentRef(user.uid).set(
        userModel.toJson(),
      );
      if (userModel.role?.userRole == Role.candidate) {
        await _firestore.collection('candidates').doc(user.uid).set(
              CandidateProfileModel(
                userId: user.uid,
                createdAt: DateTime.now(),
              ).toJson(),
            );
        log('Created candidate profile!');
      } else if (userModel.role?.userRole == Role.recruiter) {
        await _firestore.collection('recruiters').doc(user.uid).set(
              RecruiterProfileModel(
                userId: user.uid,
                createdAt: DateTime.now(),
              ).toJson(),
            );
        log('Created recruiter profile!');
      }
      Utils.showToast(message: 'Account created successfully!');
    }
  }

  //-----Sign In with email & password with validations
  Future signIn({
    required String email,
    required String password,
    bool isFromSignup = false,
  }) async {
    if (_validateEmail(email) && password.isNotEmpty) {
      try {
        emit(state.copyWith(signinApiStatus: ApiStatus.loading));
        await _firebaseAuth
            .signInWithEmailAndPassword(
          email: email,
          password: password,
        )
            .then(
          (value) async {
            // await _fetchUserDetails(id: value.user?.uid);
            checkAuthStatus();
          },
        );
        // final user = dependencyLocator<UserModel>();
        // emit(state.copyWith(signinApiStatus: ApiStatus.success));
        // final user = getUser();
        // if (isFromSignup) {
        //   if (user.role?.userRole == Role.candidate) {
        //     AppRoutes.appRouter.pushReplacement(Routes.candidateOnboarding);
        //   } else if (user.role?.userRole == Role.recruiter) {
        //     AppRoutes.appRouter.pushReplacement(Routes.recruiterOnboarding);
        //   }
        // } else {
        //   AppRoutes.appRouter.pushReplacement(Routes.dashboard);
        // }
      } catch (error) {
        emit(state.copyWith(signinApiStatus: ApiStatus.failure));
        log('Error while Sign In- ${error.toString()}');
        Utils.showToast(message: error.toString());
      }
    } else {
      Utils.showToast(message: 'Please enter valid details!');
    }
  }

  Future<void> _fetchUserDetails({required String? id}) async {
    if (id != null) {
      final userDetails = await userDetailDocumentRef(id).get();
      Map<String, dynamic> jsonData =
          userDetails.data() as Map<String, dynamic>;
      dependencyLocator.unregister<UserModel>();
      dependencyLocator.registerSingleton<UserModel>(
        UserModel.fromJson(jsonData),
      );
    }
  }
}
