import 'dart:convert';

import 'package:talent_mesh/pages/job_listing/model/job_filter_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class JobModel {
  final String? recruiterId;
  final String? jobId;
  final String? companyName;
  final String? companyLogo;
  final String? jobRole;
  final String? description;
  final String? requirements;
  final String? responsibilities;
  final ExperienceLevel? experienceLevel;
  final List? requiredSkills;
  final Location? location;
  final bool? isRemote;
  final String? employmentType;
  final SalaryRange? salaryRange;
  final DateTime? applicationDeadline;
  final DateTime? postedAt;
  final DateTime? updatedAt;
  final String? status;
  final int? applicationsCount;
  JobModel({
    this.jobId,
    this.recruiterId,
    this.companyName,
    this.jobRole,
    this.description,
    this.requirements,
    this.responsibilities,
    this.experienceLevel,
    this.requiredSkills,
    this.location,
    this.isRemote,
    this.employmentType,
    this.salaryRange,
    this.applicationDeadline,
    this.postedAt,
    this.updatedAt,
    this.status,
    this.applicationsCount,
    this.companyLogo,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'recruiterId': recruiterId,
      'jobId': jobId,
      'companyName': companyName,
      'jobRole': jobRole,
      'description': description,
      'requirements': requirements,
      'responsibilities': responsibilities,
      'experienceLevel': experienceLevel?.toMap(),
      'requiredSkills': requiredSkills,
      'location': location?.toMap(),
      'isRemote': isRemote,
      'employmentType': employmentType,
      'salaryRange': salaryRange?.toMap(),
      'applicationDeadline': applicationDeadline,
      'postedAt': postedAt,
      'updatedAt': updatedAt,
      'status': status,
      'applicationsCount': applicationsCount,
      'companyLogo': companyLogo,
    };
  }

  factory JobModel.fromMap(Map<String, dynamic> map) {
    return JobModel(
      recruiterId: map['recruiterId'] as String?,
      jobId: map['jobId'] as String?,
      companyName: map['companyName'] as String?,
      jobRole: map['jobRole'] as String?,
      description: map['description'] as String?,
      requirements: map['requirements'] as String?,
      responsibilities: map['responsibilities'] as String?,
      experienceLevel: map['experienceLevel'] != null
          ? ExperienceLevel.fromMap(map['experienceLevel'])
          : null,
      requiredSkills: map['requiredSkills'] != null
          ? List.from((map['requiredSkills'] as List))
          : null,
      location:
          map['location'] != null ? Location.fromMap(map['location']) : null,
      isRemote: map['isRemote'] as bool?,
      employmentType: map['employmentType'] as String?,
      salaryRange: map['salaryRange'] != null
          ? SalaryRange.fromMap(map['salaryRange'] as Map<String, dynamic>)
          : null,
      applicationDeadline: map['applicationDeadline'] != null
          ? (map['applicationDeadline'] as Timestamp).toDate()
          : null,
      postedAt: map['postedAt'] != null
          ? (map['postedAt'] as Timestamp).toDate()
          : null,
      updatedAt: map['updatedAt'] != null
          ? (map['updatedAt'] as Timestamp).toDate()
          : null,
      status: map['status'] as String?,
      applicationsCount: map['applicationsCount'] as int?,
      companyLogo: map['companyLogo'] as String?,
    );
  }

  String toJson() => json.encode(toMap());

  factory JobModel.fromJson(String source) =>
      JobModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

class SalaryRange {
  final String? id;
  final num? min;
  final num? max;
  final bool? isVisible;
  final String? salaryType;
  SalaryRange({
    this.id,
    this.min,
    this.max,
    this.isVisible,
    this.salaryType,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'min': min,
      'max': max,
      'isVisible': isVisible,
      'salaryType': salaryType,
    };
  }

  factory SalaryRange.fromMap(Map<String, dynamic> map) {
    return SalaryRange(
      id: map['id'] as String?,
      salaryType: map['salaryType'] as String?,
      min: map['min'] as num?,
      max: map['max'] as num?,
      isVisible: map['isVisible'] as bool?,
    );
  }

  String toJson() => json.encode(toMap());

  factory SalaryRange.fromJson(String source) =>
      SalaryRange.fromMap(json.decode(source) as Map<String, dynamic>);
}
