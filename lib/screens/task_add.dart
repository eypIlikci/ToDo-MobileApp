import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:todo/api/task_api.dart';
import 'package:todo/data/databaseHelper.dart';
import 'package:todo/model/task.dart';
import 'package:todo/screens/task_detail.dart';
import 'package:todo/validation/task_validator.dart';

class TaskAdd extends StatefulWidget {
  @override
  _TaskAddState createState() => _TaskAddState();
}

class _TaskAddState extends State<TaskAdd> with TaskValidationMixin {
  final format = DateFormat("yyyy-MM-dd HH:mm");
  var _key = GlobalKey<FormState>();
  var _titleTxt = TextEditingController();
  var _contentTxt = TextEditingController();
  var _startdateTxt = TextEditingController();
  var _duedateTxt = TextEditingController();



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Yeni  Görev",
          style: TextStyle(
            fontSize: 30.0,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(20.0),
          child: Column(
            children: [
              buildForm(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildForm() {
    return Form(
      key: _key,
      child: Column(
        children: <Widget>[
          TextFormField(
              controller: _titleTxt,
              validator: validateTitle,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                hintText: "Görev Başlılığı...",
                border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black)),
                hintStyle: TextStyle(color: Colors.black),
              )),
          SizedBox(height: 30.0),
          TextFormField(
            controller: _contentTxt,
            validator: validateContent,
            minLines:
                6, // any number you need (It works as the rows for the textarea)
            keyboardType: TextInputType.multiline,
            maxLines: null,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
              hintText: "Görev...",
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black)),
              hintStyle: TextStyle(color: Colors.black),
            ),
          ),
          SizedBox(height: 30.0),
          Text("Başlama Tarihi", style: TextStyle(fontWeight: FontWeight.bold)),
          DateTimeField(
            format: format,
            controller: _startdateTxt,
            validator: validateDate,
            onShowPicker: (context, currentValue) async {
              final date = await showDatePicker(
                  context: context,
                  firstDate: DateTime(1900),
                  initialDate: currentValue ?? DateTime.now(),
                  lastDate: DateTime(2100));
              if (date != null) {
                final time = await showTimePicker(
                  context: context,
                  initialTime:
                      TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                );
                return DateTimeField.combine(date, time);
              } else {
                return currentValue;
              }
            },
          ),
          Text("Bitirme Tarihi", style: TextStyle(fontWeight: FontWeight.bold)),
          DateTimeField(
            format: format,
            controller: _duedateTxt,
            validator: validateDate,
            onShowPicker: (context, currentValue) async {
              final date = await showDatePicker(
                  context: context,
                  firstDate: DateTime(1900),
                  initialDate: currentValue ?? DateTime.now(),
                  lastDate: DateTime(2100),);
              if (date != null) {
                final time = await showTimePicker(
                  context: context,
                  initialTime:
                      TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                );
                return DateTimeField.combine(date, time);
              } else {
                return currentValue;
              }
            },
          ),
          SizedBox(height: 40.0),
          RaisedButton(
            child: Text("Görevi Ekle",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold)),
            color: Colors.black,
            splashColor: Colors.white,
            disabledColor: Colors.black,
            animationDuration: Duration(microseconds:2),
            onPressed: () {
              if (_key.currentState.validate()) {
                _key.currentState.save();
                Task newTask = Task.witoutId(
                  title: _titleTxt.text,
                  content: _contentTxt.text,
                  status: false,
                  startDate: DateTime.parse(_startdateTxt.text),
                  dueDate: DateTime.parse(_duedateTxt.text),
                );
                TaskApi api=TaskApi();
                DatabaseHelper().findUser().then((user){
                  api.save(newTask,user).then((value){
                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                        TaskDetail(value)), (Route<dynamic> route) => route.isFirst);
                  });
                });
              }


            },
          ),
        ],
      ),
    );
  }
}
