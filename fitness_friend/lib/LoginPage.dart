import 'package:fitnessfriend/MyNavBar.dart';
import 'package:fitnessfriend/database_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'FoodLog.dart';
import 'Register.dart';
import 'database_helper.dart';

class LoginPage extends StatefulWidget {


  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  static var username;
  static var password;


  final usernameCon = new TextEditingController();
  final passwordCon = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 18.0),
          children: <Widget>[
            Column(children: <Widget>[
              SizedBox(
                height: 50,
              ),
              Image.asset(
                'assets/logo.png',
                width: 250,
                height: 250,
              ),
            ]),
            SizedBox(height: 60.0),
            TextField(
              decoration: InputDecoration(
                labelText: "Name",
                labelStyle: TextStyle(fontSize: 20),
                filled: true,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xff68D065)),
                ),
              ),
              controller: usernameCon,
            ),
            SizedBox(height: 20.0),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Password",
                labelStyle: TextStyle(fontSize: 20),
                filled: true,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xff68D065)),
                ),
              ),
              controller: passwordCon,
            ),
            SizedBox(
              height: 20,
            ),
            Column(
              children: <Widget>[
                ButtonTheme(
                  height: 50,
                  disabledColor: Color(0xff68D065),
                  child: RaisedButton(
                    disabledElevation: 4.0,
                    onPressed: () async {
                      setState(() {
                        username = usernameCon.text;
                        password = passwordCon.text;
                      });
                      int queryLogin = await DatabaseHelper.instance.checkLogin(username, password);
                      int uid = await DatabaseHelper.instance.getUserID(username);

                      if (queryLogin == 1) {
//                        var pref = await SharedPreferences.getInstance();
//                        pref.setInt('UID', uid);
//                        print("user id is $uid");
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) =>
                                MyNavBar(uid)));
                      }
                      else
                        wrongDetails(context);
                    },
                    child: Text('Login',
                        style: TextStyle(fontSize: 20, color: Colors.white)),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  child: Text(
                    'New User? register here',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Color(0xff68D065),
                    ),
                  ),
                  onTap: (){
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Register()));
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void wrongDetails(BuildContext context){

    var alertDialog = AlertDialog(
      title: Text("This account does not exist"),
      content: Text("please enter correct details or register an account"),
    );

    showDialog(
        context: context,
        builder: (BuildContext context) => alertDialog
    );
  }

}