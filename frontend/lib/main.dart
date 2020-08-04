import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:tagge_map/Pages/addTagPage.dart';
import 'package:tagge_map/Pages/editPage.dart';
import 'package:tagge_map/Pages/followRequests.dart';
import 'package:tagge_map/Pages/followersPage.dart';
import 'package:tagge_map/Pages/followingPage.dart';
import 'package:tagge_map/Pages/locationIDpage.dart';
import 'package:tagge_map/Pages/searchFriends.dart';
import 'package:tagge_map/Pages/searchPage.dart';
import 'package:tagge_map/Pages/accountSettingsPage.dart';
import 'package:tagge_map/Pages/appSettingsPage.dart';
import 'package:tagge_map/Pages/connectPage.dart';
import 'package:tagge_map/Pages/homePage.dart';
import 'package:tagge_map/Pages/locationIDpage.dart';
import 'package:tagge_map/Pages/userstagsPage.dart';

import 'Pages/recommandationsPage.dart';
import 'Pages/registerPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String token;
  int id;

  void setToken(String newtoken) {
    setState(() {
      token = newtoken;
      print("NEW TOKEN MAIN");
      print(token);
    });
  }

  String getToken() {
    return token;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {
        '/home': (context) => TokenProvider(
            getToken: getToken,
            setToken: setToken,
            child: Home(ModalRoute.of(context).settings.arguments)),
        '/login': (context) => TokenProvider(
              getToken: getToken,
              setToken: setToken,
              child: Login(),
            ),
        '/add': (context) => SearchLocation(),
        '/addtag': (context) => TokenProvider(
              getToken: getToken,
              setToken: setToken,
              child: AddTagPage(ModalRoute.of(context).settings.arguments),
            ),
        '/appSettings': (context) => AppSettings(),
        '/accountSettings': (context) => TokenProvider(
              getToken: getToken,
              setToken: setToken,
              child: AccountSettings(),
            ),
        '/edit': (context) => TokenProvider(
              getToken: getToken,
              setToken: setToken,
              child: Edit(),
            ),
        '/register': (context) => TokenProvider(
              getToken: getToken,
              setToken: setToken,
              child: Register(),
            ),
        '/addtagpageLocation': (context) => TokenProvider(
              getToken: getToken,
              setToken: setToken,
              child: IdLocationPage(ModalRoute.of(context).settings.arguments),
            ),
        '/searchfriends': (context) => TokenProvider(
              getToken: getToken,
              setToken: setToken,
              child: SearchFriends(),
            ),
        '/followers': (context) => TokenProvider(
              getToken: getToken,
              setToken: setToken,
              child: Followers(),
            ),
        '/following': (context) => TokenProvider(
              getToken: getToken,
              setToken: setToken,
              child: Following(),
            ),
        '/followRequests': (context) => TokenProvider(
              getToken: getToken,
              setToken: setToken,
              child: FollowRequests(),
            ),
        '/recommandations': (context) => TokenProvider(
              getToken: getToken,
              setToken: setToken,
              child: Recommandations(),
            ),
        '/selecttags': (context) => TokenProvider(
              getToken: getToken,
              setToken: setToken,
              child: SelectTags(),
            ),
      },
    );
  }
}

class TokenProvider extends InheritedWidget {
  Function getToken;
  Function setToken;

  final Widget child;
  TokenProvider({this.getToken, this.setToken, this.child})
      : super(child: child);

  static TokenProvider of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(TokenProvider);
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }
}
