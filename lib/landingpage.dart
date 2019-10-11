import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
              Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    height: 60,
                    width: 60,
                    margin: EdgeInsets.only(right: 160),
                    decoration: new BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.amberAccent,
                    ),
                    child: Icon(Icons.home),
                  ),
                  Container(
                    alignment: Alignment.center,
                    height: 60,
                    width: 60,
                    margin: EdgeInsets.only(right:75),
                    decoration: new BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.redAccent,
                    ),
                    child: Icon(Icons.card_travel),
                  ),
                  Container(
                    alignment: Alignment.center,
                    height: 60,
                    width: 60,
                    margin: EdgeInsets.only(left:15),
                    decoration: new BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.greenAccent,
                    ),
                    child: Icon(Icons.card_travel),
                  ),
                  Container(
                    alignment: Alignment.center,
                    height: 60,
                    width: 60,
                    margin: EdgeInsets.only(left:100),
                    decoration: new BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.blueAccent,
                    ),
                    child: Icon(Icons.card_travel),
                  ),
                ],
              ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    "Fassos",
                    style: TextStyle(
                      fontSize: 40,
                      fontFamily: 'Nunito-Regular',
                    ),
                  ),
                ),
                Container(
                  height: 70,
                  width: 400,
                  margin: EdgeInsets.symmetric(horizontal: 25),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.greenAccent,
                  ),
                  child: Center(
                    child: Text("Sign in with Facebook",
                      style: TextStyle(color: Colors.white,fontSize: 25),),
                  ),
                ),
                SizedBox(height: 40,),
                Container(
                  height: 70,
                  width: 400,
                  margin: EdgeInsets.symmetric(horizontal: 25),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.greenAccent,
                  ),
                  child: Center(
                    child: Text("Sign in with Gmail",
                      style: TextStyle(color: Colors.white,fontSize: 25),),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
