import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:application_medicines/auth_controller.dart';

class LoginScreen extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final RxBool emailError = false.obs;
  final RxBool passwordError = false.obs;

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Iniciar Sesión'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(() => TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Correo Electrónico',
                border: OutlineInputBorder(),
                errorText: emailError.value ? 'El correo es requerido' : null,
              ),
              keyboardType: TextInputType.emailAddress,
              onChanged: (_) => emailError.value = false,
            )),
            const SizedBox(height: 16),
            Obx(() => TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Contraseña',
                border: OutlineInputBorder(),
                errorText: passwordError.value ? 'La contraseña es requerida' : null,
              ),
              obscureText: true,
              onChanged: (_) => passwordError.value = false,
            )),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {

                bool isValid = true;
                
                if (emailController.text.isEmpty) {
                  emailError.value = true;
                  isValid = false;
                }
                
                if (passwordController.text.isEmpty) {
                  passwordError.value = true;
                  isValid = false;
                }
                
                if (isValid) {
                  await authController.login(
                    emailController.text,
                    passwordController.text,
                  );
                }
              },
              child: const Text('Iniciar Sesión'),
            ),
            TextButton(
              onPressed: () => Get.toNamed('/register'),
              child: const Text('¿No tienes cuenta? Regístrate'),
            ),
          ],
        ),
      ),
    );
  }
}