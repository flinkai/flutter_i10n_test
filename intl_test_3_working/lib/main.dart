import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

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

  Locale currentLocale = Locale('en', 'US');

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(onLocaleChange),
      onGenerateTitle: (context) => S.of(context).intlExperiments,
      locale: currentLocale,
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,],
      supportedLocales: S.delegate.supportedLocales,
      localeResolutionCallback: (deviceLocale, supportedLocales) {
        return currentLocale  ?? deviceLocale;
      },
    );
  }

  void onLocaleChange(Locale l) {
    setState(() {
      currentLocale = l;
    });
  }
}

typedef void OnLocaleChange(Locale l);

class HomePage extends StatelessWidget {
  final OnLocaleChange onLocaleChange;

  HomePage(this.onLocaleChange);

  @override
  Widget build(BuildContext context) {
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
                onLocaleChange(Locale('en', 'US'));
              },
            ),
            FlatButton(
              child: Text(S.of(context).pressForGerman),
              onPressed: () {
                onLocaleChange(Locale('de', 'DE'));
              },
            )
          ],
        ),
      ),
    );;
  }
}
