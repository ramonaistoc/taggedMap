import 'package:flutter/material.dart';
import 'package:tagge_map/Pages/homePage.dart';
import 'package:tagge_map/Pages/homePage.dart';

class PurpleNavbar extends StatefulWidget {
  @override
  _PurpleNavbarState createState() => _PurpleNavbarState();
}

class _PurpleNavbarState extends State<PurpleNavbar> {
  var _curIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      // padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * .1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          InkWell(
            onTap: () {
              HomeStateProvider.of(context).show("labels");
            },
            child: Container(
              child: Column(
                children: <Widget>[
                  Icon(
                    Icons.label,
                    color: Colors.white,
                    size: 23,
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Filter',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/add');
            },
            child: Container(
              child: Column(
                children: <Widget>[
                  Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 23,
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Add',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              HomeStateProvider.of(context).show("friends");
            },
            child: Container(
              child: Column(
                children: <Widget>[
                  Icon(
                    Icons.people,
                    color: Colors.white,
                    size: 23,
                  ),
                  SizedBox(height: 3),
                  Text(
                    'Following',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/recommandations');
            },
            child: Container(
              child: Column(
                children: <Widget>[
                  Icon(
                    Icons.add_location,
                    color: Colors.white,
                    size: 23,
                  ),
                  SizedBox(height: 3),
                  Text(
                    'Find places',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
    // return BottomNavigationBar(
    //   items: [
    //     BottomNavigationBarItem(
    //         icon: Icon(Icons.label),
    //         title: Text(
    //           'Label',
    //           style:
    //               TextStyle(color: _curIndex == 0 ? Colors.blue : Colors.black),
    //         )),
    //     BottomNavigationBarItem(
    //       icon: Icon(Icons.add),
    //       title: Text(
    //         'Add',
    //         style:
    //             TextStyle(color: _curIndex == 1 ? Colors.blue : Colors.black),
    //       ),
    //     ),
    //     BottomNavigationBarItem(
    //       icon: Icon(Icons.people),
    //       title: Text(
    //         'Friends',
    //         style:
    //             TextStyle(color: _curIndex == 2 ? Colors.blue : Colors.black),
    //       ),
    //     ),
    //   ],
    //   type: BottomNavigationBarType.fixed,
    //   currentIndex: _curIndex,
    //   onTap: (index) {
    //     if (index == 1) {
    //       Navigator.pushNamed(context, '/add');
    //     } else if (index == 0) {
    //       HomeStateProvider.of(context).show("labels");
    //     } else if (index == 2) {
    //       HomeStateProvider.of(context).show("friends");
    //     }
    //     setState(() {
    //       _curIndex = index;
    //     });
    //   },
    // );
  }
}
