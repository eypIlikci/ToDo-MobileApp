
class User{
  int id;
  String username;
  String password;

  User();
  User.withAll({this.id,this.username,this.password});

   factory User.formJson(Map<String,dynamic> json){
    return User.withAll(
        id: json['id'],
        username: json['username'],
        password: json['password'],
    );
  }

  Map<String,dynamic> jsonDoc(){
    Map<String,dynamic> json=Map();
    if(id>0){
      json["id"]=id;
    }else{
      json["id"]=null;
    }
    json["username"]=username;
    json["password"]=password;
    return json;
  }

  User.empty(){
     this.id=0;
     this.username="";
     this.password="";
  }

}