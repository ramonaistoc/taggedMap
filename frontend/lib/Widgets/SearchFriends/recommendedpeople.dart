import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:tagge_map/Widgets/Search/searchFriendsContainer.dart';
import 'package:tagge_map/Widgets/SearchFriends/recommendedpeoplecontainer.dart';
import 'package:tagge_map/main.dart';

class RecommendedPeople extends StatefulWidget {
  @override
  _RecommendedPeopleState createState() => _RecommendedPeopleState();
}

class _RecommendedPeopleState extends State<RecommendedPeople> {
  List<RecContainer> searchedPersons = [];

  List<String> usernames = [];
  List<String> places = [];

  void getPersonList(String token) async {
    print("recommendeed peopleee haeiofoasdfjoas;dfj;o");
    final isUser = await http.post(
      'http://192.168.1.15:5000/recommendedpeople',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'token': token,
      }),
    );
    Map<String, dynamic> r = jsonDecode(isUser.body);
    print(r);

    List<String> ucopy = [], pcopy = [];

    if (r['response'] == 'yes') {
      print("worked");
      print(r['usernames'].length);
      print(r['places'].length);
      print(r['usernames'][0]);
      print(r['places'][0]);

      for (var i = 0; i < r['usernames'].length; i++) {
        print(r['usernames'][i]);
        ucopy.add(r['usernames'][i]);
        pcopy.add(r['places'][i].toString());
      }
      print(ucopy);

      setState(() {
        usernames = ucopy;
        places = pcopy;

        for (var i = 0; i < r['usernames'].length; i++) {
          print('dinsuper_for');
          print(ucopy[i]);
          print(i);
          searchedPersons.add(RecContainer(ucopy[i], pcopy[i]));
        }
        getPeople = 1;
      });
    } else {
      print(" NO RESULT");
    }
  }

  int getPeople = 0;
  String token;
  @override
  Widget build(BuildContext context) {
    token = TokenProvider.of(context).getToken();

    if (getPeople == 0) {
      getPersonList(token);
    }

    print("here");
    print(searchedPersons);
    return Container(
      margin: EdgeInsets.only(top: 10, left: 10, right: 10),
      width: MediaQuery.of(context).size.width * .86,
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        child: Column(
          // scrollDirection: Axis.vertical,
          children: searchedPersons,
        ),
      ),
    );
  }
}
