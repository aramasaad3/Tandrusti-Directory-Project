import 'package:flutter/material.dart';
import '../main.dart';
import '../services/app_state.dart';
import '../services/auth_service.dart';
import '../services/localization_service.dart';


class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailCtrl = TextEditingController();
  bool _isLoading = false;
  String? _error;
  bool _emailSent = false;

  Future<void> _sendReset() async {
    final email = _emailCtrl.text.trim();
    if (email.isEmpty) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    final err = await AuthService.instance.sendPasswordResetEmail(email);

    if (!mounted) return;

    if (err != null) {
      final lang = AppState.instance.language;
      setState(() {
        _isLoading = false;
        _error = LocalizationService.translate(err, lang);
      });
    } else {
      setState(() {
        _isLoading = false;
        _emailSent = true;
      });
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
                  child: Icon(Icons.lock_reset_rounded, color: AppColors.accentGreen, size: 40),
                ),
                SizedBox(height: 24),

                // Title
                Text(
                  LocalizationService.translate('forgot_password', lang),
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
                SizedBox(height: 8),
                Text(
                  LocalizationService.translate('forgot_password_subtitle', lang),
                  style: TextStyle(fontSize: 15, color: AppColors.textSecondary, height: 1.5),
                ),
                SizedBox(height: 32),

                // Success state
                if (_emailSent) ...[
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.accentGreenSoft,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.accentGreen.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.mark_email_read_rounded, color: AppColors.accentGreen, size: 32),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                LocalizationService.translate('reset_email_sent', lang),
                                style: TextStyle(color: AppColors.accentGreen, fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              SizedBox(height: 4),
                              Text(
                                LocalizationService.translate('reset_email_sent_subtitle', lang),
                                style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 32),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: AppColors.accentGreen,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          LocalizationService.translate('back_to_login', lang),
                          style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                ] else ...[
                  // Error message
                  if (_error != null)
                    Container(
                      padding: EdgeInsets.all(12),
                      margin: EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: AppColors.redSoft,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.error_outline, color: AppColors.red, size: 18),
                          SizedBox(width: 8),
                          Expanded(child: Text(_error!, style: TextStyle(color: AppColors.red))),
                        ],
                      ),
                    ),

                  // Email field
                  TextField(
                    controller: _emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(color: AppColors.textPrimary),
                    decoration: InputDecoration(
                      labelText: LocalizationService.translate('email', lang),
                      labelStyle: TextStyle(color: AppColors.inputHint),
                      prefixIcon: Icon(Icons.email_outlined, color: AppColors.textSecondary),
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

                  // Send Button
                  GestureDetector(
                    onTap: _isLoading ? null : _sendReset,
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
                                LocalizationService.translate('send_reset_link', lang),
                                style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
