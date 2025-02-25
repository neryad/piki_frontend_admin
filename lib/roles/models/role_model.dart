// import 'dart:convert';

// List<Roles> rolesFromJson(String str) =>
//     List<Roles>.from(json.decode(str).map((x) => Roles.fromJson(x)));

// String rolesToJson(List<Roles> data) =>
//     json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Roles {
  int id;
  String name;

  Roles({
    required this.id,
    required this.name,
  });

  factory Roles.fromJson(Map<String, dynamic> json) => Roles(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }
}
