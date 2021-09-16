import 'package:click_down/Models/listModel.dart';
import 'package:click_down/Models/spaceModel.dart';
import 'package:click_down/Shared/shared.dart';
import 'package:click_down/mainScreens/homeScreen.dart';
import 'package:click_down/mainScreens/listDetails.dart';
import 'package:click_down/mainScreens/profileScreen.dart';
import 'package:click_down/mainScreens/settingsScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class MoreDetailsWrapper extends StatefulWidget {
  const MoreDetailsWrapper({Key? key}) : super(key: key);

  @override
  _MoreDetailsWrapperState createState() => _MoreDetailsWrapperState();
}

class _MoreDetailsWrapperState extends State<MoreDetailsWrapper> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          color: Color(Shared().primaryBackGround),
          height: MediaQuery.of(context).size.height,
          child: ValueListenableBuilder<String>(
              valueListenable: Shared().currentScreen,
              builder: (BuildContext context, String currentScreen,
                  Widget? child) {
                switch (currentScreen) {
                  case "Home":
                    return HomeScreen();
                  case "Profile":
                    return ProfileScreen();
                  case "Settings":
                    return SettingsScreen();
                  case "ListDetails":
                    return ListDetailsScreen();
                }
                return SizedBox();
              }),
        )
      ],
    );
  }
}
