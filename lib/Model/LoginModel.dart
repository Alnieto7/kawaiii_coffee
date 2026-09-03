class LoginResponse {
  String? message;
  String? token;
  String? tokenType;
  UserModel? user;

  LoginResponse({
    this.message,
    this.token,
    this.tokenType,
    this.user,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      message: json['message'],
      token: json['token'],
      tokenType: json['token_type'],
      user: json['user'] != null
          ? UserModel.fromJson(json['user'])
          : null,
    );
  }
}

class UserModel {
  int? id;
  String? name;
  String? role;

  UserModel({this.id, this.name, this.role});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      role: json['role'],
    );
  }
}