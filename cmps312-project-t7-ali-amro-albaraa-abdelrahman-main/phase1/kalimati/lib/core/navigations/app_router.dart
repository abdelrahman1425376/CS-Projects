import 'package:go_router/go_router.dart';
import 'package:class_manager/features/auth/presentaion/screens/login_page.dart';
import 'package:class_manager/features/view_learning_packages/presentation/screens/learning_packages_page.dart';
import 'package:class_manager/features/teacher_tools/presentation/screens/teacher_tools_page.dart';
import 'package:class_manager/features/game/presentation/screens/flash_cards_page.dart';
import 'package:class_manager/features/game/presentation/screens/unscramble_sentences_page.dart';
import 'package:class_manager/features/game/presentation/screens/match_word_definition_page.dart';
import 'package:class_manager/features/view_learning_packages/domain/entities/learning_package.dart';

class AppRoute {
  static final router = GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
      GoRoute(
        path: '/learning_packages',
        builder: (context, state) => const LearningPackagesPage(),
      ),
      GoRoute(
        path: '/teacher_tools',
        builder: (context, state) => const TeacherToolsPage(),
      ),
      GoRoute(
        path: '/flash_cards',
        builder: (context, state) {
          final package = state.extra as LearningPackage;
          return FlashCardsPage(package: package);
        },
      ),
      GoRoute(
        path: '/unscramble_sentences',
        builder: (context, state) {
          final package = state.extra as LearningPackage;
          return UnscrambleSentencesPage(package: package);
        },
      ),
      GoRoute(
        path: '/match_word_definition',
        builder: (context, state) {
          final package = state.extra as LearningPackage;
          return MatchWordDefinitionPage(package: package);
        },
      ),
    ],
  );
}
