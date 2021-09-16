
import 'package:click_down/Models/spaceModel.dart';
import 'package:click_down/customWidgets/welcomeScreenWidgets/spaceListWidget.dart';
import 'package:click_down/customWidgets/welcomeScreenWidgets/spaceTitleWidget.dart';
import 'package:click_down/Shared/shared.dart';
import 'package:flutter/material.dart';

class SpaceWidget extends StatefulWidget {
  final SpaceModel spaceModel;
  const SpaceWidget({Key? key, required this.spaceModel}) : super(key: key);

  @override
  _SpaceWidgetState createState() => _SpaceWidgetState();
}

class _SpaceWidgetState extends State<SpaceWidget> {
  Color color = Color(Shared().secondaryBackGround);
  bool expanded = false;
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      GestureDetector(onTap: (){
        FocusScope.of(context).unfocus();
        setState(() {
          expanded = !expanded;
        });
      },child: SpaceTitleWidget(spaceModel: widget.spaceModel, expanded: expanded)),
      expanded?Column(
        children: widget.spaceModel.spaceLists.map((e) => SpaceListWidget(list : e, space:widget.spaceModel)).toList()
      ):SizedBox()
    ],);
  }
}
