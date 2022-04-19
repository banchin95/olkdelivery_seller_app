import 'package:flutter/material.dart';
import 'package:olkdelivery_sellers_app/authentication/login.dart';
import 'package:olkdelivery_sellers_app/authentication/register.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
          ),
          automaticallyImplyLeading: false,
          title: RichText(
            text: const TextSpan(
              style: TextStyle(
                fontSize: 25,
                fontFamily: "Righteous",
                letterSpacing: 3,
                fontWeight: FontWeight.bold,
              ),
              children: <TextSpan> [
                TextSpan(text: "OLK", style: TextStyle(color: Colors.black),),
                TextSpan(text: "DELIVERY", style: TextStyle(color: Colors.orangeAccent),),
              ],
            ),
          ),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.lock, color: Colors.blueGrey,),
                child: Text(
                  "Войти",
                  style: TextStyle(
                    color: Colors.blueGrey,
                  ),
                ),
              ),
              Tab(
                icon: Icon(Icons.person, color: Colors.blueGrey,),
                child: Text(
                  "Регистрация",
                  style: TextStyle(
                    color: Colors.blueGrey,
                  ),
                ),
              ),
            ],
            indicatorColor: Colors.orangeAccent,
            indicatorWeight: 4,
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Colors.blueGrey,
                Colors.orangeAccent,
              ],
            ),
          ),
          child: const TabBarView(
            children: [
              LoginScreen(),
              RegisterScreen(),
            ],
          ),
        ),
      ),
    );
  }
}
