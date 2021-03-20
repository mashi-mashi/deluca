import 'package:deluca/data/firebase/firestore.dart';
import 'package:deluca/data/firebase/firestore_reference.dart';
import 'package:deluca/utils/timestamp_util.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Pick {
  final String id;
  final String title;
  final String url;
  final String providerId;
  DateTime createdAt;

  Pick({
    required this.id,
    required this.title,
    required this.url,
    required this.providerId,
    required this.createdAt,
  });
}

class UserPickModel extends ChangeNotifier {
  UserPickModel() : super();

  dynamic? _lastData;
  final List<Pick> _picks = [];
  dynamic get lastData => _lastData;
  List<Pick> get picks => _picks;

  Future<List<Pick>> load() async {
    final documents = await Firestore.getByQuery<Map<String, dynamic>>(
        FirestoreReference.userPicks().orderBy('createdAt', descending: true));
    if (documents.toList().isNotEmpty) {
      _lastData = documents.toList()[documents.toList().length - 1];
      _picks.clear();
      _picks.addAll(documents
          .map((doc) => Pick(
              id: doc['id'] as String,
              title: doc['title'] as String,
              url: doc['url'] as String,
              createdAt: dateFromTimestampValue(doc['createdAt']),
              providerId: doc['providerId'] as String))
          .toList());

      print(
          'length - ${picks.length.toString()} lastdata - ${_lastData['title'].toString()}');
    }
    notifyListeners();

    return _picks;
  }

  Future<void> add(
      {required String id,
      required String title,
      required String url,
      required String providerId}) async {
    final ref = FirestoreReference.userPicks().doc(id);
    final current = await Firestore.get(ref);
    // TODO: null返せるようにしたら直す
    if (current['title'] == null) {
      await Firestore.add(ref, {
        'favorite': true,
        'title': title,
        'url': url,
        'providerId': providerId,
      });
    }
  }
}

final userPickProvider = ChangeNotifierProvider(
  (ref) => UserPickModel(),
);

// https://qiita.com/tfandkusu/items/36640529294f65b6ae81
final pickListStreamProvider = StreamProvider.autoDispose((_) {
  final snapshots =
      Firestore.getSnapshotByQuery(FirestoreReference.userPicks());
  return snapshots.map((snapshot) => snapshot.docs
      .map((doc) => {...?doc.data(), 'id': doc.id})
      .map((data) => Pick(
          id: data['id'] as String,
          title: data['title'] as String,
          url: data['url'] as String,
          providerId: data['providerId'] as String,
          createdAt: dateFromTimestampValue(data['createdAt'])))
      .toList());
});

final pickListProvider = Provider.autoDispose((ref) async {
  // 最新の情報をwatchする
  final futurePickModel = ref.watch(pickListStreamProvider.last);
  // Future<List<Pick>>なので、値を取得できるまで待つ。
  return await futurePickModel;
});
