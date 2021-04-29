import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:todo/model/user.dart';
class DatabaseHelper{
  final String _CREATE="CREATE TABLE _user(id INTEGER PRIMARY KEY , username TEXT,password TEXT)";

  Database _database;
  Future<Database> get database async{
    if(_database==null){
      _database=await  _init();
    }
    return _database;
  }
  Future<Database> _init() async{
    String path=join(await getDatabasesPath(),"todoApp.db");
    var etradeDb=await openDatabase(path,version:1,onCreate:_createDb);
    return etradeDb;
  }
  void _createDb(Database db, int version)async{
    await db.execute(_CREATE);
  }

  /**
   *Veritabanında sadece bir kullanıcı kayıt halinde olması gerekiyor
   */
  Future insert(User user)async{
    Database db=await this.database;
    var result=await db.query("_user");

    if(!result.isEmpty){
      db.rawQuery("delete from _user");
    }
    await db.insert("_user",_userToMap(user));
  }

  /**
   * Veritabanında sadece bir kullanıcı olduğu için result.first değeri dönuyor.
   * */
  Future<User> findUser()async{
    Database db=await this.database;
    var result=await db.query("_user");
    if(result.isEmpty)return await null;
    var u=await User.formJson(result.first);
    return u;
  }

  Future delete()async{
    Database db=await this.database;
    var result=await db.query("_user");
    if(!result.isEmpty){
      await db.rawQuery("delete from _user");
    }

  }

  Future update(User user)async{
    Database db=await this.database;
    await db.rawUpdate("UPDATE _user SET username=?, password=? WHERE id=?",
        [user.username,user.password,user.id]);
  }

  Map<String,dynamic> _userToMap(User user){
    Map<String,dynamic> imap=new Map();
    imap["id"]=user.id;
    imap["username"]=user.username;
    imap["password"]=user.password;
    return imap;
  }



}