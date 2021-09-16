import 'package:click_down/Shared/firebaseDB.dart';
import 'package:click_down/Shared/shared.dart';
import 'package:click_down/mainScreens/listDetails.dart';
import 'package:click_down/mainScreens/widgetTree.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async{
  await Firebase.initializeApp();
  Shared().spaceList.value = await FirebaseDB().getSpaces("UserIdHere");
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData( 
        fontFamily: GoogleFonts.montserrat().fontFamily,
        primaryColor: Color(Shared().primaryBackGround),
        cardColor: Color(Shared().secondaryBackGround),
        backgroundColor: Color(Shared().secondaryBackGround),
        splashColor: Color(Shared().iconsColor),
      ),
      home: WidgetTree(),
    );
  }
}
