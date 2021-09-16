import 'package:click_down/Shared/shared.dart';
import 'package:flutter/material.dart';

class SwitchScreenBtn extends StatefulWidget {
  final String title;
  final IconData iconData;
  const SwitchScreenBtn({
    Key? key,
    required this.title,
    required this.iconData,
  }) : super(key: key);

  @override
  _SwitchScreenBtnState createState() => _SwitchScreenBtnState();
}

class _SwitchScreenBtnState extends State<SwitchScreenBtn> {
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
          Shared().currentScreen.value = widget.title;
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          color: color,
          child: Row(
            children: [
              Icon(widget.iconData, color: Color(Shared().iconsColor), size: 20),
              SizedBox(
                width: 10,
              ),
              Text(
                widget.title,
                style: TextStyle(fontSize: 13, color: Colors.white70),
              )
            ],
          ),
        ),
      ),
    );
  }
}
