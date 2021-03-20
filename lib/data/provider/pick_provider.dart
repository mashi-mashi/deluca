import 'package:deluca/data/firebase/firestore.dart';
import 'package:deluca/data/firebase/firestore_reference.dart';
import 'package:deluca/utils/timestamp_util.dart';
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

class PickList extends StateNotifier<List<Pick>> {
  PickList(List<Pick> initialPicks) : super(initialPicks);

  void add(String id, String title, String providerId, String url,
      DateTime createdAt) {
    state = [
      ...state,
      Pick(
          id: id,
          title: title,
          createdAt: createdAt,
          providerId: providerId,
          url: url)
    ];
  }
}

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
  final futurePickList = ref.watch(pickListStreamProvider.last);
  // Future<List<Pick>>なので、値を取得できるまで待つ。
  final pickList = await futurePickList;
  return pickList;
});
