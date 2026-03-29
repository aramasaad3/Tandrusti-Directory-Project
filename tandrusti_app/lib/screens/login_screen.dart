import 'package:flutter/material.dart';
import '../main.dart';
import '../services/app_state.dart';
import '../services/auth_service.dart';
import '../services/localization_service.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _isLoading = false;
  String? _error;

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    final err = await AuthService.instance.login(
      email: _emailCtrl.text.trim(),
      password: _passCtrl.text,
    );
    if (err != null) {
      setState(() {
        _isLoading = false;
        _error = err;
      });
    } else {
      if (mounted) Navigator.pop(context); // Go back after login
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
              LocalizationService.translate('login', lang),
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            SizedBox(height: 8),
            Text(
              LocalizationService.translate('login_subtitle', lang),
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
              onTap: _isLoading ? null : _login,
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
                      : Text(LocalizationService.translate('login_btn', lang), style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(LocalizationService.translate('no_account', lang), style: TextStyle(color: AppColors.textSecondary)),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => RegisterScreen()));
                  },
                  child: Text(LocalizationService.translate('register', lang), style: TextStyle(color: AppColors.accentGreen)),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
