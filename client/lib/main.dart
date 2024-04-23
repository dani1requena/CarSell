// ignore_for_file: library_prefixes

import 'dart:convert';
import 'package:app_car/createCarForm.dart';
import 'package:app_car/detailCar.dart';
import 'package:app_car/ownAds.dart';
import 'package:app_car/registerForm.dart';
import 'package:flutter/material.dart';
import 'loginPage.dart';
import 'package:http/http.dart' as http;
import 'dto/CarDto.dart';
import 'dart:html' as html;
import 'package:app_car/Service/AuthService.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AppCar',
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
  late AuthService authService;

  Future<List<CarDto>> fetchData() async {
    final response = await http.get(Uri.parse('http://localhost:4000/cars'));

    var cars = <CarDto>[];

    if (response.statusCode == 200) {
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
    authService = AuthService();
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
          margin: const EdgeInsets.only(top: 5),
          padding: const EdgeInsets.all(10),
          color: Colors.grey[300],
          width: double.infinity,
          child: const Text("Filtro"),
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
                'PERFIL',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: const Text('Mis anuncios'),
              onTap: () {
                final userId = authService.getUserId();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ownAds(userId: userId)),
                );
              },
            ),
            ListTile(
              title: const Text('LogOut'),
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
                Scaffold.of(context).openEndDrawer();
              },
              icon: const Icon(Icons.face),
              iconSize: 40,
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          final car = _CarDto[index];
          return Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailCar(adId: car.id),
                  ),
                );
              },
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
                      color:
                          const Color.fromARGB(255, 0, 0, 0).withOpacity(0.5),
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
            ),
          );
        },
        itemCount: _CarDto.length,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          bool isLoggedIn =
              html.window.sessionStorage.containsKey('accessToken');
          String? userId = html.window.sessionStorage['userId'];
          if (isLoggedIn) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CreateCarForm(userId: userId)),
            );
          } else {
            _showConfirmationDialog(context);
          }
        },
        tooltip: 'Add Car',
        child: const Icon(Icons.add),
      ),
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const loginPage()),
                );
              },
              child: const Text('Login'),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const registerForm()),
                );
              },
              child: const Text('Registrarse'),
            ),
          ],
        );
      },
    );
  }
}
