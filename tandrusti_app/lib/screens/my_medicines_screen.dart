import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../main.dart';
import '../services/app_state.dart';
import '../services/localization_service.dart';
import 'medicine_detail_screen.dart';

class MyMedicinesScreen extends StatelessWidget {
  const MyMedicinesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        final lang = AppState.instance.language;
        final favIds = AppState.instance.favMedicines;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.appBarTint,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios, size: 18, color: AppColors.accentGreen),
              onPressed: () => Navigator.pop(context),
            ),
             title: Text(LocalizationService.translate('app_title', lang), style: TextStyle(fontSize: 16, color: AppColors.textPrimary)),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LocalizationService.translate('my_medicines', lang),
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '${favIds.length} ${LocalizationService.translate('saved', lang)}',
                      style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),

              if (favIds.isEmpty)
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.bookmark, color: AppColors.purpleSoft, size: 64),
                        SizedBox(height: 16),
                        Text(
                          LocalizationService.translate('no_saved_medicines', lang),
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                )
              else
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection('medicines').snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator(color: AppColors.accentGreen));
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Center(child: Text(LocalizationService.translate('empty_list', lang), style: TextStyle(color: AppColors.textPrimary)));
                      }

                      final docs = snapshot.data!.docs.where((doc) {
                        return favIds.contains(doc.id);
                      }).toList();

                      return ListView.builder(
                        padding: EdgeInsets.fromLTRB(20, 0, 20, MediaQuery.of(context).padding.bottom + 20),
                        itemCount: docs.length,
                        itemBuilder: (context, index) {
                          final medId = docs[index].id;
                          final med = docs[index].data() as Map<String, dynamic>;
                          
                          final scientificName = med['scientificName'] ?? 'No Name';
                          final brands = (med['commonBrands'] as List<dynamic>?)?.join(', ') ?? '';
                          final category = med['category'] ?? 'Medicine';
                          final transCategory = LocalizationService.translate(category, lang);

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (_) => MedicineDetailScreen(
                                medicineId: medId,
                                medicineData: med,
                              )));
                            },
                            child: Container(
                              margin: EdgeInsets.only(bottom: 16),
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: AppColors.borderTertiary),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: AppColors.redSoft,
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: Icon(Icons.medication, color: AppColors.red),
                                  ),
                                  SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(scientificName, style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 16)),
                                        SizedBox(height: 4),
                                        Text(brands, style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                                        SizedBox(height: 8),
                                        Container(
                                           padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                           decoration: BoxDecoration(
                                              color: AppColors.accentGreenSoft,
                                              borderRadius: BorderRadius.circular(6),
                                              border: Border.all(color: AppColors.accentGreen.withOpacity(0.3))
                                           ),
                                           child: Text(
                                              transCategory,
                                              style: TextStyle(
                                                 color: AppColors.accentGreen,
                                                 fontSize: 10,
                                                 fontWeight: FontWeight.bold
                                              ),
                                           )
                                        )
                                      ],
                                    ),
                                  ),
                                  Icon(Icons.chevron_right, color: AppColors.textSecondary),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
