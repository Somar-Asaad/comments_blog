import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comments_viewer_application/models/user_model.dart';

class DatabaseServices {
  final FirebaseFirestore _firebaseFireStore = FirebaseFirestore.instance;
  CollectionReference? _collectionReference;

  DatabaseServices() {
    _setUpCollectionReference();
  }

  void _setUpCollectionReference() {
    _collectionReference = _firebaseFireStore
        .collection('users')
        .withConverter<UserModel>(fromFirestore: (snapshot, _) {
      return UserModel.fromJson(snapshot.data()!);
    }, toFirestore: (userModel, _) {
      return userModel.toJson();
    });
  }

  Future<void> createUserProfile({required UserModel userModel}) async {
    await _collectionReference!.doc(userModel.uid).set(userModel);
  }
}
