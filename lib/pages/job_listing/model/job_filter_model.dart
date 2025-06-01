import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:talent_mesh/pages/dashboard/models/job_model.dart';

class JobFilterModel {
  final List<Filter?>? jobRoles;
  final List<Filter>? domains;
  final List<dynamic>? industries;
  final List<Filter>? companySize;
  final List<ExperienceLevel?>? experienceLevels;
  final List<Skill?>? skills;
  final List<Location?>? locations;
  final String? lastUpdatedBy;
  final DateTime? lastUpdatedAt;
  final List<SalaryRange?>? salaryRange;
  final List<Filter>? employmentType;
  final bool? remote;
  final String? id;

  JobFilterModel({
    this.jobRoles,
    this.domains,
    this.industries,
    this.companySize,
    this.experienceLevels,
    this.skills,
    this.locations,
    this.lastUpdatedBy,
    this.lastUpdatedAt,
    this.salaryRange,
    this.employmentType,
    this.remote,
    this.id,
  });

  factory JobFilterModel.fromMap(Map<String, dynamic> map) {
    return JobFilterModel(
      domains: (map['domains'] as List?)
              ?.map((domain) => Filter.fromMap(domain))
              .toList() ??
          [],
      employmentType: (map['employmentType'] as List?)
              ?.map((type) => Filter.fromMap(type))
              .toList() ??
          [],
      companySize: (map['companySize'] as List?)
              ?.map((size) => Filter.fromMap(size))
              .toList() ??
          [],
      jobRoles: (map['jobRoles'] as List?)
              ?.map((role) => Filter.fromMap(role))
              .toList() ??
          [],
      industries: map['industries'] as List<dynamic>?,
      experienceLevels: (map['experienceLevels'] as List?)
              ?.map((level) => ExperienceLevel.fromMap(level))
              .toList() ??
          [],
      skills: (map['skills'] as List?)
              ?.map((skill) => Skill.fromMap(skill))
              .toList() ??
          [],
      locations: (map['locations'] as List?)
              ?.map((location) => Location.fromMap(location))
              .toList() ??
          [],
      lastUpdatedBy: map['lastUpdatedBy'] as String?,
      salaryRange: (map['salaryRange'] as List?)
              ?.map((salary) => SalaryRange.fromMap(salary))
              .toList() ??
          [],
      lastUpdatedAt: map['lastUpdatedAt'] != null
          ? (map['lastUpdatedAt'] as Timestamp).toDate()
          : null,
      remote: map['remote'] as bool?,
      id: map['id'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'domains': domains?.map((domain) => domain.toMap()).toList(),
      'jobRoles': jobRoles?.map((role) => role?.toMap()).toList(),
      'industries': industries,
      'companySize': companySize?.map((size) => size.toMap()).toList(),
      'experienceLevels':
          experienceLevels?.map((level) => level?.toMap()).toList(),
      'skills': skills?.map((skill) => skill?.toMap()).toList(),
      'employmentType': employmentType?.map((type) => type.toMap()).toList(),
      'locations': locations?.map((location) => location?.toMap()).toList(),
      'lastUpdatedBy': lastUpdatedBy,
      'lastUpdatedAt': lastUpdatedAt,
      'salaryRange': salaryRange?.map((salary) => salary?.toMap()).toList(),
      'remote': remote,
      'id': id,
    };
  }

  JobFilterModel copyWith({
    List<Filter?>? jobRoles,
    List<Filter>? domains,
    List<ExperienceLevel?>? experienceLevels,
    List<Filter>? companySize,
    List<dynamic>? industries,
    List<Skill?>? skills,
    List<Location?>? locations,
    String? lastUpdatedBy,
    DateTime? lastUpdatedAt,
    List<SalaryRange?>? salaryRange,
    List<Filter>? employmentType,
    bool? remote,
    String? id,
  }) {
    return JobFilterModel(
      domains: domains ?? this.domains,
      jobRoles: jobRoles ?? this.jobRoles,
      experienceLevels: experienceLevels ?? this.experienceLevels,
      skills: skills ?? this.skills,
      locations: locations ?? this.locations,
      lastUpdatedBy: lastUpdatedBy ?? this.lastUpdatedBy,
      lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
      salaryRange: salaryRange ?? this.salaryRange,
      employmentType: employmentType ?? this.employmentType,
      remote: remote ?? this.remote,
      companySize: companySize ?? companySize,
      industries: industries ?? industries,
      id: id ?? this.id,
    );
  }
}

class Filter {
  final String? id;
  final String? name;
  final DateTime? createdAt;

  Filter({
    this.id,
    this.name,
    this.createdAt,
  });

  factory Filter.fromMap(Map<String, dynamic> map) {
    return Filter(
      id: map['id'] as String?,
      name: map['name'] as String?,
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'createdAt': createdAt,
    };
  }
}

class ExperienceLevel {
  final String? id;
  final String? name;
  final num? yearsFrom;
  final num? yearsTo;
  final DateTime? createdAt;

  ExperienceLevel({
    this.id,
    this.name = '',
    this.yearsFrom = 0,
    this.yearsTo = 0,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory ExperienceLevel.fromMap(Map<String, dynamic> map) {
    return ExperienceLevel(
      id: map['id'] as String?,
      name: map['name'] as String?,
      yearsFrom: map['yearsFrom'] as num?,
      yearsTo: map['yearsTo'] as num?,
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'yearsFrom': yearsFrom,
      'yearsTo': yearsTo,
      'createdAt': createdAt,
    };
  }
}

class Skill {
  final String? id;
  final String? name;
  final String? category;
  final DateTime? createdAt;

  Skill({
    this.id,
    this.name,
    this.category,
    this.createdAt,
  });

  factory Skill.fromMap(Map<String, dynamic> map) {
    return Skill(
      id: map['id'] as String?,
      name: map['name'] as String?,
      category: map['category'] as String?,
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'createdAt': createdAt,
    };
  }
}

class Location {
  final String? id;
  final String? name;
  final String? country;
  final DateTime? createdAt;

  Location({
    this.id,
    this.name,
    this.country,
    this.createdAt,
  });

  factory Location.fromMap(Map<String, dynamic> map) {
    return Location(
      id: map['id'] as String?,
      name: map['name'] as String?,
      country: map['country'] as String?,
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'country': country,
      'createdAt': createdAt,
    };
  }
}
