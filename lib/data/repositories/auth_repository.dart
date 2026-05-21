import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/app_constants.dart';
import '../models/agent.dart';
import '../services/auth_service.dart';

class AuthRepository {
  AuthRepository({required this.authService});

  final AuthService authService;

  Future<Agent> login({required String email, required String password}) async {
    final agent = await authService.login(email: email, password: password);
    await cacheAgent(agent);
    return agent;
  }

  Future<void> cacheAgent(Agent agent) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.prefsAuthTokenKey, agent.token);
    await prefs.setString(AppConstants.prefsAgentIdKey, agent.id);
    await prefs.setString(AppConstants.prefsAgentNameKey, agent.name);
    await prefs.setString(AppConstants.prefsAgentEmailKey, agent.email);
    if ((agent.image ?? '').trim().isEmpty) {
      await prefs.remove(AppConstants.prefsAgentImageKey);
    } else {
      await prefs.setString(AppConstants.prefsAgentImageKey, agent.image!);
    }
  }

  Future<Agent?> readCachedAgent() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(AppConstants.prefsAuthTokenKey);
    if (token == null || token.isEmpty) return null;
    final id = prefs.getString(AppConstants.prefsAgentIdKey) ?? 'cached';
    final name = prefs.getString(AppConstants.prefsAgentNameKey) ?? 'Agent';
    final email = prefs.getString(AppConstants.prefsAgentEmailKey) ?? '';
    final image = prefs.getString(AppConstants.prefsAgentImageKey);
    return Agent(id: id, name: name, email: email, token: token, image: image);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.prefsAuthTokenKey);
    await prefs.remove(AppConstants.prefsAgentIdKey);
    await prefs.remove(AppConstants.prefsAgentNameKey);
    await prefs.remove(AppConstants.prefsAgentEmailKey);
    await prefs.remove(AppConstants.prefsAgentImageKey);
  }
}
