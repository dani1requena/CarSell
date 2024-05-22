import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'dart:html' as html;
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:convert';
import 'package:app_car/dto/CarDto.dart' as dto;

class AdUpdater extends StatefulWidget {
  final String? adId;
  final dto.CarDto carDto;
  const AdUpdater({Key? key, required this.adId, required this.carDto})
      : super(key: key);

  @override
  _AdUpdaterState createState() => _AdUpdaterState();
}

class _AdUpdaterState extends State<AdUpdater> {
  html.FileUploadInputElement? _selectedImage;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _kilometerController = TextEditingController();
  final TextEditingController _horsePowerController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _brandController.text = widget.carDto.brand;
    _kilometerController.text = widget.carDto.kilometer.toString();
    _horsePowerController.text = widget.carDto.horsepower.toString();
    _descriptionController.text = '';
  }

  void _pickImageFromGallery() {
    _selectedImage = html.FileUploadInputElement()..accept = 'image/*';
    _selectedImage!.click();
    _selectedImage!.onChange.listen((event) {
      // Handle file selection and set the selected image.
      setState(() {
        _selectedImage = _selectedImage;
      });
    });
  }

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    int kmNumber = int.parse(_kilometerController.text);
    int hpNumber = int.parse(_horsePowerController.text);

    final url = Uri.parse('http://localhost:4000/cars/update/${widget.adId}');

    var requestBody = {
      'brand': _brandController.text,
      'kilometer': kmNumber,
      'horsepower': hpNumber,
      'description': _descriptionController.text,
    };

    if (_selectedImage != null && _selectedImage!.files!.isNotEmpty) {
      final file = _selectedImage!.files!.first;
      final reader = html.FileReader();

      reader.onLoadEnd.listen((e) async {
        List<int> fileBytes = Uint8List.fromList(reader.result as List<int>);
        var multerUpload = http.MultipartFile.fromBytes(
          'photo',
          fileBytes,
          filename: 'car_image.jpg',
          contentType: MediaType('multipart', 'form-data'),
        );

        var request = http.MultipartRequest('PATCH', url)
          ..fields.addAll(
              requestBody.map((key, value) => MapEntry(key, value.toString())))
          ..files.add(multerUpload)
          ..headers.addAll({
            'Authorization':
                'Bearer ${html.window.sessionStorage['accessToken']}',
          });

        try {
          final response = await request.send();
          final responseData = await http.Response.fromStream(response);

          if (response.statusCode == 200) {
            print('Actualización exitosa');
            _formKey.currentState?.reset();
          } else {
            print('Error: ${responseData.statusCode}');
            print('Response: ${responseData.body}');
          }
        } catch (e) {
          print('Error en la solicitud PATCH: $e');
        }
      });

      reader.onError.listen((e) {
        print('Error al leer el archivo: $e');
      });

      reader.readAsArrayBuffer(file);
    } else {
      // Si no hay imagen seleccionada, solo envía los datos del formulario.
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${html.window.sessionStorage['accessToken']}',
      };

      try {
        final response = await http.patch(
          url,
          body: jsonEncode(requestBody),
          headers: headers,
        );

        if (response.statusCode == 200) {
          print('Actualización exitosa');
          _formKey.currentState?.reset();
        } else {
          print('Error: ${response.statusCode}');
          print('Response: ${response.body}');
        }
      } catch (e) {
        print('Error en la solicitud PATCH: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Actualizar Vehículo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _pickImageFromGallery,
                child: const Text('Seleccionar Imagen'),
              ),
              TextFormField(
                controller: _brandController,
                decoration: const InputDecoration(labelText: 'Marca'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese la marca';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _kilometerController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Kilometros'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese los kilometros';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _horsePowerController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Potencia'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese la potencia';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Descripción'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese la descripción';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Enviar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CarDto {
  final String brand;
  final int kilometer;
  final int horsepower;

  CarDto({
    required this.brand,
    required this.kilometer,
    required this.horsepower,
  });
}
