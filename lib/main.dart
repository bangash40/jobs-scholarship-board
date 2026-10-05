import 'package:flutter/material.dart';

import 'screens/home_shell.dart';
import 'services/feed_repository.dart';
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
  runApp(MainApp(repository: repository, saved: saved));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key, required this.repository, required this.saved});

  final FeedRepository repository;
  final SavedController saved;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jobs & Scholarships',
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      home: HomeShell(repository: repository, saved: saved),
    );
  }
}
