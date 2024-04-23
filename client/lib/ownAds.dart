import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dto/CarDto.dart';
import 'dart:html' as html;

class ownAds extends StatefulWidget {
  final String userId;
  const ownAds({Key? key, required this.userId}) : super(key: key);

  @override
  _ownAds createState() => _ownAds();
}

class _ownAds extends State<ownAds> {
  // ignore: non_constant_identifier_names
  final List<CarDto> _CarDto = [];

  Future<List<CarDto>> fetchData() async {
    print('El valor del userId: ${widget.userId}');
    final response = await http
        .get(Uri.parse('http://localhost:4000/cars/user-ads/${widget.userId}'));

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
    fetchData().then((value) {
      setState(() {
        _CarDto.addAll(value);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemBuilder: (context, index) {
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
    );
  }
}
