import 'package:cloud_firestore/cloud_firestore.dart';
import 'mock_data_service.dart';

class SeedDataService {
  static Future<void> uploadInitialData() async {
    final firestore = FirebaseFirestore.instance;
    
    final doctors = MockDataService.getMockDoctors();
    for (var doc in doctors) {
      await firestore.collection('doctors').doc(doc.id).set({
        'name': doc.name,
        'specialty': doc.specialty,
        'city': doc.city, // Including the new city filter field in the cloud
        'phoneNumber': doc.phoneNumber,
        'clinicLocation': doc.clinicLocation,
        'latitude': doc.latitude,
        'longitude': doc.longitude,
        'workingHours': doc.workingHours,
        'rating': doc.rating,
      });
    }

    final medicines = MockDataService.getMockMedicines();
    for (var med in medicines) {
      await firestore.collection('medicines').doc(med.id).set({
        'scientificName': med.scientificName,
        'commonBrands': med.commonBrands,
        'indications': med.indications,
        'sideEffects': med.sideEffects,
        'usageInstructions': med.usageInstructions,
      });
    }

    final tests = MockDataService.getMockTests();
    for (var test in tests) {
      await firestore.collection('tests').doc(test.id).set({
        'testName': test.testName,
        'category': test.category,
        'preparationInstruction': test.preparationInstruction,
        'whatToExpect': test.whatToExpect,
      });
    }
  }
}
