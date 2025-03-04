import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ImagePicker imagePicker = ImagePicker();
  File? _selectedImage;
  String _apiResponse = "Selecciona una imagen para analizar";
  bool _isLoading = false;

  // 🔹 Reemplaza con tus credenciales de Imagga
  final String apiKey = "acc_4a6b12b3c49a494";
  final String apiSecret = "5d1edc447318bdba9f562135359bdfe4";

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Análisis de Imágenes"),
        actions: [
          IconButton(
            onPressed: () => _logout(context),
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: _selectedImage != null
                ? Image.file(
                    _selectedImage!,
                    width: 300,
                    height: 300,
                    fit: BoxFit.cover,
                  )
                : Text('No hay imagen seleccionada'),
          ),
          SizedBox(height: 20),
          _isLoading 
            ? CircularProgressIndicator() 
            : Text(_apiResponse, textAlign: TextAlign.center),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _optionsDialogBox,
      ),
    );
  }

  //selecionar la imagen de la camara
  void _openCamera() async {
    Navigator.pop(context); // Cierra el diálogo antes de abrir la cámara
    final picture = await imagePicker.pickImage(source: ImageSource.camera);
    if (picture != null) {
      setState(() {
        _selectedImage = File(picture.path);
        _apiResponse = "Analizando imagen...";
        _isLoading = true;
      });
      _analyzeImage(); // Enviar a Imagga automáticamente
    }
  }

  //selecionar la imagen de la galeria
  void _openGallery() async {
    Navigator.pop(context); // Cierra el diálogo antes de abrir la galería
    final picture = await imagePicker.pickImage(source: ImageSource.gallery);
    if (picture != null) {
      setState(() {
        _selectedImage = File(picture.path);
        _apiResponse = "Analizando imagen...";
        _isLoading = true;
      });
      _analyzeImage(); // Enviar a Imagga automáticamente
    }
  }

  // analisis de la imagen
  Future<void> _analyzeImage() async {
    if (_selectedImage == null) return;

    var request = http.MultipartRequest(
      "POST",
      Uri.parse("https://api.imagga.com/v2/tags"),
    );

    // 🔹 Adjunta la imagen seleccionada
    request.files.add(await http.MultipartFile.fromPath("image", _selectedImage!.path));

    // 🔹 Agrega las credenciales en la cabecera
    request.headers["Authorization"] =
        "Basic " + base64Encode(utf8.encode("$apiKey:$apiSecret"));

    var response = await request.send();

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(await response.stream.bytesToString());
      List tags = jsonResponse["result"]["tags"];

      if (tags.isNotEmpty) {
        setState(() {
          _apiResponse = "Etiquetas: " + tags.map((tag) => tag["tag"]["en"]).take(5).join(", ");
        });
      } else {
        setState(() {
          _apiResponse = "No se encontraron etiquetas para la imagen.";
        });
      }
    } else {
      setState(() {
        _apiResponse = "Error en el análisis de la imagen.";
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _optionsDialogBox() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: Text('Tomar foto'),
                  onTap: _openCamera,
                ),
                SizedBox(height: 10),
                GestureDetector(
                  child: Text('Elegir foto'),
                  onTap: _openGallery,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
