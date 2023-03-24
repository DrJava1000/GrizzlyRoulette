import 'package:flutter/material.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children:[
            Text(widget.title)
          ],
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Image(
                image: AssetImage('assets/bbuildingwavy.jpg')
            ),
            SizedBox(height: 50),
            Text(
              'Created By Ryan Gambrell',
              style: TextStyle(fontSize : 28),
            ),
            SizedBox(height: 40),
            Text(
              'Created for ITEC 4550',
              style: TextStyle(fontSize : 24),
            ),
            SizedBox(height: 50),
            Image(
                image: AssetImage('assets/android_guy.png'),
                width: 300,
                height: 300
            ),
            SizedBox(height: 50),
            Text(
              '11/15/2021',
              style: TextStyle(fontSize : 22),
            ),
          ],
        ),
      ),
    );
  }
}
