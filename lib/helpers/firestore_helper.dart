import 'package:adv_11_am_firebase_app/helpers/firebase_storage_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreHelper {
  FireStoreHelper._();
  static final FireStoreHelper fireStoreHelper = FireStoreHelper._();

  FirebaseFirestore fireStore = FirebaseFirestore.instance;

  CollectionReference? collectionReference;

  connectCollection() {
    collectionReference = fireStore.collection('UserData');
  }

  Future<void> addUser({
    required String name,
    required String email,
    required int contact,
    required String image,
  }) async {
    connectCollection();

    String uniqueId = DateTime.now().millisecondsSinceEpoch.toString();

    FirebaseStorageHelper.firebaseStorageHelper.uploadFile(imagePath: image, uniqueId: uniqueId);

    String imagePath = "https://firebasestorage.googleapis.com/v0/b/firestore-11am.appspot.com/o/images%2F$uniqueId.jpg?alt=media&token=0a99b126-49f6-479f-acc4-faa9a9501eed";

    await collectionReference!
        .doc(uniqueId)
        .set({
          'id': uniqueId,
          'name': name,
          'contact': contact,
          'email': email,
          'image': imagePath,
        })
        .then(
          (value) => print("User added"),
        )
        .catchError(
          (error) => print("$error"),
        );
  }

  Stream<QuerySnapshot<Object?>> getUser() {
    connectCollection();

    return collectionReference!.snapshots();
  }

  editUser({required String id, required Map<Object, Object> data}) {
    connectCollection();

    collectionReference!.doc(id).update(data).then((value) => print("User edited...")).catchError((error) => print(error));
  }

  removeRecord({required String id}) {
    connectCollection();

    collectionReference!.doc(id).delete().then((value) => print("Record deleted...")).catchError((error) => print(error));
  }
}
