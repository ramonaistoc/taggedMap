import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:http/http.dart' as http;
import 'package:tagge_map/Widgets/Reviews/reviewtag.dart';
import 'package:tagge_map/Widgets/Reviews/searchlocaftertag.dart';

import '../main.dart';

class Recommandations extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Color(0xFF52489C),
//         title: Center(
//             child: Text(
//           "FIND NEW PLACE",
//           style: TextStyle(fontSize: 18),
//         )),
//       ),
//       body: ReviewTag(),
//     );
//   }
// }

  @override
  Widget build(BuildContext context) {
    // String token = TokenProvider.of(context).getToken();
    // recommand(token);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xFF52489C),
            title: Center(
                child: Text(
              'FIND NEW PLACES',
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
              SearchLocationAfterTag(),
              // al doilea tab
              ReviewTag(),
            ],
          )),
    );
  }
}
