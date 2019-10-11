import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter/material.dart';
import 'CustomShapeClipper.dart';

//Inherited widget
class Inherited extends InheritedWidget{
  final String toLocation,fromLocation;

  Inherited({this.toLocation,this.fromLocation,Widget child}): super(child : child);
  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static Inherited of(BuildContext context) =>
      context.inheritFromWidgetOfExactType(Inherited);

}

class FlightList extends StatelessWidget {

  //variables
  final Color discount = Color(0xFFFFE08D);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Color(0xFFEF772C),
        title: Text('Searched Result',),
        centerTitle: true,
        leading: InkWell(
          onTap: ((){
            Navigator.pop(context);
          }),
            child: Icon(Icons.arrow_back)),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: <Widget>[
            FlightListTop(),
            SizedBox(height: 10,),
            FlightBottomPart()
          ],
        ),
      ),
    );
  }
}


class FlightListTop extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ClipPath(
          clipper: CustomShapeClipper(),
          child: Container(
            height: 160,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  firstcolor,
                  secondcolor
                ]
              )
            ),
          ),
        ),

        Column(
          children: <Widget>[
            SizedBox(height: 20,),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              margin: EdgeInsets.symmetric(horizontal: 16),
              elevation: 10.0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16,vertical: 22),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      flex: 5,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("${Inherited.of(context).fromLocation}",style: TextStyle(color: Colors.black,fontSize: 18)),
                          Divider(height: 20,color: Colors.grey[400],),
                          Text("${Inherited.of(context).toLocation}",
                            style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.bold),)
                        ],
                      ),
                    ),
                    Spacer(),
                    Icon(Icons.import_export,color: Colors.black,size: 32,)
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

final Color border = Color(0xFFE6E6E6);

class FlightBottomPart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left:16.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Flight Deals",style: popupMenuItem),
              SizedBox(height: 20,),
              StreamBuilder(
                stream: Firestore.instance.collection('deals').snapshots(),
                builder: (context, snapshot) {
                  return !snapshot.hasData
                      ? Center(child: CircularProgressIndicator())
                      : _buildDealsList(context, snapshot.data.documents);
                },
              ),
              /*ListView(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                children: <Widget>[
                  FlightCard(),
                  FlightCard(),
                  FlightCard(),
                  FlightCard(),
                ],
              ),*/
            ],
          ),

    );
  }
}

Widget _buildDealsList(BuildContext context, List<DocumentSnapshot> snapshots) {

  return ListView.builder(
      shrinkWrap: true,
      itemCount: snapshots.length,
      physics: ClampingScrollPhysics(),
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) {
        return FlightCard(
            flightDetails: FlightDetails.fromSnapshot(snapshots[index]));
      });

}



class FlightDetails {

  final String airlines, date, discount, rating;
  final int oldPrice, newPrice;

  FlightDetails.fromMap(Map<String, dynamic> map)

      : assert(map['airlines'] != null),
        assert(map['date'] != null),
        assert(map['discount'] != null),
        assert(map['rating'] != null),
        airlines = map['airlines'],
        date = map['date'],
        discount = map['discount'],
        oldPrice = map['oldPrice'],
        newPrice = map['newPrice'],
        rating = map['rating'];

  FlightDetails.fromSnapshot(DocumentSnapshot snapshot)

      : this.fromMap(snapshot.data);

}


class FlightCard extends StatelessWidget {

  final FlightDetails flightDetails;
  FlightCard({this.flightDetails});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Stack(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              border: Border.all(color: border),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text("₹ ${flightDetails.newPrice}",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                      SizedBox(width: 20,),
                      Text("₹ ${flightDetails.oldPrice}",style: TextStyle(fontSize: 20,color: Colors.grey,fontWeight: FontWeight.normal,decoration: TextDecoration.lineThrough),),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Wrap(
                    spacing: 16.0,
                    runSpacing: -10,
                    children: <Widget>[
                      FlightChip(Icons.calendar_today,"${flightDetails.date}"),
                      FlightChip(Icons.flight_takeoff,"${flightDetails.airlines}"),
                      FlightChip(Icons.star,"${flightDetails.rating}"),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 0.0,
            top: 15.0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8,vertical: 4),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey),
                color: Colors.orange.withOpacity(0.3),
              ),
              child: Text("%${flightDetails.discount}",style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),

            ),
          ),
        ],
      ),
    );
  }
}


class FlightChip extends StatelessWidget {
  final Color chip = Color(0xFFF6F6F6);
  final IconData icon ;
  final String title;
  FlightChip(this.icon,this.title);
  @override
  Widget build(BuildContext context) {
    return RawChip(
      avatar: Icon(icon,size: 20,),
      label: Text(title),
      backgroundColor: Colors.grey[100],
      labelStyle: TextStyle(fontSize: 16,color: Colors.black),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );
  }
}
