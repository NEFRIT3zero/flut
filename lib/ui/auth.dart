import 'package:flut/services/db_controller.dart';
import 'package:flut/ui/my_colors.dart';
import 'package:flut/ui/shop.dart';
import 'package:flutter/material.dart';
import 'package:flut/ui/register.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flut/services/user_provider.dart';


class Auth extends ConsumerStatefulWidget {
  const Auth({super.key});

  @override
  ConsumerState<Auth> createState() => _AuthState();
}

class _AuthState extends ConsumerState<Auth> {
  final _formKey = GlobalKey<FormState>();
  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final user = await DatabaseController.instance.authorizeUser(
        _loginController.text.trim(),
        _passwordController.text,
      );

      if (!mounted) return;

      if (user != null) {
        ref.read(userProvider.notifier).login(user);
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const Shop()),
        );
      } else {
        _showError('Неверный логин или пароль');
      }
    } catch (e) {
      if (mounted) _showError('Ошибка соединения. Попробуйте позже.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: MyColors.errorSnack,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              child: Form(
                key: _formKey,
                child: AutofillGroup(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Logo / Icon
                      const Icon(Icons.lock_outline, size: 80,
                          color: MyColors.textLight),
                      const SizedBox(height: 16),
                      const Text(
                        'Добро пожаловать',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: MyColors.textLight,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Войдите в свою учётную запись',
                        style: TextStyle(
                          fontSize: 16,
                          color: MyColors.textLight.withOpacity(0.8),
                        ),
                      ),
                      const SizedBox(height: 40),
                      // Login card
                      Card(
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        color: MyColors.cardBg,
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _loginController,
                                style: const TextStyle(color: MyColors.textLight),
                                autofillHints: const [AutofillHints.username],
                                textInputAction: TextInputAction.next,
                                autovalidateMode: AutovalidateMode.onUserInteraction,   // ← added
                                decoration: InputDecoration(
                                  labelText: 'Логин',
                                  hintText: 'Введите ваш логин',
                                  labelStyle: const TextStyle(color: MyColors.textHint),
                                  hintStyle: TextStyle(color: MyColors.textHint.withOpacity(0.7)),
                                  prefixIcon: const Icon(Icons.person_outline),
                                  prefixIconColor: MyColors.textHint,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  focusedBorder: OutlineInputBorder(                   // ← new
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: const BorderSide(color: MyColors.focusedBorder, width: 2),
                                  ),
                                  filled: true,
                                  fillColor: MyColors.inputFill,
                                ),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Введите логин';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                controller: _passwordController,
                                style: const TextStyle(color: MyColors.textLight),
                                autofillHints: const [AutofillHints.password],
                                obscureText: _obscurePassword,
                                textInputAction: TextInputAction.done,
                                onFieldSubmitted: (_) => _onLogin(),
                                autovalidateMode: AutovalidateMode.onUserInteraction,   // ← added
                                decoration: InputDecoration(
                                  labelText: 'Пароль',
                                  hintText: 'Введите пароль',
                                  labelStyle: const TextStyle(color: MyColors.textHint),
                                  hintStyle: TextStyle(color: MyColors.textHint.withOpacity(0.7)),
                                  prefixIcon: const Icon(Icons.lock_outline),
                                  prefixIconColor: MyColors.textHint,
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscurePassword = !_obscurePassword;
                                      });
                                    },
                                  ),
                                  suffixIconColor: MyColors.textHint,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  focusedBorder: OutlineInputBorder(                   // ← new
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: const BorderSide(color: MyColors.focusedBorder, width: 2),
                                  ),
                                  filled: true,
                                  fillColor: MyColors.inputFill,
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Введите пароль';
                                  }
                                  if (value.length < 4) {
                                    return 'Минимум 4 символа';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 30),
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: _isLoading ? null : _onLogin,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: MyColors.buttonBg,
                                    foregroundColor: MyColors.buttonFg,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    elevation: 2,
                                  ),
                                  child: _isLoading
                                      ? const SizedBox(
                                          height: 24,
                                          width: 24,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2.5,
                                            valueColor: AlwaysStoppedAnimation<Color>(
                                                MyColors.buttonFg),
                                          ),
                                        )
                                      : const Text(
                                          'Войти',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const Register(),
                            ),
                          );
                        },
                        child: RichText(
                          text: TextSpan(
                            text: 'Нет аккаунта? ',
                            style: TextStyle(
                                color: MyColors.textLight.withOpacity(0.9)),
                            children: const [
                              TextSpan(
                                text: 'Зарегистрироваться',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                  color: MyColors.textLight, // explicit colour
                                ),
                              ),
                            ],
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
}