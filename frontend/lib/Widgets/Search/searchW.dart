import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Search extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Enter name place',
          hintStyle: TextStyle(
            color: Color(0xFF757575),
            fontSize: 16,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: Color(0xFF757575),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 0),
          fillColor: Color(0xFFEEEEEE),
          filled: true,
        ),
      ),
    );
  }
}
