import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:restaurantpoint/customs/custom_button.dart';
import 'package:restaurantpoint/customs/fade_animation.dart';
import 'package:restaurantpoint/pages/sign_up_page.dart';
import 'package:restaurantpoint/service/view_model/auth_view_model.dart';

class LoginPage extends GetWidget<AuthViewModel> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  bool showSpinner = false;

  //String email, password;

  @override
  Widget build(BuildContext context) {

    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: SafeArea(
        child: Scaffold(
            resizeToAvoidBottomPadding: true,
            backgroundColor: Colors.white, //Color(0xff251F34),
            body: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Center(
                    child: SizedBox(
                        width: 225,
                        height: 225,
                        child: Image.asset("assets/images/app_logov2.png")),
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 15, 20, 8),
                            child: Text(
                              'Giriş',
                              style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left:20.0),
                            child: Text(
                              'Devam etmek için lütfen giriş yapınız.',
                              style: TextStyle(
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w400,
                                  fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),



                  Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          FadeAnimation(
                            1.7,
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'E-mail',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w300,
                                        fontSize: 15,
                                        fontFamily: "Poppins",
                                        color: Colors.green),
                                  ),
                                  SizedBox(height: 5,),
                                  TextFormField(
                                    style: (TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400)),
                                    keyboardType: TextInputType.emailAddress,
                                    cursorColor: Colors.white,
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      fillColor: Color(0xfff3B324E),
                                      filled: true,
                                      prefixIcon: Image.asset(
                                          'assets/images/icon_email.png'),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xff14DAE2),
                                            width: 2.0),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20.0)),
                                      ),
                                    ),
                                    onChanged: (girilenEmail) {
                                      controller.email = girilenEmail;
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          FadeAnimation(
                            1.9,
                            Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: 10,),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Şifre',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w300,
                                        fontSize: 15,
                                        fontFamily: "Poppins",
                                        color: Colors.green),
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
                                            color: Color(0xff14DAE2),
                                            width: 2.0),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20.0)),
                                      ),
                                    ),
                                    onChanged: (girilenSifre) {
                                      controller.sifre = girilenSifre;
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
                            height: 10,
                          ),

                          SizedBox(
                            height: 30,
                          ),
                          FadeAnimation(2,
                             Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: CustomButton(
                                  text: 'GİRİŞ',
                                  color: Color(0xff14DAE2),
                                  onPress: () async {
                                    // Add login code

                                      //showSpinner = true;

                                    _formKey.currentState.save();
                                    if (_formKey.currentState.validate()) {
                                      controller.signInWithEmailAndPassword();
                                    }
                                     // showSpinner = false;
                                  },
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: false,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              //crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Text('Parolamı Unuttum?',
                                    style: TextStyle(
                                        color: Color(0xff14DAE2)
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Hesabınız Yok Mu?',
                                style: TextStyle(
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w400
                                ),),
                              FlatButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SignUpPage()));
                                },
                                child: Text('Kayıt Ol',
                                    style: TextStyle(
                                      color: Color(0xff14DAE2),)
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )),
      ),
    );
  }
}
