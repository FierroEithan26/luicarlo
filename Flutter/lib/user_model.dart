class UserModel {
  final String email;
  final String password;
  final String paymentMethod;

  UserModel({
    required this.email,
    required this.password,
    required this.paymentMethod,
  });

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'password': password,
      'paymentMethod': paymentMethod,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      paymentMethod: map['paymentMethod'] ?? '',
    );
  }
}
