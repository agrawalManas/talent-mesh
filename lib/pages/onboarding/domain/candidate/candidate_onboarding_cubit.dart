import 'dart:developer';
import 'package:talent_mesh/common/utils/locator.dart';
import 'package:talent_mesh/common/utils/utils.dart';
import 'package:talent_mesh/pages/dashboard/models/job_model.dart';
import 'package:talent_mesh/pages/job_listing/model/job_filter_model.dart'
    as jobFilter;
import 'package:talent_mesh/pages/onboarding/domain/candidate/candidate_onboarding_state.dart';
import 'package:talent_mesh/pages/onboarding/models/candidate_profile_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CandidateOnboardingCubit extends Cubit<CandidateOnboardingState> {
  CandidateOnboardingCubit() : super(CandidateOnboardingState.init());

  final _firestore = dependencyLocator<FirebaseFirestore>();

  //-------step-1-controllers
  final TextEditingController _nameController = TextEditingController(
    text: getUser().name ?? '',
  );
  final TextEditingController _designationController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();

  //--------step-2-controllers
  final TextEditingController _summaryController = TextEditingController();
  final List<jobFilter.Filter> _candidatePreferredDomains = [];

  //---------step-3-controllers
  final TextEditingController _minSalaryController = TextEditingController();
  final TextEditingController _maxSalaryController = TextEditingController();
  final List<String> _candidatePreferredEmploymentTypes = [];

  //-------getters
  TextEditingController get nameController => _nameController;
  TextEditingController get designationController => _designationController;
  TextEditingController get numberController => _numberController;
  TextEditingController get summaryController => _summaryController;
  TextEditingController get minSalaryController => _minSalaryController;
  TextEditingController get maxSalaryController => _maxSalaryController;

  void onChangeDOB(DateTime? date) {
    emit(state.copyWith(candidateDOB: date));
  }

  void onSelectCandidateExperienceLevel(jobFilter.ExperienceLevel? value) {
    log('experience level- $value');
    emit(state.copyWith(candidateExperienceLevel: value));
  }

  void onSelectCandidatePreferredDomains(List<jobFilter.Filter> value) {
    for (var element in value) {
      _candidatePreferredDomains.add(element);
    }
    emit(state.copyWith(candidatePreferredDomains: _candidatePreferredDomains));
    log('preferred domains- $_candidatePreferredDomains');
  }

  void onSelectCandidatePreferredEmploymentType(List<dynamic> value) {
    for (var element in value) {
      _candidatePreferredEmploymentTypes.add(element.toString());
    }
    emit(state.copyWith(
      candidatePreferredEmploymentTypes: _candidatePreferredEmploymentTypes,
    ));
    log('preferred employment types- $_candidatePreferredEmploymentTypes');
  }

  void onSelectCandidatePreferredLocations(
      List<jobFilter.Location?> locations) {
    emit(state.copyWith(preferredLocations: locations));
  }

  void onSelectCandidateSkills(jobFilter.Skill? skill) {
    if ((state.candidateSkills ?? []).contains(skill)) {
      Utils.showToast(message: 'Skill already added, try another one!');
      return;
    }
    final updatedSkills =
        List<jobFilter.Skill?>.from(state.candidateSkills ?? [])..add(skill);
    emit(state.copyWith(candidateSkills: updatedSkills));
  }

  void onRemoveSelectedSkill(int index) {
    final updatedSkills =
        List<jobFilter.Skill>.from(state.candidateSkills ?? []);
    updatedSkills.removeAt(index);
    emit(state.copyWith(candidateSkills: updatedSkills));
  }

  Future<bool> continueOnboardingStep1() async {
    if (_nameController.text.isNotEmpty &&
        _designationController.text.isNotEmpty &&
        _numberController.text.isNotEmpty) {
      await _updateOnboardingDetails(
        data: CandidateProfileModel(
          fullName: _nameController.text.trim(),
          phoneNumber: _numberController.text.trim(),
          currentDesignation: _designationController.text.trim(),
          updatedAt: DateTime.now(),
        ).toJson(),
        step: 1,
      );
      return true;
    }
    Utils.showToast(message: 'Please enter valid details!');
    return false;
  }

  Future<bool> continueOnboardingStep2() async {
    if (_summaryController.text.isNotEmpty &&
        state.candidateExperienceLevel != null &&
        (state.candidatePreferredDomains ?? []).isNotEmpty) {
      await _updateOnboardingDetails(
        data: CandidateProfileModel(
          experienceLevel: state.candidateExperienceLevel,
          preferredDomains: state.candidatePreferredDomains,
          summary: _summaryController.text.trim(),
          updatedAt: DateTime.now(),
        ).toJson(),
        step: 2,
      );
      return true;
    }
    Utils.showToast(message: 'Please enter/select valid details!');
    return false;
  }

  Future<bool> continueOnboardingStep3() async {
    if (_minSalaryController.text.isNotEmpty &&
        _maxSalaryController.text.isNotEmpty &&
        (state.candidateSkills ?? []).isNotEmpty &&
        (state.candidatePreferredEmploymentTypes ?? []).isNotEmpty &&
        (state.preferredLocations ?? []).isNotEmpty) {
      await _updateOnboardingDetails(
        data: CandidateProfileModel(
          experienceLevel: state.candidateExperienceLevel,
          preferredLocations: state.preferredLocations,
          skills: state.candidateSkills,
          expectedSalary: SalaryRange(
            min: num.parse(_minSalaryController.text.trim()),
            max: num.parse(_maxSalaryController.text.trim()),
          ),
          updatedAt: DateTime.now(),
        ).toJson(),
        step: 3,
      );
      return true;
    }
    Utils.showToast(message: 'Please enter/select valid details!');
    return false;
  }

  /// update the candidate profile collection
  /// corresponds to his profile
  Future<void> _updateOnboardingDetails({
    required Map<String, dynamic> data,
    required int step,
  }) async {
    final userRef = userDetailDocumentRef(getUser().uid ?? '');
    await _firestore.collection('candidates').doc(getUser().uid).update(data);
    await userRef.update({
      'onboardingStep': step,
    });
  }
}
