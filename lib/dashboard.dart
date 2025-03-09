import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sisvirflutter/services/flutterservices.dart';
import 'package:intl/intl.dart';
import 'package:sisvirflutter/dashboard/paciente_detalles.dart'; // Asegúrate de importar el archivo de la nueva pantalla
import 'package:sisvirflutter/dashboard/agujas_medidoras.dart';
import 'package:sisvirflutter/login_page.dart';
import 'package:sisvirflutter/dashboard/dispositivo_detalles.dart';

class PatientDetailsPage extends StatelessWidget {
  final String documentId;
  final String nombre;
  final String apellido;
  final String dni;
  final String valorCritico;

  const PatientDetailsPage({
    Key? key, // Agrega el parámetro key aquí
    required this.documentId,
    required this.nombre,
    required this.apellido,
    required this.dni,
    required this.valorCritico,
  }) : super(key: key); // Pasa el key al constructor de la superclase
  void _showLogoutDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Confirmar',
            textAlign: TextAlign.center, // Centra el título
            style: TextStyle(
              fontSize: 24, // Tamaño de fuente más grande para el título
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            '¿Estás seguro que quieres cerrar la sesión?',
            textAlign: TextAlign.center, // Centra el contenido
            style: TextStyle(
              fontSize: 20, // Tamaño de fuente más grande para el contenido
            ),
          ),
          actions: <Widget>[
            SingleChildScrollView(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment:
                    MainAxisAlignment.center, // Centra los botones
                children: <Widget>[
                  TextButton(
                    child: const Text(
                      'No',
                      style: TextStyle(
                        fontSize:
                            18, // Tamaño de fuente más grande para los botones
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(); // Cierra el diálogo
                    },
                  ),
                  TextButton(
                    child: const Text(
                      'Sí',
                      style: TextStyle(
                        fontSize:
                            18, // Tamaño de fuente más grande para los botones
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(); // Cierra el diálogo

                      // Navega de regreso a la LoginPage y asegúrate de que se reconstruya
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
          actionsAlignment: MainAxisAlignment
              .center, // Esta línea centra los botones horizontalmente
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        if (didPop) {
          return;
        }
        _showLogoutDialog(context);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Monitoreo del Paciente'),
          backgroundColor: Color.fromARGB(255, 19, 255, 149),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.exit_to_app),
              onPressed: () {
                _showLogoutDialog(context);
              },
            ),
          ],
        ),
        backgroundColor: const Color.fromARGB(255, 103, 195, 197),
        body: StreamBuilder<Paciente>(
          stream: streamPaciente(documentId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              //final nowUtc = DateTime.now().toUtc();
              final nowUtc = DateTime.now();
              final nowInPeru = nowUtc.subtract(const Duration(
                  hours:
                      5)); // Ajusta la hora UTC al horario de Perú manualmente
              String actualizacion = DateFormat('HH:mm').format(nowUtc);
              return Column(
                children: <Widget>[
                  Expanded(
                    child: buildPatientDetails(snapshot.data!, context),
                  ),
                  // Muestra la fecha de la última actualización en la parte inferior
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Última Actualización: $actualizacion',
                      //'Última Actualización: $paciente.temperatura,',
                      style: const TextStyle(
                          color: Color.fromARGB(255, 59, 1, 83),
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              );
            } else {
              return const Center(
                  child: Text('No se encontraron datos del paciente'));
            }
          },
        ),
      ),
    );
  }

  bool obtenerEstadoDispositivoConectado(ultimaHora) {
    final nowUtc = DateTime.now().toUtc();
    final nowInPeru = nowUtc.subtract(const Duration(
        hours: 5)); // Ajusta la hora UTC al horario de Perú manualmente
    final diff = nowInPeru.difference(
        ultimaHora); // Suponiendo que lastUpdateTime es la última hora de actualización del paciente
    // Si la diferencia es mayor a un minuto, el dispositivo está desconectado
    return diff.inMinutes <= 1;
  }

  Map<String, dynamic> obtenerEstadoDelPaciente(int pulso, int temp) {
    String estado;
    Color color;
    // Comparar los valores y determinar el estado
    //if (int.parse(valorCritico) < pulso) {
    if (int.parse(valorCritico) < pulso || temp > 37) {
      estado = "En Peligro";
      color = const Color.fromARGB(
          255, 245, 118, 0); // Color rojo para estado crítico
    } else {
      estado = "Estable";
      color = const Color.fromARGB(
          255, 34, 255, 0); // Color verde para estado estable
    }
    return {'estado': estado, 'color': color};
  }

  Widget buildPatientDetails(Paciente paciente, BuildContext context) {
    DateTime obtenerFecha() {
      String ultimaActualizacion = paciente.fecha;
      DateFormat format = DateFormat("dd/MM/yyyy HH:mm:ss");
      DateTime dateTime = format.parse(ultimaActualizacion);

      // Retorna la fecha y hora sin milisegundos
      return DateTime(dateTime.year, dateTime.month, dateTime.day,
          dateTime.hour, dateTime.minute, dateTime.second);
    }

    String calcularDiferenciaFechas() {
      // Obtener la hora actual en formato de 24 horas
      TimeOfDay horaActual = TimeOfDay.now();

      // Convertir la hora actual a un objeto DateTime
      DateTime nowUtc = DateTime(DateTime.now().year, DateTime.now().month,
          DateTime.now().day, horaActual.hour, horaActual.minute);
      //print(nowUtc);
      // Obtener la hora generada por la función obtenerFecha()
      DateTime fechaGenerada = obtenerFecha();

      // Calcular la diferencia de tiempo
      Duration diferencia = nowUtc.difference(fechaGenerada);

      // Convertir la diferencia de tiempo en días, horas, minutos y segundos
      int dias = diferencia.inDays;
      int horas = diferencia.inHours % 24;
      int minutos = diferencia.inMinutes % 60;
      int segundos = diferencia.inSeconds % 60;

      // Construir la cadena de diferencia de tiempo
      String diferenciaString =
          '$dias días, $horas horas, $minutos minutos, $segundos segundos';
      return diferenciaString;
    }

    bool comprobarEstadoDispositivo() {
      TimeOfDay horaActual = TimeOfDay.now();
      // Convertir la hora actual a un objeto DateTime
      DateTime nowUtc = DateTime(DateTime.now().year, DateTime.now().month,
          DateTime.now().day, horaActual.hour, horaActual.minute);
      //print(nowUtc);
      // Obtener la hora generada por la función obtenerFecha()
      DateTime fechaGenerada = obtenerFecha();
      // Calcular la diferencia de tiempo
      Duration diferencia = nowUtc.difference(fechaGenerada);
      // Convertir la diferencia de tiempo en días, horas, minutos y segundos
      // int dias = diferencia.inDays;
      // int horas = diferencia.inHours % 24;
      // int minutos = diferencia.inMinutes % 60;
      // int segundos = diferencia.inSeconds % 60;
      return diferencia.inSeconds <= 40;
    }

    Widget tarjetaPaciente = _buildDetailCard(
      context,
      "Paciente:",
      "${nombre}  ${apellido}", // Asegúrate de que 'nombre' y 'apellido' están disponibles
      FontAwesomeIcons.user,
      const Color.fromARGB(166, 255, 255, 255), // Hace la tarjeta transparente
      isPatientCard:
          true, // Asumiendo que agregas este parámetro para centrar el contenido
    );

    // Tarjetas de Temperatura y Pulso en forma de cuadrados
    List<Widget> tarjetasDetalles = [
      buildGaugeCard1(
        context,
        "Temperatura",
        paciente
            .temperatura, // Asegúrate de que este valor esté en el rango que tu medidor soporte
        FontAwesomeIcons.temperatureHigh,
        obtenerEstadoDelPaciente(
            paciente.pulso, paciente.temperatura.toInt())['color'],
      ),
      buildGaugeCard2(
        context,
        "Pulso Cardiaco",
        paciente.pulso
            .toDouble(), // Asegúrate de que este valor esté en el rango que tu medidor soporte
        FontAwesomeIcons.heartbeat,
        obtenerEstadoDelPaciente(
            paciente.pulso, paciente.temperatura.toInt())['color'],
      ),
    ];

    // Tarjeta del Estado en forma de rectángulo
    Widget tarjetaEstado = _buildDetailCard(
      context,
      "Estado Actual del Paciente:",
      obtenerEstadoDelPaciente(
          paciente.pulso, paciente.temperatura.toInt())['estado'],
      FontAwesomeIcons.comment,
      obtenerEstadoDelPaciente(paciente.pulso, paciente.temperatura.toInt())[
          'color'], // Esto determinará el color basado en el estado
    );
    Widget tarjetaFechaHora = _buildDetailCard(
      context,
      "Ultima Fecha y Hora del Reporte:",
      //calcularDiferenciaFechas(),
      //obtenerFecha().toString(),
      paciente.fecha,
      FontAwesomeIcons.clock,
      const Color.fromARGB(255, 152, 221,
          244), // Puedes personalizar el color según tus preferencias
    );
    Widget tarjetaDispositivo = InkWell(
      onTap: () {
        // Navegar a la pantalla de información del dispositivo (DispositivoScreen)
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DispositivoScreen(
                    variable1: documentId,
                    variable2: calcularDiferenciaFechas(),
                    //variable2: convertirHora('22:34').toString(),
                    variable3: comprobarEstadoDispositivo(),
                  )),
        );
      },
      child: _buildDetailCard(
        context,
        "Información del Dispositivo",
        //calcularDiferenciaFechas(),
        "?",
        Icons.devices_other,
        const Color.fromARGB(255, 151, 221, 173),
      ),
    );

