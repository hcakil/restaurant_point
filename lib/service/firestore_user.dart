
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:restaurantpoint/models/my_user.dart';

class FireStoreUser {
  final CollectionReference _userCollectionRef =
  FirebaseFirestore.instance.collection('Users');

  Future<void> addUserToFireStore(MyUser userModel) async {
    return await _userCollectionRef
        .doc(userModel.userID)
        .set(userModel.toMap());
  }

  Future<DocumentSnapshot> getCurrentUser (String userId) async{
    return await _userCollectionRef.doc(userId).get();
  }
}
