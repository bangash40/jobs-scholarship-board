import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'l10n/app_localizations.dart';
import 'screens/home_shell.dart';
import 'services/feed_repository.dart';
import 'services/locale_controller.dart';
import 'services/reminder_service.dart';
import 'services/saved_controller.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final repository = FeedRepository();
  await repository.init();
  final reminders = ReminderService();
  await reminders.init();
  final saved = SavedController(reminders);
  await saved.init();
  final locale = LocaleController(reminders);
  await locale.init();
  runApp(MainApp(repository: repository, saved: saved, locale: locale));
}

class MainApp extends StatelessWidget {
  const MainApp({
    super.key,
    required this.repository,
    required this.saved,
    required this.locale,
  });

  final FeedRepository repository;
  final SavedController saved;
  final LocaleController locale;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: locale,
      builder: (_, _) => MaterialApp(
        onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
        locale: locale.locale,
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        home: HomeShell(repository: repository, saved: saved, locale: locale),
      ),
    );
  }
}
