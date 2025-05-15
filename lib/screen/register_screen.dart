import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:application_medicines/auth_controller.dart';

class RegisterScreen extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  
  // Variables para controlar el estado de error
  final RxBool emailError = false.obs;
  final RxBool passwordError = false.obs;
  final RxBool confirmPasswordError = false.obs;
  final RxString emailErrorText = ''.obs;
  final RxString passwordErrorText = ''.obs;
  final RxString confirmPasswordErrorText = ''.obs;

  RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro'),
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
                errorText: emailError.value ? emailErrorText.value : null,
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
                errorText: passwordError.value ? passwordErrorText.value : null,
              ),
              obscureText: true,
              onChanged: (_) => passwordError.value = false,
            )),
            const SizedBox(height: 16),
            Obx(() => TextField(
              controller: confirmPasswordController,
              decoration: InputDecoration(
                labelText: 'Confirmar Contraseña',
                border: OutlineInputBorder(),
                errorText: confirmPasswordError.value ? confirmPasswordErrorText.value : null,
              ),
              obscureText: true,
              onChanged: (_) => confirmPasswordError.value = false,
            )),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // Validar campos
                bool isValid = true;
                
                if (emailController.text.isEmpty) {
                  emailError.value = true;
                  emailErrorText.value = 'El correo es requerido';
                  isValid = false;
                }
                
                if (passwordController.text.isEmpty) {
                  passwordError.value = true;
                  passwordErrorText.value = 'La contraseña es requerida';
                  isValid = false;
                }
                
                if (confirmPasswordController.text.isEmpty) {
                  confirmPasswordError.value = true;
                  confirmPasswordErrorText.value = 'Confirme su contraseña';
                  isValid = false;
                } else if (passwordController.text != confirmPasswordController.text) {
                  confirmPasswordError.value = true;
                  confirmPasswordErrorText.value = 'Las contraseñas no coinciden';
                  isValid = false;
                }
                
                if (isValid) {
                  authController.createAccount(
                    emailController.text,
                    passwordController.text,
                  );
                }
              },
              child: const Text('Registrarse'),
            ),
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('¿Ya tienes cuenta? Inicia Sesión'),
            ),
          ],
        ),
      ),
    );
  }
}