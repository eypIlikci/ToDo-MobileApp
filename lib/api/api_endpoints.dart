class ApiEndpoints{
  static final String _serverURL='http://192.168.1.148:8080';
  static final String _apiVersion='/api/v1';
  static final String registerUser=_serverURL+_apiVersion+'/user';
  static final String login=_serverURL+_apiVersion+"/auth";
  static final String updateUser=registerUser;
  static final String tasks=_serverURL+_apiVersion+"/tasks";
}