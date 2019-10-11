import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/flightList.dart';
import 'package:flutter/material.dart';
import 'CustomShapeClipper.dart';
import 'custombar.dart';
import 'flightList.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'login.dart';
import 'camera.dart';

void main() => runApp(MaterialApp(
  title: 'Flight Booking',
  debugShowCheckedModeBanner: false,
  home: Login(),
  routes: {
    'home': (context) => Home(),
    'flightlist': (context) => FlightList(),
    'login' : (context) => Login(),
    'camera' : (context) => Camera()
  },
  theme: appTheme,

));

//Declared variables
bool isflightSelected = true;
ThemeData appTheme = ThemeData(fontFamily: 'Oxygen-Regular');
Color firstcolor = Color(0xFFF47D15);
Color secondcolor = Color(0xFFEF772C);
var selectedlocation = 0;

List<String> location = ['London (LON)','India (IND)','America (USA)'];


//declared properties
TextStyle popupMenu = TextStyle(color: Colors.white,fontSize: 16);
TextStyle popupMenuItem = TextStyle(color: Colors.black,fontSize: 18);
TextStyle screentext = TextStyle(color: Colors.white,fontSize: 32,);


class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomBar(),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: <Widget>[
            TopScreen(),
            BottomScreen('Recently Watched',10),
            BottomScreen('Popular Places',14),
          ],
        ),
      ),
    );
  }
}


class BottomScreen extends StatefulWidget {

  final String title;
  final int total;
  BottomScreen(this.title,this.total);

  @override
  _BottomScreenState createState() => _BottomScreenState();
}

class _BottomScreenState extends State<BottomScreen> {

  @override
  Widget build(BuildContext context) {
    return Container(

      child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18,vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    'View All (${widget.total})',
                    style: TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  )
                ],
              ),
            ),

            Container(
              height: 235,
              child: StreamBuilder(
                stream: Firestore.instance.collection('cities').snapshots(),
                builder: (context,snapshot){
                  return !snapshot.hasData
                      ? Center(child: CircularProgressIndicator())
                      : _buildCityList(context,snapshot.data.documents);
                },
              ),
              /*ListView(
                scrollDirection: Axis.horizontal,
                children: cards,
              ),*/

            ),

          ]
      ),

    );
  }
}

Widget _buildCityList(BuildContext context, List<DocumentSnapshot> snapshots) {

  return ListView.builder(
      itemCount: snapshots.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        return ItemCards(
            cityDetails : CityDetails.fromSnapshot(snapshots[index]));
      });

}

class CityDetails {

  final String cityName, monthYear, discount, imagePath;
  final int oldPrice, newPrice;

  CityDetails.fromMap(Map<String, dynamic> map)

      : assert(map['cityName'] != null),
        assert(map['discount'] != null),
        assert(map['imagePath'] != null),
        assert(map['monthYear'] != null),
        cityName = map['cityName'],
        monthYear = map['monthYear'],
        discount = map['discount'],
        oldPrice = map['oldPrice'],
        newPrice = map['newPrice'],
        imagePath = map['imagePath'];

  CityDetails.fromSnapshot(DocumentSnapshot snapshot)

      : this.fromMap(snapshot.data);

}

class ItemCards extends StatefulWidget {

  final CityDetails cityDetails;
  ItemCards({this.cityDetails});

  @override
  _ItemCardsState createState() => _ItemCardsState();
}

class _ItemCardsState extends State<ItemCards> {

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.all(
                Radius.circular(35)
            ),
            child: Stack(
              children: <Widget>[
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 8),
                    height: 200,
                    width: 160,
                    child: CachedNetworkImage(
                      imageUrl:'${widget.cityDetails.imagePath}',
                      fit: BoxFit.cover,
                      placeholder: (context,progressText) => Center(child: CircularProgressIndicator(),),
                      fadeInDuration: Duration(milliseconds: 500),
                      fadeInCurve: Curves.easeIn,
                      errorWidget: (context, progressText, error) => Icon(Icons.error),
                    )
                ),
                Positioned(
                  left:0.0,
                  bottom: 0.0,
                  height: 60,
                  width: 176,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black,
                              Colors.transparent
                            ]
                        )
                    ),
                  ),
                ),
                Positioned(
                  left: 15,
                  bottom: 10,
                  right:10,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '${widget.cityDetails.cityName}',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 5.0,),
                          Text(
                            '${widget.cityDetails.monthYear}',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.normal,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 2),
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.white,
                          ),
                          child: Text('${widget.cityDetails.discount}',style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[

                Text('₹ ${widget.cityDetails.newPrice}',style: TextStyle(fontSize: 20,color: Colors.black,fontWeight: FontWeight.bold,),),
                SizedBox(width: 10.0,),
                Text('₹ (${widget.cityDetails.oldPrice})',style: TextStyle(fontSize: 18,color: Colors.grey,fontWeight: FontWeight.normal),),
              ],
            ),
          )
        ],
      ),
    );
  }
}


