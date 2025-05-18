class RegisterModel {
  final String email;
  final String password;
  final String confirmPassword;
  final String username;

  RegisterModel({
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.username,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['password'] = password;
    data['confirmPassword'] = confirmPassword;
    data['username'] = username;
    return data;
  }
}
