import 'dart:convert';

import 'package:database/Detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:http/http.dart' as http;

class AdminPage extends StatefulWidget {
AdminPage({Key key}) : super(key:key);

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  Icon actionIcon = new Icon(Icons.search);
  Widget appBarTitle = new Text("Admin Page");
  final key = new GlobalKey<ScaffoldState>();
  final TextEditingController _searchQuery = new TextEditingController();
  bool _isSearching = false;
  String _searchText = "";

  _AdminPageState(){
    _searchQuery.addListener((){
      if(_searchQuery.text.isEmpty){
        setState(() {
          _isSearching = false;
          _searchText = "";
        });
      } else {
        setState(() {
          _isSearching = true;
          _searchText = _searchQuery.text;
        });
      }
    });
  }

  void _handleSearchStart(){
    setState(() {
      _isSearching = true;
    });
  }

  void _handleSearchEnd(){
    setState(() {
      this.actionIcon = new Icon(Icons.search, color: Colors.white);
      this.appBarTitle = new Text("Search Sample", style: new TextStyle(color: Colors.white));
      _isSearching = false;
      _searchQuery.clear();
    });
  }

  
  

  Future<List> tampilkanBuku() async {
    // final response = await http.post("http://172.20.10.3/Flutter/buku.php");
    final response = await http.get("https://jsonplaceholder.typicode.com/posts");
    var ha = json.decode(response.body);
    //   return json.decode(response.body);
    return (ha);
  }

  Future<List> tampilBuku() async {
    // final response = await http.post("http://172.20.10.3/Flutter/buku.php");
    final response = await http.get("https://jsonplaceholder.typicode.com/posts");
    var ha = json.decode(response.body);
    
    if(_searchText.isEmpty){
      return ha;
    } else {
      List <String> _searchList = List();
      for(int i = 0; i < ha.length; i++){
        String name = ha.elementAt(i);
        if(name.toLowerCase().contains(_searchText.toLowerCase())){
          _searchList.add(name);
          ha.toString().contains(_searchText.toLowerCase());
        } 
      }
      return ha;
    }

  }



  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: key,
      appBar: AppBar(
        centerTitle: true,
        title: appBarTitle,
        actions: <Widget>[
          new IconButton(icon: actionIcon, onPressed: (){
            setState(() {
              if(this.actionIcon.icon == Icons.search){
                this.actionIcon = new Icon(Icons.close);
                this.appBarTitle = new TextField(
                  controller: _searchQuery,
                  autofocus: true,
                  style: new TextStyle(
                    color: Colors.white,
                  ),
                  decoration: new InputDecoration(
                    prefixIcon: new Icon(Icons.search, color: Colors.white),
                    hintText: "Search...",
                    hintStyle: new TextStyle(color: Colors.white)
                  ),
                );
                _handleSearchStart();
              } else {
                _handleSearchEnd();
                this.actionIcon = new Icon(Icons.search);
                this.appBarTitle = new Text("Admin Page");
              }
            });
          },)
        ],
      ),
      body: new FutureBuilder<List>(
        future: _isSearching ? tampilBuku() : tampilkanBuku(),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);

          return snapshot.hasData
              ? new ItemList(
                  list: snapshot.data,
                )
              : new Center(
                  child: new CircularProgressIndicator(),
                );
        },
        
      ),
    );
  }

  List<ItemList> _buildList(){
    
  }

}

class ItemList extends StatelessWidget {
  final List list;
  ItemList({this.list});

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      itemCount: list == null ? 0 : list.length,
      itemBuilder: (context, i) {
        return new GestureDetector(
          onTap: () => Navigator.of(context).push(new MaterialPageRoute(
              builder: (BuildContext context) =>
                  new Detail(list: list, index: i))),
          child: Card(
            child: new ListTile(
              title: Text(list[i]['title']),
              leading: new Icon(Icons.book),
              subtitle: Text("Jumlah Buku = ${list[i]['id']}"),
            ),
          ),
        );
      },
      
    );

    // ]);
  }
}

// class Post {
//   final int userId;
//   final int id;
//   final String title;
//   final String body;

//   Post({this.userId, this.id, this.title, this.body});

//   factory Post.fromJson(Map<String, dynamic> json) {
//     return Post(
//       userId: json['userId'],
//       id: json['id'],
//       title: json['title'],
//       body: json['body'],
//     );
//   }
// }