import 'package:appwrite/appwrite.dart';
import 'package:get/get.dart';

import 'package:application_medicines/appwrite_config.dart';
import 'package:application_medicines/appwrite_constants.dart';
import 'package:application_medicines/medication.dart';

class MedicationController extends GetxController {
  final Databases databases = Databases(AppwriteConfig.getClient());
  final RxList<Medication> medications = <Medication>[].obs;

  @override
  void onInit() {
    super.onInit();
    getMedications();
  }

  Future<void> addMedication(Medication medication) async {
    try {
      print("Intentando agregar medicamento: ${medication.toJson()}");
      

      final Map<String, dynamic> data = {
        'name': medication.name,
        'dosage': medication.dosage,
        'time': medication.time.toIso8601String(),
        'userId': medication.userId,
        'color': medication.color,
      };
      
      final result = await databases.createDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.collectionId,
        documentId: ID.unique(),
        data: data,
      );
      
      print("Medicamento agregado con ID: ${result.$id}");
      await getMedications(); 
      
    } catch (e) {
      print("Error al agregar medicamento: $e");
      Get.snackbar('Error', 'No se pudo agregar el medicamento: ${e.toString()}');
    }
  }

  Future<void> getMedications() async {
    try {
      print("Obteniendo medicamentos...");
      final response = await databases.listDocuments(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.collectionId,
      );
      
      print("Documentos obtenidos: ${response.documents.length}");
      
      medications.value = response.documents.map((doc) {
        print("Documento: ${doc.data}");
        try {

          final Map<String, dynamic> data = {...doc.data};
          data['\$id'] = doc.$id; 
          return Medication.fromJson(data);
        } catch (e) {
          print("Error al convertir documento: $e");
          return null;
        }
      }).whereType<Medication>().toList(); 
      
    } catch (e) {
      print("Error al obtener medicamentos: $e");
      Get.snackbar('Error', 'No se pudieron cargar los medicamentos: ${e.toString()}');
    }
  }

  Future<void> updateMedication(Medication medication) async {
    try {
      await databases.updateDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.collectionId,
        documentId: medication.id,
        data: {
          'name': medication.name,
          'dosage': medication.dosage,
          'time': medication.time.toIso8601String(),
          'userId': medication.userId,
          'color': medication.color,
        },
      );
      await getMedications();
    } catch (e) {
      print("Error al actualizar medicamento: $e");
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> deleteMedication(String medicationId) async {
    try {
      await databases.deleteDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.collectionId,
        documentId: medicationId,
      );
      await getMedications();
    } catch (e) {
      print("Error al eliminar medicamento: $e");
      Get.snackbar('Error', e.toString());
    }
  }
}