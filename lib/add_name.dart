import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_pal/student.dart';
import 'package:flutter_pal/storage.dart';

class AddNamePage extends StatefulWidget{
  const AddNamePage({Key? key, required this.title, required this.list}) : super(key: key);

  final String title;
  final List<Student> list;

  @override
  State<AddNamePage> createState() => _AddNamePageState();
}

class _AddNamePageState extends State<AddNamePage> {

  String name = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
            Navigator.pop(context);
          },
          icon: Icon(Icons.close)
        ),
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Center(child: Text(widget.title)),
        actions: [
          IconButton(
            onPressed: (){
              widget.list.add(Student(name, false));
              (Storage()).writeStudents(widget.list);
              Navigator.pop(context);
              Navigator.pop(context);
            },
            icon : Text("ADD")
          )
        ]
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
              width: 380,
              child: TextField(
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  hintText: 'Enter Name',
                ),
                onChanged : (String value) async {
                  setState(() {name = value;});
                  log("Name: " + name);
                }
              ),
            )
          ],
        ),
      ),
    );
  }
}
