import 'package:flutter/material.dart';

class Detail extends StatefulWidget {
  List list;
  int index;
  Detail({this.index, this.list});

  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("${widget.list[widget.index]['judul']}"),
      ),
      backgroundColor: Colors.lightBlueAccent,
      body: new Container(
        padding: const EdgeInsets.all(27.0),
        child: new Card(
          child: new Column(
            children: <Widget>[
              Container(
                height: 20.0,
              ),
              Text(
                widget.list[widget.index]['judul'],
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              Container(
                height: 20.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Card(
                      child: Column(
                    children: <Widget>[
                      new Text("Kota Terbit ",style: TextStyle(color: Colors.deepOrange)),
                      new Text(" ${widget.list[widget.index]['kota_terbit']} ")
                    ],
                  )),
                  Card(
                    child: Column(
                      children: <Widget>[
                         new Text("Cetakan Ke",style: TextStyle(color: Colors.deepOrange)),
                         new Text(" ${widget.list[widget.index]['cetakan_ke']}"),
                      ],
                    )
                   
                        
                  ),
                  Card(
                    child: Column(
                      children: <Widget>[
                        new Text("Jumlah Halaman",style: TextStyle(color: Colors.deepOrange)),
                        new Text("Jumlah Halaman ${widget.list[widget.index]['jumlah_halaman']}"),
                      ],
                    )
                    
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
