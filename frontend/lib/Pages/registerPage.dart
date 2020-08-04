import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tagge_map/main.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

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
      width: 250,
      child: TextField(
        controller: widget.myController,
        decoration: InputDecoration(
          border: new UnderlineInputBorder(),
          hintText: widget.hintText,
        ),
      ),
    );
  }
}

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  final fNameController = TextEditingController();

  final lNameController = TextEditingController();

  void f(String fname, String lname, String email, String password,
      BuildContext context) async {
    final register = await http.post(
      'http://192.168.1.15:5000/register',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'first_name': fname,
        'last_name': lname,
        'email': email,
        'password': password,
      }),
    );
    print(register.body);
    Map<String, dynamic> r = jsonDecode(register.body);

    if (r['success'] == 'yes') {
      print("hereee");
      TokenProvider.of(context).setToken(r['token']);
      Navigator.pushNamed(context, '/home');
    }
  }

  void encryptedPassword(String password) {
    // final key = encrypt.Key.fromUtf8('my32lengthsupersecretnooneknows1');
    final key = encrypt.Key.fromUtf8('hy97BMZjhbDyjSuRTkuRCi6vSncCqGne');
    final iv = encrypt.IV.fromLength(16);

    final encrypter = encrypt.Encrypter(encrypt.AES(key));

    final encrypted = encrypter.encrypt(password, iv: iv);
    final decrypted = encrypter.decrypt(encrypted, iv: iv);
    print("TYPE");
    print(encrypted.runtimeType);

    print(decrypted); // Lorem ipsum dolor sit amet, consectetur adipiscing elit
    print(encrypted
        .base64); // R4PxiU3h8YoIRqVowBXm36ZcCeNeZ4s1OvVBTfFlZRdmohQqOpPQqD1YecJeZMAop/hZ4OxqgC1WtwvX/hP9mw==

    setState(() {
      password = encrypted.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Input('First name', fNameController),
            SizedBox(height: 10),
            Input('Last name', lNameController),
            SizedBox(height: 10),
            Input('Email', emailController),
            SizedBox(height: 10),
            Input('Password', passwordController),
            SizedBox(height: 30),
            RaisedButton(
              color: Colors.blue,
              shape: StadiumBorder(),
              onPressed: () {
                f(fNameController.text, lNameController.text,
                    emailController.text, passwordController.text, context);
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: const Text(
                  'Register',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
