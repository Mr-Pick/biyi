import 'package:biyi_app/app/available_ocr_engines/page.dart';
import 'package:biyi_app/app/available_translation_engines/page.dart';
import 'package:biyi_app/app/home/page.dart';
import 'package:biyi_app/app/settings/about/page.dart';
import 'package:biyi_app/app/settings/advanced/page.dart';
import 'package:biyi_app/app/settings/appearance/page.dart';
import 'package:biyi_app/app/settings/changelog/page.dart';
import 'package:biyi_app/app/settings/general/page.dart';
import 'package:biyi_app/app/settings/keybinds/page.dart';
import 'package:biyi_app/app/settings/language/page.dart';
import 'package:biyi_app/app/settings/layout.dart';
import 'package:biyi_app/app/settings/ocr_engine_types/page.dart';
import 'package:biyi_app/app/settings/ocr_engines/new/page.dart';
import 'package:biyi_app/app/settings/ocr_engines/page.dart';
import 'package:biyi_app/app/settings/page.dart';
import 'package:biyi_app/app/settings/translation_engine_types/page.dart';
import 'package:biyi_app/app/settings/translation_engines/new/page.dart';
import 'package:biyi_app/app/settings/translation_engines/page.dart';
import 'package:biyi_app/app/settings/translation_targets/new/page.dart';
import 'package:biyi_app/app/supported_languages/page.dart';
import 'package:biyi_app/models/translation_target.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart' show DialogRoute;
import 'package:go_router/go_router.dart';
import 'package:influxui/influxui.dart';
import 'package:uni_platform/uni_platform.dart';

class DialogPage<T> extends Page<T> {
  const DialogPage({
    required this.builder,
    this.anchorPoint,
    this.barrierColor,
    this.barrierDismissible = true,
    this.barrierLabel,
    this.useSafeArea = true,
    this.themes,
    super.key,
    super.name,
    super.arguments,
    super.restorationId,
  });

  final Offset? anchorPoint;
  final Color? barrierColor;
  final bool barrierDismissible;
  final String? barrierLabel;
  final bool useSafeArea;
  final CapturedThemes? themes;
  final WidgetBuilder builder;

  @override
  Route<T> createRoute(BuildContext context) {
    return DialogRoute<T>(
      context: context,
      settings: this,
      builder: builder,
      anchorPoint: anchorPoint,
      barrierColor: barrierColor,
      barrierDismissible: barrierDismissible,
      barrierLabel: barrierLabel,
      useSafeArea: useSafeArea,
      themes: themes,
    );
  }
}

class PageId {
  static const String availableOcrEngines = '/available-ocr-engines';
  static const String availableTranslationEngines =
      '/available-translation-engines';
  static const String home = '/home';
  static const String settingsOcrEnginesNew = '/settings/ocr-engines/new';
  static const String settingsGeneral = '/settings/general';
  static const String settingsAppearance = '/settings/appearance';
  static const String settingsKeybinds = '/settings/keybinds';
  static const String settingsLanguage = '/settings/language';
  static const String settingsAdvanced = '/settings/advanced';
  static const String settingsTranslationEngineTypes =
      '/settings/translation-engine-types';
  static const String settingsTranslationEngines =
      '/settings/translation-engines';
  static const String settingsOcrEngineTypes = '/settings/ocr-engine-types';
  static const String settingsOcrEngines = '/settings/ocr-engines';
  static const String settingsAbout = '/settings/about';
  static const String settingsChangelog = '/settings/changelog';
  static const String supportedLanguages = '/supported-languages';
  static const String settingsTranslationEnginesNew =
      '/settings/translation-engines/new';
  static const String translationTargetsNew =
      '/settings/translation-targets/new';
  static String settingsOcrEngine(String id) => '/settings/ocr-engines/$id';
  static String settingsTranslationEngine(String id) =>
      '/settings/translation-engines/$id';
  static String settingsTranslationTarget(String id) =>
      '/settings/translation-targets/$id';
}

