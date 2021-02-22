import 'package:cloud_firestore/cloud_firestore.dart';

class Firestore {
  static FieldValue timestamp() {
    return FieldValue.serverTimestamp();
  }

  static Future<T> get<T>(DocumentReference ref) async {
    final doc = await ref.get();
    return {...?doc.data(), 'id': doc.id} as T;
  }

  static Future<Iterable<T>> getByIds<T>(
      CollectionReference ref, List<String> ids) async {
    final uniq = ids.toSet().toList();

    if (uniq.isEmpty) return [];

    return Future.wait(uniq.map((id) => Firestore.get<T>(ref.doc(id))));
  }

  static Future<Iterable<T>> getByQuery<T>(Query query) async {
    final snap = await query.get();
    final data = snap?.docs?.map((doc) => {...?doc.data(), 'id': doc?.id} as T);
    return data;
  }

  // TODO: Firestoreじゃない型をかえす
  static Stream<QuerySnapshot> getSnapshotByQuery(Query query) {
    return query.snapshots();
  }

  static Future<void> delete(DocumentReference ref) async {
    return await Firestore.set(
        ref, {'deleted': true, 'deletedAt': Firestore.timestamp()});
  }

  static Future<void> forceDelete(DocumentReference ref) async {
    return await ref.delete();
  }

  static Future<void> add(
      DocumentReference ref, Map<String, dynamic> data) async {
    return await ref.set({
      ...data,
      'deleted': false,
      'createdAt': Firestore.timestamp(),
      'updatedAt': Firestore.timestamp()
    }, SetOptions(merge: true));
  }

  static Future<void> set(
      DocumentReference ref, Map<String, dynamic> data) async {
    return await ref.set(
        {...data, 'updatedAt': Firestore.timestamp()}, SetOptions(merge: true));
  }
}
