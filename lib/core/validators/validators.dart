class Validators {
  static String? email(String? v) {
    final value = (v ?? '').trim();
    if (value.isEmpty) return 'Email is required';
    final re = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!re.hasMatch(value)) return 'Enter a valid email';
    return null;
  }

  static String? password(String? v) {
    final value = (v ?? '');
    if (value.isEmpty) return 'Password is required';
    if (value.length < 6) return 'Min 6 characters';
    return null;
  }

  static String? requiredText(String? v, {String label = 'This field'}) {
    final value = (v ?? '').trim();
    if (value.isEmpty) return '$label is required';
    return null;
  }

  static String? minLen(String? v, int min, {String label = 'This field'}) {
    final value = (v ?? '').trim();
    if (value.isEmpty) return '$label is required';
    if (value.length < min) return 'Min $min characters';
    return null;
  }

  static String? positiveNum(String? v, {String label = 'Value'}) {
    final value = (v ?? '').trim();
    if (value.isEmpty) return '$label is required';
    final n = num.tryParse(value);
    if (n == null) return 'Enter a valid number';
    if (n <= 0) return '$label must be > 0';
    return null;
  }

  static String? numericOptional(String? v, {String label = 'Value'}) {
    final value = (v ?? '').trim();
    if (value.isEmpty) return null;
    final n = num.tryParse(value);
    if (n == null) return 'Enter a valid number';
    if (n < 0) return '$label must be >= 0';
    return null;
  }
}

