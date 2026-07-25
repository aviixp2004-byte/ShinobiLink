import 'package:go_router/go_router.dart';

import '../../features/chat/chat_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/nearby/nearby_devices_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/splash/splash_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => HomeScreen(),
    ),
    GoRoute(
      path: '/nearby',
      builder: (context, state) => NearbyDevicesScreen(),
    ),
    GoRoute(
      path: '/chat',
      builder: (context, state) {
        final deviceName = state.extra as String? ?? 'Unknown Device';

        return ChatScreen(
          deviceName: deviceName,
        );
      },
    ),
  ],
);
