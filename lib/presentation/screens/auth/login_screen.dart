import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../core/validators/validators.dart';
import '../../../providers/auth_provider.dart';
import '../../../routes/route_names.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/primary_button.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();

  String? _emailErr;
  String? _passErr;
  bool _obscure = true;

  bool get _isValid =>
      _emailErr == null &&
      _passErr == null &&
      _email.text.trim().isNotEmpty &&
      _password.text.isNotEmpty;

  @override
  void initState() {
    super.initState();
    // Do NOT validate on init — errors should only show after user interaction.
  }

  void _validateAll() {
    setState(() {
      _emailErr = Validators.requiredText(_email.text, label: 'ID / Email');
      _passErr = Validators.password(_password.text);
    });
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    _validateAll();
    if (!_isValid) return;

    try {
      await ref
          .read(authProvider.notifier)
          .login(email: _email.text, password: _password.text);
    } catch (e) {
      if (mounted) AppSnackbar.show(context, e.toString());
    }
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loading = ref.watch(authProvider).isLoading;
    final t = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,

      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /// 🔵 HEADER / BRANDING
                Icon(Icons.apartment_rounded, size: 64, color: cs.primary),
                AppSpacing.vSm,
                Text(
                  'Property Manager',
                  style: t.titleLarge?.copyWith(fontWeight: FontWeight.w900),
                ),
                AppSpacing.vXs,
                Text('Sign in to continue', style: t.bodySmall),

                AppSpacing.vXl,

                /// 🟦 LOGIN CARD
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: cs.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      AppTextField(
                        label: 'ID / Email',
                        controller: _email,
                        keyboardType: TextInputType.text,
                        prefixIcon: Icons.person_outline,
                        errorText: _emailErr,
                        onChanged: (_) => _validateAll(),
                        textInputAction: TextInputAction.next,
                      ),
                      AppSpacing.vSm,
                      AppTextField(
                        label: 'Password',
                        controller: _password,
                        obscureText: _obscure,
                        prefixIcon: Icons.lock_outline,
                        errorText: _passErr,
                        onChanged: (_) => _validateAll(),
                        suffixIcon: IconButton(
                          onPressed: () => setState(() => _obscure = !_obscure),
                          icon: Icon(
                            _obscure
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            size: 18,
                          ),
                        ),
                        textInputAction: TextInputAction.done,
                      ),

                      AppSpacing.vSm,

                      /// 🔑 FORGOT PASSWORD
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () =>
                              context.pushNamed(RouteNames.forgotPassword),
                          child: const Text('Forgot password?'),
                        ),
                      ),

                      AppSpacing.vSm,

                      /// 🔵 LOGIN BUTTON
                      SizedBox(
                        width: double.infinity,
                        child: PrimaryButton(
                          label: 'Login',
                          icon: Icons.login_rounded,
                          isLoading: loading,
                          onPressed: _isValid && !loading ? _submit : null,
                        ),
                      ),
                    ],
                  ),
                ),

                AppSpacing.vLg,
                //
                // /// 💡 FOOTER TIP
                // Text(
                //   'Demo tip: use agent@demo.com',
                //   style: t.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                //   textAlign: TextAlign.center,
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
