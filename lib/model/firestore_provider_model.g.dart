// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firestore_provider_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FirestoreProviderModel _$FirestoreProviderModelFromJson(
    Map<String, dynamic> json) {
  return FirestoreProviderModel(
    feedUrl: json['feedUrl'] as String,
    title: json['title'] as String,
    description: json['description'] as String?,
    link: json['link'] as String?,
    tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
    craetedAt: dateFromTimestampValue(json['createdAt']),
    updatedAt: dateFromTimestampValue(json['updatedAt']),
  );
}

Map<String, dynamic> _$FirestoreProviderModelToJson(
        FirestoreProviderModel instance) =>
    <String, dynamic>{
      'feedUrl': instance.feedUrl,
      'title': instance.title,
      'description': instance.description,
      'link': instance.link,
      'tags': instance.tags,
      'createdAt': timestampFromDateValue(instance.craetedAt),
      'updatedAt': timestampFromDateValue(instance.updatedAt),
    };
