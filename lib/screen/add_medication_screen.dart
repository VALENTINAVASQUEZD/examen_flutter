import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'dart:math';

import 'package:application_medicines/auth_controller.dart';
import 'package:application_medicines/medication.dart';
import 'package:application_medicines/medication_controller.dart';
import 'package:application_medicines/notification_service.dart';

class AddMedicationScreen extends StatelessWidget {
  final MedicationController medicationController =
      Get.find<MedicationController>();
  final NotificationService notificationService =
      Get.find<NotificationService>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController dosageController = TextEditingController();
  final Rx<TimeOfDay> selectedTime = TimeOfDay.now().obs;
  
  final RxBool nameError = false.obs;
  final RxBool dosageError = false.obs;
  final RxBool timeError = false.obs;


  final List<Color> medicationColors = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.pink,
    Colors.amber,
    Colors.indigo,
    Colors.cyan,
  ];


  String getRandomColor() {
    final random = Random();
    final color = medicationColors[random.nextInt(medicationColors.length)];
    return color.value.toRadixString(16).padLeft(8, '0');
  }

  AddMedicationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Medicamento'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Obx(() => TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Nombre del Medicamento',
                border: OutlineInputBorder(),
                errorText: nameError.value ? 'El nombre es requerido' : null,
              ),
              onChanged: (_) => nameError.value = false,
            )),
            const SizedBox(height: 16),
            Obx(() => TextField(
              controller: dosageController,
              decoration: InputDecoration(
                labelText: 'Dosis',
                border: OutlineInputBorder(),
                errorText: dosageError.value ? 'La dosis es requerida' : null,
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly
              ],
              onChanged: (_) => dosageError.value = false,
            )),
            const SizedBox(height: 16),
            Obx(
              () => ListTile(
                title: const Text('Hora de la Medicación'),
                subtitle: Text(
                  '${selectedTime.value.hour}:${selectedTime.value.minute.toString().padLeft(2, '0')}',
                ),
                trailing: const Icon(Icons.access_time),
                tileColor: timeError.value ? Colors.red.withOpacity(0.1) : null,
                onTap: () async {
                  final TimeOfDay? time = await showTimePicker(
                    context: context,
                    initialTime: selectedTime.value,
                  );
                  if (time != null) {
                    selectedTime.value = time;
                    timeError.value = false;
                  }
                },
              ),
            ),
            if (timeError.value)
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 4),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Seleccione una hora',
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
              ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
             
                bool isValid = true;
                
                if (nameController.text.isEmpty) {
                  nameError.value = true;
                  isValid = false;
                }
                
                if (dosageController.text.isEmpty) {
                  dosageError.value = true;
                  isValid = false;
                }
                
                if (isValid) {
                  try {
                    final now = DateTime.now();
                    final medicationTime = DateTime(
                      now.year,
                      now.month,
                      now.day,
                      selectedTime.value.hour,
                      selectedTime.value.minute,
                    );

                   
                    final userData = await Get.find<AuthController>().account.get();
                    final userId = userData.$id;

                    final medication = Medication(
                      id: '', 
                      name: nameController.text,
                      dosage: dosageController.text,
                      time: medicationTime,
                      userId: userId,
                      color: getRandomColor(),
                    );

                    print("Creando medicamento: ${medication.toJson()}");
                    await medicationController.addMedication(medication);
            
                    await notificationService.scheduleMedicationNotification(
                      'Es hora de tu medicamento',
                      'Toma ${medication.name} - ${medication.dosage}',
                      medicationTime,
                    );

                    Get.back(); 
                    Get.snackbar('Éxito', 'Medicamento agregado correctamente');
                  } catch (e) {
                    print("Error al crear medicamento: $e");
                    Get.snackbar('Error', 'No se pudo crear el medicamento: ${e.toString()}');
                  }
                }
              },
              child: const Text('Guardar Medicamento'),
            ),
          ],
        ),
      ),
    );
  }
}