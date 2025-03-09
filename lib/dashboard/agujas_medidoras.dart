import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Widget buildGaugeCard1(BuildContext context, String title, double value,
    IconData icon, Color color) {
  return Card(
    margin: const EdgeInsets.all(10),
    child: Container(
      width: MediaQuery.of(context).size.width /
          2.2, // Ajusta el ancho de la tarjeta
      height: MediaQuery.of(context).size.width /
          1.5, // Asegura que la tarjeta sea cuadrada
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FaIcon(icon, size: 24, color: color), // Icono a color
          const SizedBox(height: 4),
          Text(title,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          Expanded(
            child: SfRadialGauge(
              axes: <RadialAxis>[
                RadialAxis(
                  minimum: 30,
                  maximum: 42, // Ajusta según tus necesidades
                  ranges: <GaugeRange>[
                    GaugeRange(
                        startValue: 30, endValue: 34, color: Colors.green),
                    GaugeRange(
                        startValue: 34, endValue: 38, color: Colors.orange),
                    GaugeRange(startValue: 38, endValue: 42, color: Colors.red)
                  ],
                  pointers: <GaugePointer>[
                    NeedlePointer(
                      value: value,
                      needleColor: Colors.blue,
                      needleLength:
                          0.8, // La aguja tendrá una longitud del 80% del radio del eje
                      needleStartWidth: 0.3, // Ancho de la base de la aguja
                      needleEndWidth:
                          3, // Ancho del extremo de la aguja, haciéndola más gruesa en la punta
                    ) // Aguja a color
                  ],
                )
              ],
            ),
          ), // Muestra el valor numérico
          Text('${value.toStringAsFixed(1)}°C',
              style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold)), // Muestra el valor numérico
        ],
      ),
    ),
  );
}

Widget buildGaugeCard2(BuildContext context, String title, double value,
    IconData icon, Color color) {
  return Card(
    margin: const EdgeInsets.all(5),
    child: Container(
      width: MediaQuery.of(context).size.width /
          2.2, // Ajusta el ancho de la tarjeta
      height: MediaQuery.of(context).size.width /
          1.5, // Asegura que la tarjeta sea cuadrada
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FaIcon(icon, size: 24, color: color), // Icono a color
          SizedBox(height: 8),
          Text(title,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          Expanded(
            child: SfRadialGauge(
              axes: <RadialAxis>[
                RadialAxis(
                  minimum: 60,
                  maximum: 100, // Ajusta según tus necesidades
                  ranges: <GaugeRange>[
                    GaugeRange(
                        startValue: 60, endValue: 70, color: Colors.green),
                    GaugeRange(
                        startValue: 70, endValue: 80, color: Colors.orange),
                    GaugeRange(startValue: 80, endValue: 100, color: Colors.red)
                  ],
                  pointers: <GaugePointer>[
                    NeedlePointer(
                      value: value,
                      needleColor: Colors.blue,
                      needleLength:
                          0.8, // La aguja tendrá una longitud del 80% del radio del eje
                      needleStartWidth: 0.3, // Ancho de la base de la aguja
                      needleEndWidth:
                          3, // Ancho del extremo de la aguja, haciéndola más gruesa en la punta
                    ) // Aguja a color
                  ],
                )
              ],
            ),
          ), // Muestra el valor numérico
          Text('${value.toInt()}bpm',
              style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold)), // Muestra el valor numérico
        ],
      ),
    ),
  );
}
