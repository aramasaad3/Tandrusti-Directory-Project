class Doctor {
  final String id;
  final String name;
  final String? nameKu;
  final String specialty;
  final String city; // Added for advanced filtering
  final String phoneNumber;
  final String clinicLocation;
  final double latitude;
  final double longitude;

  Doctor({
    required this.id,
    required this.name,
    this.nameKu,
    required this.specialty,
    required this.city,
    required this.phoneNumber,
    required this.clinicLocation,
    required this.latitude,
    required this.longitude,
  });
}
