import 'package:flutter/material.dart';
import '../main.dart';
import '../services/app_state.dart';
import '../services/auth_service.dart';
import '../services/localization_service.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _isLoading = false;
  String? _error;

  Future<void> _register() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final err = await AuthService.instance.signUp(
      name: _nameCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      password: _passCtrl.text,
    );

    if (err != null) {
      final lang = AppState.instance.language;
      setState(() {
        _isLoading = false;
        _error = LocalizationService.translate(err, lang);
      });
      return;
    }

    // Send Email Verification
    await AuthService.instance.sendEmailVerification();
    setState(() {
      _isLoading = false;
    });
    
    if (mounted) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: AppColors.surface,
          title: Text(LocalizationService.translate('verify_email', AppState.instance.language), style: TextStyle(color: AppColors.textPrimary)),
          content: Text(LocalizationService.translate('verify_email_subtitle', AppState.instance.language), style: TextStyle(color: AppColors.textSecondary)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.pop(context);
              },
              child: Text('OK', style: TextStyle(color: AppColors.accentGreen)),
            )
          ],
        )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = AppState.instance.language;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              LocalizationService.translate('register', lang),
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            SizedBox(height: 8),
            Text(
              LocalizationService.translate('register_subtitle', lang),
              style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
            ),
            SizedBox(height: 32),
            if (_error != null)
              Container(
                padding: EdgeInsets.all(12),
                margin: EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(color: AppColors.redSoft, borderRadius: BorderRadius.circular(8)),
                child: Text(_error!, style: TextStyle(color: AppColors.red)),
              ),
            TextField(
              controller: _nameCtrl,
              keyboardType: TextInputType.name,
              style: TextStyle(color: AppColors.textPrimary),
              decoration: InputDecoration(
                labelText: LocalizationService.translate('full_name', lang),
                labelStyle: TextStyle(color: AppColors.inputHint),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.borderTertiary)),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.accentGreen)),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _emailCtrl,
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(color: AppColors.textPrimary),
              decoration: InputDecoration(
                labelText: LocalizationService.translate('email', lang),
                labelStyle: TextStyle(color: AppColors.inputHint),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.borderTertiary)),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.accentGreen)),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _passCtrl,
              obscureText: true,
              style: TextStyle(color: AppColors.textPrimary),
              decoration: InputDecoration(
                labelText: LocalizationService.translate('password', lang),
                labelStyle: TextStyle(color: AppColors.inputHint),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.borderTertiary)),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.accentGreen)),
              ),
            ),
            SizedBox(height: 48),
            GestureDetector(
              onTap: _isLoading ? null : _register,
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
                      : Text(LocalizationService.translate('register_btn', lang), style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(LocalizationService.translate('has_account', lang), style: TextStyle(color: AppColors.textSecondary)),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginScreen()));
                  },
                  child: Text(LocalizationService.translate('login', lang), style: TextStyle(color: AppColors.accentGreen)),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
