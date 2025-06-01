// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:talent_mesh/common/app_enums.dart';
import 'package:talent_mesh/pages/dashboard/models/job_model.dart';
import 'package:talent_mesh/pages/job_listing/model/job_filter_model.dart';
import 'package:equatable/equatable.dart';

class CandidateOnboardingState extends Equatable {
  final int currentPage;
  final DateTime? candidateDOB;
  final ExperienceLevel? candidateExperienceLevel;
  final List<Filter>? candidatePreferredDomains;
  final List<String>? candidatePreferredEmploymentTypes;
  final List<Skill?>? candidateSkills;
  final List<Location?>? preferredLocations;
  final SalaryRange? salaryExpectations;
  const CandidateOnboardingState({
    this.currentPage = 0,
    this.candidateDOB,
    this.candidateSkills,
    this.preferredLocations,
    this.salaryExpectations,
    this.candidatePreferredEmploymentTypes,
    this.candidateExperienceLevel,
    this.candidatePreferredDomains,
  });

  @override
  List<Object?> get props => [
        currentPage,
        candidateDOB,
        candidateExperienceLevel,
        candidatePreferredDomains,
        candidatePreferredEmploymentTypes,
        salaryExpectations,
        candidateSkills,
        preferredLocations,
      ];

  CandidateOnboardingState.init()
      : this(
          currentPage: 0,
          candidateDOB: DateTime(
            DateTime.now().year - 10,
            DateTime.now().month,
            DateTime.now().day,
          ),
          candidateExperienceLevel: null,
          candidatePreferredDomains: null,
          salaryExpectations: null,
          preferredLocations: null,
          candidateSkills: null,
          candidatePreferredEmploymentTypes: null,
        );

  CandidateOnboardingState copyWith({
    final Role? role,
    final int? currentPage,
    final DateTime? candidateDOB,
    final ExperienceLevel? candidateExperienceLevel,
    final List<Filter>? candidatePreferredDomains,
    final List<String>? candidatePreferredEmploymentTypes,
    final List<Location?>? preferredLocations,
    final List<Skill?>? candidateSkills,
    final SalaryRange? salaryExpectations,
  }) {
    return CandidateOnboardingState(
      currentPage: currentPage ?? this.currentPage,
      candidateDOB: candidateDOB ?? this.candidateDOB,
      candidatePreferredEmploymentTypes: candidatePreferredEmploymentTypes ??
          this.candidatePreferredEmploymentTypes,
      candidatePreferredDomains:
          candidatePreferredDomains ?? this.candidatePreferredDomains,
      candidateExperienceLevel:
          candidateExperienceLevel ?? this.candidateExperienceLevel,
      candidateSkills: candidateSkills ?? this.candidateSkills,
      preferredLocations: preferredLocations ?? this.preferredLocations,
      salaryExpectations: salaryExpectations ?? this.salaryExpectations,
    );
  }
}
