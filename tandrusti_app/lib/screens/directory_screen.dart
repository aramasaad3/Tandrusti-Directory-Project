import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/app_state.dart';
import '../services/localization_service.dart';
import '../main.dart'; // For AppColors
import '../widgets/doctor_card.dart';
import '../widgets/filter_icon_button.dart';
import '../widgets/filter_bottom_sheet.dart';
import 'doctor_detail_screen.dart';

class DirectoryScreen extends StatefulWidget {
  const DirectoryScreen({super.key});

  @override
  State<DirectoryScreen> createState() => _DirectoryScreenState();
}

class _DirectoryScreenState extends State<DirectoryScreen> {
  String _searchQuery = '';
  String _selectedCity = 'All Cities';
  String _selectedSpecialty = 'All Specialties';

  void _openFilterSheet(String lang) {
     showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) {
           return FilterBottomSheet(
              currentCity: _selectedCity,
              currentSpecialty: _selectedSpecialty,
              lang: lang,
              onApply: (newCity, newSpecialty) {
                 setState(() {
                    _selectedCity = newCity;
                    _selectedSpecialty = newSpecialty;
                 });
              },
           );
        }
     );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        final lang = AppState.instance.language;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
             backgroundColor: AppColors.appBarTint,
             leading: IconButton(
              icon: Icon(Icons.arrow_back_ios, size: 18, color: AppColors.accentGreen),
              onPressed: () => Navigator.pop(context),
            ),
            title: Row(
               mainAxisSize: MainAxisSize.min,
               children: [
                 Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.accentGreenSoft,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.local_hospital, color: AppColors.accentGreen, size: 16),
                  ),
                  const SizedBox(width: 8),
                 Text(LocalizationService.translate('app_title', lang), style: TextStyle(fontSize: 16, color: AppColors.textPrimary)),
               ],
            ),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LocalizationService.translate('directory_title', lang),
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: LocalizationService.translate('search_doctor', lang),
                              hintStyle: TextStyle(color: AppColors.inputHint),
                              prefixIcon: Icon(Icons.search, color: AppColors.textSecondary),
                              filled: true,
                              fillColor: AppColors.surface,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(color: AppColors.borderTertiary),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(color: AppColors.borderTertiary),
                              ),
                              focusedBorder: OutlineInputBorder(
                                 borderRadius: BorderRadius.circular(16),
                                 borderSide: BorderSide(color: AppColors.accentGreen),
                              ),
                              contentPadding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            style: TextStyle(color: AppColors.textPrimary),
                            onChanged: (val) {
                              setState(() { _searchQuery = val; });
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        FilterIconButton(onTap: () => _openFilterSheet(lang)),
                      ],
                    ),
                  ],
                ),
              ),

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
                      final data = doc.data() as Map<String, dynamic>;
                      final name = (data['name'] ?? '').toString().toLowerCase();
                      final nameKu = (data['nameKu'] ?? '').toString().toLowerCase();
                      final specialtyRaw = (data['specialty'] ?? '').toString();
                      final specEn = LocalizationService.translate(specialtyRaw, 'English').toLowerCase();
                      final specKu = LocalizationService.translate(specialtyRaw, 'Kurdish').toLowerCase();
                      
                      final city = (data['city'] ?? 'Erbil').toString();
                      final query = _searchQuery.toLowerCase();
                      
                      bool matchesQuery = name.contains(query) || nameKu.contains(query) || specEn.contains(query) || specKu.contains(query) || specialtyRaw.toLowerCase().contains(query);
                      bool matchesCity = _selectedCity == 'All Cities' || city == _selectedCity;
                      bool matchesSpecialty = _selectedSpecialty == 'All Specialties' || data['specialty'] == _selectedSpecialty;
                      
                      return matchesQuery && matchesCity && matchesSpecialty;
                    }).toList();

                    if (docs.isEmpty) {
                       return Center(child: Text('No doctors match your filters', style: TextStyle(color: AppColors.textSecondary)));
                    }

                    return ListView.builder(
                      padding: EdgeInsets.fromLTRB(20, 0, 20, MediaQuery.of(context).padding.bottom + 20),
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        final docId = docs[index].id;
                        final data = docs[index].data() as Map<String, dynamic>;

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
