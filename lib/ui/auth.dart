import 'package:flut/services/db_controller.dart';
import 'package:flut/ui/shop.dart';
import 'package:flutter/material.dart';
import 'package:flut/ui/register.dart';
import 'package:flut/models/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flut/services/user_provider.dart';

class Auth extends ConsumerStatefulWidget {
  const Auth({super.key});

  @override
  ConsumerState<Auth> createState() => _AuthState();
}

class _AuthState extends ConsumerState<Auth> {
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

  void onLogin() async {
    User? user = await DatabaseController.instance.authorizeUser(
      controllerLog.text,
      controllerPass.text,
    );

    if (user != null) {
      ref.read(userProvider.notifier).login(user);

      if (!mounted) return;

      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (context) => Shop()));

      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Неверный пароль или логин')));
  }

  void onRegister() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => Register()));
  }
}
