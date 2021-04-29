class UserValidationMixin{
    String validateUsername(String username){
    if(username==null || username.isEmpty || username.length<3 || username.length>10){
      return "Kullanıcı Adı Geçerli Değil: 3 ile 10 karekter içermeli.";
    }
   }
    String validatePassword(String password){
    if(password==null || password.isEmpty || password.length<5 || password.length>10){
      return "Şifre Geçerli Değil: 5 ile 10 karekter içermeli. ";
    }
  }
}