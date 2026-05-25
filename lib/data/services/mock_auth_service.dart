import 'dart:async';

import '../models/agent.dart';
import 'auth_service.dart';

class MockAuthService implements AuthService {
  @override
  Future<Agent> login({required String email, required String password}) async {
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (!email.toLowerCase().contains('agent')) {
      throw Exception('Only agents are allowed. Try `agent@demo.com`.');
    }
    if (password.length < 6) {
      throw Exception('Invalid credentials');
    }
    return Agent(
      id: 'agent_001',
      name: 'Rohit Jaiswal',
      email: email.trim(),
      token: 'mock-token-${DateTime.now().millisecondsSinceEpoch}',
    );
  }

  @override
  Future<void> forgotPassword({required String email}) async {
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (!email.toLowerCase().contains('@')) {
      throw Exception('Enter a valid email address');
    }
  }
}
