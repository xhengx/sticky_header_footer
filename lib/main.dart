import 'package:flutter/material.dart';
import 'package:sticky_header_footer/sticky_header_footer/widget.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sticky header footer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Sticky header footer'),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: ListView.builder(
            itemCount: 10,
            itemBuilder: (BuildContext context, int index) {
              return XSticky(
                header: Container(
                  constraints: BoxConstraints.expand(height: 50),
                  color: Colors.orange,
                  child: Text("#$index header"),
                ),
                content: Container(
                  constraints: BoxConstraints.expand(height: 100),
                  color: Colors.white,
                  child: Text("#$index content"),
                ),
                footer: Container(
                  constraints: BoxConstraints.expand(height: 50),
                  color: Colors.indigo,
                  child: Text("#$index footer"),
                ),
              );
            },
          ),
        ));
  }
}
