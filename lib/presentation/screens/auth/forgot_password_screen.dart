import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../core/validators/validators.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/primary_button.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _email = TextEditingController();
  String? _emailErr;
  bool _loading = false;

  bool get _isValid => _emailErr == null && _email.text.trim().isNotEmpty;

  void _validate() {
    setState(() => _emailErr = Validators.email(_email.text));
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    _validate();
    if (!_isValid) return;

    setState(() => _loading = true);
    await Future<void>.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    setState(() => _loading = false);
    AppSnackbar.show(context, 'Reset link sent (mock).');
    context.pop();
  }

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text('Forgot password')),
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          children: [
            Text('Recover access', style: t.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
            AppSpacing.vXs,
            Text('We will email a reset link (mock).', style: t.bodySmall),
            AppSpacing.vLg,
            AppTextField(
              label: 'Email',
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              prefixIcon: Icons.alternate_email,
              errorText: _emailErr,
              onChanged: (_) => _validate(),
            ),
            AppSpacing.vLg,
            PrimaryButton(
              label: 'Send reset link',
              icon: Icons.send_rounded,
              isLoading: _loading,
              onPressed: _isValid && !_loading ? _submit : null,
            ),
          ],
        ),
      ),
    );
  }
}
