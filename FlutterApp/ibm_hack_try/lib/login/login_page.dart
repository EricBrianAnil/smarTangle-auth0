import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ibm_hack_try/Database/user_repository.dart';
import 'package:ibm_hack_try/Home/landingpage.dart';
import 'package:ibm_hack_try/Register/register_page.dart';
import 'package:ibm_hack_try/bloc_login/bloc/authentication_bloc.dart';
import 'package:ibm_hack_try/bloc_login/bloc/login_bloc.dart';
import 'package:ibm_hack_try/login/login_form.dart';

class Login extends StatelessWidget {
  final UserRepository userRepository;
  
  Login({Key key, @required this.userRepository})
      : assert(userRepository != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      backgroundColor: Color(0xff3B5EE6),
      body: BlocProvider(
        create: (context) {
          return LoginBloc(
            authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
            userRepository: userRepository,
          );
        },
        child: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              upperHalf(context),
              pageTitle(context),
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: LoginForm(),
              ),
            ]
          ),
        ),
      ),
      
      
      bottomNavigationBar: FlatButton(
        onPressed: (){
          Navigator.push(context,
            MaterialPageRoute(builder: (context) => HomePage())
        );},
        child: Text("SKIP LOGGING IN"),textColor: Colors.white,),
    );
  }

  Widget upperHalf(BuildContext context) {
    return Container(
      height: 200,
      color: Color(0xff3B5EE6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
          'images/logo_title.png',
          height: 65,
          width: 130,
          ),
        ],
      )
    );
  }
  
  Widget  pageTitle(BuildContext context) {
    return Container(
      height: 300,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          FlatButton(
            onPressed: (){
              Navigator.push(null,
                MaterialPageRoute(
                  builder: (context) => Login(userRepository: null,)));
            },
            child: Text("LOGIN", style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Montserrat', fontSize: 14),),
          ),
          Text(" | ", style: TextStyle(
            color: Colors.grey[700], fontWeight: FontWeight.bold, fontFamily: 'Montserrat', fontSize: 14),),
          FlatButton(
            onPressed: (){
              //Get.to(Register());
              Navigator.push(context,
                MaterialPageRoute(
                  builder: (context) => Register()));
            },
            child: Text("REGISTER", style: TextStyle(
              color: Colors.grey[700], fontWeight: FontWeight.bold, fontFamily: 'Montserrat', fontSize: 14),),
          )
        ],
      ), 
    );
  }

}

