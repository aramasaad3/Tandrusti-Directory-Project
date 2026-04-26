import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  final meds = await FirebaseFirestore.instance.collection('medicines').get();
  for (var doc in meds.docs) {
    debugPrint('MED: ${doc.id} - ${doc.data()['usageInstructions']} - ${doc.data()['sideEffects']}');
  }
  
  final tests = await FirebaseFirestore.instance.collection('tests').get();
  for (var doc in tests.docs) {
    debugPrint('TEST: ${doc.id} - ${doc.data()['whatToExpect']} - ${doc.data()['preparationInstruction']}');
  }
}
