import 'package:deep_link_main/main.dart';
import 'package:go_router/go_router.dart';
import 'package:deep_link_main/second_page.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
      routes: [
        GoRoute(
          path: 'second',
          builder: (context, state) => const SecondPage(),
        ),
      ],
    ),
  ],
);
