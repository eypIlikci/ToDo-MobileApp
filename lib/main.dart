import 'package:flutter/material.dart';
import 'package:todo/data/databaseHelper.dart';
import 'package:todo/screens/tasks.dart';
import 'package:todo/screens/user_login.dart';
import 'package:todo/screens/welcome.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var _dbHelper=DatabaseHelper();
  var _asyc="welcome";
  @override
  void initState() {
    _dbHelper.findUser().then((user){
      setState(() {
        if(user==null){
          _asyc="login";
        }else{
          _asyc="tasks";
        }
      });
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: buildPage(),
    );
  }

  Widget buildPage(){
    switch(_asyc){
      case "welcome":{return WelcomePage();}
      case "login":{return LoginPage();}
      case "tasks":{return TasksPage();}
    }
  }

}
