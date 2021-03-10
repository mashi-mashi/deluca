import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deluca/data/firebase/firebase_auth.dart';

class FirestoreReference {
  static String get _userId => FirebaseAuthenticate.userId ?? '';
  static String base() => 'decula/v1/';
  static CollectionReference providers() => FirebaseFirestore.instance
      .collection(FirestoreReference.base() + 'providers');

  static CollectionReference providerArticles(String providerId) => FirebaseFirestore.instance
      .collection(FirestoreReference.base() + 'providers/$providerId/articles');

  static CollectionReference userSubscriptions() {
    return FirebaseFirestore.instance.collection(FirestoreReference.base() +
        'users/' +
        FirestoreReference._userId +
        '/subscriptions');
  }

  static CollectionReference userPicks() {
    return FirebaseFirestore.instance.collection(FirestoreReference.base() +
        'users/' +
        FirestoreReference._userId +
        '/picks');
  }
}
