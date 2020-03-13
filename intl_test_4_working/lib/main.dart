import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'generated/l10n.dart';

void main() async {
  runApp(MyApp());
}

class LocaleNotifier extends ChangeNotifier {
  Locale locale = Locale('en', 'US');

  Locale get getlocale => locale;

  void changeLocale(Locale l) {
    locale = l;
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LocaleNotifier(),
      child: Consumer<LocaleNotifier>(
        builder: (context, notifier, child) {
          Locale locale = Provider.of<LocaleNotifier>(context).getlocale;
          return MaterialApp(
            home: HomePage(),
            onGenerateTitle: (context) => S.of(context).intlExperiments,
            locale: locale,
            localizationsDelegates: [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
            localeResolutionCallback: (deviceLocale, supportedLocales) {
              return locale ?? deviceLocale;
            },
          );
        },
      ),
    );
  }
}

class HomePage extends StatelessWidget {

  HomePage();

  @override
  Widget build(BuildContext context) {
    LocaleNotifier notifier = Provider.of<LocaleNotifier>(context);
    return Scaffold(
      appBar: AppBar(title: Text(S.of(context).home)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(S.of(context).chooseANewLanguage),
            SizedBox(height: 20),
            FlatButton(
              child: Text(S.of(context).pressForEngish),
              onPressed: () {
                notifier.changeLocale(Locale('en', 'US'));
              },
            ),
            FlatButton(
              child: Text(S.of(context).pressForGerman),
              onPressed: () {
                notifier.changeLocale(Locale('de', 'DE'));
              },
            )
          ],
        ),
      ),
    );
  }
}
