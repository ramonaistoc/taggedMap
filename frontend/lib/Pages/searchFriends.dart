import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tagge_map/Widgets/Search/searchFriendsContainer.dart';
import 'package:tagge_map/Widgets/SearchFriends/recommendedpeople.dart';
import 'package:tagge_map/Widgets/SearchFriends/searchfriends.dart';
import 'package:tagge_map/main.dart';

class SearchFriends extends StatefulWidget {
  @override
  _SearchFriendsState createState() => _SearchFriendsState();
}

class _SearchFriendsState extends State<SearchFriends> {
  // TextEditingController friendController = new TextEditingController();

  // List<FriendsContainer> searchedPersons = [];
  // List<int> requestedusers =
  //     []; // aici sunt persoanele catre care deja e trimisa cererea de urmarire

  // void getPersonList(String token, String name) async {
  //   print("searched friendddss");
  //   final isUser = await http.post(
  //     'http://192.168.1.15:5000/searchfriends',
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //     },
  //     body: jsonEncode(<String, String>{
  //       'name': name,
  //       'token': token,
  //     }),
  //   );
  //   Map<String, dynamic> r = jsonDecode(isUser.body);
  //   print(r);
  //   //aici iau lista id urilor persoanelor pe care utilizatorul le urmareste
  //   List<int> copy = [];

  //   for (var i = 0; i < r['requested_users'].length; i++) {
  //     copy.add(r['requested_users'][i]);
  //   }
  //   //dau lista cu persoanele cautate
  //   List<FriendsContainer> fcopy = [];
  //   for (var i = 0; i < r['list'].length; i++) {
  //     fcopy.add(FriendsContainer(r['list'][i], copy));
  //   }

  //   if (r['result'] == 'yes') {
  //     // print("frineds list here");
  //     // print(r['list']); //copie a listei cu utilizatorii urmariti

  //     setState(() {
  //       searchedPersons = fcopy;
  //       requestedusers = copy;
  //       print(requestedusers);
  //     });
  //   } else {
  //     print(" NO RESULT");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    String token = TokenProvider.of(context).getToken();
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xFF52489C),
            title: Center(
                child: Text(
              'FIND PEOPLE',
              // style: TextStyle(fontFamily: 'DancingScript'),
            )),
            bottom: TabBar(
              indicatorColor: Colors.transparent,
              tabs: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Icon(Icons.search),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Icon(Icons.trending_up),
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              SearchedFriends(),
              // al doilea tab
              RecommendedPeople(),
            ],
          )),
    );
    //   body: Center(
    //     child: Stack(
    //       children: <Widget>[
    //         Positioned(
    //           top: 15,
    //           left: MediaQuery.of(context).size.width * .07,
    //           child: Container(
    //             margin: EdgeInsets.only(top: 100),
    //             width: MediaQuery.of(context).size.width * .86,
    //             height: MediaQuery.of(context).size.height,
    //             child: ListView(
    //               children: searchedPersons,
    //             ),
    //           ),
    //         ),
    //         Positioned(
    //           top: 0,
    //           child: Container(
    //             height: 100,
    //             width: MediaQuery.of(context).size.width,
    //             color: Color(0xFF52489C),
    //             child: Container(
    //               padding: EdgeInsets.only(top: 30),
    //               child: Text(
    //                 "FIND FRIENDS",
    //                 textAlign: TextAlign.center,
    //                 style: TextStyle(
    //                   color: Colors.white,
    //                   fontWeight: FontWeight.bold,
    //                   fontSize: 15,
    //                 ),
    //               ),
    //             ),
    //           ),
    //         ),
    //         Positioned(
    //           top: 75,
    //           left: MediaQuery.of(context).size.width * .1,
    //           right: MediaQuery.of(context).size.width * .1,
    //           child: Container(
    //             padding: EdgeInsets.symmetric(
    //               vertical: 2,
    //               horizontal: 10,
    //             ),
    //             decoration: BoxDecoration(
    //               color: Colors.white,
    //               borderRadius: BorderRadius.all(
    //                 Radius.circular(5),
    //               ),
    //               boxShadow: [
    //                 BoxShadow(
    //                   spreadRadius: 1,
    //                   offset: Offset(0, 0),
    //                   color: Colors.grey[400],
    //                   blurRadius: 1,
    //                 )
    //               ],
    //             ),
    //             width: MediaQuery.of(context).size.width * .8,
    //             child: TextField(
    //               onSubmitted: (String s) {
    //                 print(s);
    //                 getPersonList(token, s);
    //               },
    //               controller: friendController,
    //               decoration: InputDecoration(
    //                 border: InputBorder.none,
    //                 hintText: 'Enter friend name ',
    //               ),
    //             ),
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
}

class FriendsProvider extends InheritedWidget {
  List<int> requestedP;
  final Widget child;
  FriendsProvider({this.requestedP, this.child}) : super(child: child);

  static FriendsProvider of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(FriendsProvider);
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }
}
