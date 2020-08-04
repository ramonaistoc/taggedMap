import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:tagge_map/Widgets/Connect/loginContainer.dart';
import 'package:tagge_map/Widgets/Connect/registerContainer.dart';
import 'package:tagge_map/main.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'dart:io';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class Input extends StatefulWidget {
  final String hintText;
  TextEditingController myController;

  Input(this.hintText, this.myController);

  @override
  _InputState createState() => _InputState();
}

class _InputState extends State<Input> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      child: TextField(
        controller: widget.myController,
        decoration: InputDecoration(
            border: new UnderlineInputBorder(),
            hintText: widget.hintText,
            hintStyle: TextStyle(color: Colors.blueGrey)),
      ),
    );
  }
}

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  List<bool> isSelected = [true, false]; //, (_) => false);
  StatefulWidget log = LoginContainer();
  StatefulWidget reg = RegisterContainer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Container(
          width: 1 * MediaQuery.of(context).size.width,
          height: 1 * MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                Color(0xFAFFC9B5),
                Color(0xFFF7B1AB),
                Color(0xFFD8AA96),
                Color(0xFFC7D3BF),
              ])),
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 10),
                width: 0.3 * MediaQuery.of(context).size.width,
                height: 0.2 * MediaQuery.of(context).size.height,
                child: Image.asset(
                  'assets/images/logo.png',
                  // width: 100,
                  // height: 100,
                ),
              ),
              Container(
                padding: EdgeInsets.zero,
                decoration: BoxDecoration(
                  color: Color(0x40616161),
                  border: Border.all(
                    color: Color(0x40616161),
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                ),
                child: ToggleButtons(
                  renderBorder: false,
                  selectedColor: Colors.grey,
                  fillColor: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                      bottomLeft: Radius.circular(25),
                      bottomRight: Radius.circular(25)),
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 30, right: 27),
                      child: Text(
                        "Login",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.blueGrey,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 22, right: 22),
                      child: Text(
                        "Register",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.blueGrey,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                  isSelected: isSelected,
                  onPressed: (int index) {
                    setState(() {
                      isSelected[index] = !isSelected[index];
                      if (index == 0)
                        isSelected[1] = false;
                      else
                        isSelected[0] = false;
                      print(isSelected);
                    });
                  },
                ),
              ),
              isSelected[0] == true ? log : reg,
            ],
          ),
        ),
      ),
    );
  }
}
