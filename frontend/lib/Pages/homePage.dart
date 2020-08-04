import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tagge_map/Widgets/Drawer/drawerBody.dart';
import 'package:tagge_map/Widgets/Navbar/navbar.dart';
import 'package:tagge_map/Widgets/Navbar/label.dart';
import 'package:tagge_map/Widgets/Navbar/friends.dart';
import 'package:tagge_map/Widgets/Drawer/drawerHeader.dart';
import 'package:http/http.dart' as http;
import 'package:tagge_map/Widgets/Navbar/purplenavbar.dart';
import 'package:tagge_map/Widgets/Tags/pinContainer.dart';
import 'package:tagge_map/main.dart';

class Home extends StatefulWidget {
  final dynamic locationArgument;
  Home(this.locationArgument);

  @override
  State<Home> createState() => HomeState(this.locationArgument);
}

class HomeState extends State<Home> {
  final dynamic locationArgument;
  var req = 0;
  List<Marker> allMarkers = [];
  List<String> placeidList = [];
  var fuul = 0;
  List<Marker> markersCopy = [];
  String navbarHelper = "";
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<String> locationsCopy = [];
  var id;
  var placeID;
  Set<int> filteringTags = new Set<int>();
  // Map<String, List<int>> placesWithTags = new Map<String, List<int>>();
  var placesWithTags;
  String global_token;
  String encryptedlocation;
  HomeState(this.locationArgument) {
    this.id = null;
  }
  File image;

//-----------------------------------------------------------------------

  //iau id-ul userului care e logat si apoi in placeidList o sa am place_id urile locatiilor lui
  void getUserPlacesID(String token) async {
    final userID = await http.post(
      'http://192.168.1.15:5000/home',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'token': token,
      }),
    );

    Map<String, dynamic> r = jsonDecode(userID.body);
    print('HOME REQUEEEST');
    print(r);
    locationsCopy = [];
    if (r['success'] == 'yes') {
      for (var i = 0; i < r['placesid'].length; i++) {
        locationsCopy.add(r['placesid'][i]);
      }

      markersCopy = [];
      print(r);
      for (int i = 0; i < locationsCopy.length; i++) {
        final locationID = await http.post(
            'https://maps.googleapis.com/maps/api/place/details/json?place_id=' +
                locationsCopy[i] +
                '&fields=name,geometry&key=yourkey',
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: "");

        Map<String, dynamic> a = jsonDecode(locationID.body);
        print(a);
        print('LOCATIONS COPY[i]');
        print(MarkerId(locationsCopy[i]));
        markersCopy.add(Marker(
            markerId: MarkerId(locationsCopy[i]),
            onTap: () {
              setState(() {
                navbarHelper = "";
              });
              Future.delayed(const Duration(milliseconds: 200), () {
                setState(() {
                  navbarHelper = "location";
                  placeID = locationsCopy[i] + "";
                  print(placeID);
                });
              });
            },
            position: LatLng(a['result']['geometry']['location']['lat'],
                a['result']['geometry']['location']['lng'])));
      }

      setState(() {
        encryptedlocation = r['file_path'];
        // id = r['id'];
        global_token = token;
        id = null;

        placesWithTags = r['places_with_tags'];
        print('PLACES WITH TAGS');
        print(placesWithTags);
        placeidList = locationsCopy;
        allMarkers = markersCopy;
        print("markers");
        print(allMarkers);
        if (encryptedlocation == "")
          image = null;
        else
          stringtofile(encryptedlocation);
      });
    } else {
      print("This user has no location added");
    }
  }

  void getFriendPlacesID(int friendId) async {
    final userID = await http.post(
      'http://192.168.1.15:5000/home_friend',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        // 'token': token,
        'id': friendId.toString()
      }),
    );

    Map<String, dynamic> r = jsonDecode(userID.body);
    print('HOME REQUEEEST');
    print(r);
    locationsCopy = [];
    if (r['success'] == 'yes') {
      for (var i = 0; i < r['placesid'].length; i++) {
        locationsCopy.add(r['placesid'][i]);
      }

      markersCopy = [];
      print(r);
      for (int i = 0; i < locationsCopy.length; i++) {
        final locationID = await http.post(
            'https://maps.googleapis.com/maps/api/place/details/json?place_id=' +
                locationsCopy[i] +
                '&fields=name,geometry&key=yourkey',
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: "");

        Map<String, dynamic> a = jsonDecode(locationID.body);
        print(a);
        print('LOCATIONS COPY[i]');
        print(MarkerId(locationsCopy[i]));
        markersCopy.add(Marker(
            markerId: MarkerId(locationsCopy[i]),
            onTap: () {
              setState(() {
                navbarHelper = "";
              });
              Future.delayed(const Duration(milliseconds: 200), () {
                setState(() {
                  navbarHelper = "location";
                  placeID = locationsCopy[i] + "";
                  print(placeID);
                });
              });
            },
            position: LatLng(a['result']['geometry']['location']['lat'],
                a['result']['geometry']['location']['lng'])));
      }

      setState(() {
        // encryptedlocation = r['file_path'];
        id = friendId;

        placesWithTags = r['places_with_tags'];
        print('PLACES WITH TAGS');
        print(placesWithTags);
        placeidList = locationsCopy;
        allMarkers = markersCopy;
        print("markers");
        print(allMarkers);
        // if (encryptedlocation == "")
        // image = null;
        // else
        // stringtofile(encryptedlocation);
      });
    } else {
      print("This user has no location added");
    }
  }

  void filterLocations(List<int> tags) {
    setState(() {
      filteringTags = Set.from(tags);
    });
  }

  File im2;

  void stringtofile(String s) async {
    im2 = await File(
            '/storage/emulated/0/Android/data/com.example.tagge_map/files/Pictures/profile_picture_!.jpg')
        .writeAsBytes(base64Decode(s).cast<int>()); //asa decotdez

    print("immm2");

    print(im2);

    setState(() {
      image = im2;
    });
  }

  // void getUserID(String token) async {
  //   final userID = await http.post(
  //     'http://192.168.1.15:5000/getuserid',
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //     },
  //     body: jsonEncode(<String, String>{
  //       'token': token,
  //     }),
  //   );

  //   Map<String, dynamic> r = jsonDecode(userID.body);

  //   // print("GETTING USER ID");
  //   // print(r);
  //   if (r['result'] == 'yes') {
  //     setState(() {
  //       encryptedlocation = r['file_path'];
  //       id = r['id'];

  //       if (encryptedlocation == "")
  //         image = null;
  //       else
  //         stringtofile(encryptedlocation);
  //     });
  //   }
  // }

