import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ValidarUsuario {
  static Future<Map<String, dynamic>> validarCredenciales(
      String username, String password) async {
    // Construir el cuerpo de la solicitud en formato JSON
    Map<String, String> requestBody = {
      'usuario': username,
      'contrasena': password,
    };
    var token = dotenv.env['API_TOKEN'];
    try {
      // Realizar la solicitud HTTP a la API con la URL y encabezados específicos
      http.Response response = await http.post(
        Uri.parse(
            'https://tej0nb36k0.execute-api.us-east-1.amazonaws.com/dev/awssisvir/appsisvir/login'),
        headers: {
          'Content-Type': 'application/json',
          'auth-token': token.toString(),
        },
        body: json.encode(requestBody),
      );

      // Verificar si la respuesta es exitosa (código de estado 200)
      if (response.statusCode == 200) {
        // Parsear el JSON de la respuesta
        Map<String, dynamic> responseData = json.decode(response.body);
        return responseData;
      } else {
        // Lanzar una excepción en lugar de devolver null
        Map<String, dynamic> responseData = json.decode(response.body);
        return responseData;
      }
    } catch (e) {
      print('Error en la solicitud HTTP: $e');
      // Puedes manejar el error aquí si es necesario
      // Devolver un valor predeterminado o lanzar otra excepción si es apropiado
      return Map<String, dynamic>(); // Devolver un mapa vacío por ejemplo
    }
  }
}
