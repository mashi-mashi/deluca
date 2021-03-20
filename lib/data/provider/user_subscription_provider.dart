import 'package:deluca/data/firebase/firestore.dart';
import 'package:deluca/data/firebase/firestore_reference.dart';
import 'package:deluca/data/provider/provider_provider.dart';
import 'package:deluca/utils/timestamp_util.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class UserSubscription {
  String id;
  String name;
  String providerId;
  DateTime createdAt;

  UserSubscription(
      {required this.id,
      required this.name,
      required this.createdAt,
      required this.providerId});
}

final userSubscriptionProvider = ChangeNotifierProvider(
  (ref) => UserSubscriptionModel(),
);

class UserSubscriptionModel extends ChangeNotifier {
  UserSubscriptionModel() : super();

  dynamic? _lastData;
  final List<UserSubscription> _subscriptions = [];
  dynamic get lastData => _lastData;
  List<UserSubscription> get subscriptions => _subscriptions;

  Future<List<UserSubscription>> load() async {
    final documents = await Firestore.getByQuery<Map<String, dynamic>>(
        FirestoreReference.userSubscriptions()
            .orderBy('createdAt', descending: true));
    if (documents.toList().isNotEmpty) {
      _lastData = documents.toList()[documents.toList().length - 1];
      _subscriptions.clear();
      _subscriptions.addAll(documents
          .map((doc) => UserSubscription(
              id: doc['id'] as String,
              name: doc['name'] as String,
              createdAt: dateFromTimestampValue(doc['createdAt']),
              providerId: doc['providerId'] as String))
          .toList());

      print(
          'length - ${subscriptions.length.toString()} lastdata - ${_lastData['title'].toString()}');
    }
    notifyListeners();

    return _subscriptions;
  }

  Future<void> add(DelucaProvider provider) async {
    await Firestore.add(
        FirestoreReference.userSubscriptions().doc(provider.id), {
      'id': provider.id,
      'name': provider.name,
      'providerId': provider.id,
    });

    notifyListeners();
  }

  Future<void> delete(DelucaProvider provider) async {
    await Firestore.forceDelete(
        FirestoreReference.userSubscriptions().doc(provider.id));

    notifyListeners();
  }
}
