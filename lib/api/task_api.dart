
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:todo/api/api_endpoints.dart';
import 'package:todo/data/databaseHelper.dart';
import 'package:todo/model/task.dart';
import 'package:todo/model/user.dart';

class TaskApi{
  var _dbHelper=DatabaseHelper();
  Future<List<Task>> getTask()async{
   await _dbHelper.findUser().then((user)async{
          var res=await http.get(ApiEndpoints.tasks,
            headers: {"Content-Type": "application/json",'authorization':_toBasicAuth(user)},);
          if(res.statusCode==400){
            return null;

          }else{
            return Task.tasksToJson(jsonDecode(res.body));
          }
    });
  }

  Future<List<Task>> getAllTasks(User user)async{
    var res=await http.get(ApiEndpoints.tasks,
      headers: {"Content-Type": "application/json",'authorization':_toBasicAuth(user)},);
    if(res.statusCode==400 || res.body.isEmpty){
      return null;
    }else{
      return Task.tasksToJson(json.decode(utf8.decode(res.bodyBytes)));
    }
  }

  Future deleteTask(Task task)async{
    var res=await http.delete(ApiEndpoints.tasks+"/"+task.id.toString(),
      headers: {"Content-Type": "application/json",'authorization':_getBasicAuth()},);
  }

  Future<Task> update(Task task)async{
    var _body=jsonEncode(<String,dynamic>
                   {"id":task.id,
                    "title":task.title,
                      "content":task.content,
                      "status":task.status,
                        "startDate":task.startDate.toString(),
                          "dueDate":task.dueDate.toString()});
    var res=await http.put(ApiEndpoints.tasks,
      headers: {"Content-Type": "application/json",'authorization':_getBasicAuth()},
      body:_body);

    if(res.statusCode==200){
      return task;
    }
  }

  Future<Task> save(Task task,User user)async{

     var _body=jsonEncode(<String,dynamic>{
      "title":task.title,
      "content":task.content,
      "status":task.status,
      "startDate":task.startDate.toString(),
      "dueDate":task.dueDate.toString()});
    var res=await http.post(ApiEndpoints.tasks,
        headers: {"Content-Type": "application/json",'authorization':_toBasicAuth(user)},
        body:_body);
    if(res.statusCode==201){
      Task task=Task.withJson(jsonDecode(res.body));
       return task;
    }

  }

  String _getBasicAuth(){
    var user=User();
    DatabaseHelper().findUser().then((dbuser){
      user=dbuser;
    });
    return 'Basic '+base64Encode(utf8.encode(user.username+':'+user.password));
  }

  String _toBasicAuth(User user){
    var auth=user.username+':'+user.password;
    return 'Basic '+base64Encode(utf8.encode(auth));
  }
}