import 'package:flut/shop.dart';
import 'package:flutter/material.dart';
import 'package:flut/register.dart';
import 'package:flut/user.dart';

class Auth extends StatefulWidget {
  const Auth({super.key});

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  var controllerLog = TextEditingController();
  var controllerPass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Авторизация',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            TextFormField(
              controller: controllerLog,
              decoration: InputDecoration(
                hintText: 'Логин',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 8),
            TextFormField(
              obscureText: true,
              controller: controllerPass,
              decoration: InputDecoration(
                hintText: 'Пароль',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: onLogin,
              child: Text('Войти', style: TextStyle(fontSize: 16)),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRegister,
              child: Text('Зарегестрироваться', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  void onLogin() {
    for (var user in users) {
      if (user.login == controllerLog.text &&
          user.password == controllerPass.text) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => Shop(),
            // MyFirstPage(tittle: 'Main Page', name: user.name),
          ),
        );
        return;
      }
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Неверный пароль или логин')));
  }

  void onRegister() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => Register()));
  }
}
