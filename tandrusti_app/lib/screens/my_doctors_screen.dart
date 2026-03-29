import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../main.dart';
import '../services/app_state.dart';
import '../services/localization_service.dart';
import '../widgets/doctor_card.dart';
import 'doctor_detail_screen.dart';

class MyDoctorsScreen extends StatelessWidget {
  const MyDoctorsScreen({super.key});

  bool _isOpen(String hoursString) {
    if (hoursString.toLowerCase().contains('24/7')) return true;
    try {
      final now = DateTime.now();
      final currentHour = now.hour;
      final parts = hoursString.split('-');
      if (parts.length == 2) {
        int start = int.parse(parts[0].replaceAll(RegExp(r'[^0-9]'), ''));
        int end = int.parse(parts[1].replaceAll(RegExp(r'[^0-9]'), ''));

        if (parts[0].toLowerCase().contains('pm') && start != 12) start += 12;
        if (parts[1].toLowerCase().contains('pm') && end != 12) end += 12;

        if (end < start) {
           return currentHour >= start || currentHour < end;
        }
        return currentHour >= start && currentHour < end;
      }
    } catch (_) {
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        final lang = AppState.instance.language;
        final favIds = AppState.instance.favDoctors;

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
                      LocalizationService.translate('my_doctors', lang),
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
                        Icon(Icons.bookmark, color: AppColors.redSoft, size: 64),
                        SizedBox(height: 16),
                        Text(
                          LocalizationService.translate('no_saved_doctors', lang),
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                )
              else
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection('doctors').snapshots(),
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
                          final docId = docs[index].id;
                          final data = docs[index].data() as Map<String, dynamic>;
                          final doctorHours = data['workingHours'] ?? 'Hours Unknown';
                          final isOpen = _isOpen(doctorHours);

                          return GestureDetector(
                            onTap: () {
                               Navigator.push(context, MaterialPageRoute(builder: (_) => DoctorDetailScreen(
                                  doctorId: docId,
                                  doctorData: data,
                               )));
                            },
                            child: DoctorCard(
                              data: data,
                              lang: lang,
                              isOpen: isOpen,
                            )
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
