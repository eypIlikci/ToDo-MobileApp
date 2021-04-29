import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:todo/api/user_api.dart';
import 'package:todo/data/databaseHelper.dart';
import 'package:todo/model/user.dart';
import 'package:todo/screens/tasks.dart';
import 'package:todo/screens/user_register.dart';
import 'package:todo/validation/user_validator.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPage createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> with UserValidationMixin {
  var user = User();
  var _key = GlobalKey<FormState>();
  var _pssTxt = TextEditingController();
  var _checkLogin = false;
  var _dbHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:SingleChildScrollView(
        child: Padding(

          padding: EdgeInsets.all(60.0),
          child:buildPage(),
        ),
      ),
    );
  }

  var _loadingPage=false;
  Widget buildPage(){
    if(_loadingPage){return buildLoadingPage();}
    return loginPage();
  }

  Widget loginPage(){
      return Column(
        children: <Widget>[
          buildHeaderText(),
          buildForm(),
          buildRegisterPageNavi(),
        ],
      );
  }

  Widget buildHeaderText() {
    return Container(
      margin: EdgeInsets.only(top: 50.0),
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
      child: Text("GİRİŞ YAP",
          style: TextStyle(
              color: Colors.black,
              fontSize: 40.0,
              fontWeight: FontWeight.bold)),
    );
  }

  Widget buildForm() {
    return Form(
      key: _key,
      child: Column(
        children: <Widget>[
          buildMessage(),
          TextFormField(
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
              hintText: "Kullanıcı Adı",
              border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black)),
              hintStyle: TextStyle(color: Colors.black),
            ),
            validator: validateUsername,
            onSaved: (value) {
              user.username = value;
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
            onSaved: (value) {
              user.password = value;
            },
          ),
          SizedBox(height: 30.0),
          RaisedButton(
            child: Text("Giriş Yap",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold)),
            color: Colors.black,
            splashColor: Colors.white,
            disabledColor: Colors.black,
            animationDuration: Duration(milliseconds: 500),
            onPressed: () => login(),
          ),
        ],
      ),
    );
  }


  Widget buildMessage() {
    if (_checkLogin) {
      return Container(
        margin: const EdgeInsets.all(30.0),
        alignment: Alignment.center,
        child: Text(
          'Kullanıcı adı ya da şifre yanlış!',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
      );
    }
    return Container();
  }

  void login() {
    if (_key.currentState.validate()) {
      _key.currentState.save();
      var api = UserApi();
      var res = api.login(user);
            res.then((value) {
              if (value == null) {
                setState(() {
                  setState(() {
                    _checkLogin = true;
                   _loadingPage=false;
                  });
                });
              } else {
                _dbHelper.insert(user).then((value) {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => TasksPage()),
                      (Route<dynamic> route) => false);
                });
              }
            });

      setState(() {
        _loadingPage=true;
      });
    }
  }



  Widget buildRegisterPageNavi() {
    return RaisedButton(
      child: Text("Kayıt Ol",
          style: TextStyle(
              color: Colors.black,
              fontSize: 30.0,
              fontWeight: FontWeight.bold),
              ),
      color: Colors.white,
      shape: RoundedRectangleBorder(side: BorderSide(color: Colors.black)),
      splashColor: Colors.black,
      disabledColor: Colors.white,
      animationDuration: Duration(seconds: 2),
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => RegisterPage()));
      },
    );
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
