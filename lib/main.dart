import 'dart:convert';

import 'package:database/adminpage.dart';
import 'package:database/memberpage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ConnectDatabase(),
    theme: ThemeData(),
    routes: <String,WidgetBuilder>{
      '/AdminPage' : (BuildContext context) => new AdminPage(),
      '/MemberPage' : (BuildContext context) => new MemberPage(),
      
       
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
  
  String msg='';
  
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
    final response = await http.post("http://172.16.141.33/Flutter/login.php",
        body: {
        "email": email, 
        "password": password 
        });

    var data = jsonDecode(response.body);    

    int value = data['value'];
    String pesan = data['message'];
    // String password = data['password'];
    String emailAPI = data['email'];
    int level = data['level'];
    // int id = data['id'];
    // print(data.toString());
    if (value == 1) {
      setState(() {
        _loginStatus = LoginStatus.signIn;
        // savePref(value, emailAPI, namaAPI, id);
        if(data['level']==1){
        print("welcome Favian");
      } else if (data['level']==2){
        print("welcome mir");
      }
      });
      // print(data[0]['level'].toString());
      // print(level);
      print(pesan);
      print(emailAPI);
      print(password);
    } else {
      print(pesan);
      print(emailAPI);
      print(password);
    }
  }


  savePref(int value, String email, String nama, String id) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", value);
      preferences.setString("nama", nama);
      preferences.setString("email", email);
      preferences.setString("id", id);
      preferences.commit();
    });
  }

  var value;
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      value = preferences.getInt("value");

      _loginStatus = value == 1 ? LoginStatus.signIn : LoginStatus.notSignIn;
    });
  }

  signOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", null);
      preferences.commit();
      _loginStatus = LoginStatus.notSignIn;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    switch (_loginStatus) {
      case LoginStatus.notSignIn:
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

                Text(msg,style: TextStyle(fontSize: 20, color: Colors.red),)
              ],
            ),
          ),
        );
        break;
      case LoginStatus.signIn:
        return MainMenu(signOut());
        break;
    }
  }
}

class MainMenu extends StatefulWidget {
  final VoidCallback signOut;
  MainMenu(this.signOut);
  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
 signOut() {
   setState(() {
     widget.signOut();
   });
 }

 getPref() async {
   SharedPreferences preferences = await SharedPreferences.getInstance();
   setState(() {
    //  email = preferences.getString("email");
    //  nama = preferences.getString("nama");
   });
 }

 @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
  }

  Widget build (BuildContext context){
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
         title: Text("Halaman Dashboard"),
         actions: <Widget>[
           IconButton(
             onPressed: () {
               signOut();
             },
             icon: Icon(Icons.lock_open),
           )
         ],
        
        ),

        body: Center(
         child: Text(
           "Dashboard"
         )
       )

      ),
      
      );
  }



}

