import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dto/CarDto.dart';
import 'dart:html' as html;

class DetailCar extends StatefulWidget {
  final int adId;

  const DetailCar({Key? key, required this.adId}) : super(key: key);

  @override
  _DetailCarState createState() => _DetailCarState();
}

class _DetailCarState extends State<DetailCar> {
  late CarDto _carDto;

  @override
  void initState() {
    super.initState();
    _carDto = CarDto(
        id: 0,
        photo: '',
        brand: '',
        kilometer: 0,
        horsepower: 0,
        description: '');
    _fetchCarDetails();
  }

  Future<void> _fetchCarDetails() async {
    try {
      final response = await http
          .get(Uri.parse('http://localhost:4000/cars/${widget.adId}'));

      print('Lo del widget: ${widget.adId}');
      print('Código de estado de la respuesta: ${response.statusCode}');
      print('Cuerpo de la respuesta: ${response.body}');
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          _carDto = CarDto.fromJson(data);
        });
      } else {
        throw Exception('Failed to load ad details');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalle del anuncio'),
      ),
      body: _carDto != null
          ? ListView(
              padding: EdgeInsets.all(16.0),
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Image.network(
                    'http://localhost:4000/cars/images/${_carDto.photo}',
                    width: 80,
                    height: 80,
                  ),
                ),
                Text('Marca: ${_carDto.brand}'),
                Text('Kilometraje: ${_carDto.kilometer}'),
                Text('Potencia: ${_carDto.horsepower}'),
                Text('Descripción: ${_carDto.description}'),
              ],
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
