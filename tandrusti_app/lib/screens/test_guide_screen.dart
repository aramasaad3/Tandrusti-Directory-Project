import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../main.dart';
import '../services/app_state.dart';
import '../services/localization_service.dart';
import 'test_detail_screen.dart';

class TestGuideScreen extends StatefulWidget {
  const TestGuideScreen({super.key});

  @override
  State<TestGuideScreen> createState() => _TestGuideScreenState();
}

class _TestGuideScreenState extends State<TestGuideScreen> {
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
                      color: AppColors.amberSoft,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.biotech, color: AppColors.amber, size: 16),
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
                      LocalizationService.translate('lab_diagnostics', lang),
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                    ),
                    SizedBox(height: 4),
                    Text(
                      LocalizationService.translate('prep_guides', lang),
                      style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      decoration: InputDecoration(
                        hintText: LocalizationService.translate('search_tests_hint', lang),
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
                  stream: FirebaseFirestore.instance.collection('tests').snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator(color: AppColors.amber));
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(child: Text(LocalizationService.translate('no_tests', lang), style: TextStyle(color: AppColors.textPrimary)));
                    }

                    final docs = snapshot.data!.docs.where((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      final name = (data['testName'] ?? '').toString().toLowerCase();
                      final cat = (data['category'] ?? '').toString();
                      final transCatEn = LocalizationService.translate(cat, 'English').toLowerCase();
                      final transCatKu = LocalizationService.translate(cat, 'Kurdish').toLowerCase();
                      final transNameEn = LocalizationService.translate(data['testName'] ?? '', 'English').toLowerCase();
                      final transNameKu = LocalizationService.translate(data['testName'] ?? '', 'Kurdish').toLowerCase();
                      
                      final query = _searchQuery.toLowerCase();
                      return name.contains(query) || transCatEn.contains(query) || transCatKu.contains(query) || transNameEn.contains(query) || transNameKu.contains(query);
                    }).toList();

                    return ListView.builder(
                      padding: EdgeInsets.fromLTRB(20, 0, 20, MediaQuery.of(context).padding.bottom + 20),
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        final testId = docs[index].id;
                        final test = docs[index].data() as Map<String, dynamic>;
                        
                        final testName = test['testName'] ?? 'Unknown Test';
                        final category = test['category'] ?? 'Diagnostic';
                        final duration = test['duration'] ?? '15-30 min';
                        
                        final prepStr = (test['preparationInstruction'] ?? '').toString();
                        final steps = prepStr.split('.').where((s) => s.trim().length > 5).toList();
                        final stepCount = steps.isEmpty ? 1 : steps.length;

                        final colors = [
                          AppColors.red, 
                          AppColors.blue, 
                          AppColors.purple,
                          AppColors.amber
                        ];
                        final cIndex = testName.length % colors.length;
                        final iconColor = colors[cIndex];

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => TestDetailScreen(
                              testId: testId,
                              testData: test,
                              iconColor: iconColor,
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
                                    color: iconColor.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Icon(
                                    cIndex == 0 ? Icons.bloodtype : 
                                    (cIndex == 1 ? Icons.medical_services : Icons.biotech), 
                                    color: iconColor
                                  ),
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(testName, style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 16)),
                                      SizedBox(height: 4),
                                      Text('$category · $duration', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                                      SizedBox(height: 8),
                                      Text(
                                        '$stepCount ${LocalizationService.translate('prep_steps_count', lang)}',
                                        style: TextStyle(
                                           color: AppColors.amber,
                                           fontSize: 11,
                                           fontWeight: FontWeight.bold
                                        ),
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
