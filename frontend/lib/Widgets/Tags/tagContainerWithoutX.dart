import 'dart:convert';
import 'package:tagge_map/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TagContainerWithoutX extends StatelessWidget {
  final String text;
  final Color color;
  final Function deleteTag;
  final Function addTag;
  final int id;
  TagContainerWithoutX(
      this.id, this.text, this.color, this.deleteTag, this.addTag);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      margin: EdgeInsets.only(right: 15),
      child: Row(
        children: <Widget>[
          InkWell(
            onTap: () {},
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
