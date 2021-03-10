// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firestore_provider.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FirestoreProvider _$FirestoreProviderFromJson(Map<String, dynamic> json) {
  return FirestoreProvider(
    json['feedUrl'] as String,
    json['title'] as String,
    json['description'] as String,
    json['link'] as String?,
    (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
    dateFromTimestampValue(json['createdAt']),
    dateFromTimestampValue(json['updatedAt']),
  );
}

Map<String, dynamic> _$FirestoreProviderToJson(FirestoreProvider instance) =>
    <String, dynamic>{
      'feedUrl': instance.feedUrl,
      'title': instance.title,
      'description': instance.description,
      'link': instance.link,
      'tags': instance.tags,
      'createdAt': timestampFromDateValue(instance.craetedAt),
      'updatedAt': timestampFromDateValue(instance.updatedAt),
    };
