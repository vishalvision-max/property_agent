import 'dart:io';

import '../models/agent.dart';
import '../services/staff_account_service.dart';

class AccountRepository {
  AccountRepository({required this.accountService});

  final StaffAccountService accountService;

  Future<void> updatePassword({
    required String currentPassword,
    required String password,
    required String passwordConfirmation,
  }) {
    return accountService.updatePassword(
      currentPassword: currentPassword,
      password: password,
      passwordConfirmation: passwordConfirmation,
    );
  }

  Future<Agent> getProfile() {
    return accountService.getProfile();
  }

  Future<Agent> updateProfile({required String name, File? image}) {
    return accountService.updateProfile(name: name, image: image);
  }
}
