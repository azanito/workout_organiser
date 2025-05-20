import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'settings_model.dart';
import 'l10n/s.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final sm = context.watch<SettingsModel>();

    return Scaffold(
      appBar: AppBar(title: Text(S.of(context)!.settings)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ----------  Theme  ----------
            _title(context, S.of(context)!.theme),
            _themeTile(context, sm, ThemeMode.system, S.of(context)!.system),
            _themeTile(context, sm, ThemeMode.light,  S.of(context)!.light),
            _themeTile(context, sm, ThemeMode.dark,   S.of(context)!.dark),

            const SizedBox(height: 32),

            /// ----------  Language  ----------
            _title(context, S.of(context)!.language),
            _langTile(context, sm, null,               S.of(context)!.system),
            _langTile(context, sm, const Locale('en'), 'English'),
            _langTile(context, sm, const Locale('ru'), 'Русский'),
            _langTile(context, sm, const Locale('kk'), 'Қазақша'),
          ],
        ),
      ),
    );
  }

  Widget _title(BuildContext c, String t) =>
      Text(t, style: Theme.of(c).textTheme.titleLarge);

  RadioListTile<ThemeMode> _themeTile(
    BuildContext ctx,
    SettingsModel sm,
    ThemeMode mode,
    String label,
  ) =>
      RadioListTile<ThemeMode>(
        title: Text(label),
        value: mode,
        groupValue: sm.themeMode,
        onChanged: (m) => sm.updateThemeMode(m!),
      );

  RadioListTile<Locale?> _langTile(
    BuildContext ctx,
    SettingsModel sm,
    Locale? loc,
    String label,
  ) =>
      RadioListTile<Locale?>(
        title: Text(label),
        value: loc,
        groupValue: sm.locale,
        onChanged: (l) => sm.updateLocale(l),
      );
}
