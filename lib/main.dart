import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'about.dart';
import 'add_name.dart';
import 'student.dart';
import 'storage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(title: 'Grizzly Roulette'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>{

  var backendStorage;
  var students;
  var length;
  var _picked;

  _MyHomePageState(){
    _picked = '';
    backendStorage = Storage();
    students = [];
    length = students.length;

    log("Home Page Recreated");
  }

  @override
  initState(){
    read();
    super.initState();
  }

  read() async{
    await backendStorage.readStudents().then((list) => setState(() {
      students = list;
    }));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(widget.title)),
        actions: [
          PopupMenuButton(
            color: Colors.white,
            icon : Icon(Icons.more_horiz),
            itemBuilder: (context) => [
              PopupMenuItem<String>(
                value: "SETTINGS",
                child: Text("Settings ...", style: TextStyle(color: Colors.black),),
              ),
              PopupMenuItem<String>(
                value: "OCR",
                child: Text("OCR ...", style: TextStyle(color: Colors.black),),
              ),
              PopupMenuItem<String>(
                value: "ABOUT",
                child: Text("About", style: TextStyle(color: Colors.black),),
              ),
            ],
            onSelected: (item) => {routePopupMenu(item, context)},
          )
        ],
      ),
      drawer: Drawer(
          child: ListView(
              padding: EdgeInsets.zero,
              children: [
                const DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.green,
                  ),
                  child: Text('Edit List'),
                ),
                ListTile(
                  title: const Text('Add Name'),
                  onTap: () {
                    routeDrawerMenu("ADD");
                  },
                ),
                ListTile(
                  title: const Text('Sort'),
                  onTap: () {
                    routeDrawerMenu("SORT");
                  },
                ),
                ListTile(
                  title: const Text('Shuffle'),
                  onTap: () {
                    routeDrawerMenu("SHUFFLE");
                  },
                ),
                ListTile(
                  title: const Text('Clear'),
                  onTap: () {
                    routeDrawerMenu("CLEAR");
                  },
                )
              ]
          )
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(
              image: AssetImage('assets/bbuildingwavy.jpg')
            ),
            Container(
              height: 50,
              width: 380,
              margin: EdgeInsets.only(
                top: 15,
                bottom: 50
              ),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Center(
                child: Text(
                  _picked,
                  style : TextStyle(fontSize : 28)
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: students.length,
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: UniqueKey(),
                    background: Container(
                      color: Colors.red,
                    ),
                    child: ListTile(
                      title: Text(students[index].name),
                      trailing: Icon((students[index].hidden) ? Icons.visibility_off : null),
                      onTap: () {
                        changeVisibility(index);
                      },
                    ),
                    onDismissed: (DismissDirection direction) {
                      log("Widget has been dismissed.");
                      _remove(students[index]);
                    }
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _selectRandomName,
        tooltip: 'Increment',
        child: Icon(Icons.sync),
      ),
    );
  }

  void routeDrawerMenu(Object? item){
    String value = item as String;

    switch(value) {
      case "ADD":
        _add();
        break;
      case "SORT":
        _sort();
        break;
      case "SHUFFLE":
        _shuffle();
        break;
      case "CLEAR":
        _clear();
        break;
    }

    backendStorage.writeStudents(students);
  }

  changeVisibility(int index){
    setState(() {
      students[index].hidden = !(students[index].hidden);
    });
    backendStorage.writeStudents(students);
  }

  Future<void> _add() async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) => AddNamePage(title: "Add Student Name", list: students)))
        .then((data) => setState(() {
          length = students.length;
    }));

    log("Going to Add Name");
  }

  void _remove(Student student){
    students.remove(student);
    log("Removing from list...");
    backendStorage.writeStudents(students);
  }

  void _sort(){
    log("Going to Sort List");
    students.sort((Student studentA, Student studentB) => studentA.getName().compareTo(studentB.getName()));

    if(students.length == 0) {
      setState(() {
        _picked = "No List";
      });
      Navigator.pop(context);
      return;
    }

    var firstVisibleStudent;
    students.forEach((student) => {
      if(!student.hidden){
        firstVisibleStudent = student
      }
    });

    String selected;
    if(firstVisibleStudent == null)
      selected = "No Visible Students";
    else
      selected = firstVisibleStudent.name;

    setState(() {
      _picked = selected;
    });

    Navigator.pop(context);
  }

  void _shuffle(){
    students.shuffle(); // shuffle actual list
    _selectRandomName(); // pick name
    log("Going to Shuffle List");
    Navigator.pop(context);
  }

  void _selectRandomName() {
    // create new shuffled list (don't show on screen)
    List<Student> shuffledList = students.toList()..shuffle();

    if(students.length == 0) {
      setState(() {
        _picked = "No List";
      });

      return;
    }

    var firstVisibleStudent;
    shuffledList.forEach((student) => {
      if(!student.hidden){
        firstVisibleStudent = student
      }
    });

    String selected;
    if(firstVisibleStudent == null)
      selected = "No Visible Students";
    else
      selected = firstVisibleStudent.name;

    if(selected == "No Visible Students")
      log("No Random Selection has taken place.");
    else
      log("Student: " + selected + ", has been randomly selected.");

    setState(() {
      _picked = selected;
    });
  }

  void _clear(){
    students.clear();
    setState(() {
      _picked = "No List";
    });
    log("Going to Clear List");
    Navigator.pop(context);
  }

  void routePopupMenu(Object? item, BuildContext build){
    String value = item as String;
    switch(value) {
      case "SETTINGS": displayToast(build, "Settings - Coming Soon ...");
                       log("Settings Selected");
                       break;
      case "OCR":      displayToast(build, "OCR - Coming Soon ...");
                       log("OCR Selected");
                       break;
      case "ABOUT":    Navigator.push(context, MaterialPageRoute(builder: (context) => AboutPage(title: "Grizzly Roulette")));
                       log("About Selected");
                       break;
    }
  }

  void displayToast(BuildContext context, String message) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds : 1)
      ),
    );
  }
}




