import 'package:flutter/material.dart';
import 'package:flut/user.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _Register();
}

var loginController = TextEditingController();
var nameController = TextEditingController();
var passwordController = TextEditingController();
var confirmPasswordController = TextEditingController();

class _Register extends State<Register> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Регистрация'),
      ),
      body: Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: 'Имя',
                border: OutlineInputBorder(),
              ),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value){//<---------------------------------------------------------валидация
                // final regex = RegExp(r'^[0-9A-Za-z]{3,}$');
                if(value == null || !RegExp(r'^[0-9A-Za-z]{3,}$').hasMatch(value)){return '> 3';}
                return null;
              },
            ),
            SizedBox(height: 3),
            TextField(
              controller: loginController,
              decoration: InputDecoration(
                hintText: 'Логин',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 3),

            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                hintText: 'Пароль',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 3),

            TextField(
              controller: confirmPasswordController,
              decoration: InputDecoration(
                hintText: 'Подтверждение пароля',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 3),

            ElevatedButton(
              onPressed: register,
              child: Text('Зарегестрировать пользователя'),
            ),
          ],
        ),
      ),
    );
  }

  void register() {
    if (nameController.text.isEmpty ||
        loginController.text.isEmpty ||
        passwordController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Данные не введены')));
    } else if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Пароли не совпадают')));
    } else {
      var user = User(
        name: nameController.text,
        login: loginController.text,
        password: passwordController.text,
      );
      users.add(user);
      Navigator.pop(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Пользователь зарегестрирован')));
    }
  }
}
