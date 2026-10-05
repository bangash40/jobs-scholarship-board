import 'package:flutter/material.dart';

import '../l10n/l10n_helpers.dart';
import '../services/locale_controller.dart';
import '../theme/app_theme.dart';

/// Language switch, scam-safety tips and about.
class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key, required this.locale});

  final LocaleController locale;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final tips = [l.safetyTip1, l.safetyTip2, l.safetyTip3, l.safetyTip4];
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: AppColors.headerGradient,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 22),
                child: Text(
                  l.navMore,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.translate),
                    title: Text(l.moreLanguage),
                    trailing: FilledButton.tonal(
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(0, 38),
                      ),
                      onPressed: locale.toggle,
                      child: Text(l.languageToggle),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.shield_outlined,
                              color: AppColors.verified,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              l.moreSafetyTitle,
                              style: theme.textTheme.titleMedium,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        for (final tip in tips)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(top: 2),
                                  child: Icon(
                                    Icons.check_circle_outline,
                                    size: 18,
                                    color: AppColors.verified,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(child: Text(tip)),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l.moreAboutTitle,
                          style: theme.textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(l.moreAboutBody),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
