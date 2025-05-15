class Medication {
  final String id;
  final String name;
  final String dosage;
  final DateTime time;
  final String userId;
  final String color;

  Medication({
    required this.id,
    required this.name,
    required this.dosage,
    required this.time,
    required this.userId,
    required this.color,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'dosage': dosage,
      'time': time.toIso8601String(),
      'userId': userId,
      'color': color,
    };
  }

  factory Medication.fromJson(Map<String, dynamic> json) {
    try {
      return Medication(
        id: json['\$id'] ?? '',
        name: json['name'] ?? '',
        dosage: json['dosage'] ?? '',
        time: json['time'] != null ? DateTime.parse(json['time']) : DateTime.now(),
        userId: json['userId'] ?? '',
        color: json['color'] ?? '0xFF2196F3',
      );
    } catch (e) {
      print("Error al convertir JSON a Medication: $e");
      print("JSON recibido: $json");

      return Medication(
        id: '',
        name: 'Error',
        dosage: '',
        time: DateTime.now(),
        userId: '',
        color: '0xFF2196F3',
      );
    }
  }
}