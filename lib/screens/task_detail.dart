import 'package:flutter/material.dart';
import 'package:todo/api/task_api.dart';
import 'package:todo/model/task.dart';
import 'package:todo/screens/tasks.dart';
import 'package:todo/util/date.dart';

class TaskDetail extends StatefulWidget {
  Task task;
  TaskDetail(Task task) {
    this.task = task;
  }
  @override
  _TaskDetailState createState() => _TaskDetailState(this.task);
}

class _TaskDetailState extends State<TaskDetail> {
  Task task;
  TaskApi taskApi = TaskApi();
  _TaskDetailState(Task task) {
    this.task = task;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Görev"+task.id.toString(),
          style: TextStyle(
            fontSize: 30.0,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.white,
      body: Container(
        child: Column(
          children: <Widget>[
            buildTask(),
            buildFinishingBtn(),
            buildRemoveBtn(),
          ],
        ),
      ),
    );
  }

  Widget buildTask() {
    return Container(
      margin: const EdgeInsets.all(20.0),
      child: Column(
        children: <Widget>[
          Text(_getTaskValue(task.title),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0)),
          buildCheckIcon(),
          Divider(height: 4, thickness: 4),
          Container(
            margin: const EdgeInsets.all(15.0),
            padding: const EdgeInsets.all(20.0),
            height: 400.0,
            width: 300,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.red),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(_getTaskValue(task.content),
                style: TextStyle(fontSize: 15.0)),
          ),
          Text("Görev Başlama Zamanı: " + DateFormat.write(task.startDate)),
          Text("Görev Bitirme Zamanı: " + DateFormat.write(task.dueDate)),
          Divider(height: 2, thickness: 2),
        ],
      ),
    );
  }

  Widget buildCheckIcon() {
    if (task.status) {
      return Icon(
        Icons.fact_check,
        color: Colors.green,
        size: 35.0,
      );
    }
    return Container();
  }

  Widget buildFinishingBtn() {
    if (!task.status) {
      return FlatButton(
        child: Text("Görevi Bitir",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
                color: Colors.green)),
        onPressed: (){
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Görevi bitti mi!"),
                  actions: [
                    FlatButton(
                      child: Text("Hayır"),
                      onPressed: () {
                        setState(() {
                          Navigator.pop(context);
                        });
                      },
                    ),
                    FlatButton(
                      child: Text("Evet"),
                      onPressed: () {
                        task.status=true;
                        taskApi.update(task).then((value) {
                          setState(() {Navigator.pop(context);});
                        });
                      },
                    ),
                  ],
                );
              });
        },
      );
    }
    return Container();
  }

  Widget buildRemoveBtn(){
    return Container(
      child: FlatButton(
        child: Text("Görevi Sil",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
                color: Colors.redAccent)),
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
               return AlertDialog(
                  title: Text("Görevi Siliyorsun!"),
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
                      child: Text("Sil"),
                      onPressed: () {
                        taskApi.deleteTask(task).then((value) {
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => TasksPage()),
                                  (Route<dynamic> route) => false);
                        });

                        /*
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) => LoadinPage()),
                                (Route<dynamic> route) => false);*/
                      },
                    ),
                  ],
                );
              });
        },
      ),
    );

  }

  String _getTaskValue(dynamic value) {
    if (value is String && !value.isEmpty)
      return value;
    else if (value is DateTime && value != null)
      return value.toString().substring(0, value.toString().length - 7);
    else if (value is bool && value == true)
      return "Tamamlandı";
    else if (value is bool && value == false) return "Tamamlanmadı";
    return "****";
  }
}
