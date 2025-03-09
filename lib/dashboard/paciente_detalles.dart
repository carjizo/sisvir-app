import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class PatientDniPage extends StatefulWidget {
  final String dni;
  final String nombre;
  final String apellido;
  PatientDniPage(
      {required this.dni, required this.nombre, required this.apellido});

  @override
  _PatientDniPageState createState() => _PatientDniPageState();
}

class _PatientDniPageState extends State<PatientDniPage> {
  late Future<dynamic> patientData;

  @override
  void initState() {
    super.initState();
    patientData = fetchPatientData(widget.dni);
  }

  Future<dynamic> fetchPatientData(String dni) async {
    try {
      var token = dotenv.env['API_TOKEN'];
      final response = await http.post(
        Uri.parse(
            'https://tej0nb36k0.execute-api.us-east-1.amazonaws.com/dev/awssisvir/appsisvir/consulta-usuario'),
        headers: {
          'Content-Type': 'application/json',
          'auth-token': token.toString(),
        },
        body: jsonEncode(<String, String>{
          'dni': dni,
          'nombre': widget.nombre,
          'apellido': widget.apellido,
        }),
      );

      if (response.statusCode == 200) {
        // Lógica adicional si la alerta fue exitosa
        print('Consulta realizada correctamente');
        print(DateTime.now().toString()); // Obtener hora actual);
        return jsonDecode(response.body);
      } else {
        throw Exception(
            'Fallo al cargar el dato del paciente: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al cargar el dato del paciente: $e');
      _showDialog(context, 'Error !!!', '$e', false);
      return null; // Devuelve null en caso de error
    }
  }

  Widget _buildDetailCard(String title, String value) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(value, style: const TextStyle(fontSize: 20)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalles del Paciente"),
        backgroundColor: const Color.fromARGB(255, 132, 171, 202),
      ),
      backgroundColor: const Color.fromARGB(255, 211, 242, 227),
      body: Center(
        child: FutureBuilder<dynamic>(
          future: patientData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            } else if (snapshot.hasData) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      'Datos del Paciente:',
                      //'Última Actualización: $paciente.temperatura,',
                      style: TextStyle(
                          color: Color.fromARGB(255, 52, 49, 0),
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    _buildDetailCard("DNI", widget.dni),
                    _buildDetailCard("Peso",
                        "${snapshot.data['peso']} kg"), // Asegúrate de ajustar la clave de acuerdo a tu respuesta JSON
                    _buildDetailCard("Estatura",
                        "${snapshot.data['estatura']} cm"), // Ajusta la clave según sea necesario
                    _buildDetailCard(
                        "Antecedentes Patológicos",
                        snapshot.data[
                            'antecedente_patologico']), // Ajusta la clave según sea necesario
                    ElevatedButton(
                      onPressed: () {
                        // Acción a realizar cuando se presiona el botón
                        alertarPaciente(widget.nombre, widget.apellido);
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color.fromARGB(255, 255, 152,
                                49)), // Cambia el color del botón
                      ),
                      child: const Text(
                        'Alertar',
                        style: TextStyle(
                            color: Color.fromARGB(255, 0, 15, 102),
                            fontSize: 22),
                      ),
                    )
                  ],
                ),
              );
            } else {
              return const Text("No se encontraron datos del paciente");
            }
          },
        ),
      ),
    );
  }

  // Función para alertar al paciente
  Future<void> alertarPaciente(String nombre, String apellido) async {
    try {
      var token = dotenv.env['API_TOKEN'];
      final response = await http.post(
        Uri.parse(
            'https://tej0nb36k0.execute-api.us-east-1.amazonaws.com/dev/awssisvir/appsisvir/alertas-patologicas'),
        headers: {
          'Content-Type': 'application/json',
          'auth-token': token.toString(),
        },
        body: jsonEncode(<String, String>{
          "nombres": nombre,
          "apellidos": apellido,
          "fecha_hora": DateTime.now().toString()
        }),
      );

      if (response.statusCode == 200) {
        // Lógica adicional si la alerta fue exitosa
        print('Alerta enviada correctamente');
        _showDialog(
            context, 'Alerta Exitosa', 'Se envió el sms de emergencia', true);
      } else {
        throw Exception('Fallo al alertar al paciente: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al alertar al paciente: $e');
      _showDialog(context, 'Error !!!', '$e', false);
    }
  }

  void _showDialog(
      BuildContext context, String title, String message, bool isSuccess) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            textAlign: TextAlign.center,
          ),
          content: Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              color: isSuccess ? Colors.green : Colors.red,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }
}
