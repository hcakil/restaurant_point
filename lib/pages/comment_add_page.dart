import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:restaurantpoint/customs/fade_animation.dart';
import 'package:restaurantpoint/customs/utils/colors.dart';
import 'package:restaurantpoint/models/comment.dart';
import 'package:restaurantpoint/pages/landing_page.dart';
import 'package:restaurantpoint/pages/main_page.dart';
import 'package:restaurantpoint/service/view_model/home_view_model.dart';

class CommentAddPage extends StatefulWidget {
  CommentAddPage(
      {Key key, this.gelenAdresId, this.gelenAdresName, this.isAdmin})
      : super(key: key);
  String gelenAdresId;
  bool isAdmin;

  String gelenAdresName;

  @override
  _CommentAddPageState createState() => _CommentAddPageState();
}

class _CommentAddPageState extends State<CommentAddPage> {
  String _comment, _commentId;

  final _formKey = GlobalKey<FormState>();

  File _clubPhoto;
  final ImagePicker _picker = ImagePicker();

  _formSubmit(HomeViewModel controller) async {
    _formKey.currentState.save();

    if (_comment == null || _clubPhoto == null || _comment.trim().length < 3) {
      showDialog(
          context: context,
          builder: (context) {
            Future.delayed(Duration(seconds: 2), () {
              Navigator.of(context).pop();
            });
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 200),
                  child: AlertDialog(
                    backgroundColor: Colors.white70,
                    content: SingleChildScrollView(
                      child: Text(
                        "Fotoğraf Boş ve Yorum 3 karakterden az olamaz !!",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          letterSpacing: 2,
                          //fontFamily: "Lobster"
                        ),
                      ),
                    ),
                    // shape: ContinuousRectangleBorder(),
                  ),
                ),
              ],
            );
          });
    } else {
      //final _userModel = Provider.of<UserModel>(context, listen: false);

      _commentId = _comment.substring(0, 3).replaceAll(" ", "");
      _commentId = _commentId + randomSayiUret();


      controller.addComment(
          Comment(
            id: _commentId,
            comment: _comment,
            placeId: widget.gelenAdresId,
          ),
          _clubPhoto,
          widget.gelenAdresName);

      Future.delayed(Duration(seconds: 1)).then((value) {
        Get.offAll(() => LandingPage());
      });
    }
  }

  String randomSayiUret() {
    int rastgeleSayi = Random().nextInt(9999999);
    return rastgeleSayi.toString();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeViewModel>(
      builder: (controller) {

        if (controller.loading == null) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              toolbarHeight: 80,
              automaticallyImplyLeading: false,
              backgroundColor: Colors.deepPurpleAccent,
              title: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Yorum Yap",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          // fontFamily: "Lobster",
                          color: Colors.white,
                          //letterSpacing: 3,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            body: SingleChildScrollView(
              //scrollDirection: Axis.vertical,
              child: Column(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            Container(
                              // color: Colors.red,
                              height: 350.0,
                              //color: Colors.red,
                            ),
                            Container(
                              height: 250.0,
                              decoration:
                                  BoxDecoration(gradient: primaryGradient),
                            ),
                            Positioned(
                                top: 100,
                                right: 0,
                                left: 0,
                                child: GestureDetector(
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (context) {
                                        return Container(
                                          height: 180,
                                          child: Column(
                                            children: [
                                              ListTile(
                                                leading: Icon(Icons.camera),
                                                title:
                                                    Text("Kameradan Foto Çek"),
                                                onTap: () {
                                                  _kameradanFotoCek();
                                                },
                                              ),
                                              ListTile(
                                                leading: Icon(Icons.image),
                                                title: Text("Galeriden Seç"),
                                                onTap: () {
                                                  _galeridenSec();
                                                },
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: Stack(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20.0, right: 20.0),
                                        child: Material(
                                          elevation: 5.0,
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          shadowColor: Colors.white,
                                          child: Container(
                                            height: 220.0,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              border: Border.all(
                                                color: Colors.grey
                                                    .withOpacity(0.2),
                                              ),
                                              color: Colors.grey,
                                            ),
                                            foregroundDecoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              image: DecorationImage(
                                                  image: _clubPhoto == null
                                                      ? NetworkImage(
                                                          "https://digitalpratix.com/wp-content/uploads/resim.jpg")
                                                      : FileImage(_clubPhoto),
                                                  fit: BoxFit.fill),
                                            ),
                                          ),
                                        ),
                                      ),
                                      // userStats
                                    ],
                                  ),
                                ))
                          ],
                        ),
                        FadeAnimation(
                          2,
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: 90,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 20),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 5),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: gradientStart, width: 1),
                                      boxShadow: const [
                                        BoxShadow(
                                            color: gradientEnd,
                                            blurRadius: 10,
                                            offset: Offset(1, 1)),
                                      ],
                                      color: Colors.white,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(20))),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Icon(Icons.category),
                                      Expanded(
                                        child: Container(
                                          margin:
                                              const EdgeInsets.only(left: 10),
                                          child: TextFormField(
                                            maxLength: 100,
                                            //maxLines: 1,
                                            onSaved: (String girilenMetin) {
                                              _comment = girilenMetin;
                                            },
                                            decoration: InputDecoration(
                                              labelText: " Yorum Metni ...",
                                              border: InputBorder.none,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),

                        const SizedBox(
                          height: 20,
                        ),

                        FadeAnimation(
                          2,
                          ElevatedButton(
                            onPressed: () => _formSubmit(controller),
                            style: ElevatedButton.styleFrom(
                                onPrimary: Colors.purpleAccent,
                                shadowColor: Colors.purpleAccent,
                                elevation: 18,
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20))),
                            child: Ink(
                              decoration: BoxDecoration(
                                  gradient: const LinearGradient(colors: [
                                    Colors.purpleAccent,
                                    Colors.deepPurpleAccent
                                  ]),
                                  borderRadius: BorderRadius.circular(20)),
                              child: Container(
                                width: 200,
                                height: 50,
                                alignment: Alignment.center,
                                child: const Text(
                                  'Yorum Yap',
                                  style: TextStyle(
                                    fontSize: 30,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 80,
                        ),
                        // secondCard, thirdCard
                      ],
                    ),
                  ),
                ],
              ),
            ), //Container(child: Center(child: Text("Add Category Page"),),),
          );
        }
      },
    );
  }

  void _kameradanFotoCek() async {
    var pickedPhoto = await _picker.getImage(source: ImageSource.camera);

    if (pickedPhoto != null) {
      setState(
        () {
          _clubPhoto = File(pickedPhoto.path);
          Navigator.of(context).pop();
        },
      );
    }
  }

  void _galeridenSec() async {
    var pickedPhoto = await _picker.getImage(source: ImageSource.gallery);

    if (pickedPhoto != null) {
      setState(
        () {
          _clubPhoto = File(pickedPhoto.path);
          Navigator.of(context).pop();
        },
      );
    }
  }
}
