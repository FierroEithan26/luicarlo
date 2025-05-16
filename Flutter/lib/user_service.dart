import 'dart:convert';
import 'package:http/http.dart' as http;
import 'user_model.dart';

class UserService {
 // static const String baseUrl = 'http://TUDOMINIO.com/api'; // cambiar por tu IP o dominio

 static const String baseUrl = 'http://192.168.1.111:3000'; //reemplaza con tu IP real

  static Future<bool> registerUser(UserModel user) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user.toMap()),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print("Error al registrar: ${response.body}");
      return false;
    }
  }

  static Future<bool> loginUser(String email, String password) async {
  final response = await http.post(
    Uri.parse('$baseUrl/login'), // Asegúrate que $baseUrl esté bien definido con tu IP local
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'email': email, 'password': password}),
  );

  if (response.statusCode == 200) {
    return true;
  } else {
    print("Error al iniciar sesión: ${response.body}");
    return false;
  }
}
}
