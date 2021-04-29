class DateFormat{

  static String write(DateTime time){
    return _toString(time);
  }
  static String _toString(DateTime time){
    DateTime nowDate=DateTime.now();
    if(time==null)return "****";
    if(nowDate.year==time.year){
        if(nowDate.month==time.month){
          if(nowDate.day==time.day){
            if(nowDate.hour==time.hour){
              return _write(time.hour)+":"+_write(time.minute);
            }else{
              return _write(time.hour)+":"+_write(time.minute);
            }
          }else{
            return _writeMonth(time.month)+"-"+_write(time.day)+"  "+_write(time.hour)+":"+_write(time.minute);
          }
        }else{
          return _writeMonth(time.month)+_write(time.month)+"-"+_write(time.day)+"  "+_write(time.hour)+":"+_write(time.minute);
        }
    }
    return _write(time.year)+"-"+_writeMonth(time.month)+"-"+_write(time.day)+"  "+_write(time.hour)+":"+_write(time.minute);
  }

  static String _write(int time){
      if(time!=0){
        return time.toString();
      }
  }
  static String _writeMonth(int month){
    if(month!=0){
      if(month<10){
        return "0"+month.toString();
      }return month.toString();
    }
  }


}