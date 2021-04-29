import 'package:flutter/material.dart';
import 'package:todo/api/task_api.dart';
import 'package:todo/api/user_api.dart';
import 'package:todo/data/databaseHelper.dart';
import 'package:todo/model/task.dart';
import 'package:todo/model/user.dart';
import 'package:todo/screens/task_add.dart';
import 'package:todo/screens/task_detail.dart';
import 'package:todo/screens/user_login.dart';
import 'package:todo/util/date.dart';
import 'package:todo/validation/user_validator.dart';

class TasksPage extends StatefulWidget {
  @override
  _TasksPageState createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> with UserValidationMixin {
  var _dbHelper = DatabaseHelper();
  var _userApi = UserApi();
  var user = User.empty();
  var _taskApi = TaskApi();
  List<Task> tasks = [];
  @override
  void initState() {
    super.initState();
    _dbHelper.findUser().then((value) {
      user = value;
      var res = _taskApi.getAllTasks(user);
      res.then((tasks) {
        setState(() {
          this.tasks = tasks;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "ToDo App",
          style: TextStyle(
            fontSize: 30.0,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black,
      ),
      drawer: buildPopupMenu(),
      body:SingleChildScrollView(
        child: Column(
          children: [
            buildTasksPage(),
          ],
        ),
      ),


      floatingActionButton: buildAddTaskBtn(),
    );
  }

  Widget buildPopupMenu() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(35.0),
            child: Text(
              'Kullanıcı: ' + user.username,
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Divider(
            height: 1,
            thickness: 1,
          ),
          ListTile(
            leading: Icon(Icons.cached),
            title: Text('Şifre Değiştir'),
            onTap: () {
              changePasswordDialog();
            },
          ),
          Divider(
            height: 4,
            thickness: 4,
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text("Çıkış Yap"),
            onTap: () {
              DatabaseHelper().delete().then((value) {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => LoginPage()),
                    (Route<dynamic> route) => false);
              });
            },
          ),
        ],
      ),
    );
  }

  final _formKey = GlobalKey<FormState>();
  var txtPass = TextEditingController();
  var _checkPassword=false;
  void changePasswordDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Container(
              height: 300.0,
              child: Stack(
                overflow: Overflow.visible,
                children: <Widget>[
                  Positioned(
                    right: -40.0,
                    top: -40.0,
                    child: InkResponse(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: CircleAvatar(
                        child: Icon(Icons.close),
                        backgroundColor: Colors.red,
                      ),
                    ),
                  ),
                  Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            style: TextStyle(color: Colors.black),
                            obscureText: true,
                            decoration: InputDecoration(
                              hintText: "Eski Şifre",
                              border: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black)),
                              hintStyle: TextStyle(color: Colors.black),
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Eski Şifre Boş Olamaz";
                              } else if (value != user.password) {
                                return "Eski Şifre Yanlış";
                              }return null;
                            },
                          ),
                          TextFormField(
                            controller: txtPass,
                            style: TextStyle(color: Colors.black),
                            obscureText: true,
                            decoration: InputDecoration(
                              hintText: "Yeni Şifre",
                              border: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black)),
                              hintStyle: TextStyle(color: Colors.black),
                            ),
                            validator: (value){
                              if(validatePassword(value)!=null){
                                return validatePassword(value);
                              }else if(value==user.password){
                                return "Eski şifre, yeni şifre ile aynı olamaz!";
                              }return null;
                            },
                          ),
                          TextFormField(
                            style: TextStyle(color: Colors.black),
                            obscureText: true,
                            decoration: InputDecoration(
                              hintText: "Yeni Şifre Tekrar",
                              border: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black)),
                              hintStyle: TextStyle(color: Colors.black),
                            ),
                            validator: (value) {
                              if (value != txtPass.text) {
                                return "Şifre Tekrarı Aynı Olmalı!";
                              }return null;
                            },
                          ),
                          Container(
                            margin:
                                const EdgeInsets.only(top: 30.0, bottom: 20.0),
                            child: RaisedButton(
                              child: Text("Değiştir",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 30.0,
                                      fontWeight: FontWeight.bold)),
                              color: Colors.black,
                              splashColor: Colors.white,
                              disabledColor: Colors.black,
                              animationDuration: Duration(seconds: 2),
                              onPressed: () {
                                if (_formKey.currentState.validate()) {
                                  changePassword(txtPass.text);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

/*

* */
  void changePassword(String newPassword) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Şifreni Değiştiriyorsun!"),
          actions: [
            FlatButton(
              child: Text("İptal"),
              onPressed: () {
                setState(() {
                  Navigator.pop(context);
                });
              },
            ),
            FlatButton(
              child: Text("Değiştir"),
              onPressed: () {
                var newUser = User.withAll(
                    id: user.id,
                    username: user.username,
                    password: txtPass.text);
                _userApi.update(user, newUser).then((value) {
                  if (value != null) {
                    _dbHelper.update(newUser).then((value) =>value);
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => TasksPage()),
                        (Route<dynamic> route) => false);
                  }
                });
              },
            ),
          ],
        );
      },
    );
  }

  //---Task Widgets
  Widget buildWaitingPage() {}

  Widget buildTasksPage() {
    if (tasks != null && tasks.length > 0) {
      return SingleChildScrollView(
          child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return FlatButton(
                  shape: Border(bottom: BorderSide(color: Colors.white)),
                  padding: EdgeInsets.all(10.0),
                  color: Colors.grey,
                  child: ListTile(
                    title: Text(
                      _getTaskValue(tasks[index].title),
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                        "Başlama:" +
                            DateFormat.write(tasks[index].startDate) +
                            "  Bitirme:" +
                            DateFormat.write(tasks[index].dueDate),
                        style: TextStyle(color: Colors.white)),
                    trailing: _getTaskIcon(tasks[index].status),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TaskDetail(tasks[index])));
                  },
                );
              }),

      );
    }else{
      return Container(
        height: 400,

        child: Center(
          child: Text("Kayıtlı Görev Yok",style: TextStyle(fontSize: 20.0),),
        ),
      );
    }

    return Container();
  }

  Icon _getTaskIcon(bool status) {
    if (status) {
      return Icon(Icons.check, color: Colors.green);
    }
    return Icon(Icons.forward, color: Colors.red);
  }

  String _getTaskValue(dynamic value) {
    if (value is String) {
      if (value == null || value.isEmpty) return "****";
      return value;
    } else if (value is DateTime) {
      if (value == null) return "****";
      return value.toString();
    } else if (value is bool) {
      if (value == true) return "Durum: Bitirilmedi";
      return "Durum: Tamamlanan Görev";
    }
    return "****";
  }

  Widget buildAddTaskBtn() {
    return Container(
      padding: const EdgeInsets.all(30.0),
      width: 140,
      height: 140,
      child: FloatingActionButton(
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        child: const Icon(Icons.note_add_sharp),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => TaskAdd()));
        },
      ),
    );
  }
}
