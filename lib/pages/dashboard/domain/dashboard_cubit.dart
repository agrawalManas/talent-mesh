import 'dart:developer';
import 'package:talent_mesh/common/app_enums.dart';
import 'package:talent_mesh/common/models/user_model.dart';
import 'package:talent_mesh/common/navigation/app_routes.dart';
import 'package:talent_mesh/common/navigation/routes.dart';
import 'package:talent_mesh/common/utils/extensions/string_extensions.dart';
import 'package:talent_mesh/common/utils/locator.dart';
import 'package:talent_mesh/common/utils/utils.dart';
import 'package:talent_mesh/pages/dashboard/domain/dashboard_state.dart';
import 'package:talent_mesh/pages/dashboard/models/application_model.dart';
import 'package:talent_mesh/pages/dashboard/models/job_model.dart';
import 'package:talent_mesh/pages/job_listing/model/job_filter_model.dart'
    as filter_model;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit() : super(const DashboardState());

  final FirebaseFirestore _firestore = dependencyLocator<FirebaseFirestore>();
  final FirebaseAuth _auth = dependencyLocator<FirebaseAuth>();
  final _user = getUser();

  List<String> _filters = [];

  void resetState() {
    emit(const DashboardState());
  }

  void setFilters(List<String> filters) {
    _filters = filters;
  }

  Future<void> logoutUser() async {
    try {
      await _auth.signOut();
      dependencyLocator.unregister<UserModel>();
      dependencyLocator.registerSingleton<UserModel>(
        UserModel(
          role: 'none',
        ),
      );
      if (dependencyLocator.isRegistered<List<ApplicationModel>>()) {
        dependencyLocator.unregister<List<ApplicationModel>>();
      }
      AppRoutes.appRouter.pushReplacement(Routes.signin);
    } catch (error) {
      log('Error while signing out- ${error.toString()}');
      Utils.showToast(message: 'Unable to logout at the moment!');
    }
  }

  Future<void> getJobFilters() async {
    if (!dependencyLocator.isRegistered<filter_model.JobFilterModel>()) {
      emit(state.copyWith(jobFiltersApiStatus: ApiStatus.loading));
      try {
        final result = await _firestore.collection('jobFilters').get();
        Map<String, dynamic> jsonData =
            result.docs.firstOrNull?.data() as Map<String, dynamic>;
        final filters = filter_model.JobFilterModel.fromMap(jsonData);
        dependencyLocator.registerSingleton<filter_model.JobFilterModel>(
          filter_model.JobFilterModel.fromMap(jsonData),
        );
        emit(
          state.copyWith(
            jobFiltersApiStatus: ApiStatus.success,
            filters: filters,
          ),
        );
      } catch (error) {
        emit(state.copyWith(jobFiltersApiStatus: ApiStatus.failure));
        log('Error while fetching job filters- ${error.toString()}');
      }
    }
  }

  /// get recruiter posted jobs to be shown on dashboard(recruiter)
  Future<void> getJobs() async {
    if (_user.role?.userRole == Role.recruiter) {
      emit(state.copyWith(getJobsApiStatus: ApiStatus.loading));
      final List<JobModel> jobs = [];
      int activeJobs = 0;
      try {
        QuerySnapshot<Map<String, dynamic>>? result;
        result = await _firestore
            .collection('jobs')
            .where(
              'recruiterId',
              isEqualTo: _user.uid,
            )
            .get();

        for (var job in result.docs) {
          if (job.exists) {
            Map<String, dynamic> jsonData = job.data();
            jobs.add(JobModel.fromMap(jsonData));
          }
        }
        activeJobs = jobs
            .where(
              (job) => job.status == JobStatus.active.name,
            )
            .length;
        emit(
          state.copyWith(
            getJobsApiStatus: ApiStatus.success,
            jobs: jobs,
            activeJobs: activeJobs,
          ),
        );
      } catch (error) {
        log('Error while fetching jobs- ${error.toString()}');
        Utils.showToast(
            message: "Could't get the jobs at the moment try again");
        emit(state.copyWith(getJobsApiStatus: ApiStatus.failure));
      }
    }
  }

  /// get candidate applied jobs to be shown on dashboard(candidate)
  Future<void> getAppliedJobs() async {
    if (_user.role?.userRole == Role.candidate) {
      emit(state.copyWith(getAppliedJobsApiStatus: ApiStatus.loading));
      final List<ApplicationModel> appliedJobs = [];
      try {
        QuerySnapshot<Map<String, dynamic>>? result;
        result = await _firestore
            .collection('jobApplications')
            .where(
              'candidateId',
              isEqualTo: _user.uid,
            )
            .get();

        for (var appliedJob in result.docs) {
          if (appliedJob.exists) {
            Map<String, dynamic> jsonData = appliedJob.data();
            appliedJobs.add(ApplicationModel.fromMap(jsonData));
          }
        }
        if (dependencyLocator.isRegistered<List<ApplicationModel>>()) {
          dependencyLocator.unregister<List<ApplicationModel>>();
        }
        dependencyLocator.registerSingleton<List<ApplicationModel>>(
          appliedJobs,
        );
        emit(
          state.copyWith(
            getAppliedJobsApiStatus: ApiStatus.success,
            appliedJobs: appliedJobs,
          ),
        );
      } catch (error) {
        log('Error while fetching applied jobs- ${error.toString()}');
        Utils.showToast(
            message: "Could't get the jobs at the moment try again");
        emit(state.copyWith(getAppliedJobsApiStatus: ApiStatus.failure));
      }
    }
  }

  ///change the job status, only for recruiters
  Future<void> changeJobStatus(String id, String status) async {
    if (_user.role?.userRole == Role.recruiter) {
      emit(state.copyWith(
        changeJobStatusApiStatus: ApiStatus.loading,
      ));
      try {
        await _firestore.collection('jobs').doc(id).update({
          'status': status,
        });
        emit(
          state.copyWith(
            changeJobStatusApiStatus: ApiStatus.success,
          ),
        );
        getJobs();
      } catch (error) {
        emit(state.copyWith(changeJobStatusApiStatus: ApiStatus.failure));
        log('Error while changing job status- ${error.toString()}');
        Utils.showToast(message: 'Unable to change the job status!');
      }
    }
  }

  filter_model.ExperienceLevel setExperience({
    required String position,
    required String yearsFrom,
    String? yearsTo,
  }) {
    return filter_model.ExperienceLevel(
      createdAt: DateTime.now(),
      id: Utils.getUUID(),
      name: position,
      yearsFrom: double.parse(yearsFrom.replaceAll('years', '')),
      yearsTo: double.parse((yearsTo ?? '0').replaceAll('years', '')),
    );
  }

  SalaryRange? setSalaryRange({required String min, required String max}) {
    final minSalary = double.parse(min.replaceAll(',', ''));
    final maxSalary = double.parse(max.replaceAll(',', ''));
    if (minSalary >= maxSalary) {
      Utils.showToast(message: 'Min salary should be less tha Max salary');
      return null;
    }
    return SalaryRange(
      id: Utils.getUUID(),
      isVisible: true,
      max: maxSalary,
      min: minSalary,
      salaryType: 'LPA',
    );
  }

  /// update existing filters, only for admins
  Future<void> _updateFiltersInDB({
    required filter_model.JobFilterModel data,
  }) async {
    await _firestore.collection('jobFilters').doc(getFilters().id).update(
          data.toMap(),
        );
  }

  Future<void> updateFilters({
    required JobFilters filterType,
    String? text,
    bool? remote,
    SalaryRange? salary,
    filter_model.ExperienceLevel? experienceLevel,
  }) async {
    if (_user.role?.userRole == Role.admin) {
      try {
        emit(state.copyWith(addFilterApiStatus: ApiStatus.loading));
        filter_model.JobFilterModel existingFilters = getFilters();
        switch (filterType) {
          case JobFilters.locations:
            existingFilters = existingFilters.copyWith(
              locations: [
                ...List.from(existingFilters.locations ?? []),
                ...List.generate(_filters.length, (index) {
                  return filter_model.Location(
                    id: Utils.getUUID(),
                    country: 'India',
                    createdAt: DateTime.now(),
                    name: _filters[index].trim(),
                  );
                }),
              ],
            );
          case JobFilters.domains:
            existingFilters = existingFilters.copyWith(
              domains: [
                ...existingFilters.domains ?? [],
                ...List.generate(_filters.length, (index) {
                  return filter_model.Filter(
                    id: Utils.getUUID(),
                    createdAt: DateTime.now(),
                    name: _filters[index].trim(),
                  );
                }),
              ],
            );
          case JobFilters.companySize:
            existingFilters = existingFilters.copyWith(
              companySize: [
                ...existingFilters.companySize ?? [],
                ...List.generate(_filters.length, (index) {
                  return filter_model.Filter(
                    id: Utils.getUUID(),
                    createdAt: DateTime.now(),
                    name: _filters[index].trim(),
                  );
                }),
              ],
            );
          case JobFilters.employmentType:
            existingFilters = existingFilters.copyWith(
              employmentType: [
                ...existingFilters.employmentType ?? [],
                ...List.generate(_filters.length, (index) {
                  return filter_model.Filter(
                    id: Utils.getUUID(),
                    createdAt: DateTime.now(),
                    name: _filters[index].trim(),
                  );
                }),
              ],
            );
          case JobFilters.remote:
            existingFilters = existingFilters.copyWith(
              remote: remote,
            );
          case JobFilters.skills:
            existingFilters = existingFilters.copyWith(
              skills: [
                ...List.from(existingFilters.skills ?? []),
                ...List.generate(_filters.length, (index) {
                  return filter_model.Skill(
                    id: Utils.getUUID(),
                    category: null,
                    createdAt: DateTime.now(),
                    name: _filters[index].trim(),
                  );
                })
              ],
            );
          case JobFilters.experienceLevels:
            existingFilters = existingFilters.copyWith(
              experienceLevels: [
                ...List.from(existingFilters.experienceLevels ?? []),
                experienceLevel,
              ],
            );
          case JobFilters.salaryRange:
            if (salary == null) {
              emit(state.copyWith(addFilterApiStatus: ApiStatus.init));
              return;
            }
            existingFilters = existingFilters.copyWith(
              salaryRange: [
                ...List.from(existingFilters.salaryRange ?? []),
                salary,
              ],
            );
          case JobFilters.none:
            return;
        }
        final filterData = existingFilters.copyWith(
          lastUpdatedAt: DateTime.now(),
          lastUpdatedBy: _user.name,
        );
        await _updateFiltersInDB(data: filterData);
        dependencyLocator.unregister<filter_model.JobFilterModel>();
        dependencyLocator
            .registerSingleton<filter_model.JobFilterModel>(filterData);
        emit(state.copyWith(addFilterApiStatus: ApiStatus.success));
        Utils.showToast(
          message: 'Successfully added ${filterType.name.toPascalCase()}',
        );
        AppRoutes.appRouter.pop();
      } catch (error) {
        emit(state.copyWith(addFilterApiStatus: ApiStatus.failure));
        log('Error while adding filter- ${error.toString()}');
        Utils.showToast(message: 'Unable to add this filter!');
      }
    }
  }
}
