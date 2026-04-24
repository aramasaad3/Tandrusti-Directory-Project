import 'package:flutter/material.dart';
import '../main.dart';
import '../services/app_state.dart';
import '../services/auth_service.dart';
import '../services/localization_service.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _nameCtrl.text = AuthService.instance.currentUser?.displayName ?? '';
  }

  Future<void> _saveProfile() async {
    final newName = _nameCtrl.text.trim();
    final password = _passCtrl.text;

    if (newName.isEmpty || password.isEmpty) {
      setState(() => _error = "Please fill in all fields.");
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    final err = await AuthService.instance.updateDisplayName(newName: newName, password: password);

    if (!mounted) return;

    if (err != null) {
      setState(() {
        _isLoading = false;
        _error = err;
      });
    } else {
      Navigator.pop(context); // Go back on success
    }
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
            backgroundColor: AppColors.background,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: AppColors.accentGreen, size: 18),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.accentGreenSoft,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(Icons.person_outline, color: AppColors.accentGreen, size: 40),
                ),
                SizedBox(height: 24),

                // Title
                Text(
                  LocalizationService.translate('edit_profile', lang),
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
                SizedBox(height: 8),
                Text(
                  LocalizationService.translate('edit_profile_subtitle', lang),
                  style: TextStyle(fontSize: 15, color: AppColors.textSecondary, height: 1.5),
                ),
                SizedBox(height: 32),

                if (_error != null)
                  Container(
                    padding: EdgeInsets.all(12),
                    margin: EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(color: AppColors.redSoft, borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      children: [
                        Icon(Icons.error_outline, color: AppColors.red, size: 18),
                        SizedBox(width: 8),
                        Expanded(child: Text(_error!, style: TextStyle(color: AppColors.red))),
                      ],
                    ),
                  ),

                // Display Name field
                Text(LocalizationService.translate('full_name', lang), style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                TextField(
                  controller: _nameCtrl,
                  style: TextStyle(color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person, color: AppColors.textSecondary),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppColors.borderTertiary),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppColors.accentGreen, width: 2),
                    ),
                    filled: true,
                    fillColor: AppColors.surface,
                  ),
                ),
                SizedBox(height: 24),

                // Password Confirmation field
                Text(LocalizationService.translate('confirm_password', lang), style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                TextField(
                  controller: _passCtrl,
                  obscureText: true,
                  style: TextStyle(color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    hintText: LocalizationService.translate('password', lang),
                    hintStyle: TextStyle(color: AppColors.inputHint),
                    prefixIcon: Icon(Icons.lock_outline, color: AppColors.textSecondary),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppColors.borderTertiary),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppColors.accentGreen, width: 2),
                    ),
                    filled: true,
                    fillColor: AppColors.surface,
                  ),
                ),
                SizedBox(height: 32),

                // Save Button
                GestureDetector(
                  onTap: _isLoading ? null : _saveProfile,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: _isLoading ? AppColors.borderTertiary : AppColors.accentGreen,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: _isLoading
                          ? SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: AppColors.white, strokeWidth: 2))
                          : Text(
                              LocalizationService.translate('save', lang),
                              style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
