import 'package:flutter/material.dart';
import 'package:tagge_map/Widgets/SeparatorLine.dart';

class LocationContainer extends StatelessWidget {
  final dynamic location;
  LocationContainer(this.location);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/addtag', arguments: location);
      },
      child: Container(
        decoration: BoxDecoration(
          // color: Color(0x88F4D35E),
          color: Colors.pink[50],
          borderRadius: new BorderRadius.all(
            Radius.circular(20.0),
          ),
        ),
        alignment: Alignment.centerLeft,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(
          top: 20,
          // left: 20,
        ),
        padding: EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              location['name'],
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(location['formatted_address']),
            // SeparatorLine(),
          ],
        ),
      ),
    );
  }
}
