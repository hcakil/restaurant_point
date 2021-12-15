import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurantpoint/helper/local_storage_data.dart';
import 'package:restaurantpoint/helper/shared_prefs.dart';
import 'package:restaurantpoint/models/comment.dart';
import 'package:restaurantpoint/models/my_user.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:restaurantpoint/pages/main_page.dart';
import 'package:restaurantpoint/service/view_model/auth_view_model.dart';

class HomeViewModel extends GetxController {
  ValueNotifier<bool> get loading => _loading;
  ValueNotifier<bool> _loading = ValueNotifier(false);

  final FirebaseFirestore _firestoreDb = FirebaseFirestore.instance;

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  firebase_storage.Reference _storageReference;

  final LocalStorageData localStorageData = Get.find();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getCurrentUser();
  }

  void getCurrentUser() async {
     _loading.value = true;
    MyUser userModel = await localStorageData.getUser;
    if(userModel != null)
      {
        MySharedPreferences.instance.setStringValue("userEmail", userModel.email);
        MySharedPreferences.instance
            .setStringValue("userLevel", userModel.seviye.toString());
      }

    // await AuthViewModel.localStorageData.getUser.then((value) {_userModel=value;});
    _loading.value = false;
    update();
  }
  Future<bool> checkComment(
      ) async {
    _loading.value = true;
    try {


      MyUser user = await localStorageData.getUser;
     var userEmail = user.email;
      var isApproved = "false";

      QuerySnapshot querySnapshot = await _firestoreDb
          .collection("comments")
          .where("userEmail",isEqualTo:userEmail )
          .where("isApproved",isEqualTo:isApproved )
          .get();
      print(querySnapshot.docs.length.toString() + " is blank");
      if(querySnapshot.docs.length>0)
        return false;
      else return true;

    } catch (e) {
      print(e.message);
      Get.snackbar(
        'Error login account',
        e.message,
        colorText: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      _loading.value = false;
      update();
      // Get.offAll();

    }
  }
  Future<bool> addComment(
      Comment comment, File commentPhoto, String gelenAdressName) async {
    _loading.value = true;
    try {

      DocumentSnapshot _okunanComment =
          await FirebaseFirestore.instance.doc("comments/${comment.id}").get();
      MyUser user = await localStorageData.getUser;
      comment.userEmail = user.email;
      comment.isApproved = "false";

      if (_okunanComment.data() == null) {


        var sonuc = await _firestoreDb
            .collection("comments")
            .doc(comment.id)
            .set(comment.toJson());
        var url = await uploadPhotoComment(comment.id, commentPhoto);
        var elCevap = await updatePhotoURL(comment, url);




      } else {


      }

    } catch (e) {
      print(e.message);
      Get.snackbar(
        'Error login account',
        e.message,
        colorText: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      _loading.value = false;
      update();
      // Get.offAll();

    }
  }

  Future<bool> updatePhotoURL(Comment comment, String commentPhotoURL) async {
    try {
      await _firestoreDb
          .collection("comments")
          .doc(comment.id)
          .update({"photoUrl": commentPhotoURL});
      return true;
    } catch (e) {
      print(e.message);
      Get.snackbar(
        'Error update photo url',
        e.message,
        colorText: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<String> uploadPhotoComment(String commentId, File commentPhoto) async {
    try {
      _storageReference = firebase_storage.FirebaseStorage.instance
          .ref()
          .child(commentId)
          .child("comment_photo");
      // .child(random+"profil_photo.png");

      firebase_storage.UploadTask uploadTask =
          _storageReference.putFile(commentPhoto);
      firebase_storage.TaskSnapshot snapshot = await uploadTask;

      var url = await _storageReference.getDownloadURL();

      return url;
    } catch (e) {
      print(e.message);
      Get.snackbar(
        'Error upload to photo to Storage',
        e.message,
        colorText: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<List<Comment>> getCommentsForPlace(String gelenAdresId) async {
    try {
      QuerySnapshot querySnapshot = await _firestoreDb
          .collection("comments")
          .where("placeId == $gelenAdresId")
          .get();
      List<Comment> allComments = [];

      for (DocumentSnapshot oneComment in querySnapshot.docs) {
        Comment _tekPost = Comment.fromJson(oneComment.data());
        if (_tekPost.placeId.contains(gelenAdresId) && _tekPost.isApproved.contains("approved")) {
          allComments.add(_tekPost);

        }

      }
      return allComments;
    } catch (e) {
      print(e.message);
      Get.snackbar(
        'Comments Load Problem',
        e.message,
        colorText: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> signOut() async {
    FirebaseAuth.instance.signOut();

    localStorageData.deleteUser();
  }

  Future<List<Comment>> getCommentsForResponse() async {
    try {
      _loading.value=true;
      var metin = "false";
      QuerySnapshot querySnapshot = await _firestoreDb
          .collection("comments")
         // .where("isApproved == $metin")
          .get();
      List<Comment> allComments = [];

      for (DocumentSnapshot oneComment in querySnapshot.docs) {
        Comment _tekPost = Comment.fromJson(oneComment.data());
        if(_tekPost.isApproved.contains("false"))
          {
            allComments.add(_tekPost);

          }

        _loading.value=false;
      }
      return allComments;
    } catch (e) {
      print(e.message);
      _loading.value=false;
      Get.snackbar(
        'Comments Waiting Response Load Problem',
        e.message,
        colorText: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<List<Comment>> approveDenyRequest(
      String answer, Comment comment) async {
    try {
    //  _loading.value = true;
      await _firestoreDb
          .collection("comments")
          .doc(comment.id)
          .update({"isApproved": answer});

      //_loading.value = false;
      update();
    } catch (e) {
      print(e.message);
      Get.snackbar(
        'Comment Appove/Deny Response Load Problem',
        e.message,
        colorText: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
