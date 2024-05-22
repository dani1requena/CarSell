import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Usar alias para evitar conflicto
import 'package:app_car/dto/CarDto.dart' as dto;
import 'package:app_car/adUpdater.dart';

class OwnAds extends StatefulWidget {
  final String userId;

  const OwnAds({Key? key, required this.userId}) : super(key: key);

  @override
  _OwnAdsState createState() => _OwnAdsState();
}

class _OwnAdsState extends State<OwnAds> {
  final List<dto.CarDto> _carDto = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(
          Uri.parse('http://localhost:4000/cars/user-ads/${widget.userId}'));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body) as List;
        setState(() {
          _carDto.clear();
          for (var jsonCar in jsonResponse) {
            _carDto.add(dto.CarDto.fromJson(jsonCar));
          }
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _error = 'Failed to load data: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = 'Failed to load data: $e';
      });
    }
  }

  void deleteAd(int id) async {
    final url = Uri.parse('http://localhost:4000/cars/$id');
    try {
      final response = await http.delete(url);
      if (response.statusCode == 200) {
        setState(() {
          _carDto.removeWhere((car) => car.id == id);
        });
      } else {
        print(
            'Error al eliminar el anuncio. Código de estado: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al eliminar el anuncio: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemBuilder: (context, index) {
          final car = _carDto[index];
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
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Image.network(
                            'http://localhost:4000/cars/images/${_carDto[index].photo}',
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
                                  _carDto[index].brand,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => AdUpdater(
                                                adId: car.id.toString(),
                                                carDto: _carDto[index],
                                              )),
                                    );
                                  },
                                  child: const Icon(Icons.edit),
                                ),
                                const SizedBox(width: 10),
                                GestureDetector(
                                  onTap: () {
                                    deleteAd(car.id);
                                  },
                                  child: const Icon(Icons.delete),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Text(
                                  _carDto[index].kilometer.toString(),
                                )
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Text(
                                  _carDto[index].horsepower.toString(),
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
        itemCount: _carDto.length,
      ),
    );
  }
}
