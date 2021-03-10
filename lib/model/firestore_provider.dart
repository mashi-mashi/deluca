import 'package:deluca/data/serializer/serializer_util.dart';
import 'package:json_annotation/json_annotation.dart';

part 'firestore_provider.g.dart';

@JsonSerializable()
class FirestoreProvider {
  final String feedUrl;
  final String title;
  final String description;
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

  FirestoreProvider(this.feedUrl, this.title, this.description, this.link,
      this.tags, this.craetedAt, this.updatedAt);

  factory FirestoreProvider.fromJson(Map<String, dynamic> json) =>
      _$FirestoreProviderFromJson(json);
  Map<String, dynamic> toJson() => _$FirestoreProviderToJson(this);
}
