import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:tagge_map/main.dart';
import 'package:geolocator/geolocator.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:pointycastle/export.dart' as pc;
import 'package:crypto/crypto.dart';

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
            focusColor: Colors.pink[50],
            border: InputBorder.none,
            hintText: widget.hintText,
            hintStyle: TextStyle(color: Colors.blueGrey)),
      ),
    );
  }
}

class RegisterContainer extends StatefulWidget {
  @override
  _RegisterContainerState createState() => _RegisterContainerState();
}

class _RegisterContainerState extends State<RegisterContainer> {
  GlobalKey<FormState> formKey = GlobalKey();
  bool showErrorMessage = false;
  bool validate = false;
  String email = "";
  String password = "";
  String fname = "";
  String lname = "";

  void f(String fname, String lname, String email, String password,
      BuildContext context) async {
    var bytes = utf8.encode(password); // data being hashed
    var digest = sha1.convert(bytes);
    print("TYPE");
    print(digest.runtimeType);
    String nul = "";
    String s = digest.toString();
    print(s);
    final register = await http.post(
      'http://192.168.1.15:5000/register',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'first_name': fname,
        'last_name': lname,
        'email': email,
        'password': s,
        'userstags': nul,
      }),
    );
    print(register.body);
    Map<String, dynamic> r = jsonDecode(register.body);

    if (r['success'] == 'yes') {
      print("hereee");
      TokenProvider.of(context).setToken(r['token']);
      Navigator.pushNamed(context, '/selecttags');
    } else {
      setState(() {
        showErrorMessage = true;
      });
      print('something wrong');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Stack(
          children: <Widget>[
            Align(
              // alignment: Alignment.center,
              child: Container(
                margin: EdgeInsets.only(top: 30),
                width: 0.9 * MediaQuery.of(context).size.width,
                height: 0.43 * MediaQuery.of(context).size.height,
                decoration: new BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: new BorderRadius.only(
                        topLeft: const Radius.circular(30.0),
                        topRight: const Radius.circular(30.0),
                        bottomLeft: const Radius.circular(30),
                        bottomRight: const Radius.circular(30))),
                child: Form(
                  key: formKey,
                  child: Container(
                    // margin: EdgeInsets.only(top: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        // Container(child: showErrorMessage == true ? a : t),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.person_outline),
                              SizedBox(width: 10),
                              Container(
                                width: 200,
                                child: TextFormField(
                                  cursorColor: Colors.purple,
                                  // ignore: missing_return
                                  validator: fnameValidator,
                                  // child: TextField(
                                  onSaved: (String val) {
                                    fname = val;
                                  },
                                  autovalidate: validate,
                                  decoration: InputDecoration(
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.purple),
                                      ),
                                      hintText: "First name",
                                      hintStyle:
                                          TextStyle(color: Colors.blueGrey)),
                                ),
                              ),
                            ]),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.person_outline),
                              SizedBox(width: 10),
                              Container(
                                width: 200,
                                child: TextFormField(
                                  cursorColor: Colors.purple,
                                  // ignore: missing_return
                                  validator: lnameValidator,
                                  // child: TextField(
                                  onSaved: (String val) {
                                    lname = val;
                                  },
                                  autovalidate: validate,
                                  decoration: InputDecoration(
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.purple),
                                      ),
                                      hintText: "Last name",
                                      hintStyle:
                                          TextStyle(color: Colors.blueGrey)),
                                ),
                              ),
                            ]),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.mail_outline),
                              SizedBox(width: 10),
                              Container(
                                width: 200,
                                child: TextFormField(
                                  cursorColor: Colors.purple,
                                  validator: emailValidator,
                                  onSaved: (String val) {
                                    email = val;
                                  },
                                  autovalidate: validate,
                                  decoration: InputDecoration(
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.purple),
                                      ),
                                      hintText: "Email",
                                      hintStyle:
                                          TextStyle(color: Colors.blueGrey)),
                                ),
                              ),
                            ]),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.lock_outline),
                              SizedBox(width: 10),
                              Container(
                                width: 200,
                                child: TextFormField(
                                  validator: passwordValidator,
                                  onSaved: (String val) {
                                    password = val;
                                  },
                                  cursorColor: Colors.purple,
                                  autovalidate: validate,
                                  decoration: InputDecoration(
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.purple),
                                      ),
                                      hintText: "Password",
                                      hintStyle:
                                          TextStyle(color: Colors.blueGrey)),
                                  obscureText: true,
                                ),
                              ),
                            ]),
                        SizedBox(height: 10)
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment(0, 0),
              child: Container(
                width: 190,
                margin: EdgeInsets.only(top: 320),
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25),
                        bottomLeft: Radius.circular(25),
                        bottomRight: Radius.circular(25)),
                    gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          Color(0xFAFFC9B5),
                          Color(0xFFF7B1AB),
                          Color(0xFFD8AA96),
                          Color(0xFFC7D3BF),
                        ])),
                child: FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(18.0),
                  ),
                  onPressed: () {
                    check();
                    // f(fname, lname, email, password, context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "Register",
                      style: TextStyle(fontSize: 20, color: Colors.blueGrey),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String fnameValidator(String value) {
    String pattern = r'(^[a-zA-Z]*$)';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "First name is required";
    } else if (!regExp.hasMatch(value)) {
      return "Only a-z, A-Z characters ";
    }
    return null;
  }

  String lnameValidator(String value) {
    String pattern = r'(^[a-zA-Z]*$)';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "Last name is required";
    } else if (value.length < 3) {
      return 'Name must be more than 2 charater';
    } else if (!regExp.hasMatch(value)) {
      return "Only a-z, A-Z characters ";
    }
    return null;
  }

  String passwordValidator(String value) {
    String pattern = r'(^[a-zA-Z0-9 ]*$)';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "Password is required";
    } else if (value.length < 3) {
      return 'Name must be more than 2 charater';
    } else if (!regExp.hasMatch(value)) {
      return " Add a-z, A-Z characters and digits";
    }
    return null;
  }

  String emailValidator(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);

    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return null;
  }

  check() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      f(fname, lname, email, password, context);
    } else {
      setState(() {
        validate = true;
      });
    }
  }
}