//---------------------------------------------------------------
  void setNavbarHelper(String current) {
    if (navbarHelper == current)
      setState(() {
        navbarHelper = " ";
      });
    else
      setState(() {
        navbarHelper = current;
      });
  }

  void friendsLocations(var currentid) {
    print('CURRENT IFDDDD\n\n\n');
    print(currentid);
    if (currentid == null) {
      getUserPlacesID(global_token);
    } else {
      getFriendPlacesID(currentid);
    }
  }

  bool respectsFilter(marker) {
    return Set.from(placesWithTags[marker.markerId.value])
            .intersection(filteringTags)
            .length ==
        filteringTags.length;
  }

//------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    Widget navbarHelperWidget = new Container();
    String getUserToken = TokenProvider.of(context).getToken();

    if (navbarHelper == 'labels')
      navbarHelperWidget = Labels(id, filterLocations);
    else if (navbarHelper == 'friends')
      navbarHelperWidget = Friends(friendsLocations);
    else if (navbarHelper == 'location') {
      navbarHelperWidget = new MarkContainer(placeID, id);
    }

    // if (req == 0) {
    //   getUserID(getUserToken);
    //   req = 1;
    // }
    String t = TokenProvider.of(context).getToken();
    print("idddlalalala from homepage");
    print(id);
    if (fuul == 0) {
      fuul = 1;
      getUserPlacesID(t);
    }

    // print(" NULL LIST");
    // print(encryptedlocation);
    // print(image);
    return Scaffold(
      key: _scaffoldKey,
      drawer: Container(
        width: 270,
        color: Colors.white,
        child: ListView(
          children: <Widget>[
            //drawer header
            DrawerHead(getUserToken),
            //lista de optiuni
            DrawerBody(),
          ],
        ),
      ),
      body: Stack(
        children: <Widget>[
          Expanded(
            child: GoogleMap(
              // mapType: MapType.satellite,
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                target: LatLng(44.4355, 26.1011),
                zoom: 11,
              ),
              mapToolbarEnabled: false,
              zoomControlsEnabled: false,
              markers: placeidList.length == 0
                  ? Set.from(allMarkers) //null
                  : Set.from(allMarkers.where(respectsFilter)),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * .07,
            left: MediaQuery.of(context).size.width * .75,
            child: GestureDetector(
              onTap: () {
                Future.delayed(const Duration(milliseconds: 600), () {
                  // Navigator.pushNamed(context, '/home');
                  _scaffoldKey.currentState.openDrawer();
                });
              },
              child: Container(
                padding: EdgeInsets.all(6),
                decoration: new BoxDecoration(
                  // color: Colors.white70,
                  color: Color(0xFF52489C),
                  boxShadow: [
                    BoxShadow(
                      spreadRadius: 4,
                      offset: Offset(0, 0),
                      color: Colors.grey[400],
                      blurRadius: 4,
                    )
                  ],
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    // border: Border.all(width: 2),
                  ),
                  width: 60.0,
                  height: 60.0,
                  child: //imagecontainer,
                      image == null
                          ? Container(
                              width: 45,
                              height: 45,
                              decoration: new BoxDecoration(
                                color: Colors.white70,
                                shape: BoxShape.circle,
                                image: new DecorationImage(
                                  fit: BoxFit.fill,
                                  image: new NetworkImage(
                                      "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcS4OWWKtdi__FtY485WKSUD0pBUb5AVSPBXlQ&usqp=CAU"),
                                ),
                              ),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(50.0),
                              child: Image.file(
                                image,
                                fit: BoxFit.fill,
                              ),
                            ),
                ),
              ),
              // child: Icon(
              //   Icons.settings,
              //   color: Colors.white,
              //   size: 30,
              // )
            ),
          ),
          Positioned(
            bottom: 85,
            left: 0.05 * MediaQuery.of(context).size.width,
            right: 0.05 * MediaQuery.of(context).size.width,
            child: Container(
              child: navbarHelperWidget,
              width: 0.9 * MediaQuery.of(context).size.width,
            ),
          ),
          Positioned(
            // bottom: 0.03 * MediaQuery.of(context).size.height,
            // left: 0.05 * MediaQuery.of(context).size.width,
            // right: 0.05 * MediaQuery.of(context).size.width,
            bottom: 0,
            left: 0,
            right: 0,
            child: CustomPaint(
              painter: CurvePainter(),
              child: Container(
                height: 110,
                padding: EdgeInsets.only(top: 55),
                child: HomeStateProvider(
                  show: setNavbarHelper,
                  // child: BottomNavbar(),
                  child: PurpleNavbar(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = Colors.green[800];
    paint.color = Color(0xFF52489C);
    paint.style = PaintingStyle.fill;

    var path = Path();

    print(size);

    path.moveTo(0, size.height);
    path.moveTo(0, 0);
    path.quadraticBezierTo(
        size.width * .04, size.height * .35, size.width * .1, size.height * .4);
    path.lineTo(size.width * (1 - .1), size.height * .4);
    // path.lineTo(size.width, 0);
    path.quadraticBezierTo(
        size.width * (1 - .04), size.height * .35, size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);

    // path.lineTo(0, size.height * 1.5);
    // path.quadraticBezierTo(
    //     size.width * 0.25, size.height, size.width * 0.75, size.height);
    // path.lineTo(size.width * 0.75, size.height);
    // path.quadraticBezierTo(
    //     size.width * 0.75, size.height * 0.9584, size.width * 1.0, size.height);
    // path.lineTo(size.width, size.height);
    // path.lineTo(0, size.height);
    canvas.drawShadow(path.shift(Offset(0, -8)), Colors.black, 2.0, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class HomeStateProvider extends InheritedWidget {
  final Function
      show; // vreau sa imi arate fie containerul cu prieteni fie cu labeluri
  final Widget child;
  HomeStateProvider({this.show, this.child}) : super(child: child);

  static HomeStateProvider of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(HomeStateProvider);
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }
}
