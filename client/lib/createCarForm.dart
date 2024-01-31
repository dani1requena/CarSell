import 'dart:html' as html;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class CreateCarForm extends StatefulWidget {
  const CreateCarForm({Key? key}) : super(key: key);

  @override
  _CreateCarFormState createState() => _CreateCarFormState();
}

class _CreateCarFormState extends State<CreateCarForm> {
  html.FileUploadInputElement? _selectedImage;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _kilometerController = TextEditingController();
  final TextEditingController _horsePowerController = TextEditingController();
  final TextEditingController _authorIdController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  void _submitForm() async {
    int kmNumber = int.parse(_kilometerController.text);
    int hpNumber = int.parse(_horsePowerController.text);
    int authorIdNumber = int.parse(_authorIdController.text);

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

        var request = http.MultipartRequest(
            'POST', Uri.parse('http://localhost:4000/cars'));

        // Attach file
        request.files.add(multerUpload);
        request.fields['brand'] = _brandController.text;
        request.fields['kilometer'] = kmNumber.toString();
        request.fields['horsepower'] = hpNumber.toString();
        request.fields['authorId'] = authorIdNumber.toString();
        request.fields['description'] = _descriptionController.text;

        try {
          final response = await request.send();
          if (response.statusCode == 201) {
            final fileInfo = {
              'Nombre original': multerUpload.filename,
              'Tamaño': multerUpload.length,
              'Tipo de contenido': multerUpload.contentType,
            };

            print('Éxito');
            print('Datos de la imagen:');
            fileInfo.forEach((key, value) {
              print('$key: $value');
            });

            _formKey.currentState?.reset();
          } else {
            print('Error: ${response.statusCode}');
          }
        } catch (e) {
          print('Error en la solicitud POST: $e');
        }
      });

      reader.onError.listen((e) {
        print('Error al leer el archivo: $e');
      });

      reader.readAsArrayBuffer(file);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('INGRESAR VEHÍCULO'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  _pickImageFromGallery();
                },
                child: const Text('IMAGEN'),
              ),
              TextFormField(
                controller: _brandController,
                decoration: const InputDecoration(labelText: 'Marca:'),
              ),
              TextFormField(
                controller: _kilometerController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Kilometros:'),
              ),
              TextFormField(
                controller: _horsePowerController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Potencia:'),
              ),
              TextFormField(
                controller: _authorIdController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Autor:'),
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Descripción:'),
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

  void _pickImageFromGallery() {
    final input = html.FileUploadInputElement()..accept = 'image/*';
    input.click();

    input.onChange.listen((e) {
      final files = input.files;
      if (files != null && files.isNotEmpty) {
        setState(() {
          _selectedImage = input;
        });
      }
    });
  }
}
