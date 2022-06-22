import 'package:flutter/foundation.dart' show ChangeNotifier;
import 'package:json_annotation/json_annotation.dart' show JsonSerializable;

part 'metadata.g.dart';

abstract class AccountMetadata extends ChangeNotifier {
  String get id;
  Future<void> setId(String id);

  String? get name;
  Future<void> setName(String name);

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
}
