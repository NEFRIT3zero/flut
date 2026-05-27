import 'package:flut/services/db_controller.dart';
import 'package:flut/ui/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:flut/models/user.dart';


class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _loginController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final user = User(
        name: _nameController.text.trim(),
        login: _loginController.text.trim(),
        password: _passwordController.text,
      );
      await DatabaseController().insertUser(user);  

      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Пользователь зарегистрирован'),
          backgroundColor: MyColors.buttonBg,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Ошибка регистрации. Попробуйте позже.'),
            backgroundColor: MyColors.errorSnack,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
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
                      const Icon(Icons.person_add_alt_1, size: 80, color: MyColors.textLight),
                      const SizedBox(height: 16),
                      const Text(
                        'Создать аккаунт',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: MyColors.textLight,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Заполните данные для регистрации',
                        style: TextStyle(
                          fontSize: 16,
                          color: MyColors.textLight.withOpacity(0.8),
                        ),
                      ),
                      const SizedBox(height: 40),
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
                                controller: _nameController,
                                autofillHints: const [AutofillHints.name],
                                textInputAction: TextInputAction.next,
                                autovalidateMode: AutovalidateMode.onUserInteraction,   // ← added
                                decoration: InputDecoration(
                                  labelText: 'Имя',
                                  labelStyle: TextStyle(color: MyColors.textHint),
                                  hintText: 'Ваше имя',
                                  prefixIcon: const Icon(Icons.badge_outlined),
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
                                    return 'Введите имя';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                controller: _loginController,
                                autofillHints: const [AutofillHints.username],
                                textInputAction: TextInputAction.next,
                                autovalidateMode: AutovalidateMode.onUserInteraction,   // ← added
                                decoration: InputDecoration(
                                  labelText: 'Логин',
                                  labelStyle: TextStyle(color: MyColors.textHint),
                                  hintText: 'Придумайте логин',
                                  prefixIcon: const Icon(Icons.person_outline),
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
                                autofillHints: const [AutofillHints.newPassword],
                                obscureText: _obscurePassword,
                                textInputAction: TextInputAction.next,
                                autovalidateMode: AutovalidateMode.onUserInteraction,   // ← added
                                decoration: InputDecoration(
                                  labelText: 'Пароль',
                                  labelStyle: TextStyle(color: MyColors.textHint),
                                  hintText: 'Минимум 4 символа',
                                  prefixIcon: const Icon(Icons.lock_outline),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                    ),
                                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                                  ),
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
                                  if (value == null || value.isEmpty) return 'Введите пароль';
                                  if (value.length < 4) return 'Минимум 4 символа';
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                controller: _confirmPasswordController,
                                autofillHints: const [AutofillHints.newPassword],
                                obscureText: _obscureConfirm,
                                textInputAction: TextInputAction.done,
                                onFieldSubmitted: (_) => _register(),
                                autovalidateMode: AutovalidateMode.onUserInteraction,   // ← added
                                decoration: InputDecoration(
                                  labelText: 'Подтверждение пароля',
                                  labelStyle: TextStyle(color: MyColors.textHint),
                                  hintText: 'Повторите пароль',
                                  prefixIcon: const Icon(Icons.lock_outline),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscureConfirm ? Icons.visibility_off : Icons.visibility,
                                    ),
                                    onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                                  ),
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
                                  if (value == null || value.isEmpty) return 'Подтвердите пароль';
                                  if (value != _passwordController.text) return 'Пароли не совпадают';
                                  return null;
                                },
                              ),
                              const SizedBox(height: 30),
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: _isLoading ? null : _register,
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
                                            valueColor: AlwaysStoppedAnimation<Color>(MyColors.textLight),
                                          ),
                                        )
                                      : const Text(
                                          'Зарегистрироваться',
                                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: RichText(
                          text: TextSpan(
                            text: 'Уже есть аккаунт? ',
                            style: TextStyle(color: MyColors.textLight.withOpacity(0.9)),
                            children: const [
                              TextSpan(
                                text: 'Войти',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
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