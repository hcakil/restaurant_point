import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:restaurantpoint/customs/custom_button.dart';
import 'package:restaurantpoint/customs/fade_animation.dart';
import 'package:restaurantpoint/pages/login_page.dart';
import 'package:restaurantpoint/service/view_model/auth_view_model.dart';

class SignUpPage extends GetWidget<AuthViewModel> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            leading: _goBackButton(context),
            backgroundColor: Color(0xff251F34),
          ),
          backgroundColor: Color(0xff251F34),
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                  child: Text(
                    'Hesap Oluştur',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 25),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    'Lütfen Bilgilerinizi Giriniz',
                    style: TextStyle(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w400,
                        fontSize: 14),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 28.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        FadeAnimation(
                          1.8,
                          Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'E-mail',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 13,
                                      color: Colors.white),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  style: (TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400)),
                                  keyboardType: TextInputType.emailAddress,
                                  obscureText: false,
                                  cursorColor: Colors.white,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    fillColor: Color(0xfff3B324E),
                                    filled: true,
                                    prefixIcon: Image.asset(
                                        'assets/images/icon_email.png'),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color(0xff14DAE2), width: 2.0),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20.0)),
                                    ),
                                  ),
                                  onSaved: (girilenEmail) {
                                    controller.email = girilenEmail;
                                  },
                                  validator: (value) {
                                    if (value == null) {
                                      print("Error");
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        FadeAnimation(
                          1.9,
                          Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Şifre',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 13,
                                      color: Colors.white),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  style: (TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400)),
                                  obscureText: true,
                                  cursorColor: Colors.white,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    fillColor: Color(0xfff3B324E),
                                    filled: true,
                                    prefixIcon: Image.asset(
                                        'assets/images/icon_lock.png'),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color(0xff14DAE2), width: 2.0),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20.0)),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null) {
                                      print("Error");
                                    }
                                  },
                                  onSaved: (girilenSifre) {
                                    controller.sifre = girilenSifre;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        FadeAnimation(
                            2,
                            Padding(
                              padding: const EdgeInsets.only(left:8.0,right: 8),
                              child: CustomButton(
                                onPress: () {

                                  _formKey.currentState.save();
                                  if (_formKey.currentState.validate()) {
                                    controller
                                        .createAccountWithEmailAndPassword();
                                  }
                                },
                                text: "Kayıt",
                                 color: Color(0xff14DAE2)
                              ),
                            )),
                        SizedBox(
                          height: 40,
                        ),
                        FadeAnimation(
                            1.5,
                            InkWell(
                                onTap: () => Get.to(LoginPage()),
                                child: Text(
                                  "Kayıtlıysan Giriş Yap",
                                  style: TextStyle(
                                      color: Color.fromRGBO(143, 148, 251, 1),
                                      fontWeight: FontWeight.bold),
                                ))),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}

Widget _goBackButton(BuildContext context) {
  return IconButton(
      icon: Icon(Icons.arrow_back, color: Colors.grey[350]),
      onPressed: () {
        Navigator.of(context).pop(true);
      });
}
