import 'dart:convert';

import 'package:database/SecondScreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    // home: ConnectDatabase(),
    // initialRoute: '/',
    // theme: ThemeData(),
    routes: <String, WidgetBuilder>{
      '/' : ( context) =>  ConnectDatabase(),
      '/second' : (context) => SecondScreen(),
      // '/AdminPage': ( context) =>  AdminPage(),
      // '/MemberPage': ( context) =>  MemberPage(),
    },
  ));
}

class ConnectDatabase extends StatefulWidget {
  @override
  _ConnectDatabaseState createState() => _ConnectDatabaseState();
}

enum LoginStatus { notSignIn, signIn }

class _ConnectDatabaseState extends State<ConnectDatabase> {
  LoginStatus _loginStatus = LoginStatus.notSignIn;
  TextEditingController contEmail = new TextEditingController();
  TextEditingController contPassword = new TextEditingController();

  String msg = '';

  final _key = new GlobalKey<FormState>();

  bool _secureText = true;

  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      login();
    }
  }

  Future<List> login() async {
    String email = contEmail.text;
    String password = contPassword.text;
    final response = await http.post("http://172.20.10.3/Flutter/login.php",
        body: {"email": email, "password": password});

    var data = json.decode(response.body);

    if (data.length == 0) {
      print("login failed");
    } else {
      setState(() {
        //     // _loginStatus = LoginStatus.signIn;
        //     // savePref(value, emailAPI, namaAPI, id);
        if (data[0]['level'] == '1') {
          // return ("welcome");
          // print("welcome Favian");
          // Navigator.pushReplacementNamed(context, ("/AdminPage"));
        } else if (data[0]['level'] == '2') {
          // return ("welcome2");
          // print("welcome mir");
          Navigator.pushNamed(context, '/second');
          // Navigator.pushReplacementNamed(context, "/MemberPage");
        } else {
          print("welocme nope");
        }
      });
    }
    // });
    // print(data[0]['level'].toString());
    // print(level);
    //   print(pesan);
    //   print(emailAPI);
    //   print(password);
    // } else {
    //   print(pesan);
    //   print(emailAPI);
    //   print(password);
    // }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // switch (_loginStatus) {
    //   case LoginStatus.notSignIn:
        return Scaffold(
          appBar: AppBar(
            title: Text('Login'),
          ),
          body: Form(
            key: _key,
            child: ListView(
              padding: EdgeInsets.all(20),
              children: <Widget>[
                TextFormField(
                  controller: contEmail,
                  validator: (e) {
                    if (e.isEmpty) {
                      return "Please Insert Email";
                    }
                  },
                  // onSaved: (e) => email = e,
                  decoration: InputDecoration(labelText: "email"),
                ),
                TextFormField(
                  controller: contPassword,
                  obscureText: _secureText,
                  // onSaved: (e) => password = e,
                  decoration: InputDecoration(
                    labelText: "Password",
                    suffixIcon: IconButton(
                      onPressed: showHide,
                      icon: Icon(_secureText
                          ? Icons.visibility_off
                          : Icons.visibility),
                    ),
                  ),
                ),
                MaterialButton(
                  onPressed: () {
                    login();
                  },
                  child: Text("Login"),
                ),
                Text(
                  msg,
                  style: TextStyle(fontSize: 20, color: Colors.red),
                )
              ],
            ),
          ),
        );
      //   break;
      // case LoginStatus.signIn:
      //   // return MainMenu(signOut());
      //   break;
    
  }
}
