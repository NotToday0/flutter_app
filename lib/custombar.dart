import 'package:flutter/material.dart';

class CustomBar extends StatelessWidget {

  final TextStyle navigationItem = TextStyle(fontStyle: FontStyle.normal,fontWeight: FontWeight.bold,color: Colors.black);
  final List<BottomNavigationBarItem> bottomNavigationItem = [];

  //Constructor
  CustomBar(){
    bottomNavigationItem.add(
      BottomNavigationBarItem(
        icon: Icon(Icons.home,color: Colors.black,),
        title: Text("Home",style: navigationItem,)
      ),
    );
    bottomNavigationItem.add(
      BottomNavigationBarItem(
          icon: Icon(Icons.favorite,color: Colors.black,),
          title: Text("Watch List",style: navigationItem)
      ),

    );
    bottomNavigationItem.add(
      BottomNavigationBarItem(
          icon: Icon(Icons.local_offer,color: Colors.black,),
          title: Text("Deals",style: navigationItem)
      ),

    );
    bottomNavigationItem.add(
      BottomNavigationBarItem(
          icon: Icon(Icons.notifications,color: Colors.black,),
          title: Text("Notification",style: navigationItem)
      ),

    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 10.0,
      child: BottomNavigationBar(
        items: bottomNavigationItem,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
