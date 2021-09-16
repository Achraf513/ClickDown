import 'package:click_down/mainScreens/customizeTask.dart';
import 'package:click_down/mainScreens/moreDetailsWrapper.dart';
import 'package:click_down/mainScreens/responsiveLayout.dart';
import 'package:click_down/mainScreens/welcomeScreen.dart';
import 'package:flutter/material.dart';

class WidgetTree extends StatelessWidget {
  const WidgetTree({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
          smartphone: WelcomeScreen(),
          desktop: Container(
            width: double.infinity,
            child: Row(
              children: [
                Expanded(
                    flex: MediaQuery.of(context).size.width > 900
                        ? MediaQuery.of(context).size.width > 1100
                            ? 2
                            : 3
                        : 4,
                    child: WelcomeScreen()),
                Expanded(
                    flex: MediaQuery.of(context).size.width > 900
                        ? MediaQuery.of(context).size.width > 1100
                            ? 8
                            : 7
                        : 6,
                    child: MoreDetailsWrapper()),
              ],
            ),
          )),
    ); 
  }
}
