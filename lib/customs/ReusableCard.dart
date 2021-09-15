import 'package:flutter/material.dart';

class ReusableCard extends StatelessWidget {
  ReusableCard({this.cardChild, this.onPress, this.cardGradient});

  final Widget cardChild;
  final Function onPress;
  final LinearGradient cardGradient;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
          child: cardChild,
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.all(5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: cardGradient != null
                ? cardGradient
                : LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.grey.shade200,
                      Colors.white60,
                    ],
                  ),
            boxShadow: [
              BoxShadow(
                color: Colors.black54,
                blurRadius: 0.4,
                spreadRadius: 0.0,
                offset: Offset(1.0, 1.0), // shadow direction: bottom right
              ),
            ],
          )),
    );
  }
}
