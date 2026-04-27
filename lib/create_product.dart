import 'dart:io';
import 'package:flut/product.dart';
// import 'package:flut/shop.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CreateProduct extends StatefulWidget {
  const CreateProduct({super.key});

  @override
  State<CreateProduct> createState() => _CreateProductState();
}

class _CreateProductState extends State<CreateProduct> {
  var controllerName = TextEditingController();
  // var controllerImage = TextEditingController();
  final ImagePicker picker = ImagePicker();
  File? selectedImage;

  Future<void> _pickImage() async {
    final XFile? image =
        await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
         selectedImage = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Добавление продукта',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),//------------------------------
            TextFormField(
              controller: controllerName,
              decoration: InputDecoration(
                hintText: 'Название',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 8),//------------------------------
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Pick Image'),
            ),
            SizedBox(height: 8),//------------------------------
            selectedImage != null ? Image.file(selectedImage!, height: 150)  :  Text('No image selected'),
            SizedBox(height: 8),//------------------------------           
            ElevatedButton(
              onPressed: onCreate,
              child: Text('Создать', style: TextStyle(fontSize: 16)),
            ),
            SizedBox(height: 16),            
          ],
        ),
    );
  }

  void onCreate(){
    if (controllerName.text.isEmpty || selectedImage == null) {
      ScaffoldMessenger.of(
        context
      ).showSnackBar(SnackBar(content: Text('Поля пусты :(')),
      );
      return;
    }

    var product = Product(
        name: controllerName.text,
        fileImage: selectedImage
      );
      Navigator.of(context).pop(product);
      
  }
}