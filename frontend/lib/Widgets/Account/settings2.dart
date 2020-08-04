import 'package:flutter/material.dart';

class Settings2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 10, top: 15, bottom: 15),
          child: InkWell(
            child: Text(
              "Share profile",
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey,
              ),
            ),
            onTap: () {},
          ),
        ),
      ],
    );
  }
}
