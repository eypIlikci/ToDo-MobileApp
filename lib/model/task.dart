class Task{
  int id;
  String title;
  String content;
  DateTime startDate;
  DateTime dueDate;
  bool status;

  Task();
  Task.withAll({this.id,this.title,this.content,this.startDate,this.dueDate,this.status});
  Task.witoutId({this.title,this.content,this.startDate,this.dueDate,this.status});

  static List<Task> tasksToJson(List<dynamic> json){

    if(json.length>0){
      List<Task> tasks=[];
      json.forEach((element) {
        tasks.add(Task.withAll(
          id: element["id"],
          title: element["title"],
          content: element["content"],
          startDate:getTime(element["startDate"]),
          dueDate:getTime(element["dueDate"]),
          status: element["status"]
        ));
      });
      return tasks;
    }return null;


  }

  factory Task.withJson(Map<String,dynamic> json){
    return Task.withAll(
      id: json["id"],
      title: json["title"],
      content: json["content"],
      status: json["status"],
      dueDate: getTime(json["dueDate"]),
      startDate: getTime(json["startDate"])
    );
  }

   static   DateTime getTime(String time){
     if(time!=null){
       return DateTime.parse(time);
     }else{
       return null;
     }
   }
}