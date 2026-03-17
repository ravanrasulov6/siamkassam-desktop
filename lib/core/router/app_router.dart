import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/onboarding_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/customers/presentation/screens/customer_list_screen.dart';
import '../../features/customers/presentation/screens/add_customer_screen.dart';
import '../../features/products/presentation/screens/product_list_screen.dart';
import '../../features/products/presentation/screens/add_product_screen.dart';
import '../../features/debts/presentation/screens/debt_list_screen.dart';
import '../../features/debts/presentation/screens/add_debt_screen.dart';
import '../../features/pos/presentation/screens/pos_screen.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';






final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      final isLoggedIn = authState.user != null;
      final isLoggingIn = state.matchedLocation == '/login';
      final isRegistering = state.matchedLocation == '/register';
      final isOnboarding = state.matchedLocation == '/onboarding';

      if (!isLoggedIn && !isLoggingIn && !isRegistering) {
        return '/login';
      }

      if (isLoggedIn) {
        final needsOnboarding = !authState.user!.onboardingCompleted;
        
        if (needsOnboarding && !isOnboarding) {
          return '/onboarding';
        }
        
        if (!needsOnboarding && (isLoggingIn || isRegistering || isOnboarding)) {
          return '/';
        }
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const DashboardScreen(),
      ),
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
        path: '/customers',
        builder: (context, state) => const CustomerListScreen(),
      ),
      GoRoute(
        path: '/customers/add',
        builder: (context, state) => const AddCustomerScreen(),
      ),
      GoRoute(
        path: '/products',
        builder: (context, state) => const ProductListScreen(),
      ),
      GoRoute(
        path: '/products/add',
        builder: (context, state) => const AddProductScreen(),
      ),
      GoRoute(
        path: '/debts',
        builder: (context, state) => const DebtListScreen(),
      ),
      GoRoute(
        path: '/debts/add',
        builder: (context, state) => const AddDebtScreen(),
      ),
      GoRoute(
        path: '/pos',
        builder: (context, state) => const POSScreen(),
      ),
    ],
  );
});







