class Doctor {
  final String id;
  final String name;
  final String specialty;
  final String city; // Added for advanced filtering
  final String phoneNumber;
  final String clinicLocation;
  final double latitude;
  final double longitude;
  final String workingHours;
  final double rating;

  Doctor({
    required this.id,
    required this.name,
    required this.specialty,
    required this.city,
    required this.phoneNumber,
    required this.clinicLocation,
    required this.latitude,
    required this.longitude,
    required this.workingHours,
    required this.rating,
  });
}