class TopScreen extends StatefulWidget {
  @override
  _TopScreenState createState() => _TopScreenState();
}

class _TopScreenState extends State<TopScreen> {

  final _destionationTo = TextEditingController(text : location[1]);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ClipPath(
            clipper: CustomShapeClipper(),
            child:Container(
              height: 400.0,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: <Color>[firstcolor,secondcolor]
                  )
              ),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 50.0,),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: <Widget>[
                           Icon(
                          Icons.location_on,
                             size: 32,
                       color: Colors.white,
                    ),
                          SizedBox(width: 10,),
                          PopupMenuButton(
                              onSelected: ((index){
                              setState(() {
                                selectedlocation = index;
                            });
                      }),
                            child: Row(
                        children: <Widget>[
                              Text(location[selectedlocation],
                            style: popupMenu,
                          ),
                               Icon(Icons.keyboard_arrow_down,color: Colors.white,)
                        ],
                      ),
                      itemBuilder: (context) => <PopupMenuItem>[
                             PopupMenuItem(
                              child: Text(location[0],style: popupMenuItem,),
                          value: 0,
                        ),
                             PopupMenuItem(
                               child: Text(location[1],style: popupMenuItem,),
                          value: 1,
                        ),
                              PopupMenuItem(
                               child: Text(location[2],style: popupMenuItem),
                          value: 2,
                        ),
                      ],
                    ),
                         Spacer(),
                         InkWell(
                           onTap: ((){
                             Navigator.pushNamed(context, 'login');
                           }),
                             child: Icon(
                               Icons.settings,color: Colors.white,size: 30,
                             )
                         ),
                  ],
                ),
              ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text('Where  Would\nYou want to go?',
                      style: screentext,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32),
                    child: Material(
                      elevation: 5.0,
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.white,
                      child: TextField(
                        controller: _destionationTo,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 32,vertical: 13),
                          suffixIcon: Material(
                            borderRadius: BorderRadius.circular(50),
                            elevation: 4.0,
                            child: InkWell(
                                onTap: ((){
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Inherited(
                                            fromLocation: location[selectedlocation],
                                            toLocation:_destionationTo.text,
                                            child: FlightList(),
                                          )
                                      ));
                                }),
                                child: Icon(Icons.search,color: Colors.black,)
                            ),
                          ),
                        ),
                        style: TextStyle(fontSize: 16,),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32,vertical: 25.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        InkWell(
                          child: Choice(icon: Icons.flight_takeoff,title: 'Flights',isSelected: isflightSelected),
                          onTap: ((){
                            setState(() {
                              isflightSelected = !isflightSelected;
                            });
                          }),
                        ),
                        SizedBox(width: 30,),
                        InkWell(
                          child: Choice(icon: Icons.hotel,title: 'Hotels',isSelected: !isflightSelected),
                          onTap: ((){
                            setState(() {
                              isflightSelected = !isflightSelected;
                            });
                          }),
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
        ),
      ],
    );
  }
}



class Choice extends StatefulWidget {

  final IconData icon;
  final String title;
  final bool isSelected;

  Choice({this.icon, this.title,this.isSelected});

  @override
  _ChoiceState createState() => _ChoiceState();
}

class _ChoiceState extends State<Choice> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18,vertical: 8),
      decoration: widget.isSelected ? BoxDecoration(
        color: Colors.white.withOpacity(0.17),
        borderRadius: BorderRadius.circular(30),
      ):null,
      child: InkWell(
        child: Row(
          children: <Widget>[
            Icon(widget.icon,color: Colors.white,size: 20,),
            SizedBox(width: 10.0,),
            Text(
                widget.title,
                style:TextStyle(
                  color: Colors.white.withOpacity(0.75),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                )),
          ],
        ),
      ),
    );
  }
}


