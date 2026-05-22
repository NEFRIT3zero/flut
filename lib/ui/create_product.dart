import 'dart:io';
import 'dart:typed_data';
// import 'dart:nativewrappers/_internal/vm/lib/typed_data_patch.dart';
// import 'dart:nativewrappers/_internal/vm/lib/typed_data_patch.dart';
import 'package:flut/models/product.dart';
// import 'package:flut/shop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:riverpod/riverpod.dart';
import 'package:flut/services/providers.dart';
import 'package:flut/services/product_provider.dart';

class CreateProduct extends ConsumerStatefulWidget {
  const CreateProduct({super.key});

  @override
  ConsumerState<CreateProduct> createState() => _CreateProductState();
}

class _CreateProductState extends ConsumerState<CreateProduct> {
  var controllerName = TextEditingController();
  // var controllerImage = TextEditingController();
  final ImagePicker picker = ImagePicker();
  File? selectedImage;
  String? newImagePath;

  Future<void> _pickImage() async {
    // print('2');
    // PermissionStatus status = await Permission.photos.request();
    // print('3');
    // if (status.isGranted) {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    // print('4');
    if (image != null) {
      print('img choosed');
      Directory appDir = await getApplicationDocumentsDirectory();
      await Directory('${appDir.path}/images').create(recursive: true);

      File newImage = File(
        '${appDir.path}/images/${DateTime.now().millisecondsSinceEpoch.toString()}.jpg',
      );
      print(
        'generated directory ${appDir.path}/images/${DateTime.now().millisecondsSinceEpoch.toString()}.jpg',
      );

      Uint8List imageBytes = await image.readAsBytes();
      await newImage.writeAsBytes(imageBytes);
      print('img copy saved');

      setState(() {
        selectedImage = File(image.path);
        newImagePath = newImage.path;
      });

      // await newImagePath
    }
    // } else if (status.isDenied) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text('Permission denied. Cannot access gallery.')),
    //   );
    // } else if (status.isPermanentlyDenied) {
    //   openAppSettings();
    // }
  }
  // Future<void> _pickImage() async {
  //   final XFile? image = await picker.pickImage(source: ImageSource.gallery);
  //
  //   if (image != null) {
  //     setState(() {
  //        selectedImage = File(image.path);
  //     });
  //
  //     Directory appDir = await getApplicationDocumentsDirectory();
  //     await Directory('${appDir.path}/images').create(recursive: true);
  //
  //     String newPath = '${appDir.path}/images/${DateTime.now().millisecondsSinceEpoch}.jpg';
  //     File newImage = await File(image.path).copy(newPath);
  //
  //     await saveToDatabase(controllerName.text + selectedImage.hashCode.toString(), controllerName.text, newImage.path);
  //   }
  // }

  // Future<String?> saveImagePermanently() async {
  //   Directory appDir = await getApplicationDocumentsDirectory();
  //   await Directory('${appDir.path}/images').create(recursive: true);

  //   String newPath = '${appDir.path}/images/${DateTime.now().millisecondsSinceEpoch}.jpg';
  //   File newImage = await selectedImage!.copy(newPath);

  //   return newImage.path;
  // }

  // Future<void> saveToDatabase() async {
  //   var databasePath = await getDatabasesPath();
  //   Database db = await openDatabase(databasePath);

  //   Directory appDir = await getApplicationDocumentsDirectory();
  //   await Directory('${appDir.path}/images').create(recursive: true);

  //   String newPath = '${appDir.path}/images/${DateTime.now().millisecondsSinceEpoch}.jpg';
  //   File newImage = await selectedImage!.copy(newPath);

  //   await db.insert(
  //     'table_name',
  //     {
  //       'qrData': controllerName.text + selectedImage.hashCode.toString(),
  //       'name': controllerName.text,
  //       'pathImage': newImage.path,
  //     },
  //     conflictAlgorithm: ConflictAlgorithm.replace,
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final _ = ref.watch(refreshTriggerProvider);
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Добавление продукта',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8), //------------------------------
          TextFormField(
            controller: controllerName,
            decoration: InputDecoration(
              hintText: 'Название',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 8), //------------------------------
          ElevatedButton(
            onPressed: _pickImage,
            child: const Text('Pick Image'),
          ),
          SizedBox(height: 8), //------------------------------
          selectedImage != null
              ? Image.file(selectedImage!, height: 150)
              : Text('No image selected'),
          // newImagePath != null ?Image.file(File(newImagePath!), height: 150) :  Text('No image selected'),
          SizedBox(height: 8), //------------------------------
          ElevatedButton(
            onPressed: () {
              onCreate(context);
            },
            child: Text('Создать', style: TextStyle(fontSize: 16)),
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }

  void onCreate(BuildContext context) {
    if (controllerName.text.isEmpty || selectedImage == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Поля пусты :(')));
      return;
    }

    // var product = Product(
    //     name: controllerName.text,
    //     fileImage: selectedImage,
    //     qrData: controllerName.text + selectedImage.hashCode.toString()
    //   );
    ref
        .read(productProvider.notifier)
        .addProduct(
          Product(
            qrData: controllerName.text + selectedImage.hashCode.toString(),
            name: controllerName.text,
            pathImage: newImagePath!,
          ),
        );

    // DatabaseController().insertProduct(Product(
    //   qrData: controllerName.text + selectedImage.hashCode.toString(),
    //   name:controllerName.text,
    //   pathImage: (newImagePath!)));
    if (mounted) {
      Navigator.of(context).pop();
    }
  }
}
