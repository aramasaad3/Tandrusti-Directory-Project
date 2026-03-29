import 'package:flutter/material.dart';
import '../main.dart'; // AppColors
import '../services/app_state.dart';
import '../services/localization_service.dart';
import '../models/reminder_model.dart';
import '../services/notification_service.dart';

class ReminderScreen extends StatefulWidget {
  const ReminderScreen({super.key});

  @override
  State<ReminderScreen> createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  final _medNameController = TextEditingController();
  final _doseController = TextEditingController();
  TimeOfDay _selectedTime = TimeOfDay.now();
  bool _isAdding = false;

  @override
  void dispose() {
    _medNameController.dispose();
    _doseController.dispose();
    super.dispose();
  }

  void _saveReminder(String lang) async {
    if (_medNameController.text.isEmpty) return;
    
    final medName = _medNameController.text;
    final dosage = _doseController.text.isEmpty ? LocalizationService.translate('scheduled_dose', lang) : _doseController.text;
    final timeStr = "${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}";
    
    try {
      await NotificationService.scheduleNotification(
        DateTime.now().millisecond % 100000, 
        LocalizationService.translate('notification_title', lang), 
        '${LocalizationService.translate('notification_body', lang)} $medName', 
        _selectedTime.hour, 
        _selectedTime.minute
      );
    } catch (e) {
      debugPrint('Notification scheduling error: $e');
    }
    
    final newReminder = Reminder(
      id: DateTime.now().toString(),
      medicineName: medName,
      dosage: dosage,
      timeText: timeStr,
      isEnabled: true,
    );
    
    await AppState.instance.addReminder(newReminder);
    
    setState(() {
      _isAdding = false;
      _medNameController.clear();
      _doseController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        final lang = AppState.instance.language;
        final reminders = AppState.instance.reminders;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.appBarTint,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, size: 24, color: AppColors.accentGreen),
              onPressed: () => Navigator.pop(context),
            ),
             title: Row(
               mainAxisSize: MainAxisSize.min,
               children: [
                 Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.purpleSoft,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.alarm, color: AppColors.purple, size: 16),
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                     Expanded(
                       child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              LocalizationService.translate('pill_reminders', lang),
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                            ),
                            SizedBox(height: 4),
                            Text(
                              LocalizationService.translate('never_miss_dose', lang),
                              style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
                            ),
                          ],
                       ),
                     ),
                     SizedBox(width: 8),
                     if (!_isAdding)
                       GestureDetector(
                          onTap: () async {
                             setState(() => _isAdding = true);
                             await NotificationService.requestPermissions();
                          },
                          child: Container(
                             padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                             decoration: BoxDecoration(
                                color: AppColors.accentGreenSoft,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: AppColors.accentGreen.withOpacity(0.5))
                             ),
                             child: Row(
                               mainAxisSize: MainAxisSize.min,
                               children: [
                                 Icon(Icons.add, color: AppColors.accentGreen, size: 18),
                                 SizedBox(width: 4),
                                 Text(LocalizationService.translate('add', lang), style: TextStyle(color: AppColors.accentGreen, fontWeight: FontWeight.bold)),
                               ],
                             )
                          ),
                       ),
                  ],
                ),
              ),

              if (_isAdding)
                Container(
                   margin: EdgeInsets.symmetric(horizontal: 20),
                   padding: EdgeInsets.all(20),
                   decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: AppColors.borderTertiary),
                   ),
                   child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         Text(LocalizationService.translate('add_reminder', lang), style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 16)),
                         SizedBox(height: 16),
                         TextField(
                            controller: _medNameController,
                            style: TextStyle(color: AppColors.textPrimary),
                            decoration: InputDecoration(
                               hintText: LocalizationService.translate('medicine_name', lang),
                               hintStyle: TextStyle(color: AppColors.inputHint),
                               filled: true,
                               fillColor: AppColors.background,
                               border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                               contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            ),
                         ),
                         SizedBox(height: 12),
                         Row(
                           children: [
                             Expanded(
                                flex: 2,
                                child: TextField(
                                   controller: _doseController,
                                   style: TextStyle(color: AppColors.textPrimary),
                                   decoration: InputDecoration(
                                      hintText: LocalizationService.translate('dose_hint', lang),
                                      hintStyle: TextStyle(color: AppColors.inputHint),
                                      filled: true,
                                      fillColor: AppColors.background,
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                   ),
                                ),
                             ),
                             SizedBox(width: 12),
                             Expanded(
                                child: GestureDetector(
                                   onTap: () async {
                                      final TimeOfDay? time = await showTimePicker(
                                        context: context,
                                        initialTime: _selectedTime,
                                        builder: (context, child) {
                                          return Theme(
                                            data: ThemeData.dark().copyWith(
                                              colorScheme: ColorScheme.dark(primary: AppColors.accentGreen),
                                            ),
                                            child: child!,
                                          );
                                        },
                                      );
                                      if (time != null) setState(() => _selectedTime = time);
                                   },
                                   child: Container(
                                      height: 48,
                                      decoration: BoxDecoration(
                                         color: AppColors.background,
                                         borderRadius: BorderRadius.circular(12),
                                         border: Border.all(color: AppColors.borderTertiary)
                                      ),
                                      child: Center(
                                         child: Directionality(
                                           textDirection: TextDirection.ltr,
                                           child: Text(
                                              "${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}",
                                              style: TextStyle(color: AppColors.accentGreen, fontWeight: FontWeight.bold, fontSize: 16),
                                           ),
                                         )
                                      ),
                                   ),
                                ),
                             )
                           ],
                         ),
                         SizedBox(height: 20),
                         Row(
                            children: [
                               Expanded(
                                  child: OutlinedButton(
                                     onPressed: () => setState(() => _isAdding = false),
                                     style: OutlinedButton.styleFrom(
                                        padding: EdgeInsets.symmetric(vertical: 14),
                                        side: BorderSide(color: AppColors.borderTertiary),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                                     ),
                                     child: Text(LocalizationService.translate('cancel', lang), style: TextStyle(color: AppColors.textPrimary)),
                                  ),
                               ),
                               SizedBox(width: 12),
                               Expanded(
                                  child: ElevatedButton(
                                     onPressed: () => _saveReminder(lang),
                                     style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.accentGreen,
                                        padding: EdgeInsets.symmetric(vertical: 14),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                                     ),
                                     child: Text(LocalizationService.translate('save', lang), style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold)),
                                  ),
                               ),
                            ],
                         )
                      ],
                   )
                ),
                
              if (reminders.isEmpty && !_isAdding)
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.alarm_off, color: AppColors.purpleSoft, size: 64),
                        SizedBox(height: 16),
                        Text(
                          LocalizationService.translate('no_reminders', lang),
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                )
              else if (!_isAdding)
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, MediaQuery.of(context).padding.bottom + 20),
                    itemCount: reminders.length,
                    itemBuilder: (context, index) {
                      final reminder = reminders[index];
                      final iconColor = index % 2 == 0 ? AppColors.purple : AppColors.blue;

                      return Container(
                        margin: EdgeInsets.only(bottom: 16),
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.borderTertiary),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: iconColor.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Icon(Icons.medication, color: iconColor, size: 28),
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(reminder.medicineName, style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 16)),
                                      SizedBox(height: 4),
                                      Text(reminder.dosage, style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Directionality(
                                  textDirection: TextDirection.ltr,
                                  child: Text(
                                    reminder.timeText,
                                    style: TextStyle(color: AppColors.accentGreen, fontWeight: FontWeight.bold, fontSize: 20),
                                  ),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Theme(
                                      data: ThemeData(
                                        useMaterial3: true,
                                        colorScheme: ColorScheme.dark(primary: AppColors.accentGreen),
                                      ),
                                      child: Switch(
                                        value: reminder.isEnabled,
                                        onChanged: (val) {
                                          setState(() {
                                            reminder.isEnabled = val;
                                          });
                                        },
                                        activeColor: AppColors.accentGreen,
                                      ),
                                    ),
                                    SizedBox(width: 4),
                                    GestureDetector(
                                      onTap: () async {
                                        await AppState.instance.deleteReminder(reminder.id);
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          color: AppColors.redSoft,
                                          borderRadius: BorderRadius.circular(8)
                                        ),
                                        child: Icon(Icons.delete_outline, color: AppColors.red, size: 16),
                                      )
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
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
