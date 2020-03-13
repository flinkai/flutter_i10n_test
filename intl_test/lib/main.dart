import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl_standalone.dart';

import 'generated/l10n.dart';

Mockup mockup;
Locale initialDeviceLocale;

void main() async {
  String systemLocaleString = await findSystemLocale();
  initialDeviceLocale = parseLocale(systemLocaleString);
  print('=====> device locale string $systemLocaleString, parsed locale ${initialDeviceLocale.toString()}');
  mockup = Mockup();
  runApp(MyApp());
}

Locale parseLocale(String locale) {
  var tokens = locale.split("_");
  if (tokens.length == 1)
    return Locale(tokens[0]);
  if (tokens.length == 2)
    return Locale(tokens[0], tokens[1]);
  if (tokens.length == 3)
    return Locale.fromSubtags(languageCode: tokens[0], scriptCode: tokens[1], countryCode: tokens[2]);
  return null;
}

class User{
  final String name;
  final int status;
  User(this.name, this.status);
}

class Mockup {
  Mockup();
  BehaviorSubject<User> auth = BehaviorSubject<User>.seeded(User(null, -1));
  BehaviorSubject<Locale> lang = BehaviorSubject<Locale>.seeded(Locale('en', 'US'));
}

class MyApp extends StatelessWidget {

  Widget loading(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(S.of(context).loadingUser)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text(S.of(context).loading),
          ],
        ),
      ),
    );
  }

  Widget signup(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(S.of(context).signup)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(S.of(context).signup),
            SizedBox(height: 20),
            FlatButton(
              child: Text(S.of(context).pressToSignUp),
              onPressed: () {
                Future.delayed(Duration(seconds: 1), () => mockup.auth.add(User(null, 0)));
                Future.delayed(Duration(seconds: 10), () => mockup.auth.add(User('tim', 1)));
              },
            )
          ],
        ),
      ),
    );
  }

  Widget home(BuildContext context) {
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
                Future.delayed(Duration(seconds: 1), () => mockup.lang.add(Locale('en')));
              },
            ),
            FlatButton(
              child: Text(S.of(context).pressForGerman),
              onPressed: () {
                Future.delayed(Duration(seconds: 1), () => mockup.lang.add(Locale('de')));
              },
            )
          ],
        ),
      ),
    );
  }

  Widget buildAppHomeWidget(BuildContext context, User user) {
    if (user?.status == 0) {
      return loading(context);
    } else if (user?.name == null) {
      return signup(context);
    } else {
      return home(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider.value(value: mockup.auth.stream),
        StreamProvider.value(value: mockup.lang.stream)
      ],
      child: Consumer2<User, Locale>(
        builder: (context, user, locale, child) {
          print('${user?.name}, ${user?.status}, ${locale.toString()}');

          return MaterialApp(
            home: buildAppHomeWidget(context, user),
            onGenerateTitle: (context) => S.of(context).intlExperiments,
            locale: locale ?? Locale('en'),
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


