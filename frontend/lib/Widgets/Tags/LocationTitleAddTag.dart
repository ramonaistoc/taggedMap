import 'package:flutter/material.dart';

class LocationTitle extends StatelessWidget {
  final dynamic location;
  LocationTitle(this.location);
  var p;
  @override
  Widget build(BuildContext context) {
    if (location['phcopy'] == null) {
      p = location['photos'][0]['photo_reference'];
    } else
      p = location['phcopy'];

    print("location frome herereee");
    print(p);
    return Column(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.width * 3 / 4,
          decoration: new BoxDecoration(
            image: new DecorationImage(
              fit: BoxFit.fill,
              image: p == null
                  ? Text("No image to show")
                  : new NetworkImage(
                      "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=" +
                          p +
                          "&key=KEY"),
            ),
          ),
        ),
        SizedBox(height: 20),
        Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.only(
            left: 20,
            right: MediaQuery.of(context).size.width * .2,
          ),
          child: Text(
            location['name'].toUpperCase(),
            textAlign: TextAlign.left,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        SizedBox(height: 5),
        Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.only(
            left: 20,
            right: MediaQuery.of(context).size.width * .2,
          ),
          child: Text(
            location['formatted_address'],
            textAlign: TextAlign.left,
            style: TextStyle(
              color: Colors.black54,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}
