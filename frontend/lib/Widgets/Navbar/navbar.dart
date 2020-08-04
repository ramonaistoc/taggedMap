import 'package:flutter/material.dart';
import 'package:tagge_map/Pages/homePage.dart';

class BottomNavbar extends StatefulWidget {
  @override
  _BottomNavbarState createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  var _curIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
            icon: Icon(Icons.label),
            title: Text(
              'Label',
              style:
                  TextStyle(color: _curIndex == 0 ? Colors.blue : Colors.black),
            )),
        BottomNavigationBarItem(
          icon: Icon(Icons.add),
          title: Text(
            'Add',
            style:
                TextStyle(color: _curIndex == 1 ? Colors.blue : Colors.black),
          ),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people),
          title: Text(
            'Following',
            style:
                TextStyle(color: _curIndex == 2 ? Colors.blue : Colors.black),
          ),
        ),
      ],
      type: BottomNavigationBarType.fixed,
      currentIndex: _curIndex,
      onTap: (index) {
        if (index == 1) {
          Navigator.pushNamed(context, '/add');
        } else if (index == 0) {
          HomeStateProvider.of(context).show("labels");
        } else if (index == 2) {
          HomeStateProvider.of(context).show("friends");
        }
        setState(() {
          _curIndex = index;
        });
      },
    );
  }
}

class Navbar extends StatefulWidget {
  @override
  State<Navbar> createState() => NavbarState();
}

class NavbarState extends State<Navbar> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          color: Colors.transparent,
          height: 60,
          width: 0.9 * MediaQuery.of(context).size.width,
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
              bottomLeft: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0),
            ),
            child: BottomNavbar(),
          ),
        )
      ],
    );
  }
}
