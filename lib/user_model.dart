// user_model.dart

class User {
  final String id;
  final String name;
  final int age;
  final String birthdate;
  final bool active;

  User({
    required this.id,
    required this.name,
    required this.age,
    required this.birthdate,
    required this.active,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      age: json['age'],
      birthdate: json['birthdate'],
      active: json['active'],
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'age': age,
    'birthdate': birthdate,
    'active': active,
  };
}
