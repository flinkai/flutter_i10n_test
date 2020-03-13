import 'package:flutter/material.dart';
import 'package:intl/intl_standalone.dart';
import 'package:provider/provider.dart';

import 'generated/l10n.dart';

void main() async {
  runApp(MyApp());
}

class LocaleNotifier extends ChangeNotifier {
  Locale locale = Locale('en');
  Locale get getlocale => locale;
  void changeLocale(Locale l) {
    locale = l;
    notifyListeners();
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  // problem, should be a widget by itself out of here not with function created??
  Widget homeWithNotifier(BuildContext context) {
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
                Provider.of<LocaleNotifier>(context).changeLocale(Locale('en', 'US'));
              },
            ),
            FlatButton(
              child: Text(S.of(context).pressForGerman),
              onPressed: () {
                Provider.of<LocaleNotifier>(context).changeLocale(Locale('de', 'DE'));
              },
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LocaleNotifier(),
      child: Consumer<LocaleNotifier>(
        builder: (context, notifier, child) {
          Locale locale = Provider.of<LocaleNotifier>(context).getlocale;
          return MaterialApp(
            home: homeWithNotifier(context),
            onGenerateTitle: (context) => S.of(context).intlExperiments,
            locale: locale ?? Locale('en', 'US'),
            localizationsDelegates: [S.delegate],
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


