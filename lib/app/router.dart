import 'package:calculadora_laboral_mx/features/calculator/presentation/calculator_screen.dart';
import 'package:calculadora_laboral_mx/features/calculator/presentation/results_screen.dart';
import 'package:calculadora_laboral_mx/features/history/presentation/history_screen.dart';
import 'package:calculadora_laboral_mx/features/history/presentation/saved_calculation_detail_screen.dart';
import 'package:calculadora_laboral_mx/features/home/presentation/home_screen.dart';
import 'package:calculadora_laboral_mx/features/legal_guide/presentation/legal_guide_screen.dart';
import 'package:calculadora_laboral_mx/features/legal_guide/presentation/legal_guide_topic_screen.dart';
import 'package:calculadora_laboral_mx/features/onboarding/presentation/onboarding_screen.dart';
import 'package:calculadora_laboral_mx/features/settings/presentation/legal_notice_screen.dart';
import 'package:calculadora_laboral_mx/features/settings/presentation/settings_screen.dart';
import 'package:calculadora_laboral_mx/features/splash/presentation/splash_screen.dart';
import 'package:calculadora_laboral_mx/features/tools/presentation/extra_tools_screens.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: SplashScreen.routePath,
    routes: [
      GoRoute(
        path: SplashScreen.routePath,
        name: SplashScreen.routeName,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: OnboardingScreen.routePath,
        name: OnboardingScreen.routeName,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: HomeScreen.routePath,
        name: HomeScreen.routeName,
        builder: (context, state) => const HomeScreen(),
        routes: [
          GoRoute(
            path: CalculatorScreen.routeSegment,
            name: CalculatorScreen.routeName,
            builder: (context, state) => const CalculatorScreen(),
          ),
          GoRoute(
            path: ResultsScreen.routeSegment,
            name: ResultsScreen.routeName,
            builder: (context, state) => const ResultsScreen(),
          ),
          GoRoute(
            path: HistoryScreen.routeSegment,
            name: HistoryScreen.routeName,
            builder: (context, state) => const HistoryScreen(),
            routes: [
              GoRoute(
                path: SavedCalculationDetailScreen.routeSegment,
                name: SavedCalculationDetailScreen.routeName,
                builder: (context, state) {
                  return SavedCalculationDetailScreen(
                    calculationId: state.pathParameters['calculationId']!,
                  );
                },
              ),
            ],
          ),
          GoRoute(
            path: LegalGuideScreen.routeSegment,
            name: LegalGuideScreen.routeName,
            builder: (context, state) => const LegalGuideScreen(),
            routes: [
              GoRoute(
                path: LegalGuideTopicScreen.routeSegment,
                name: LegalGuideTopicScreen.routeName,
                builder: (context, state) {
                  return LegalGuideTopicScreen(
                    topicId: state.pathParameters['topicId']!,
                  );
                },
              ),
            ],
          ),
          GoRoute(
            path: SettingsScreen.routeSegment,
            name: SettingsScreen.routeName,
            builder: (context, state) => const SettingsScreen(),
          ),
          GoRoute(
            path: LegalNoticeScreen.routeSegment,
            name: LegalNoticeScreen.routeName,
            builder: (context, state) => const LegalNoticeScreen(),
          ),
          GoRoute(
            path: PrivacyScreen.routeSegment,
            name: PrivacyScreen.routeName,
            builder: (context, state) => const PrivacyScreen(),
          ),
          GoRoute(
            path: AguinaldoToolScreen.routeSegment,
            name: AguinaldoToolScreen.routeName,
            builder: (context, state) => const AguinaldoToolScreen(),
          ),
          GoRoute(
            path: VacationsToolScreen.routeSegment,
            name: VacationsToolScreen.routeName,
            builder: (context, state) => const VacationsToolScreen(),
          ),
          GoRoute(
            path: DailySalaryToolScreen.routeSegment,
            name: DailySalaryToolScreen.routeName,
            builder: (context, state) => const DailySalaryToolScreen(),
          ),
          GoRoute(
            path: OfferComparatorToolScreen.routeSegment,
            name: OfferComparatorToolScreen.routeName,
            builder: (context, state) => const OfferComparatorToolScreen(),
          ),
          GoRoute(
            path: ExitChecklistToolScreen.routeSegment,
            name: ExitChecklistToolScreen.routeName,
            builder: (context, state) => const ExitChecklistToolScreen(),
          ),
        ],
      ),
    ],
  );
});
