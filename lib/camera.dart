import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
class Camera extends StatefulWidget {
  @override
  _CameraState createState() => _CameraState();
}

class _CameraState extends State<Camera> {


  Future _openCamera(BuildContext context) async{
    var picture = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      imageFile = picture;
    });
    Navigator.of(context).pop();
  }
  Future _openGallery(BuildContext context) async {
    var picture = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageFile = picture;
    });
    Navigator.of(context).pop();
  }
  File imageFile;

  Future<void> _showDialogBox(BuildContext context){
    return showDialog(context: context,builder: (BuildContext context){
      return AlertDialog(
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              GestureDetector(
                child: Text("Gallary"),
                onTap: (){
                  _openGallery(context);
                },
              ),
              Padding(padding: EdgeInsets.all(8.0),),
              GestureDetector(
                child: Text("Camera"),
                onTap: (){
                  _openCamera(context);
                },
              ),
            ],
          ),
        ),
      );
    });
}

  Widget decideImage(){
    if(imageFile == null){
      return CircleAvatar(
          backgroundImage: AssetImage('images/user.png',),
          backgroundColor: Colors.white,
          child: Stack(
            children: <Widget>[
              Container(
                color: Colors.white.withOpacity(0.3),
              ),
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.photo_camera,size: 27,color: Colors.black.withOpacity(0.7),),
                    SizedBox(width:7,),
                    Text("Add Photo",style: TextStyle(fontSize: 22,color: Colors.black.withOpacity(0.6)),),
                  ],
                ),
              )
            ],
          ),

      );
    }
    else{
      return Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Expanded(
            flex: 4,
            child: Container(
              height: 210,
              child: CircleAvatar(
                  backgroundImage: FileImage(imageFile),
              ),
            ),
          ),
          SizedBox(width: 10,),
          Expanded(
            flex: 1,
            child: InkWell(
                onTap: (){
                  _showDialogBox(context);
                },
                child: Icon(Icons.edit,size: 30,)
            ),
          )
        ],
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child : Container(
          height: 210,
          width: 210,
          child: imageFile == null ? InkWell(
              onTap:(){
                _showDialogBox(context);
              },
              child: decideImage()

          )
              : decideImage(),
        ),

      ),
    );
  }
}
