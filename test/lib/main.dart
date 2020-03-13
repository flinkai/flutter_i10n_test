import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:provider/provider.dart';

Mockup mockup;

void main() {
  mockup = Mockup();
  runApp(MyApp());
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
      appBar: AppBar(title: Text('App')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text('Loading'),
          ],
        ),
      ),
    );
  }

  Widget signup(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Signup')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Signup'),
            SizedBox(height: 20),
            FlatButton(
              child: Text('Press to sign up'),
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
      appBar: AppBar(title: Text('Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Home'),
            SizedBox(height: 20),
            FlatButton(
              child: Text('Press for Engish'),
              onPressed: () {
                Future.delayed(Duration(seconds: 1), () => mockup.lang.add(Locale('en')));
              },
            ),
            FlatButton(
              child: Text('Press for German'),
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
            onGenerateTitle: (context) => 'Title',
          );
        },
      ),
    );
  }
}


