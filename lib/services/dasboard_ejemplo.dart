import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Medidor de Temperatura')),
        body: TemperatureGaugePage(),
      ),
    );
  }
}

class TemperatureGaugePage extends StatefulWidget {
  @override
  _TemperatureGaugePageState createState() => _TemperatureGaugePageState();
}

class _TemperatureGaugePageState extends State<TemperatureGaugePage> {
  double _currentTemperature = 0;

  @override
  void initState() {
    super.initState();
    // Simula cambios de temperatura
    Timer.periodic(Duration(seconds: 2), (timer) {
      setState(() {
        // Genera un valor de temperatura aleatorio
        _currentTemperature = math.Random().nextDouble() * 100;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      // Usa el widget del medidor con el valor de temperatura actual
      child: GaugeMeter(temperature: _currentTemperature),
    );
  }
}

class GaugeMeter extends StatelessWidget {
  final double temperature;

  const GaugeMeter({Key? key, required this.temperature}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(200, 100), // Tamaño del medidor
      painter: GaugePainter(value: temperature / 100),
    );
  }
}

class GaugePainter extends CustomPainter {
  final double value;

  GaugePainter({required this.value});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height);
    final radius = size.width / 2;

    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), math.pi,
        math.pi, false, paint);

    final needlePaint = Paint()
      ..color = Colors.red
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    final angle = math.pi + (value * math.pi);
    final needleEnd =
        center + Offset(math.cos(angle) * radius, math.sin(angle) * radius);

    canvas.drawLine(center, needleEnd, needlePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
