import 'package:flutter/material.dart';

class DispositivoScreen extends StatelessWidget {
  final String variable1;
  final String variable2;
  final bool variable3;

  Map<String, dynamic> comprobarEstadoDispositivo() {
    String estado;
    Color color;
    Color found;
    // Comparar los valores y determinar el estado
    //if (int.parse(valorCritico) < pulso) {
    if (variable3 == false) {
      estado = "Desconectado";
      color = const Color.fromARGB(
          255, 119, 14, 2); // Color rojo para estado crítico
      found = const Color.fromARGB(255, 243, 128, 116);
    } else {
      estado = "Conectado";
      color = const Color.fromARGB(
          255, 21, 156, 0); // Color verde para estado estable
      found = const Color.fromARGB(255, 194, 246, 177);
    }
    return {'estado': estado, 'color': color, 'found': found};
  }

  const DispositivoScreen(
      {required this.variable1,
      required this.variable2,
      required this.variable3});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Información del Dispositivo'),
        backgroundColor: const Color.fromARGB(255, 133, 204, 190),
      ),
      backgroundColor: comprobarEstadoDispositivo()['found'],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Estado del Dispositivo:',
              //'Última Actualización: $paciente.temperatura,',
              style: TextStyle(
                  color: Color.fromARGB(255, 52, 49, 0),
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              comprobarEstadoDispositivo()['estado'],
              //'Última Actualización: $paciente.temperatura,',
              style: TextStyle(
                  color: comprobarEstadoDispositivo()['color'],
                  fontSize: 28,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'Última Lectura:',
              //'Última Actualización: $paciente.temperatura,',
              style: TextStyle(
                  color: Color.fromARGB(255, 1, 18, 1),
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              'Hace $variable2',
              //'Última Actualización: $paciente.temperatura,',
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Color.fromARGB(255, 59, 1, 83),
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            ),
            const Text(
              '_________________',
              //'Última Actualización: $paciente.temperatura,',
              style: TextStyle(
                  color: Color.fromARGB(255, 23, 21, 21),
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            const Text(
              'Información Adicional:',
              //'Última Actualización: $paciente.temperatura,',
              style: TextStyle(
                  color: Color.fromARGB(255, 23, 21, 21),
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Nombre del Dispositivo:',
              //'Última Actualización: $paciente.temperatura,',
              style: TextStyle(
                  color: Color.fromARGB(255, 0, 141, 110),
                  fontSize: 26,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'SisvirDevice',
              //'Última Actualización: $paciente.temperatura,',
              style: TextStyle(
                  color: Color.fromARGB(255, 0, 141, 110),
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'MAC:',
              //'Última Actualización: $paciente.temperatura,',
              style: TextStyle(
                  color: Color.fromARGB(255, 2, 19, 202),
                  fontSize: 26,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              variable1,
              //'Última Actualización: $paciente.temperatura,',
              style: const TextStyle(
                  color: Color.fromARGB(255, 2, 19, 202),
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
