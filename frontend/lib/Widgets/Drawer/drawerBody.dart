import 'package:flutter/material.dart';

import '../SeparatorLine.dart';

class DrawerBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SeparatorLine(),
        SizedBox(height: 60),
        // InkWell(
        //   child: Text(
        //     "Application Settings",
        //     style: TextStyle(
        //       fontSize: 15,
        //       color: Colors.grey,
        //     ),
        //     textAlign: TextAlign.left,
        //   ),
        //   onTap: () {
        //     Navigator.of(context).pushNamed("/appSettings");
        //   },
        // ),
        // SizedBox(height: 15),
        InkWell(
          child: Text(
            "Account Settings",
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey,
            ),
            textAlign: TextAlign.left,
          ),
          onTap: () {
            Future.delayed(const Duration(milliseconds: 600), () {
              // Navigator.pushNamed(context, '/home');
              Navigator.of(context).pushNamed("/accountSettings");
            });
          },
        ),
        SizedBox(
          height: 15,
        ),
        InkWell(
          child: Text(
            "Followers",
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey,
            ),
            textAlign: TextAlign.left,
          ),
          onTap: () {
            Navigator.of(context).pushNamed("/followers");
          },
        ),
        SizedBox(
          height: 15,
        ),
        InkWell(
          child: Text(
            "Following",
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey,
            ),
            textAlign: TextAlign.left,
          ),
          onTap: () {
            Navigator.of(context).pushNamed("/following");
          },
        ),
        SizedBox(
          height: 15,
        ),
        InkWell(
          child: Text(
            "Follow requests",
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey,
            ),
            textAlign: TextAlign.left,
          ),
          onTap: () {
            Navigator.of(context).pushNamed("/followRequests");
          },
        ),
        SizedBox(
          height: 15,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.arrow_back),
            InkWell(
              child: Text(
                "Log out",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey,
                ),
              ),
              onTap: () {
                //vreu ca atunci cand dau pe log out sa fiu redirectionata catre pagina de login dar am eroare cand fac asta why
                Navigator.of(context).pushNamed("/login");
              },
            ),
          ],
        ),
      ],
    );
  }
}
