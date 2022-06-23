import 'package:flutter/foundation.dart' show ChangeNotifier;
import 'package:json_annotation/json_annotation.dart'
    show JsonSerializable, $enumDecodeNullable;

part 'metadata.g.dart';

abstract class AccountMetadata extends ChangeNotifier {
  String get id;
  Future<void> setId(String id);

  String? get name;
  Future<void> setName(String? name);

  DateTime? get birthday;
  Future<void> setBirthday(DateTime? birthday);

  SexAtBirth? get sexAtBirth;
  Future<void> setSexAtBirth(SexAtBirth? sexAtBirth);

  RelationshipStatus? get relationshipStatus;
  Future<void> setRelationshipStatus(RelationshipStatus? relationshipStatus);

  WorkPeriod? get workPeriod;
  Future<void> setWorkPeriod(WorkPeriod? workPeriod);

  Map<String, dynamic> toJson();
}

@JsonSerializable()
class AppAccountMetadata extends AccountMetadata {
  AppAccountMetadata({
    required this.id,
    this.name,
  });
  factory AppAccountMetadata.fromJson(Map<String, dynamic> json) =>
      _$AppAccountMetadataFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$AppAccountMetadataToJson(this);

  @override
  String id;
  @override
  Future<void> setId(String id) async {
    this.id = id;
    notifyListeners();
  }

  @override
  String? name;
  @override
  Future<void> setName(String? name) async {
    this.name = name;
    notifyListeners();
  }

  @override
  DateTime? birthday;
  @override
  Future<void> setBirthday(DateTime? birthday) async {
    this.birthday = birthday;
    notifyListeners();
  }

  @override
  SexAtBirth? sexAtBirth;
  @override
  Future<void> setSexAtBirth(SexAtBirth? sexAtBirth) async {
    this.sexAtBirth = sexAtBirth;
    notifyListeners();
  }

  @override
  RelationshipStatus? relationshipStatus;
  @override
  Future<void> setRelationshipStatus(
    RelationshipStatus? relationshipStatus,
  ) async {
    this.relationshipStatus = relationshipStatus;
    notifyListeners();
  }

  @override
  WorkPeriod? workPeriod;
  @override
  Future<void> setWorkPeriod(WorkPeriod? workPeriod) async {
    this.workPeriod = workPeriod;
    notifyListeners();
  }
}

enum SexAtBirth {
  male,
  female,
  unknown,
}

enum RelationshipStatus {
  single,
  coupled,
  married,
}

enum WorkPeriod {
  day,
  night,
  mixed,
}
