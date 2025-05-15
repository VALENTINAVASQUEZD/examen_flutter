import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:application_medicines/auth_controller.dart';
import 'package:application_medicines/medication_controller.dart';
import 'package:application_medicines/medication.dart';

class MedicationListScreen extends StatelessWidget {
  final MedicationController medicationController =
      Get.find<MedicationController>();

  MedicationListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      medicationController.getMedications();
    });
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Medicamentos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => medicationController.getMedications(),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => Get.find<AuthController>().logout(),
          ),
        ],
      ),
      body: Obx(
        () {
          if (medicationController.medications.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'No tienes medicamentos registrados',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Get.toNamed('/add-medication'),
                    child: Text('Agregar medicamento'),
                  ),
                ],
              ),
            );
          }
          
          return ListView.builder(
            itemCount: medicationController.medications.length,
            itemBuilder: (context, index) {
              final medication = medicationController.medications[index];
              return MedicationCard(medication: medication);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed('/add-medication'),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class MedicationCard extends StatelessWidget {
  final Medication medication;

  const MedicationCard({super.key, required this.medication});

  Color getColorFromHex(String hexColor) {
    try {
      hexColor = hexColor.replaceAll("#", "");
      if (hexColor.length == 8) {
        return Color(int.parse("0x$hexColor"));
      } else if (hexColor.length == 6) {
        return Color(int.parse("0xFF$hexColor"));
      }
      return Colors.blue; 
    } catch (e) {
      print("Error al convertir color: $e");
      return Colors.blue; 
    }
  }

  @override
  Widget build(BuildContext context) {
    Color cardColor;
    try {
      cardColor = getColorFromHex(medication.color);
    } catch (e) {
      print("Error al obtener color: $e");
      cardColor = Colors.blue; 
    }
    
    final brightness = ThemeData.estimateBrightnessForColor(cardColor);
    final textColor = brightness == Brightness.dark ? Colors.white : Colors.black;

    return Card(
      margin: const EdgeInsets.all(8.0),
      color: cardColor,
      child: ListTile(
        title: Text(
          medication.name,
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold), 
        ),
        subtitle: Text(
          'Dosis: ${medication.dosage}',
          style: TextStyle(color: textColor.withOpacity(0.7)), 
        ),
        trailing: Text(
          '${medication.time.hour}:${medication.time.minute.toString().padLeft(2, '0')}',
          style: TextStyle(color: textColor, fontSize: 16), 
        ),
        onTap: () => Get.toNamed('/edit-medication/${medication.id}'),
      ),
    );
  }
}