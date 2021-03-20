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

class PickModel extends ChangeNotifier {
  PickModel() : super();

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

final pickProvider = ChangeNotifierProvider(
  (ref) => PickModel(),
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