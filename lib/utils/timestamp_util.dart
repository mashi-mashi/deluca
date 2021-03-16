import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

// TODO: 型付け
DateTime dateFromTimestampValue(dynamic value) => (value as Timestamp).toDate();

Timestamp timestampFromDateValue(dynamic value) => value is DateTime ? Timestamp.fromDate(value) : Timestamp.now();

String formatDatetime(DateTime value, {String format = 'yyyy/MM/dd'}) => DateFormat(format).format(value);

final timestampKey = JsonKey(
  fromJson: dateFromTimestampValue,
  toJson: timestampFromDateValue
);
