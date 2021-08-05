import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class LanguagePanel extends StatelessWidget {
  const LanguagePanel({Key? key}) : super(key: key);

  void _setLanguage(BuildContext ctx, String? lang) async {
    if (lang != null) await ctx.setLocale(Locale(lang));
  }

  @override
  Widget build(BuildContext context) {
    final String? currentLanguage =
        EasyLocalization.of(context)?.currentLocale.toString().toLowerCase();
    return Column(
      children: [
        RadioListTile(
          title: Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: CircleAvatar(
                  radius: 15.0,
                  backgroundImage: AssetImage(
                    'assets/flags/az.png',
                  ),
                ),
              ),
              Text("Azərbaycanca",
                  style: Theme.of(context).textTheme.subtitle1),
            ],
          ),
          value: "az",
          groupValue: currentLanguage,
          onChanged: (lang) {
            _setLanguage(context, lang as String);
          },
        ),
        Divider(),
        RadioListTile(
          title: Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: CircleAvatar(
                  radius: 15.0,
                  backgroundImage: AssetImage(
                    'assets/flags/en.png',
                  ),
                ),
              ),
              Text("English", style: Theme.of(context).textTheme.subtitle1),
            ],
          ),
          value: "en",
          groupValue: currentLanguage,
          onChanged: (lang) {
            _setLanguage(context, lang as String);
          },
        ),
        Divider(),
        RadioListTile(
          title: Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: CircleAvatar(
                  radius: 15.0,
                  backgroundImage: AssetImage(
                    'assets/flags/ru.png',
                  ),
                ),
              ),
              Text("Русский", style: Theme.of(context).textTheme.subtitle1),
            ],
          ),
          value: "ru",
          groupValue: currentLanguage,
          onChanged: (lang) {
            _setLanguage(context, lang as String);
          },
        ),
        Divider(),
      ],
    );
  }
}
