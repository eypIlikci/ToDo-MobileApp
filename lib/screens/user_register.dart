import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:todo/api/user_api.dart';
import 'package:todo/data/databaseHelper.dart';
import 'package:todo/model/user.dart';
import 'package:todo/screens/tasks.dart';
import 'package:todo/validation/user_validator.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> with UserValidationMixin {
  var user = User();
  var _key = GlobalKey<FormState>();
  var _pssTxt=TextEditingController();
  var _checkUsername=false;
  var _dbHelper=DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child:Padding(
          padding: EdgeInsets.all(60.0),
          child:buildPage(),
        ),
      ),

    );
  }

  var _loadingPage=false;
  Widget buildPage(){
    if(_loadingPage){
      return buildLoadingPage();
    }else{
      return Column(
        children: <Widget>[
          buildHeaderText(),
          buildForm(),
        ],
      );
    }

  }


  Widget buildHeaderText() {
    return Container(
      margin: EdgeInsets.only(top: 50.0),
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
      child: Text("Kayıt Ol",
          style: TextStyle(
              color: Colors.black,
              fontSize: 40.0,
              fontWeight: FontWeight.bold)),
    );
  }
/*
*
*

*
* */

  Widget buildForm() {
    return Form(
      key: _key,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            TextFormField(
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                hintText: "Kullanıcı Adı",
                border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black)),
                hintStyle: TextStyle(color: Colors.black),
                errorText: _checkUsername ? 'Bu Kullanıcı Adı Kullanımda':null,
              ),
              validator: validateUsername,
              onSaved: (value){
                user.username=value;
              },
            ),

            SizedBox(height: 30.0),

            TextFormField(
              style: TextStyle(color: Colors.black),
              obscureText: true,
              decoration: InputDecoration(
                hintText: "Şifre",
                border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black)),
                hintStyle: TextStyle(color: Colors.black),
              ),
              validator: validatePassword,
              controller: _pssTxt,
              onSaved: (value){
                user.password=value;
              },
            ),
            SizedBox(height: 30.0),

            TextFormField(
                validator: (value){
                  if(value!=_pssTxt.text){
                    return "Şifre ile tekrarı aynı olmalı";
                  }return null;
                },
                enableSuggestions: false,
                autocorrect: false,
                obscureText: true,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  hintText: "Şifre Tekrar",
                  border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)),
                  hintStyle: TextStyle(color: Colors.black),
                )

            ),
            SizedBox(height: 30.0),

            RaisedButton(
              child: Text("Kayıt",style: TextStyle(
                  color: Colors.white,
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold)),
              color: Colors.black,
              splashColor: Colors.white,
              disabledColor: Colors.black,
              animationDuration: Duration(seconds: 2),
              onPressed: ()=>register(),
            ),

          ],
        ),
      ),
    );
  }

  void register(){
    if(_key.currentState.validate()){
      _key.currentState.save();

      var api=UserApi();
      var res= api.register(user);
      var logUser=User();
      res.then((value){
        logUser=value;
        if(logUser==null){
          setState(() {
            _checkUsername=true;
            _loadingPage=false;
          });
        }else{
          _dbHelper.insert(user).then((value){
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                TasksPage()), (Route<dynamic> route) => false);
          });
        }
      });

       setState(() {
         _loadingPage=true;
       });


    }

  }

  Widget buildLoadingPage(){

    return Container(
      alignment: Alignment.center,
      height: 500,
      child: LoadingBouncingGrid.square(
        borderColor: Colors.red,
        backgroundColor: Colors.red,
        size: 60.0,
      ),
    );

  }
}
