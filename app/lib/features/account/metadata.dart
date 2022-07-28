import 'package:flutter/foundation.dart' show ChangeNotifier;
import 'package:json_annotation/json_annotation.dart'
    show JsonSerializable, $enumDecodeNullable;

part 'metadata.g.dart';

abstract class AccountMetadata extends ChangeNotifier {
  String get id;
  Future<void> setId(final String id);

  String? get name;
  Future<void> setName(final String? name);

  DateTime? get birthday;
  Future<void> setBirthday(final DateTime? birthday);

  String? get regionText;
  Future<void> setRegionText(final String? regionText);
  // TODO(serverwentdown): Picker for ISO 3166-2 (country-adm1, https://www.geonames.org)

  SexAtBirth? get sexAtBirth;
  Future<void> setSexAtBirth(final SexAtBirth? sexAtBirth);

  RelationshipStatus? get relationshipStatus;
  Future<void> setRelationshipStatus(
    final RelationshipStatus? relationshipStatus,
  );

  WorkPeriod? get workPeriod;
  Future<void> setWorkPeriod(final WorkPeriod? workPeriod);

  Map<String, dynamic> toJson();
}

@JsonSerializable()
class AppAccountMetadata extends AccountMetadata {
  AppAccountMetadata({
    required this.id,
    this.name,
  });
  factory AppAccountMetadata.fromJson(final Map<String, dynamic> json) =>
      _$AppAccountMetadataFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$AppAccountMetadataToJson(this);

  @override
  String id;
  @override
  Future<void> setId(final String id) async {
    this.id = id;
    notifyListeners();
  }

  @override
  String? name;
  @override
  Future<void> setName(final String? name) async {
    this.name = name;
    notifyListeners();
  }

  @override
  DateTime? birthday;
  @override
  Future<void> setBirthday(final DateTime? birthday) async {
    this.birthday = birthday;
    notifyListeners();
  }

  @override
  String? regionText;
  @override
  Future<void> setRegionText(final String? regionText) async {
    this.regionText = regionText;
    notifyListeners();
  }

  @override
  SexAtBirth? sexAtBirth;
  @override
  Future<void> setSexAtBirth(final SexAtBirth? sexAtBirth) async {
    this.sexAtBirth = sexAtBirth;
    notifyListeners();
  }

  @override
  RelationshipStatus? relationshipStatus;
  @override
  Future<void> setRelationshipStatus(
    final RelationshipStatus? relationshipStatus,
  ) async {
    this.relationshipStatus = relationshipStatus;
    notifyListeners();
  }

  @override
  WorkPeriod? workPeriod;
  @override
  Future<void> setWorkPeriod(final WorkPeriod? workPeriod) async {
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
