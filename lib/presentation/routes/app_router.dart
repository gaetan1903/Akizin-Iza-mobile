import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/dashboard_screen.dart';
import '../screens/search_code_screen.dart';
import '../screens/search_name_screen.dart';
import '../screens/points_wallet_screen.dart';
import '../screens/subscription_screen.dart';
import '../screens/relation_requests_screen.dart';
import '../screens/verification_screen.dart';
import '../screens/relation_detail_screen.dart';
import '../screens/login_screen.dart';

class AppRouter {
  static const home = '/';
  static const dashboard = '/dashboard';
  static const login = '/login';
  static const searchCode = '/search/code';
  static const searchName = '/search/name';
  static const wallet = '/wallet';
  static const subscription = '/subscription';
  static const relationRequests = '/relations/requests';
  static const verification = '/verification';
  static const relationDetail = '/relation/detail';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case dashboard:
        return MaterialPageRoute(builder: (_) => const DashboardScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case searchCode:
        return MaterialPageRoute(builder: (_) => const SearchCodeScreen());
      case searchName:
        return MaterialPageRoute(builder: (_) => const SearchNameScreen());
      case wallet:
        return MaterialPageRoute(builder: (_) => const PointsWalletScreen());
      case subscription:
        return MaterialPageRoute(builder: (_) => const SubscriptionScreen());
      case relationRequests:
        return MaterialPageRoute(builder: (_) => const RelationRequestsScreen());
      case verification:
        return MaterialPageRoute(builder: (_) => const VerificationScreen());
      case relationDetail:
        return MaterialPageRoute(builder: (_) => const RelationDetailScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Route non trouvée')),
          ),
        );
    }
  }
}
