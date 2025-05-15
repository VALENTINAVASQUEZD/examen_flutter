import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:application_medicines/auth_controller.dart';
import 'package:application_medicines/medication_controller.dart';
import 'package:application_medicines/notification_service.dart';
import 'package:application_medicines/screen/add_medication_screen.dart';
import 'package:application_medicines/screen/edit_medication_screen.dart';
import 'package:application_medicines/screen/initial_screen.dart';
import 'package:application_medicines/screen/login_screen.dart';
import 'package:application_medicines/screen/medication_list_screen.dart';
import 'package:application_medicines/screen/register_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final notificationService = NotificationService();
  await notificationService.initNotification();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Control de Medicamentos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      initialBinding: BindingsBuilder(() {
        Get.put(AuthController());
        Get.put(MedicationController());
        Get.put(NotificationService());
      }),
      home: InitialScreen(),
      getPages: [
        GetPage(name: '/login', page: () => LoginScreen()),
        GetPage(name: '/register', page: () => RegisterScreen()),
        GetPage(name: '/medications', page: () => MedicationListScreen()),
        GetPage(name: '/add-medication', page: () => AddMedicationScreen()),
        GetPage(
          name: '/edit-medication/:id',
          page: () => EditMedicationScreen(),
        ),
      ],
    );
  }
}