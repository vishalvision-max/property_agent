import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_spacing.dart';
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
  bool _loading = false;
  bool _ob1 = true;
  bool _ob2 = true;
  bool _ob3 = true;
  String? _oldErr;
  String? _newErr;
  String? _confirmErr;

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text('Change password')),
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          children: [
            TextField(
              controller: _old,
              obscureText: _ob1,
              onChanged: (_) => _validate(),
              decoration: InputDecoration(
                labelText: 'Current password',
                errorText: _oldErr,
                suffixIcon: IconButton(
                  onPressed: () => setState(() => _ob1 = !_ob1),
                  icon: Icon(
                    _ob1
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    size: 18,
                  ),
                ),
              ),
            ),
            AppSpacing.vSm,
            TextField(
              controller: _nw,
              obscureText: _ob2,
              onChanged: (_) => _validate(),
              decoration: InputDecoration(
                labelText: 'New password',
                helperText: 'Min 6 characters',
                errorText: _newErr,
                suffixIcon: IconButton(
                  onPressed: () => setState(() => _ob2 = !_ob2),
                  icon: Icon(
                    _ob2
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    size: 18,
                  ),
                ),
              ),
            ),
            AppSpacing.vSm,
            TextField(
              controller: _confirm,
              obscureText: _ob3,
              onChanged: (_) => _validate(),
              decoration: InputDecoration(
                labelText: 'Confirm new password',
                errorText: _confirmErr,
                suffixIcon: IconButton(
                  onPressed: () => setState(() => _ob3 = !_ob3),
                  icon: Icon(
                    _ob3
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    size: 18,
                  ),
                ),
              ),
            ),
            AppSpacing.vLg,
            FilledButton.icon(
              onPressed: _loading ? null : (_valid ? _save : null),
              icon: _loading
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.save_rounded, size: 18),
              label: const Text('Update password'),
            ),
          ],
        ),
      ),
    );
  }
}
