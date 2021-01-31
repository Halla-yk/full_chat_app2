import 'package:flutter/material.dart';

Widget mainAppBar(BuildContext context, String title,){

  return AppBar(
    title: Text(title),
    backgroundColor: Color(0xff222831),
  );

}
InputDecoration textFieldDecoration(String title){

  return  InputDecoration(
        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white54)),
        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        hintText: title,
        hintStyle: TextStyle(color: Colors.white54));

}
Widget customButton(String text,BuildContext context,Color colors){
  return  Container(

    alignment: Alignment.center,
    width: MediaQuery.of(context).size.width,
    padding: EdgeInsets.symmetric(vertical: 20),
    child: Text(text,style: TextStyle(color: Colors.white),),
    decoration: BoxDecoration(
      color: colors,
        borderRadius: BorderRadius.circular(50),
       ),
  );
}