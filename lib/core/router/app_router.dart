import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/onboarding_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/customers/presentation/screens/customer_list_screen.dart';
import '../../features/products/presentation/screens/product_list_screen.dart';
import '../../features/reports/presentation/screens/reports_screen.dart';
import '../../features/expenses/presentation/screens/expenses_screen.dart';
import '../../features/ai/presentation/screens/ai_screen.dart';
import '../../features/messages/presentation/screens/messages_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/pos/presentation/screens/pos_screen.dart';
import '../../features/sales/presentation/screens/sales_list_screen.dart';

final appRouterStateProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      if (authState.isLoading) return null;
      
      final bool isLoggedIn = authState.user != null;
      final bool isLoggingIn = state.matchedLocation == '/login' || state.matchedLocation == '/register';

      if (!isLoggedIn) {
        return isLoggingIn ? null : '/login';
      }

      if (isLoggedIn && isLoggingIn) {
        return '/';
      }

      // Check for business context
      if (isLoggedIn && authState.user?.businessId == null && state.matchedLocation != '/onboarding') {
        return '/onboarding';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/',
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: '/customers',
        builder: (context, state) => const CustomerListScreen(),
      ),
      GoRoute(
        path: '/products',
        builder: (context, state) => const ProductListScreen(),
      ),
      GoRoute(
        path: '/pos',
        builder: (context, state) => const POSScreen(),
      ),
      GoRoute(
        path: '/expenses',
        builder: (context, state) => const ExpensesScreen(),
      ),
      GoRoute(
        path: '/reports',
        builder: (context, state) => const ReportsScreen(),
      ),
      GoRoute(
        path: '/ai',
        builder: (context, state) => const AIScreen(),
      ),
      GoRoute(
        path: '/messages',
        builder: (context, state) => const MessagesScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );
});
