import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tagge_map/main.dart';

class Settings3 extends StatelessWidget {
  void deleteUserAccount(String token) async {
    print("user delete");
    final data = await http.post(
      'http://192.168.1.15:5000/deleteuser',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'token': token,
      }),
    );

    if (data.body == 'deleted') {
      print("deleted user");
    } else {
      print("numbers not given");
    }
  }

  @override
  Widget build(BuildContext context) {
    String token = TokenProvider.of(context).getToken();

    return Container(
      margin: EdgeInsets.only(left: 10, right: 10, top: 15),
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          InkWell(
            child: Text(
              "Disconnect",
              style: TextStyle(
                fontSize: 15,
                color: Colors.red,
              ),
            ),
            onTap: () {
              Navigator.pushNamed(context, '/login');
            },
          ),
          SizedBox(height: 10),
          InkWell(
            onTap: () {
              deleteUserAccount(token);
              Navigator.pushNamed(context, '/login');
            },
            child: Text(
              "Delete my account",
              style: TextStyle(
                fontSize: 15,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
