import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../main.dart';
import '../services/app_state.dart';
import '../services/localization_service.dart';
import 'medicine_detail_screen.dart';

class MedicineScreen extends StatefulWidget {
  const MedicineScreen({super.key});

  @override
  State<MedicineScreen> createState() => _MedicineScreenState();
}

class _MedicineScreenState extends State<MedicineScreen> {
  String _searchQuery = '';

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
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.redSoft,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.medication, color: AppColors.red, size: 16),
                  ),
                  SizedBox(width: 8),
                 Text(LocalizationService.translate('app_title', lang), style: TextStyle(fontSize: 16, color: AppColors.textPrimary)),
               ],
            ),
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
                      LocalizationService.translate('medicine_guide', lang),
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                    ),
                    SizedBox(height: 4),
                    Text(
                      LocalizationService.translate('scientific_brand_search', lang),
                      style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      decoration: InputDecoration(
                        hintText: LocalizationService.translate('search_medicine_hint', lang),
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
                        contentPadding: EdgeInsets.symmetric(vertical: 14),
                      ),
                      style: TextStyle(color: AppColors.textPrimary),
                      onChanged: (val) {
                        setState(() { _searchQuery = val; });
                      },
                    ),
                  ],
                ),
              ),
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
                      final data = doc.data() as Map<String, dynamic>;
                      final name = (data['scientificName'] ?? '').toString().toLowerCase();
                      final brands = (data['commonBrands'] as List<dynamic>?)?.join(' ').toLowerCase() ?? '';
                      final query = _searchQuery.toLowerCase();
                      return name.contains(query) || brands.contains(query);
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
