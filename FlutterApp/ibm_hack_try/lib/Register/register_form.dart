import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ibm_hack_try/Database/user_repository.dart';
import 'package:ibm_hack_try/login/login_page.dart';
import 'package:ibm_hack_try/models/user_signup.dart';


class RegisterForm extends StatefulWidget {
  final Future<NewUser> add;
  RegisterForm({Key key, this.add}) : super(key: key);
  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  double screenHeight;
  final userRepository = UserRepository();
  final _usernameController = TextEditingController();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();

  
  static final BASE_URL = 'http://ec2-52-91-123-133.compute-1.amazonaws.com';
  

  Future<NewUser> createPost(String url, {Map body}) async {
  return http.post(url, body: body).then((http.Response response) {
    print("Function");
    final int statusCode = response.statusCode;

    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw new Exception("Error while fetching data");
    }
    return NewUser.fromJson(json.decode(response.body));
  });
}

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    return Container(
      margin: EdgeInsets.only(top: screenHeight / 3 -100),
      padding: EdgeInsets.only(left: 10, right: 10),
      color: Colors.white,
      alignment: Alignment.topCenter,
      child: Form(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Username", 
                style: TextStyle(color: Color(0xff3B5EE6),fontWeight: FontWeight.bold, fontFamily: 'Montserrat', fontSize: 10),),
              TextFormField(
                decoration: InputDecoration(
                fillColor: Colors.grey[300],
                filled: true,
                labelText: 'username', prefixIcon: Icon(Icons.person, color: Color(0xff3B5EE6)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0)))),
                controller: _usernameController,
             ),
              SizedBox(height: 10),
              Text("Name", 
                style: TextStyle(color: Color(0xff3B5EE6),fontWeight: FontWeight.bold, fontFamily: 'Montserrat', fontSize: 10),),
              TextFormField(
                decoration: InputDecoration(
                  fillColor: Colors.grey[300],
                  filled: true,
                  labelText: 'name', prefixIcon: Icon(Icons.person, color: Color(0xff3B5EE6)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25.0)))),
                controller: _nameController,
              ),
              SizedBox(height: 10),
              Text("Password", 
                style: TextStyle(color: Color(0xff3B5EE6),fontWeight: FontWeight.bold, fontFamily: 'Montserrat', fontSize: 10),),
              TextFormField(
                decoration: InputDecoration(
                fillColor: Colors.grey[300],
                filled: true,
                labelText: 'password', prefixIcon: Icon(Icons.security, color: Color(0xff3B5EE6)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0)))),
                controller: _passwordController,
                obscureText: true,
              ),
              SizedBox(height: 10),
              Text("Confirm Password", 
                style: TextStyle(color: Color(0xff3B5EE6),fontWeight: FontWeight.bold, fontFamily: 'Montserrat', fontSize: 10),),
              TextFormField(
                decoration: InputDecoration(
                fillColor: Colors.grey[300],
                filled: true,
                labelText: 'password', prefixIcon: Icon(Icons.security, color: Color(0xff3B5EE6)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0)))),
                obscureText: true,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.85,
                height: MediaQuery.of(context).size.width * 0.22,
                child: Padding(
                  padding: EdgeInsets.only(top: 30.0),
                  child: RaisedButton(
                    color: Color(0xff3B5EE6),
                    onPressed: () async{
                      print("mapping");
                      NewUser newPost = NewUser(
                        user: _usernameController.text, 
                        name: _nameController.text, 
                        psswd: _passwordController.text
                      );
                      NewUser p = await createPost(BASE_URL,body: newPost.toMap());
                      print(p.user);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>  Login(userRepository: userRepository,),
                      ));
                    },
                    child: Text(
                      'SIGN UP',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.white
                        ),
                    ),
                    shape: StadiumBorder(
                      side: BorderSide(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
