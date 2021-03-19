import 'package:deluca/data/firebase/firestore.dart';
import 'package:deluca/data/firebase/firestore_reference.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Pick {
  Pick({
    required this.title,
    required this.id,
  });

  final String id;
  final String title;
}

class PickList extends StateNotifier<List<Pick>> {
  PickList(List<Pick> initialPicks) : super(initialPicks);

  void add(String id, String title) {
    state = [...state, Pick(id: id, title: title)];
  }
}

final pickListStreamProvider = StreamProvider.autoDispose((_) {
  final snapshots =
      Firestore.getSnapshotByQuery(FirestoreReference.userPicks());
  return snapshots.map((snapshot) => snapshot.docs
      .map((doc) => {...?doc.data(), 'id': doc.id})
      .map((data) =>
          Pick(id: data['id'] as String, title: data['title'] as String))
      .toList());
});

final pickListProvider = Provider.autoDispose((ref) async {
  // 最新の情報をwatchする
  final futurePickList = ref.watch(pickListStreamProvider.last);
  // Future<List<Pick>>なので、値を取得できるまで待つ。
  final pickList = await futurePickList;
  return pickList;
});
