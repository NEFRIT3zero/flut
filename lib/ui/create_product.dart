import 'dart:io';
import 'dart:typed_data';
import 'package:flut/models/product.dart';
import 'package:flut/ui/my_colors.dart';
import 'package:flut/ui/placeholder_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flut/services/providers.dart';
import 'package:flut/services/product_provider.dart';
import 'package:path_provider/path_provider.dart';

class CreateProduct extends ConsumerStatefulWidget {
  const CreateProduct({super.key});

  @override
  ConsumerState<CreateProduct> createState() => _CreateProductState();
}

class _CreateProductState extends ConsumerState<CreateProduct> {
  var controllerName = TextEditingController();
  final ImagePicker picker = ImagePicker();
  File? selectedImage;
  String? newImagePath;

  Future<void> _pickImage() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
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
    }
  }

  @override
  Widget build(BuildContext context) {
    final _ = ref.watch(refreshTriggerProvider);
    return Scaffold(
        extendBodyBehindAppBar: true,                     // gradient behind AppBar
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Create зелень',
          style: TextStyle(color: MyColors.textLight),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: MyColors.textLight),
            onPressed: () => ref.read(productProvider.notifier).refresh(),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [MyColors.gradientStart, MyColors.gradientEnd],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                color: MyColors.cardBg,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Title
                      const Text(
                        'Добавление продукта',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: MyColors.textLight,
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Name field
                      TextFormField(
                        controller: controllerName,
                        style: const TextStyle(color: MyColors.textLight),
                        decoration: InputDecoration(
                          hintText: 'Название',
                          hintStyle: TextStyle(
                              color: MyColors.textHint.withOpacity(0.7)),
                          labelText: 'Название',
                          labelStyle: const TextStyle(color: MyColors.textHint),
                          filled: true,
                          fillColor: MyColors.inputFill,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(
                                color: MyColors.focusedBorder, width: 2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Pick image button
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton.icon(
                          onPressed: _pickImage,
                          icon: const Icon(Icons.image_outlined),
                          label: const Text('Pick Image'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: MyColors.buttonBg,
                            foregroundColor: MyColors.buttonFg,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 2,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Image preview with placeholder on error
                      if (selectedImage != null)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Image.file(
                            selectedImage!,
                            height: 150,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                PlaceholderImage(),
                          ),
                        )
                      else
                        Container(
                          height: 150,
                          decoration: BoxDecoration(
                            color: MyColors.inputFill,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: PlaceholderImage(),
                        ),
                      const SizedBox(height: 24),
                      // Create button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () => onCreate(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: MyColors.buttonBg,
                            foregroundColor: MyColors.buttonFg,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 2,
                          ),
                          child: const Text(
                            'Создать',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onCreate(BuildContext context) {
    if (controllerName.text.isEmpty || selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Поля пусты :('),
          backgroundColor: MyColors.errorSnack,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }
    ref
        .read(productProvider.notifier)
        .addProduct(
          Product(
            qrData: controllerName.text + selectedImage.hashCode.toString(),
            name: controllerName.text,
            pathImage: newImagePath!,
          ),
        );
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

}