    return SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            tarjetaPaciente,
            const SizedBox(
                height:
                    1), // Espacio entre la tarjeta del paciente y las tarjetas cuadradas
            tarjetaFechaHora,
            const SizedBox(height: 1),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: tarjetasDetalles,
            ),
            const SizedBox(
                height:
                    1), // Espacio entre las tarjetas cuadradas y la tarjeta del estado
            tarjetaEstado,
            const SizedBox(height: 1),
            tarjetaDispositivo,
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard(BuildContext context, String title, String value,
      IconData icon, Color color,
      {bool isPatientCard = false}) {
    return Card(
      margin: const EdgeInsets.all(15),
      color: color,
      child: isPatientCard
          ? InkWell(
              onTap: () {
                // Navega a PatientDniPage al tocar
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PatientDniPage(
                            dni: dni,
                            nombre: nombre,
                            apellido: apellido,
                          )), // Asegúrate de que 'value' contenga el DNI para la tarjeta del paciente
                );
              },
              child: ListTile(
                leading: FaIcon(icon, size: 40),
                title: Text(title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 71, 4, 255))),
                subtitle: Text(value,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 58, 2, 93))),
              ),
            )
          : ListTile(
              leading: FaIcon(icon, size: 60),
              title: Text(title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 0, 0, 0))),
              subtitle: Text(value,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 19, 43, 62))),
            ),
    );
  }
}
