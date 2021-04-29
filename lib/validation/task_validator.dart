class TaskValidationMixin{

    String validateTitle(String title){
      if(title==null || title.isEmpty || title.length<3 || title.length>20){
        return "Görev Başlığı en az 3, en faza 20 karakter olmalı!";
      }
    }
    String validateContent(String content){
      if(content==null || content.isEmpty) {
        return "Görev boş olamaz!!";
      }else if(content.length<10){
        return "Görev en az 10 karakter içerlemli";
      }else if(content.length>1000){
        return "Görev en fazla 1000 karakter içerlemli";
      }
    }

    String validateDate(dynamic date){
      if(date==null || date.toString().isEmpty)return "Tarih boş olamaz!";
    }

}