import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'user_service.dart';
import 'user_model.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _selectedPayment;

  final List<String> _paymentMethods = [
    'Tarjeta de crédito',
    'Tarjeta de débito',
    'PayPal',
    'Transferencia bancaria'
  ];

  Future<void> _registerUser() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final payment = _selectedPayment;

    if (email.isEmpty || password.isEmpty || payment == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor completa todos los campos')),
      );
      return;
    }

    // Creamos el objeto de usuario
    final user = UserModel(
      email: email,
      password: password,
      paymentMethod: payment,
    );

    // Guardamos localmente por ahora
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);

    // Placeholder: aquí luego llamarás tu base de datos real
    await saveUserToDatabase(user);

    // Navegar al home
    Navigator.pushReplacementNamed(context, '/home');
  }

  Future<void> saveUserToDatabase(UserModel user) async {
   bool success = await UserService.registerUser(user);
    if (success) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error al registrar el usuario')),
    );
  }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Crear cuenta')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Correo electrónico'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _selectedPayment,
              items: _paymentMethods
                  .map((method) => DropdownMenuItem(
                        value: method,
                        child: Text(method),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedPayment = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Método de pago',
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: _registerUser,
              child: Text('Registrarse'),
            ),
          ],
        ),
      ),
    );
  }
}
