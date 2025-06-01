import 'package:talent_mesh/pages/dashboard/models/job_model.dart';
import 'package:talent_mesh/pages/job_listing/model/job_filter_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart' hide Filter;

class CandidateProfileModel {
  final String? userId;
  final String? fullName;
  final String? currentDesignation;
  final String? summary;
  final String? phoneNumber;
  final DateTime? dateOfBirth;
  final List<Filter>? preferredDomains;
  final List<Skill?>? skills;
  final List<Location?>? preferredLocations;
  final SalaryRange? expectedSalary;
  final List<Experience>? experiences;
  final List<Education>? education;
  final ExperienceLevel? experienceLevel;
  final String? resumeURL;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool? isProfileComplete;
  final bool? isProfilePublic;

  CandidateProfileModel({
    this.userId,
    this.fullName,
    this.currentDesignation,
    this.summary,
    this.phoneNumber,
    this.dateOfBirth,
    this.experienceLevel,
    this.preferredDomains,
    this.skills,
    this.preferredLocations,
    this.expectedSalary,
    this.experiences,
    this.education,
    this.resumeURL,
    this.createdAt,
    this.updatedAt,
    this.isProfileComplete,
    this.isProfilePublic,
  });

  factory CandidateProfileModel.fromJson(Map<String, dynamic> json) {
    return CandidateProfileModel(
      userId: json['userId'] as String?,
      fullName: json['fullName'] as String?,
      currentDesignation: json['currentDesignation'] as String?,
      summary: json['summary'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      dateOfBirth: json['dateOfBirth'] != null
          ? (json['dateOfBirth'] as Timestamp).toDate()
          : null,
      experienceLevel: json['experienceLevel'] != null
          ? ExperienceLevel.fromMap(json['experienceLevel'])
          : null,
      preferredDomains: (json['domains'] as List?)
              ?.map((domain) => Filter.fromMap(domain))
              .toList() ??
          [],
      skills: json['skills'] != null
          ? (json['experiences'] as List).map((e) => Skill.fromMap(e)).toList()
          : null,
      preferredLocations: json['preferredLocations'] != null
          ? (json['experiences'] as List)
              .map((e) => Location.fromMap(e))
              .toList()
          : null,
      expectedSalary: json['expectedSalary'] != null
          ? SalaryRange.fromJson(json['expectedSalary'])
          : null,
      experiences: json['experiences'] != null
          ? (json['experiences'] as List)
              .map((e) => Experience.fromJson(e))
              .toList()
          : null,
      education: json['education'] != null
          ? (json['education'] as List)
              .map((e) => Education.fromJson(e))
              .toList()
          : null,
      resumeURL: json['resumeURL'] as String?,
      createdAt: json['createdAt'] != null
          ? (json['createdAt'] as Timestamp).toDate()
          : null,
      updatedAt: json['updatedAt'] != null
          ? (json['updatedAt'] as Timestamp).toDate()
          : null,
      isProfileComplete: json['isProfileComplete'] as bool?,
      isProfilePublic: json['isProfilePublic'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['userId'] = userId;
    data['fullName'] = fullName;
    data['currentDesignation'] = currentDesignation;
    data['summary'] = summary;
    data['phoneNumber'] = phoneNumber;
    data['dateOfBirth'] = dateOfBirth;
    data['experienceLevel'] = experienceLevel?.toMap();
    data['preferredDomains'] = preferredDomains;
    data['skills'] = skills?.map((e) => e?.toMap()).toList();
    data['preferredLocations'] =
        preferredLocations?.map((e) => e?.toMap()).toList();
    data['expectedSalary'] = expectedSalary?.toMap();
    data['experiences'] = experiences?.map((e) => e.toJson()).toList();
    data['education'] = education?.map((e) => e.toJson()).toList();
    data['resumeURL'] = resumeURL;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['isProfileComplete'] = isProfileComplete;
    data['isProfilePublic'] = isProfilePublic;
    return data;
  }
}

class Experience {
  final String? id;
  final String? title;
  final String? company;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool? current;
  final String? description;

  Experience({
    this.id,
    this.title,
    this.company,
    this.startDate,
    this.endDate,
    this.current,
    this.description,
  });

  factory Experience.fromJson(Map<String, dynamic> json) {
    return Experience(
      id: json['id'] as String?,
      title: json['title'] as String?,
      company: json['company'] as String?,
      startDate: json['startDate'] != null
          ? (json['startDate'] as Timestamp).toDate()
          : null,
      endDate: json['endDate'] != null
          ? (json['endDate'] as Timestamp).toDate()
          : null,
      current: json['current'] as bool?,
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['title'] = title;
    data['company'] = company;
    data['startDate'] = startDate;
    data['endDate'] = endDate;
    data['current'] = current;
    data['description'] = description;
    return data;
  }
}

class Education {
  final String? id;
  final String? institution;
  final String? degree;
  final String? fieldOfStudy;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool? current;

  Education({
    this.id,
    this.institution,
    this.degree,
    this.fieldOfStudy,
    this.startDate,
    this.endDate,
    this.current,
  });

  factory Education.fromJson(Map<String, dynamic> json) {
    return Education(
      id: json['id'] as String?,
      institution: json['institution'] as String?,
      degree: json['degree'] as String?,
      fieldOfStudy: json['fieldOfStudy'] as String?,
      startDate: json['startDate'] != null
          ? (json['startDate'] as Timestamp).toDate()
          : null,
      endDate: json['endDate'] != null
          ? (json['endDate'] as Timestamp).toDate()
          : null,
      current: json['current'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['id'] = id;
    data['institution'] = institution;
    data['degree'] = degree;
    data['fieldOfStudy'] = fieldOfStudy;
    data['startDate'] = startDate;
    data['endDate'] = endDate;
    data['current'] = current;
    return data;
  }
}
