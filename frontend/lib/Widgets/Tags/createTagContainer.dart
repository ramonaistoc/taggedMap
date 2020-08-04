import 'dart:convert';
import 'package:tagge_map/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CreateTagContainer extends StatelessWidget {
  final String text;
  final Color color;
  final Function deleteTag;
  final Function addTag;
  final int id;
  CreateTagContainer(
      this.id, this.text, this.color, this.deleteTag, this.addTag);

  void addTaginPersonalList(BuildContext context) async {
    final isUser = await http.post(
      'http://192.168.1.15:5000/addtagsinyourlist',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{}),
    );

    Map<String, dynamic> r = jsonDecode(isUser.body);

    if (r['success'] == 'yes') {
      print("TOKEN DIN CONNECTPAGE");
      print(r['token']);
      TokenProvider.of(context).setToken(r['token']);
      Navigator.pushNamed(context, '/home');
    } else {}
    //de facut sa apara cevav ca nu e in bd si sa se inregistreze
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 5,
        horizontal: 15,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      margin: EdgeInsets.only(right: 10),
      child: Row(
        children: <Widget>[
          InkWell(
            onTap: addTag,
            child: Text(
              text,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          InkWell(
            onTap: deleteTag,
            child: Icon(
              Icons.clear,
              color: Colors.white,
              size: 12,
            ),
          ),
        ],
      ),
    );
  }
}
