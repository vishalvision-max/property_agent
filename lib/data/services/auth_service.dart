import '../models/agent.dart';

abstract class AuthService {
  Future<Agent> login({required String email, required String password});
}

