class Reminder {
  final String id;
  final String medicineName;
  final String dosage;
  final String timeText; // e.g., "08:00 AM"
  bool isEnabled;

  Reminder({
    required this.id,
    required this.medicineName,
    required this.dosage,
    required this.timeText,
    this.isEnabled = true,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'medicineName': medicineName,
    'dosage': dosage,
    'timeText': timeText,
    'isEnabled': isEnabled,
  };

  factory Reminder.fromJson(Map<String, dynamic> json) => Reminder(
    id: json['id'],
    medicineName: json['medicineName'],
    dosage: json['dosage'],
    timeText: json['timeText'],
    isEnabled: json['isEnabled'] ?? true,
  );
}
