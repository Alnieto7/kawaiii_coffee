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