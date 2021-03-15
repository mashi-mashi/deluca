import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

DateTime dateFromTimestampValue(dynamic value) => (value as Timestamp).toDate();

Timestamp timestampFromDateValue(dynamic value) => value is DateTime ? Timestamp.fromDate(value) : Timestamp.now();

final timestampKey = JsonKey(
  fromJson: dateFromTimestampValue,
  toJson: timestampFromDateValue
);
