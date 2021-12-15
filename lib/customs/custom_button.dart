

import 'package:flutter/material.dart';
import 'package:restaurantpoint/customs/custom_text.dart';
import 'package:restaurantpoint/customs/utils/colors.dart';


class CustomButton extends StatelessWidget {
  final String text;

  final Color color;

  final Function onPress;

  CustomButton({
    @required this.onPress,
    this.text = 'Write text ',
    this.color = primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return RaisedButton(

      shape: new RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(10.0),
      ),
      padding: const EdgeInsets.all(0.0),
      onPressed: onPress,
      color: color,
      child: Ink(
        decoration: const BoxDecoration(
          //gradient: chatBubbleGradient,
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        child: Container(
          constraints: const BoxConstraints(minWidth: 88.0, minHeight: 46.0), // min sizes for Material buttons
          alignment: Alignment.center,
          child: CustomText(
            fontSize: 25,

            alignment: Alignment.center,
            text: text,
            color: Color(0xfff3B324E),//Colors.white,
          ),
        ),
      ),
    );
  }
}
