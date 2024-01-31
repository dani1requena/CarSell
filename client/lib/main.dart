// ignore_for_file: library_prefixes

import 'dart:convert';
import 'package:app_car/registerForm.dart';
import 'package:flutter/material.dart';
import 'CreateCarForm.dart';
import 'package:http/http.dart' as http;
import 'dto/CarDto.dart';
import 'registerForm.dart';

void main() {
  runApp(const MyApp());
  //createCarForm carCreator = createCarForm();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CARROS DE LA VRG',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 108, 181, 118)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'CARROS DEL AÑO'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // ignore: non_constant_identifier_names
  final List<CarDto> _CarDto = [];

  Future<List<CarDto>> fetchData() async {
    final response = await http.get(Uri.parse('http://localhost:4000/cars'));

    var cars = <CarDto>[];

    if (response.statusCode == 200) {
      // final List<dynamic> jsonResponse = json.decode(response.body);
      // return jsonResponse.map((json) => CarDto.fromJson(json)).toList();
      final jsonResponse = json.decode(response.body);
      for (var jsonCar in jsonResponse) {
        cars.add(CarDto.fromJson(jsonCar));
      }
    } else {
      throw Exception('Failed to load data');
    }
    return cars;
  }

  @override
  void initState() {
    super.initState();
    fetchData().then((value) {
      setState(() {
        _CarDto.addAll(value);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
          child: Column(children: [
        Container(
          margin: const EdgeInsets.only(top: 20),
          padding: const EdgeInsets.all(10),
          color: Colors.grey[300],
          width: double.infinity,
          child: const Text("Perfil"),
        ),
        Container(
          margin: const EdgeInsets.only(top: 5),
          padding: const EdgeInsets.all(10),
          color: Colors.grey[300],
          width: double.infinity,
          child: const Text("Ajustes"),
        ),
        Container(
          margin: const EdgeInsets.only(top: 5),
          padding: const EdgeInsets.all(10),
          color: Colors.grey[300],
          width: double.infinity,
          child: const Text("Guardados"),
        ),
        Container(
          margin: const EdgeInsets.only(top: 5),
          padding: const EdgeInsets.all(10),
          color: Colors.grey[300],
          width: double.infinity,
          child: const Text("LogOut"),
        )
      ])),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Mi Drawer Derecho',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: const Text('Ajustes'),
              onTap: () {
                // Acción para la opción 1
              },
            ),
            ListTile(
              title: const Text('Salir'),
              onTap: () {
                // Acción para la opción 2
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        centerTitle: true,
        actions: [
          Builder(
            builder: (context) => IconButton(
              onPressed: () {
                Scaffold.of(context).openEndDrawer(); // Abre el Drawer
              },
              icon: const Icon(Icons.face),
              iconSize: 40,
            ),
          ),
        ],
      ),
      body: ListView.builder(
        //body: FutureBuilder(
        //future: fetchData(),
        itemBuilder: (context, index) {
          // if (snapshot.connectionState == ConnectionState.waiting) {
          //   return const CircularProgressIndicator();
          // } else if (snapshot.hasError) {
          //   return Text('Error: ${snapshot.error}');
          // } else {
          //   final List<dynamic>? data = snapshot.data;

          return Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
            child: Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.blue, Color.fromARGB(255, 173, 213, 231)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Image.network(
                          'http://localhost:4000/cars/images/${_CarDto[index].photo}',
                          width: 80,
                          height: 80,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                _CarDto[index].brand,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Text(
                                _CarDto[index].kilometer.toString(),
                              )
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Text(
                                _CarDto[index].horsepower.toString(),
                              )
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
        },
        itemCount: _CarDto.length,
      ),
      floatingActionButton: FloatingActionButton(
        // onPressed: () {
        //   Navigator.push(
        //     context,
        //     MaterialPageRoute(builder: (context) => const CreateCarForm()),
        //   );
        // },
        onPressed: () {
          _showConfirmationDialog(context);
        },
        tooltip: 'Add Car',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Solo los miembros pueden publicar anuncios'),
          content: const Text(
              '¿Tienes una cuenta? Pulsa Login. En caso de no tenerla, pulsa Registrarse'),
          actions: [
            TextButton(
              onPressed: () {
                // Acciones al presionar "Sí"
                Navigator.of(context).pop(); // Cierra el diálogo
                // Aquí puedes agregar más lógica si es necesario
              },
              child: const Text('Login'),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const registerForm()),
                );
                //Navigator.of(context).pop(); // Cierra el diálogo
                // Aquí puedes agregar más lógica si es necesario
              },
              child: const Text('Registrarse'),
            ),
          ],
        );
      },
    );
  }
}
