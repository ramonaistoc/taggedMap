import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:tagge_map/main.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:pointycastle/export.dart' as pc;
import 'package:crypto/crypto.dart';

class LoginContainer extends StatefulWidget {
  @override
  _LoginContainerState createState() => _LoginContainerState();
}

class _LoginContainerState extends State<LoginContainer> {
  // final emailController = TextEditingController();
  // final passwordController = TextEditingController();
  bool showErrorMessage = false;

  void f(String e, String p, BuildContext context) async {
    var bytes = utf8.encode(p); // data being hashed
    var digest = sha1.convert(bytes);
    String s = digest.toString();
    print(s);

    final isUser = await http.post(
      'http://192.168.1.15:5000/login',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': e,
        'password': s,
      }),
    );

    Map<String, dynamic> r = jsonDecode(isUser.body);

    if (r['success'] == 'yes') {
      print("TOKEN DIN CONNECTPAGE");
      print(r['token']);
      TokenProvider.of(context).setToken(r['token']);
      print("here  i am");
      showErrorMessage = false;

      Navigator.pushNamed(context, '/home');
    } else {
      setState(() {
        showErrorMessage = true;
      });
      print('ID SI PAROLA NU SUNT BUNE');
    }
  }

  GlobalKey<FormState> formKey = GlobalKey();

  bool validate = false;
  String email = "";
  String password = "";
  Text a = new Text("Incorrect email or password",
      style: TextStyle(color: Colors.red));
  Text t = new Text("");

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: Container(
                padding: EdgeInsets.only(top: 30),
                margin: EdgeInsets.only(top: 20),
                width: 0.9 * MediaQuery.of(context).size.width,
                height: 0.28 * MediaQuery.of(context).size.height,
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
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(child: showErrorMessage == true ? a : t),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.mail_outline),
                              SizedBox(width: 10),
                              Container(
                                width: 200,
                                child: TextFormField(
                                  cursorColor: Colors.purple,
                                  autovalidate: validate,
                                  validator: emailValidator,
                                  onSaved: (String val) {
                                    email = val;
                                  },
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
                                  cursorColor: Colors.purple,
                                  // ignore: missing_return
                                  validator: passwordValidator,
                                  // child: TextField(
                                  onSaved: (String val) {
                                    password = val;
                                  },
                                  autovalidate: validate,
                                  obscureText: true,
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
                                ),
                              ),
                            ]),
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
                margin: EdgeInsets.only(top: 190),
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
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "Login",
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

  String passwordValidator(String value) {
    String pattern = r'(^[a-zA-Z0-9 ]*$)';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "Password is required";
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
      //    If all data are correct then save data to out variables
      formKey.currentState.save();
      showErrorMessage = false;
      f(email, password, context);
    } else {
      setState(() {
        validate = true;
      });
    }
  }
}
