import 'package:door_opener/log_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Door Opener',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Door Opener'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);


  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final databaseReference = FirebaseDatabase.instance.reference();
  List<Log> logs = new List();
  
  // Retrive the list of logs when the user open door
  void getList() async{
    await databaseReference.child("Images").once().then((DataSnapshot dataSnapshot){
        this.setState((){
          for(var value in dataSnapshot.value.values) {
          logs.add(new Log.fromJson(value));
          }
        });
    });
  }
  // delete data in user's end is a good idea??
  void deleteData(){
    databaseReference.child('flutterDevsTeam1').remove();
    databaseReference.child('flutterDevsTeam2').remove();
    databaseReference.child('flutterDevsTeam3').remove();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: new ListView.builder(itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LogDetail(log: logs[index]),
                  ),
                );
              },
              child: new Card(
                child: new Column(children: <Widget>[
                  new Text(logs[index].name),
                  new Text(logs[index].timestamp)],
                  ),
              ),
            );
          },
          itemCount: logs==null?0:logs.length,
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getList,
      ),
    );
  }
}

class LogDetail extends StatelessWidget {
  final Log log;
  LogDetail({this.log});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
        GestureDetector(
          onTap: Navigator.of(context).pop,
          child: Icon(Icons.backpack)
          )
        ],
         title: Text("Log Details"),
      ),
      body: Container(
        child: Column(
          children: [
            Text("Who" + log.name),
            Text("When" + log.timestamp),
            Image.memory(base64Decode(log.data))
        ],),),
    );
  }
}
