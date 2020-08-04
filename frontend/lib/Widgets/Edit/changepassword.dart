import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:pointycastle/export.dart' as pc;
import '../../main.dart';
import 'package:http/http.dart' as http;
import 'package:tagge_map/Widgets/Edit/dataEdit.dart';

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  GlobalKey<FormState> formKey = GlobalKey();

  bool validate = false;
  String current_pasword = "";
  String new_password = "";
  String confirm_new_password = "";
  bool current_pass_validate = false;
  int ap = 0;
  String dbpass = "";
  TextEditingController newpassController = new TextEditingController();

  void checkPassword(String t) async {
    print(t);
    final register = await http.post(
      'http://192.168.1.15:5000/correctcurrentpassword',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'token': t,
      }),
    );
    Map<String, dynamic> r = jsonDecode(register.body);

    print(register.body);

    if (r['result'] == 'yes') {
      print("hereee");

      setState(() {
        dbpass = r['password'];
        print(dbpass);
      });
    } else {
      print('something wrong');
    }
  }

  void updatePassword(String password, String t) async {
    print("updatepass");
    var bytes = utf8.encode(password);
    // data being hashed
    var digest = sha1.convert(bytes);

    String s = digest.toString();
    print(s);
    // String t = TokenProvider.of(context).getToken();
    final register = await http.post(
      'http://192.168.1.15:5000/updatepassword',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'password': s,
        'token': t,
      }),
    );
    print(register.body);
    if (register.body == "changed") {
      print("changed");
    } else {
      print("error changing");
    }
  }

  bool obscuretext = true;
  bool obscuretext1 = true;
  bool obscuretext2 = true;

  void _toggle() {
    setState(() {
      obscuretext = !obscuretext;
    });
  }

  void _toggle1() {
    setState(() {
      obscuretext1 = !obscuretext1;
    });
  }

  void _toggle2() {
    setState(() {
      obscuretext2 = !obscuretext2;
    });
  }

  String t;
  @override
  Widget build(BuildContext context) {
    t = EditProvider2.of(context).token;
    // String t = TokenProvider.of(context).getToken();
    // fac rost de parola ccriptata de la inceput
    print("tooooooooooooooooooooooooooook");
    print(t);
    if (ap == 0) {
      ap = 1;
      checkPassword(t);
    }
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0)), //this right here
      child: Form(
        key: formKey,
        child: Container(
          height: 350,
          width: 0.9 * MediaQuery.of(context).size.width,
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Change your password",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 220,
                    child: TextFormField(
                      obscureText: obscuretext,
                      cursorColor: Colors.purple,
                      autovalidate: validate,
                      validator: cpValidator,
                      onSaved: (String val) {
                        current_pasword = val;
                      },
                      decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.purple),
                          ),
                          hintText: "Current password",
                          hintStyle: TextStyle(color: Colors.blueGrey)),
                    ),
                  ),
                  Container(
                    width: 50,
                    child: FlatButton(
                      onPressed: _toggle,
                      // child: new Text(obscuretext ? "Show" : "Hide")
                      child: Icon(obscuretext == true
                          ? Icons.visibility
                          : Icons.visibility_off),
                    ),
                  )
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: <Widget>[
                  Container(
                    width: 220,
                    child: TextFormField(
                      obscureText: obscuretext1,
                      controller: newpassController,
                      cursorColor: Colors.purple,
                      autovalidate: validate,
                      validator: passwordValidator,
                      onSaved: (String val) {
                        setState(() {
                          new_password = val;
                        });
                      },
                      decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.purple),
                          ),
                          hintText: "New password",
                          hintStyle: TextStyle(color: Colors.blueGrey)),
                    ),
                  ),
                  Container(
                    width: 50,
                    child: FlatButton(
                      onPressed: _toggle1,
                      // child: new Text(obscuretext ? "Show" : "Hide")
                      child: Icon(obscuretext1 == true
                          ? Icons.visibility
                          : Icons.visibility_off),
                    ),
                  )
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: <Widget>[
                  Container(
                    width: 220,
                    child: TextFormField(
                      obscureText: obscuretext2,
                      cursorColor: Colors.purple,
                      autovalidate: validate,
                      validator: (String value) {
                        print("confpaasssssssssssss");
                        print(value);
                        print("newww");
                        print(
                            newpassController.text); //aici nu are new password
                        if (value != newpassController.text)
                          return "Passwords don't match";

                        return null;
                      },
                      onSaved: (String val) {
                        confirm_new_password = val;
                      },
                      decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.purple),
                          ),
                          hintText: "Confirm new password",
                          hintStyle: TextStyle(color: Colors.blueGrey)),
                    ),
                  ),
                  Container(
                    width: 50,
                    child: FlatButton(
                      onPressed: _toggle2,
                      // child: new Text(obscuretext ? "Show" : "Hide")
                      child: Icon(obscuretext2 == true
                          ? Icons.visibility
                          : Icons.visibility_off),
                    ),
                  )
                ],
              ),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FlatButton(
                    color: Color(0xFF52489C),
                    textColor: Colors.white,
                    padding: EdgeInsets.only(
                      left: 5.0,
                      right: 5.0,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    child: Text(
                      "Cancel",
                      style: TextStyle(fontSize: 15.0),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 15),
                    child: FlatButton(
                      color: Color(0xFF52489C),
                      textColor: Colors.white,
                      padding: EdgeInsets.only(
                        left: 5.0,
                        right: 5.0,
                      ),
                      onPressed: () {
                        print("object dsafsdaffffffff");
                        change(t);
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                      child: Text(
                        "Change",
                        style: TextStyle(fontSize: 15.0),
                      ),
                    ),
                  ),
                ],
              ),
              // SizedBox(height: 5),
            ],
          ),
        ),
      ),
    );
  }

  String passwordValidator(String value) {
    String pattern = r'(^[a-zA-Z0-9 ]*$)';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "This field is required";
    } else if (value.length < 3) {
      return 'Name must be more than 2 charater';
    } else if (!regExp.hasMatch(value)) {
      return " Add a-z, A-Z characters and digits";
    }
    return null;
  }

  String cpValidator(String value) {
    var bytes = utf8.encode(value); // data being hashed
    var digest = sha1.convert(bytes);
    String s = digest.toString();
    print("im 1");

    print(s);
    print(dbpass);
    print("im 2");
    if (value.length == 0) {
      return "This field is required";
    } else if (s != dbpass) {
      return "Incorrect password";
    } else if (s == dbpass) return null;

    return null;
  }

  // String confirmPass(String value) {
  //   print("confpaasssssssssssss");
  //   print(value);
  //   print(new_password); //aici nu are new password
  //   if (value != new_password) return "Passwords don't match";

  //   return null;
  // }

  change(String t) {
    if (formKey.currentState.validate()) {
      print("uauauauauauau");
      print(new_password);
      formKey.currentState.save();

      updatePassword(new_password, t);
    } else {
      setState(() {
        validate = true;
      });
    }
  }
}
