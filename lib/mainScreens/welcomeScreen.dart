import 'package:click_down/Models/spaceModel.dart';
import 'package:click_down/customWidgets/welcomeScreenWidgets/newSpaceBtn.dart';
import 'package:click_down/customWidgets/welcomeScreenWidgets/spaceWidget.dart';
import 'package:click_down/customWidgets/welcomeScreenWidgets/switchScreenBtn.dart';
import 'package:click_down/Shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  void initState(){
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Color(Shared().secondaryBackGround),
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 10,
                    child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        height: 35,
                        child: SvgPicture.asset(
                          "assets/clickDownLogo.svg",
                          alignment: Alignment.centerLeft,
                        )),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SwitchScreenBtn(title: "Home", iconData: Icons.home_outlined),
                  SizedBox(
                    height: 5,
                  ),
                  SwitchScreenBtn(
                      title: "Profile", iconData: Icons.person_outlined),
                  SizedBox(
                    height: 5,
                  ),
                  SwitchScreenBtn(
                      title: "Settings", iconData: Icons.settings_outlined),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20.0),
                    color: Colors.black87,
                    height: 0.25,
                    width: double.infinity,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text("Work space",
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Colors.white)),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  NewSpaceBtn(),
                  SizedBox(
                    height: 15,
                  ),
                  ValueListenableBuilder<List<SpaceModel>>(
                  valueListenable: Shared().spaceList,
                  builder: (BuildContext context, List<SpaceModel> spaceList, Widget? child) {
                    spaceList.sort((a,b)=>a.timeStamp.compareTo(b.timeStamp));
                    return Column(
                      children: [
                        Container(
                          height: 300,
                          child: ListView( children: spaceList.map((space){
                                return SpaceWidget(spaceModel: space);
                              }).toList()
                            ),
                        ),
                      ],
                    );
                  }
                ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}


