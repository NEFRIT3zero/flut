class User {
  String name;
  String login;
  String password;
  bool isAdmin;

  User({
    required this.name, 
    required this.login, 
    required this.password,
    this.isAdmin = false
  });

  Map<String, dynamic> toMap() {
    return {
      'login': login,
      'name': name,
      'password': password,
      'isAdmin': isAdmin ? 1 : 0,
    };
  }

  factory User.fromMap(Map<String, Object?> map) {
    return User(
      name: map['name'] as String,
      login: map['login'] as String,
      password: map['password'] as String,
      isAdmin: map['isAdmin'] == 1,
    );
  }

}

