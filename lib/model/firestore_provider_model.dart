import 'package:deluca/utils/timestamp_util.dart';
import 'package:json_annotation/json_annotation.dart';

part 'firestore_provider_model.g.dart';

@JsonSerializable()
class FirestoreProviderModel {
  final String feedUrl;
  final String title;
  final String? description;
  final String? link;
  final List<String>? tags;

  @JsonKey(
      name: 'createdAt',
      fromJson: dateFromTimestampValue,
      toJson: timestampFromDateValue)
  final DateTime craetedAt;

  @JsonKey(
      name: 'updatedAt',
      fromJson: dateFromTimestampValue,
      toJson: timestampFromDateValue)
  final DateTime updatedAt;

  FirestoreProviderModel(
      {required this.feedUrl,
      required this.title,
      this.description,
      this.link,
      this.tags,
      required this.craetedAt,
      required this.updatedAt});

  factory FirestoreProviderModel.fromJson(Map<String, dynamic> json) =>
      _$FirestoreProviderModelFromJson(json);
  Map<String, dynamic> toJson() => _$FirestoreProviderModelToJson(this);
}
