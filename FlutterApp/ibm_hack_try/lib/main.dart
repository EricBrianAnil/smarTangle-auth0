/*import 'package:flutter/material.dart';
import 'package:ibm_hack_try/Home/landingpage.dart';
import 'package:ibm_hack_try/QR/QRPage.dart';
import 'package:ibm_hack_try/Register/register.dart';
import 'package:ibm_hack_try/Utility/utilitypage.dart';
import 'package:ibm_hack_try/login/login.dart';
import 'dart:async';

void main() => runApp(MyApp());

final routes = {
  '/login': (BuildContext context) => LoginPage(),
  '/home': (BuildContext context) => HomePage(),
  '/register': (BuildContext context) => RegisterPage(),
  '/qrpage': (BuildContext context) => QRPage(),
  '/utility': (BuildContext context) => UtilityPage(),
};

class MyApp extends StatelessWidget {
 
 @override
 Widget build(BuildContext context){
   return new MaterialApp(
     title: 'SmarTangle App',
     theme: new ThemeData(primarySwatch: Colors.teal),
     routes: routes,
     home: FirstPage(),
   );
 }
}

class FirstPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    Timer(
        Duration(seconds: 3),
            () =>
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => LoginPage())));
    return Scaffold (
      body: Center(
        child: Image.asset('images/1- Splash Screen.png',fit: BoxFit.fill, height: double.infinity, width:double.infinity)
      ) ,
    );
  }
}*/
import 'dart:async';

import 'package:flutter/material.dart';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ibm_hack_try/Database/user_repository.dart';
import 'package:ibm_hack_try/Home/landingpage.dart';
import 'package:ibm_hack_try/bloc_login/bloc/authentication_bloc.dart';
import 'package:ibm_hack_try/login/login_page.dart';
import 'package:ibm_hack_try/splash.dart';


class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onEvent(Bloc bloc, Object event) {
    super.onEvent(bloc, event);
    print(event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }

  @override
  void onError(Bloc bloc, Object error, StackTrace stacktrace) {
    super.onError(bloc, error, stacktrace);
  }
}

void main() {
  BlocSupervisor.delegate = SimpleBlocDelegate();
  final userRepository = UserRepository();

  runApp(BlocProvider<AuthenticationBloc>(
    create: (context) {
      return AuthenticationBloc(userRepository: userRepository)
        ..add(AppStarted());
    },
    child: App(userRepository: userRepository),
  ));
}

class App extends StatelessWidget {
  final UserRepository userRepository;

  App({Key key, @required this.userRepository}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmarTangle App',
      theme: new ThemeData(primarySwatch: Colors.teal),
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        // ignore: missing_return
        builder: (context, state) {
          if (state is AuthenticationUnintialized) {
            return SplashScreen();
          }
          if (state is AuthenticationAuthenticated) {
            return HomePage();
          }
          if (state is AuthenticationUnauthenticated) {
            return Login(
              userRepository: userRepository,
            );
          }
        },
      ),
    );
  }
}
class FirstPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    Timer(
        Duration(seconds: 3),
            () =>
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => Login(userRepository: null,))));
    return Scaffold (
      body: Center(
        child: Image.asset('images/1- Splash Screen.png',fit: BoxFit.fill, height: double.infinity, width:double.infinity)
      ) ,
    );
  }
}