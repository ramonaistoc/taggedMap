import 'package:flutter/material.dart';

class SeparatorLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.90,
        height: 0.7,
        color: Colors.grey,
      ),
    );
  }
}
