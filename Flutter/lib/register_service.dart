import 'package:http/http.dart' as http;
import 'dart:convert';

Future<bool> registerUser(String email, String password, String paymentMethod) async {
  final url = Uri.parse('http://192.168.1.111:3000/register'); // Usa tu IP si es para Android

  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'email': email,
      'password': password,
      'paymentMethod': paymentMethod,
    }),
  );

  if (response.statusCode == 200) {
    print("Usuario registrado exitosamente");
    return true;
  } else {
    print("Error al registrar: ${response.body}");
    return false;
  }
}

