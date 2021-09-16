
import 'package:click_down/Models/listModel.dart';
import 'package:click_down/Models/spaceModel.dart';
import 'package:click_down/Shared/shared.dart';
import 'package:flutter/material.dart';

class SpaceListWidget extends StatefulWidget {
  final ListModel list;
  final SpaceModel space;
  const SpaceListWidget({Key? key,required this.list,required this.space}) : super(key: key);

  @override
  _SpaceListWidgetState createState() => _SpaceListWidgetState();
}

class _SpaceListWidgetState extends State<SpaceListWidget> {
  Color color = Color(Shared().secondaryBackGround);
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (pointerEnterEvent) {
        setState(() {
          color = Colors.black26;
        });
      },
      onExit: (pointerEnterEvent) {
        setState(() {
          color = Color(Shared().secondaryBackGround);
        });
      },
      child: GestureDetector(
        onTap: (){
          FocusScope.of(context).unfocus();
          Shared().selectedList.value = widget.list;
          Shared().selectedSpace = widget.space;
          Shared().currentScreen.value = "ListDetails";
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20,vertical: 7),
          color: color,
          child: Row(
            children: [
              Container(
                child: Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    Icon(
                      Icons.adjust,
                      size: 15,
                      color: Color(Shared().iconsColor),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(widget.list.listName,
                        style: TextStyle(
                            fontWeight: FontWeight.w100,
                            fontSize: 13,
                            color: Colors.white70)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
