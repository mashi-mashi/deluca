import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deluca/model/user_model.dart';

class FirestoreReference {
  static String base() => 'decula/v1/';
  static CollectionReference providers() => FirebaseFirestore.instance
      .collection(FirestoreReference.base() + 'providers');

  static CollectionReference userSubscriptions() {
    final uid = UserModel().user?.uid;
    final user = UserModel().user;
    print('=========${user.toString()}');
    return FirebaseFirestore.instance.collection(FirestoreReference.base() +
        'users/' +
        uid +
        '/subscriptions');
  }
}
