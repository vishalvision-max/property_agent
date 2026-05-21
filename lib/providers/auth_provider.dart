import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/agent.dart';
import 'app_providers.dart';

class AuthState {
  const AuthState({required this.agent, required this.isBootstrapping});

  final Agent? agent;
  final bool isBootstrapping;

  bool get isAuthed => agent != null;

  AuthState copyWith({Agent? agent, bool? isBootstrapping}) => AuthState(
        agent: agent,
        isBootstrapping: isBootstrapping ?? this.isBootstrapping,
      );
}

class AuthNotifier extends StateNotifier<AsyncValue<AuthState>> {
  AuthNotifier(this._ref) : super(const AsyncValue.data(AuthState(agent: null, isBootstrapping: true))) {
    _bootstrap();
  }

  final Ref _ref;

  Future<void> _bootstrap() async {
    try {
      final cached = await _ref.read(authRepositoryProvider).readCachedAgent();
      state = AsyncValue.data(AuthState(agent: cached, isBootstrapping: false));
      if (cached != null) {
        Future.microtask(() => _refreshProfile());
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> login({required String email, required String password}) async {
    final prev = state.valueOrNull ?? const AuthState(agent: null, isBootstrapping: false);
    state = AsyncValue.data(prev.copyWith(isBootstrapping: false));
    state = const AsyncValue.loading();
    try {
      final agent = await _ref.read(authRepositoryProvider).login(email: email, password: password);
      state = AsyncValue.data(AuthState(agent: agent, isBootstrapping: false));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      state = AsyncValue.data(AuthState(agent: null, isBootstrapping: false));
      rethrow;
    }
  }

  Future<void> logout() async {
    await _ref.read(authRepositoryProvider).logout();
    state = const AsyncValue.data(AuthState(agent: null, isBootstrapping: false));
  }

  Future<void> _refreshProfile() async {
    final current = state.valueOrNull?.agent;
    if (current == null) return;
    try {
      final fromApi = await _ref.read(accountRepositoryProvider).getProfile();
      final updated = Agent(
        id: fromApi.id.isEmpty ? current.id : fromApi.id,
        name: fromApi.name.isEmpty ? current.name : fromApi.name,
        email: fromApi.email.isEmpty ? current.email : fromApi.email,
        token: fromApi.token.isEmpty ? current.token : fromApi.token,
        image: (fromApi.image ?? '').trim().isEmpty ? current.image : fromApi.image,
      );
      await _ref.read(authRepositoryProvider).cacheAgent(updated);
      state = AsyncValue.data(AuthState(agent: updated, isBootstrapping: false));
    } catch (_) {
      // Non-fatal: keep cached profile if API fails.
    }
  }

  Future<void> updateProfile({required String name, File? image}) async {
    final current = state.valueOrNull?.agent;
    if (current == null) return;

    final trimmedName = name.trim();
    if (trimmedName.isEmpty) {
      throw Exception('Name is required');
    }

    final updatedFromApi = await _ref
        .read(accountRepositoryProvider)
        .updateProfile(name: trimmedName, image: image);

    // Keep local auth state in sync with API (also updates token if backend rotates it).
    final updated = Agent(
      id: updatedFromApi.id.isEmpty ? current.id : updatedFromApi.id,
      name: updatedFromApi.name.isEmpty ? trimmedName : updatedFromApi.name,
      email: updatedFromApi.email.isEmpty ? current.email : updatedFromApi.email,
      token: updatedFromApi.token.isEmpty ? current.token : updatedFromApi.token,
      image: (updatedFromApi.image ?? '').trim().isEmpty
          ? current.image
          : updatedFromApi.image,
    );
    await _ref.read(authRepositoryProvider).cacheAgent(updated);
    state = AsyncValue.data(
      AuthState(agent: updated, isBootstrapping: false),
    );

    // User requested: after edit, hit GET profile once to refresh data.
    await _refreshProfile();
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AsyncValue<AuthState>>((ref) {
  return AuthNotifier(ref);
});
