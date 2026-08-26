import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../core/validators/validators.dart';
import '../../../providers/app_providers.dart';

class ChangePasswordScreen extends ConsumerStatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  ConsumerState<ChangePasswordScreen> createState() =>
      _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  final _old = TextEditingController();
  final _nw = TextEditingController();
  final _confirm = TextEditingController();
  final _oldFocus = FocusNode();
  final _newFocus = FocusNode();
  final _confirmFocus = FocusNode();
  bool _loading = false;
  bool _ob1 = true;
  bool _ob2 = true;
  bool _ob3 = true;
  String? _oldErr;
  String? _newErr;
  String? _confirmErr;
  // A field's error is only surfaced once the user has left it (blurred) or
  // attempted to submit — so no error flashes while they're still typing.
  bool _oldTouched = false;
  bool _newTouched = false;
  bool _confirmTouched = false;

  @override
  void initState() {
    super.initState();
    _oldFocus.addListener(() {
      if (!_oldFocus.hasFocus && _old.text.isNotEmpty) {
        setState(() => _oldTouched = true);
      }
    });
    _newFocus.addListener(() {
      if (!_newFocus.hasFocus && _nw.text.isNotEmpty) {
        setState(() => _newTouched = true);
      }
    });
    _confirmFocus.addListener(() {
      if (!_confirmFocus.hasFocus && _confirm.text.isNotEmpty) {
        setState(() => _confirmTouched = true);
      }
    });
  }

  void _validate() {
    setState(() {
      _oldErr = Validators.password(_old.text);
      _newErr = Validators.password(_nw.text);
      _confirmErr = (_confirm.text != _nw.text) ? 'Passwords do not match' : null;
    });
  }

  bool get _valid =>
      _oldErr == null &&
      _newErr == null &&
      _confirmErr == null &&
      _old.text.isNotEmpty &&
      _nw.text.isNotEmpty &&
      _confirm.text.isNotEmpty;

  Future<void> _save() async {
    FocusScope.of(context).unfocus();
    setState(() {
      _oldTouched = true;
      _newTouched = true;
      _confirmTouched = true;
    });
    _validate();
    if (!_valid) return;
    setState(() => _loading = true);
    try {
      await ref.read(accountRepositoryProvider).updatePassword(
            currentPassword: _old.text,
            password: _nw.text,
            passwordConfirmation: _confirm.text,
          );
      if (!mounted) return;
      AppSnackbar.show(context, 'Password updated successfully.');
      context.pop();
    } catch (e) {
      if (mounted) AppSnackbar.show(context, e.toString());
    } finally {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _old.dispose();
    _nw.dispose();
    _confirm.dispose();
    _oldFocus.dispose();
    _newFocus.dispose();
    _confirmFocus.dispose();
    super.dispose();
  }

  // Field with a clear label above it. Uses the app's (light) theme for the
  // input styling so it stays consistent with the rest of the app.
  Widget _passwordField({
    required String label,
    required TextEditingController controller,
    required bool obscure,
    required VoidCallback onToggle,
    FocusNode? focusNode,
    String? hint,
    String? helperText,
    String? errorText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const Text(' *', style: TextStyle(color: Colors.red)),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          focusNode: focusNode,
          obscureText: obscure,
          onChanged: (_) => _validate(),
          decoration: InputDecoration(
            hintText: hint,
            helperText: helperText,
            errorText: errorText,
            suffixIcon: IconButton(
              onPressed: onToggle,
              icon: Icon(
                obscure
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                size: 18,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: const Text('Change password'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          children: [
            _passwordField(
              label: 'Current password',
              controller: _old,
              focusNode: _oldFocus,
              obscure: _ob1,
              onToggle: () => setState(() => _ob1 = !_ob1),
              hint: 'Enter current password',
              errorText: _oldTouched ? _oldErr : null,
            ),
            const SizedBox(height: 16),
            _passwordField(
              label: 'New password',
              controller: _nw,
              focusNode: _newFocus,
              obscure: _ob2,
              onToggle: () => setState(() => _ob2 = !_ob2),
              hint: 'Enter new password',
              helperText: 'Min 6 characters',
              errorText: _newTouched ? _newErr : null,
            ),
            const SizedBox(height: 16),
            _passwordField(
              label: 'Confirm new password',
              controller: _confirm,
              focusNode: _confirmFocus,
              obscure: _ob3,
              onToggle: () => setState(() => _ob3 = !_ob3),
              hint: 'Re-enter new password',
              errorText: _confirmTouched ? _confirmErr : null,
            ),
            AppSpacing.vLg,
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _loading ? null : (_valid ? _save : null),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.gold,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                icon: _loading
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.black,
                        ),
                      )
                    : const Icon(Icons.save_rounded, size: 18),
                label: Text(_loading ? 'Updating…' : 'Update password'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
