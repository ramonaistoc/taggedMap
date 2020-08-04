import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:tagge_map/Pages/accountSettingsPage.dart';
import 'package:tagge_map/main.dart';
import 'package:http/http.dart' as http;

class Settings1 extends StatefulWidget {
  @override
  _Settings1State createState() => _Settings1State();
}

class _Settings1State extends State<Settings1> {
  @override
  Widget build(BuildContext context) {
    String followers = AccountSProvider.of(context).nrfollowers;
    String following = AccountSProvider.of(context).nrfollowing;
    print("from settings 1");
    print(following);
    print(followers);

    return Container(
        margin: EdgeInsets.only(left: 10, right: 10, top: 15),
        child: Column(
          children: <Widget>[
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  InkWell(
                    child: Text(
                      "Following",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey,
                      ),
                    ),
                    onTap: () {},
                  ),
                  Text(
                    // "F",

                    followers,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                    ),
                  ),
                ]),
            SizedBox(
              height: 10,
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  InkWell(
                    child: Text(
                      "Followers",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey,
                      ),
                    ),
                    onTap: () {},
                  ),
                  Text(
                    // "F",

                    following,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                    ),
                  ),
                ]),
            SizedBox(height: 10)
          ],
        ));
  }
}
