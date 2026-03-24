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
import '../../features/debts/presentation/screens/debt_list_screen.dart';
import '../../features/debts/presentation/screens/add_debt_screen.dart';

// Key for the root navigator
final _rootNavigatorKey = GlobalKey<NavigatorState>();
// Key for the shell navigator (for the MainLayout)
final _shellNavigatorKey = GlobalKey<NavigatorState>();

/// A notifier that triggers a refresh of the GoRouter when the auth state changes.
class RouterRefreshNotifier extends ChangeNotifier {
  RouterRefreshNotifier(Ref ref) {
    ref.listen(authProvider, (_, __) => notifyListeners());
  }
}

final routerRefreshProvider = Provider((ref) => RouterRefreshNotifier(ref));

final appRouterStateProvider = Provider<GoRouter>((ref) {
  final refreshNotifier = ref.watch(routerRefreshProvider);
  
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    refreshListenable: refreshNotifier,
    initialLocation: '/',
    redirect: (context, state) {
      final authState = ref.read(authProvider);
      
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
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return MainLayout(child: child);
        },
        routes: [
          GoRoute(
            path: '/',
            pageBuilder: (context, state) => const NoTransitionPage(child: DashboardScreen()),
          ),
          GoRoute(
            path: '/customers',
            pageBuilder: (context, state) => const NoTransitionPage(child: CustomerListScreen()),
            routes: [
              GoRoute(
                path: 'add',
                builder: (context, state) => const AddCustomerScreen(),
              ),
            ],
          ),
          GoRoute(
            path: '/products',
            pageBuilder: (context, state) => const NoTransitionPage(child: ProductListScreen()),
            routes: [
              GoRoute(
                path: 'add',
                builder: (context, state) => const AddProductScreen(),
              ),
            ],
          ),
          GoRoute(
            path: '/pos',
            pageBuilder: (context, state) => const NoTransitionPage(child: POSScreen()),
          ),
          GoRoute(
            path: '/sales',
            pageBuilder: (context, state) => const NoTransitionPage(child: SalesListScreen()),
          ),
          GoRoute(
            path: '/debts',
            pageBuilder: (context, state) => const NoTransitionPage(child: DebtListScreen()),
            routes: [
              GoRoute(
                path: 'add',
                builder: (context, state) => const AddDebtScreen(),
              ),
            ],
          ),
          GoRoute(
            path: '/expenses',
            pageBuilder: (context, state) => const NoTransitionPage(child: ExpensesScreen()),
          ),
          GoRoute(
            path: '/reports',
            pageBuilder: (context, state) => const NoTransitionPage(child: ReportsScreen()),
          ),
          GoRoute(
            path: '/ai',
            pageBuilder: (context, state) => const NoTransitionPage(child: AIScreen()),
          ),
          GoRoute(
            path: '/messages',
            pageBuilder: (context, state) => const NoTransitionPage(child: MessagesScreen()),
          ),
          GoRoute(
            path: '/settings',
            pageBuilder: (context, state) => const NoTransitionPage(child: SettingsScreen()),
          ),
        ],
      ),
    ],
  );
});