// GoRouter configuration
final routerConfig = GoRouter(
  observers: [BotToastNavigatorObserver()],
  routes: [
    GoRoute(
      path: '/',
      redirect: (context, state) {
        return '/home';
      },
    ),
    GoRoute(
      path: '/available-ocr-engines',
      pageBuilder: (BuildContext context, GoRouterState state) {
        return DialogPage(
          barrierColor: ExtendedColors.black.withOpacity(0.5),
          builder: (_) => Center(
            child: Container(
              padding: const EdgeInsets.all(64),
              constraints: const BoxConstraints(maxWidth: 800, maxHeight: 600),
              child: Card(
                child: AvailableOcrEnginesPage(
                  selectedEngineId:
                      state.uri.queryParameters['selectedEngineId'],
                ),
              ),
            ),
          ),
        );
      },
    ),
    GoRoute(
      path: '/available-translation-engines',
      pageBuilder: (BuildContext context, GoRouterState state) {
        return DialogPage(
          barrierColor: ExtendedColors.black.withOpacity(0.5),
          builder: (_) => Center(
            child: Container(
              padding: const EdgeInsets.all(64),
              constraints: const BoxConstraints(maxWidth: 800, maxHeight: 600),
              child: Card(
                child: AvailableTranslationEnginesPage(
                  selectedEngineId:
                      state.uri.queryParameters['selectedEngineId'],
                ),
              ),
            ),
          ),
        );
      },
    ),
    GoRoute(
      path: '/home',
      pageBuilder: (context, state) {
        return FadeTransitionPage(
          key: state.pageKey,
          child: const HomePage(),
        );
      },
    ),
    ShellRoute(
      pageBuilder: (context, state, child) {
        return FadeTransitionPage(
          key: state.pageKey,
          child: SettingsLayout(child: child),
        );
      },
      routes: [
        GoRoute(
          path: '/settings',
          redirect: (context, state) {
            return null;
          },
          builder: (UniPlatform.isAndroid || UniPlatform.isIOS)
              ? (context, state) {
                  return const SettingsPage();
                }
              : null,
          routes: [
            GoRoute(
              path: 'about',
              pageBuilder: (context, state) {
                return FadeTransitionPage(
                  key: state.pageKey,
                  child: const AboutSettingPage(),
                );
              },
            ),
            GoRoute(
              path: 'advanced',
              pageBuilder: (context, state) {
                return FadeTransitionPage(
                  key: state.pageKey,
                  child: const AdvancedSettingPage(),
                );
              },
            ),
            GoRoute(
              path: 'appearance',
              pageBuilder: (context, state) {
                return FadeTransitionPage(
                  key: state.pageKey,
                  child: const AppearanceSettingPage(),
                );
              },
            ),
            GoRoute(
              path: 'changelog',
              pageBuilder: (context, state) {
                return FadeTransitionPage(
                  key: state.pageKey,
                  child: const ChangelogSettingPage(),
                );
              },
            ),
            GoRoute(
              path: 'general',
              pageBuilder: (context, state) {
                return FadeTransitionPage(
                  key: state.pageKey,
                  child: const GeneralSettingPage(),
                );
              },
            ),
            GoRoute(
              path: 'keybinds',
              pageBuilder: (context, state) {
                return FadeTransitionPage(
                  key: state.pageKey,
                  child: const KeybindsSettingPage(),
                );
              },
            ),
            GoRoute(
              path: 'language',
              pageBuilder: (context, state) {
                return FadeTransitionPage(
                  key: state.pageKey,
                  child: const LanguageSettingPage(),
                );
              },
            ),
            GoRoute(
              path: 'ocr-engine-types',
              builder: (context, state) {
                return const OcrEngineTypesPage();
              },
            ),
            GoRoute(
              path: 'ocr-engines',
              pageBuilder: (context, state) {
                return FadeTransitionPage(
                  key: state.pageKey,
                  child: const OcrEnginesSettingPage(),
                );
              },
            ),
            GoRoute(
              path: 'ocr-engines/new',
              builder: (context, state) {
                final extra = state.extra as Map<String, dynamic>?;
                return OcrEnginesNewOrEditPage(
                  ocrEngineType: extra?['ocrEngineType'],
                );
              },
            ),
            GoRoute(
              path: 'ocr-engines/:id',
              builder: (context, state) {
                final extra = state.extra as Map<String, dynamic>?;
                return OcrEnginesNewOrEditPage(
                  ocrEngineConfig: extra?['ocrEngineConfig'],
                  editable: extra?['editable'],
                );
              },
            ),
            GoRoute(
              path: 'translation-engine-types',
              builder: (context, state) {
                return const TranslationEngineTypesPage();
              },
            ),
            GoRoute(
              path: 'translation-engines',
              pageBuilder: (context, state) {
                return FadeTransitionPage(
                  key: state.pageKey,
                  child: const TranslationEnginesSettingPage(),
                );
              },
            ),
            GoRoute(
              path: 'translation-engines/new',
              builder: (context, state) {
                final extra = state.extra as Map<String, dynamic>?;
                return TranslationEnginesNewOrEditPage(
                  engineType: extra?['engineType'],
                  editable: extra?['editable'],
                );
              },
            ),
            GoRoute(
              path: 'translation-engines/:id',
              builder: (context, state) {
                final extra = state.extra as Map<String, dynamic>?;
                return TranslationEnginesNewOrEditPage(
                  engineConfig: extra?['engineConfig'],
                  editable: extra?['editable'],
                );
              },
            ),
            GoRoute(
              path: 'translation-targets/new',
              builder: (context, state) {
                return const TranslationTargetNewOrEditPage();
              },
            ),
            GoRoute(
              path: 'translation-targets/:id',
              builder: (context, state) {
                final extra = state.extra as Map<String, dynamic>?;
                return TranslationTargetNewOrEditPage(
                  translationTarget: TranslationTarget(
                    id: extra?['id'],
                    sourceLanguage: extra?['sourceLanguage'],
                    targetLanguage: extra?['targetLanguage'],
                  ),
                );
              },
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/supported-languages',
      pageBuilder: (BuildContext context, GoRouterState state) {
        return DialogPage(
          barrierColor: ExtendedColors.black.withOpacity(0.5),
          builder: (_) => Center(
            child: Container(
              padding: const EdgeInsets.all(64),
              constraints: const BoxConstraints(maxWidth: 800, maxHeight: 600),
              child: Card(
                child: SupportedLanguagesPage(
                  selectedLanguage:
                      state.uri.queryParameters['selectedLanguage'],
                ),
              ),
            ),
          ),
        );
      },
    ),
  ],
);

/// A page that fades in an out.
class FadeTransitionPage extends CustomTransitionPage<void> {
  /// Creates a [FadeTransitionPage].
  FadeTransitionPage({
    required LocalKey super.key,
    required super.child,
  }) : super(
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              FadeTransition(
            opacity: animation.drive(_curveTween),
            child: child,
          ),
          transitionDuration: const Duration(milliseconds: 100),
          reverseTransitionDuration: const Duration(milliseconds: 100),
        );

  static final CurveTween _curveTween = CurveTween(curve: Curves.easeIn);
}
