import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tagge_map/Widgets/Search/locationContainer.dart';
import 'package:tagge_map/Widgets/Search/searchW.dart';
import 'package:http/http.dart' as http;

class SearchLocation extends StatefulWidget {
  final ValueChanged<String> onChanged;

  SearchLocation({this.onChanged}) : super();

  @override
  _SearchLocationState createState() => _SearchLocationState();
}

class _SearchLocationState extends State<SearchLocation> {
  List<LocationContainer> locatii = [];
  String location;

  _SearchLocationState() {
    String s;
    getLocationList(s);
  }

  void getLocationList(String s) async {
    final isUser = await http.post(
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?key=KEY&location=44.4530661,26.0430685&radius=500000&fields=name,formatted_address&keyword=' +
            s,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: "");
    Map<String, dynamic> r = jsonDecode(isUser.body);
    print(r);
    List<LocationContainer> newlocatii = [];
    for (var i = 0; i < r['results'].length; i++) {
      final locationID = await http.post(
          'https://maps.googleapis.com/maps/api/place/details/json?place_id=' +
              r['results'][i]['place_id'] +
              '&key=KEY',
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: "");

      Map<String, dynamic> a = jsonDecode(locationID.body);
      r['results'][i]['formatted_address'] = a['result']['formatted_address'];
      print('searchresult-------------------------------');
      print(a);
      print("LOOOOOOOOOOOOOOOOOOOOOOCATION");
      print(a['result']);
      newlocatii.add(LocationContainer(r['results'][i]));
    }
    setState(() {
      locatii = newlocatii;
    });
  }

  TextEditingController searchController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      // appBar: AppBar(
      //   title: Container(
      //     height: 42,
      //     width: 0.9 * MediaQuery.of(context).size.width,
      //     child: TextField(
      //       controller: searchController,
      //       decoration: InputDecoration(
      //         hintText: 'Enter name place',
      //         hintStyle: TextStyle(
      //           color: Color(0xFF757575),
      //           fontSize: 16,
      //         ),
      //         suffix: InkWell(
      //           onTap: () {
      //             location = searchController.text;
      //             getLocationList(location);
      //           },
      //           child: Padding(
      //             padding: const EdgeInsets.only(right: 8.0),
      //             child: Icon(
      //               Icons.search,
      //               color: Color(0xFF757575),
      //             ),
      //           ),
      //         ),
      //         // border: OutlineInputBorder(
      //         //   borderRadius: BorderRadius.circular(30),
      //         // ),
      //         // focusedBorder: OutlineInputBorder(
      //         //   borderRadius: BorderRadius.circular(30),
      //         // ),
      //         contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
      //         // fillColor: Color(0xFFEEEEEE),
      //         // filled: true,
      //       ),
      //       onSubmitted: (String s) {
      //         setState(() {
      //           location = s;
      //           getLocationList(location);
      //           print(location);
      //         });
      //       },
      //     ),
      //   ),
      // ),
      body: Center(
        child: Stack(
          children: <Widget>[
            Positioned(
              top: 0,
              left: MediaQuery.of(context).size.width * .07,
              child: Container(
                margin: EdgeInsets.only(top: 130),
                width: MediaQuery.of(context).size.width * .86,
                height: MediaQuery.of(context).size.height,
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: locatii,
                ),
              ),
            ),
            Positioned(
              top: 0,
              child: Container(
                height: 100,
                width: MediaQuery.of(context).size.width,
                color: Color(0xFF52489C),
                child: Container(
                  padding: EdgeInsets.only(top: 30),
                  child: Text(
                    "FIND A GREAT LOCATION",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 75,
              left: MediaQuery.of(context).size.width * .1,
              right: MediaQuery.of(context).size.width * .1,
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: 2,
                  horizontal: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(5),
                  ),
                  boxShadow: [
                    BoxShadow(
                      spreadRadius: 1,
                      offset: Offset(0, 0),
                      color: Colors.grey[400],
                      blurRadius: 1,
                    )
                  ],
                ),
                width: MediaQuery.of(context).size.width * .8,
                child: TextField(
                  onSubmitted: (String s) {
                    setState(() {
                      location = s;
                      getLocationList(location);
                      print(location);
                    });
                  },
                  controller: searchController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter a search term',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchLocationProvider extends InheritedWidget {
  final Function show;
  final Widget child;
  SearchLocationProvider({this.show, this.child}) : super(child: child);

  static SearchLocationProvider of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(SearchLocationProvider);
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }
}
