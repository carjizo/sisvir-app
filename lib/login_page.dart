import 'package:flutter/material.dart';
import 'package:sisvirflutter/validar_usuario.dart'; // Asegúrate de proporcionar la ruta correcta
import 'package:sisvirflutter/dashboard.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscureText =
      true; // Variable para controlar la visibilidad de la contraseña
  bool _isButtonEnabled =
      false; // Variable para habilitar/deshabilitar el botón
  @override
  void _showDialog(String title, String message, bool isSuccess) {
    showDialog(
      context: context,
      barrierDismissible:
          false, // Impide que se cierre el diálogo al tocar fuera de él
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            textAlign: TextAlign.center, // Centra el título
          ),
          content: Text(
            message,
            textAlign: TextAlign.center, // Centra el mensaje
            style: TextStyle(
              fontSize: 20, // Tamaño del texto más grande
              color: isSuccess ? Colors.green : Colors.red, // Color condicional
            ),
          ),
        );
      },
    );
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context, rootNavigator: true)
          .pop(); // Asegúrate de cerrar el diálogo
    });
  }

  //@override
  void _showDialog2(String title, String message, bool isSuccess) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              color: Color.fromARGB(255, 43, 1, 8),
            ),
          ),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  color: isSuccess
                      ? Colors.green
                      : const Color.fromARGB(255, 155, 10, 0),
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context)
                      .pop(); // Cierra el diálogo al presionar el botón
                },
                child: const Text('Aceptar'),
              ),
            ),
          ],
        );
      },
    );
  }

  void cargandoData() {
    showDialog(
      context: context,
      barrierDismissible: false, // Evita cerrar el diálogo al tocar fuera de él
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(), // Barra de progreso
              SizedBox(height: 16),
              Text(
                  'Iniciando Sesión...'), // Texto indicando que se están cargando los datos
            ],
          ),
        );
      },
    );
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context, rootNavigator: true)
          .pop(); // Asegúrate de cerrar el diálogo
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio de Sesión'),
        titleTextStyle: const TextStyle(
          color: Color.fromARGB(255, 0, 46, 83),
          fontSize: 30,
        ),
        backgroundColor: const Color.fromARGB(255, 220, 248, 237),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 255, 255, 255),
              Color.fromARGB(255, 167, 219, 212),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Title(
                  color: Colors.green,
                  child: const Text(
                    'BIENVENID@',
                    style: TextStyle(
                      color:
                          Color.fromARGB(223, 2, 141, 132), // Color del texto
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  )),
              const SizedBox(height: 5),
              Container(
                child: Image.asset(
                  'assets/PosibleLogo.png', // Ruta de la imagen en tu proyecto
                  width: 200, // Ancho de la imagen
                  height: 200, // Alto de la imagen
                  fit:
                      BoxFit.cover, // Ajuste de la imagen dentro del contenedor
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: usernameController,
                onChanged: (_) {
                  setState(() {
                    _isButtonEnabled = usernameController.text.isNotEmpty &&
                        passwordController.text.isNotEmpty;
                  });
                },
                decoration: const InputDecoration(
                    labelText: 'Usuario',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                    labelStyle: TextStyle(
                      color: Color.fromARGB(255, 0, 23, 75),
                      fontSize: 20,
                    )),
                style: const TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passwordController,
                onChanged: (_) {
                  setState(() {
                    _isButtonEnabled = usernameController.text.isNotEmpty &&
                        passwordController.text.isNotEmpty;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(_obscureText
                        ? Icons.visibility_off
                        : Icons
                            .visibility), // Icono para mostrar/ocultar la contraseña
                    onPressed: () {
                      setState(() {
                        _obscureText =
                            !_obscureText; // Cambiar el estado de la visibilidad
                      });
                    },
                  ),
                  labelStyle: const TextStyle(
                    color: Color.fromARGB(255, 27, 0, 122),
                    fontSize: 20,
                  ),
                ),
                style: const TextStyle(
                  color: Color.fromARGB(255, 0, 37, 25),
                  fontSize: 20,
                ),
                obscureText:
                    _obscureText, // Usar un booleano para controlar la visibilidad
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _isButtonEnabled
                    ? () async {
                        // Obtener datos del usuario al autenticar
                        Map<String, dynamic> userInfo =
                            await ValidarUsuario.validarCredenciales(
                          usernameController.text,
                          passwordController.text,
                        );
                        if (userInfo != null &&
                            userInfo['status'] == '200' &&
                            userInfo['mensaje'] == 'SUCCESS') {
                          cargandoData();
                          //_showDialog('Inicio de sesión exitoso',
                          //  'Bienvenid@ al sistema.', true);
                          Future.delayed(const Duration(seconds: 2), () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PatientDetailsPage(
                                  documentId: userInfo['body']['mac'] ?? '',
                                  nombre: userInfo['body']['nombres'] ?? '',
                                  apellido: userInfo['body']['apellidos'] ?? '',
                                  dni: userInfo['body']['dni'] ?? '',
                                  valorCritico:
                                      userInfo['body']['valor_critico'] ?? '',
                                ),
                              ),
                            );
                          });
                        } else if (userInfo['status'] == '500' &&
                            userInfo['mensaje'] == 'Usuario no registrado') {
                          // Manejar caso de autenticación fallida
                          _showDialog('Usuario no registrado',
                              'Por Favor Ingresa un Usuario Válido ', false);
                          usernameController.clear();
                        } else if (userInfo['status'] == '500' &&
                            userInfo['mensaje'] == 'Contraseña incorrecta') {
                          // Manejar caso de autenticación fallida
                          _showDialog(
                              'Contraseña Incorrecta',
                              'Por Favor Ingresa Nuevamente Tu Contraseña ',
                              false);
                          passwordController.clear();
                        } else {
                          _showDialog2(
                              'Error!!!!',
                              'Verifica tu Conexión a Internet en este Dispositivo',
                              false);
                        }
                      }
                    : null, // Deshabilitar el botón si _isButtonEnabled es falso
                child: const Text(
                  'INGRESAR',
                  style: TextStyle(
                    color: Color.fromARGB(223, 119, 5, 132), // Color del texto
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
