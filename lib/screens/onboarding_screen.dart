import 'package:flutter/material.dart';

import '../l10n/l10n_helpers.dart';
import '../models/listing.dart';
import '../services/preferences_controller.dart';
import '../theme/app_theme.dart';

/// Optional interests setup. Shown once at first launch, and again from
/// More > My interests (then [editing] is true and it closes when done).
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({
    super.key,
    required this.prefs,
    this.editing = false,
  });

  final PreferencesController prefs;
  final bool editing;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late final Set<String> _types = {...widget.prefs.types};
  late String? _city = widget.prefs.city;
  late String? _education = widget.prefs.education;

  Future<void> _finish({required bool skip}) async {
    await widget.prefs.save(
      types: skip ? const {} : _types,
      city: skip ? null : _city,
      education: skip ? null : _education,
    );
    if (widget.editing && mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
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
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.editing)
                      const BackButton(color: Colors.white)
                    else
                      const Icon(
                        Icons.verified_user,
                        color: AppColors.accent,
                        size: 36,
                      ),
                    const SizedBox(height: 12),
                    Text(
                      l.onboardTitle,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      l.onboardSubtitle,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Text(l.onboardTypes, style: theme.textTheme.titleMedium),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    for (final t in ListingType.values)
                      FilterChip(
                        avatar: Icon(
                          t.icon,
                          size: 16,
                          color: _types.contains(t.key) ? Colors.white : t.color,
                        ),
                        label: Text(t.label(l)),
                        labelStyle: TextStyle(
                          color: _types.contains(t.key) ? Colors.white : null,
                          fontWeight: FontWeight.w600,
                        ),
                        selected: _types.contains(t.key),
                        selectedColor: t.color,
                        onSelected: (on) => setState(
                          () => on ? _types.add(t.key) : _types.remove(t.key),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(l.onboardCity, style: theme.textTheme.titleMedium),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    for (final c in PreferencesController.cities)
                      ChoiceChip(
                        label: Text(c),
                        selected: _city == c,
                        onSelected: (on) =>
                            setState(() => _city = on ? c : null),
                      ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(l.onboardEducation, style: theme.textTheme.titleMedium),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    for (final e in PreferencesController.educationLevels)
                      ChoiceChip(
                        label: Text(educationLabel(l, e)),
                        selected: _education == e,
                        onSelected: (on) =>
                            setState(() => _education = on ? e : null),
                      ),
                  ],
                ),
              ],
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FilledButton(
                    onPressed: () => _finish(skip: false),
                    child: Text(l.onboardContinue),
                  ),
                  if (!widget.editing)
                    TextButton(
                      onPressed: () => _finish(skip: true),
                      child: Text(l.onboardSkip),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
