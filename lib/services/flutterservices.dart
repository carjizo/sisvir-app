// flutterservices.dart
import 'package:cloud_firestore/cloud_firestore.dart';

Stream<Paciente> streamPaciente(String documentId) {
  return FirebaseFirestore.instance
      .collection('dispo')
      .doc(documentId)
      .snapshots()
      .map((doc) => Paciente.fromFirestore(doc));
}

class Paciente {
  final String nombre;
  final double temperatura;
  final int pulso;
  final String fecha;

  Paciente({
    required this.nombre,
    required this.temperatura,
    required this.pulso,
    required this.fecha,
  });

  factory Paciente.fromFirestore(DocumentSnapshot doc) {
    var data = doc.data() as Map<String, dynamic>;
    return Paciente(
      nombre: data['nombre'] ?? '',
      temperatura: data['temp']?.toDouble() ?? 0.0,
      pulso: data['puls']?.toInt() ?? 0,
      fecha: data['fechaHora'] ?? '',
    );
  }
}
