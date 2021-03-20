import 'package:deluca/data/firebase/firestore.dart';
import 'package:deluca/data/firebase/firestore_reference.dart';
import 'package:deluca/utils/timestamp_util.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final FIRESTORE_LOAD_LIMIT = 15;

class DelucaProvider {
  String id;
  String name;
  String url;
  DateTime createdAt;
  bool subscribe;

  DelucaProvider({
    required this.id,
    required this.name,
    required this.url,
    required this.createdAt,
    required this.subscribe,
  });
}

final providerProvider = ChangeNotifierProvider(
  (ref) => ProviderModel(),
);

class ProviderModel extends ChangeNotifier {
  ProviderModel() : super();

  dynamic? _lastData;
  final List<DelucaProvider> _providers = [];
  dynamic get lastData => _lastData;
  List<DelucaProvider> get providers => _providers;

  Future<List<DelucaProvider>> loadAll() async {
    final data = await Firestore.getByQuery<Map<String, dynamic>>(
        FirestoreReference.providers()
            .orderBy('createdAt', descending: true)
            .limit(FIRESTORE_LOAD_LIMIT));
    final alreadySubscriptions = await Firestore.getByIds<Map<String, dynamic>>(
        FirestoreReference.userSubscriptions(),
        data.map((d) => d['id'] as String).toList());
    final subscribeIds =
        alreadySubscriptions.map((sub) => sub['providerId']).toList();

    if (data.toList().isNotEmpty) {
      _lastData = data.toList()[data.toList().length - 1];
      _providers.clear();
      _providers.addAll(data
          .map((d) => DelucaProvider(
              id: d['id'] as String,
              name: d['title'] as String,
              url: d['feedUrl'] as String,
              subscribe: subscribeIds.contains(d['id']),
              createdAt: dateFromTimestampValue(d['createdAt'])))
          .toList());

      print(
          'length - ${providers.length.toString()} lastdata - ${_lastData['name'].toString()}');
    }
    notifyListeners();

    return _providers;
  }
}
