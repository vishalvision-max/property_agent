import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../presentation/screens/auth/forgot_password_screen.dart';
import '../presentation/screens/auth/login_screen.dart';
import '../presentation/screens/auth/splash_screen.dart';
import '../presentation/screens/dashboard/dashboard_screen.dart';
import '../presentation/screens/leads/my_leads_screen.dart';
import '../presentation/screens/profile/change_password_screen.dart';
import '../presentation/screens/profile/edit_profile_screen.dart';
import '../presentation/screens/profile/profile_screen.dart';
import '../presentation/screens/property/property_details_screen.dart';
import '../presentation/screens/property/property_create_screen.dart';
import '../presentation/screens/property/property_edit_screen.dart';
import '../presentation/screens/property/property_list_screen.dart';
import '../presentation/screens/property/property_video_screen.dart';
import '../presentation/widgets/app_shell.dart';
import '../providers/auth_provider.dart';
import '../data/models/property_video.dart';
import 'go_router_refresh.dart';
import 'route_names.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final authStream = ref.read(authProvider.notifier).stream;
  return GoRouter(
    initialLocation: '/dashboard',
    refreshListenable: GoRouterRefreshStream(authStream),
    redirect: (context, state) {
      final auth = ref.read(authProvider).valueOrNull;
      final bootstrapping = auth?.isBootstrapping ?? true;
      final isAuthed = auth?.isAuthed ?? false;
      final loc = state.matchedLocation;

      // Let the app render the requested location while auth bootstraps.
      // If the user isn't authed, we'll redirect to login once bootstrapping completes.
      if (bootstrapping) return null;

      final inAuth = loc.startsWith('/login') || loc.startsWith('/forgot');
      if (!isAuthed) {
        return inAuth ? null : '/login';
      }
      if (isAuthed && (loc == '/splash' || inAuth)) {
        return '/dashboard';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        name: RouteNames.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        name: RouteNames.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/forgot',
        name: RouteNames.forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/dashboard',
                name: RouteNames.dashboard,
                builder: (context, state) => const DashboardScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/properties',
                name: RouteNames.properties,
                builder: (context, state) => const PropertyListScreen(),
                routes: [
                  GoRoute(
                    path: 'new',
                    name: RouteNames.propertyNew,
                    builder: (context, state) => PropertyCreateScreen(
                      autoRestoreDraft:
                          state.uri.queryParameters['restoreDraft'] == '1',
                    ),
                  ),
                  GoRoute(
                    path: ':id',
                    name: RouteNames.propertyDetails,
                    builder: (context, state) => PropertyDetailsScreen(
                      propertyId: state.pathParameters['id']!,
                    ),
                    routes: [
                      GoRoute(
                        path: 'edit',
                        name: RouteNames.propertyEdit,
                        builder: (context, state) => PropertyEditScreen(
                          propertyId: state.pathParameters['id']!,
                        ),
                      ),
                      GoRoute(
                        path: 'videos/:videoId',
                        name: RouteNames.propertyVideo,
                        builder: (context, state) {
                          final v = state.extra;
                          if (v is! PropertyVideo) {
                            return const Scaffold(
                              body: Center(child: Text('Missing video data')),
                            );
                          }
                          return PropertyVideoScreen(
                            propertyId: state.pathParameters['id']!,
                            video: v,
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/my-leads',
                name: RouteNames.myLeads,
                builder: (context, state) => const MyLeadsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                name: RouteNames.profile,
                builder: (context, state) => const ProfileScreen(),
                routes: [
                  GoRoute(
                    path: 'change-password',
                    name: RouteNames.changePassword,
                    builder: (context, state) => const ChangePasswordScreen(),
                  ),
                  GoRoute(
                    path: 'edit',
                    name: RouteNames.editProfile,
                    builder: (context, state) => const EditProfileScreen(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(child: Text(state.error?.toString() ?? 'Route error')),
    ),
  );
});
