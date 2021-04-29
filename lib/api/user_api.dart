import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:todo/api/api_endpoints.dart';
import 'dart:convert';

import 'package:todo/model/user.dart';

class UserApi{

   Future<User> register(User user)async{

      var _headers=<String, String>{"Content-Type": "application/json"};
      var _body=jsonEncode(<String,String>
                      {"username":user.username,
                       "password":user.password});

    var res= await http.post(ApiEndpoints.registerUser,headers:_headers,body:_body);
    if(res.statusCode==201){
      var loginUser=User.formJson(jsonDecode(res.body));
      loginUser.password=user.password;
      return loginUser;
    }
    return null;

  }

  Future<User> login(User user) async{
      var auth=user.username+':'+user.password;
      String basicAuth='Basic '+base64Encode(utf8.encode(auth));
      var res=await http.post(ApiEndpoints.login,headers: {'authorization':basicAuth});
      if(res.statusCode==401)return null;
      return User.formJson(jsonDecode(res.body));
  }
  
  Future<User> update(User user,User newUser)async{

      var _body=jsonEncode(<String,dynamic>
                  { "id":user.id,
                    "username":newUser.username,
                    "password":newUser.password});

    var res=await http.put(ApiEndpoints.updateUser,
        headers: {"Content-Type": "application/json",'authorization':_toBasicAuth(user)},
        body: _body);
    return User.formJson(jsonDecode(res.body));

  }
  
  String _toBasicAuth(User user){

    var auth=user.username+':'+user.password;
    return 'Basic '+base64Encode(utf8.encode(auth));
  }

}