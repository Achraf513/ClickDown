import 'package:click_down/Shared/shared.dart';
import 'package:flutter/material.dart';

class ColorPickerWidget extends StatefulWidget {
  final String spaceName;
  const ColorPickerWidget({Key? key, required this.spaceName}) : super(key: key);

  @override
  _ColorPickerWidgetState createState() => _ColorPickerWidgetState();
}

class _ColorPickerWidgetState extends State<ColorPickerWidget> {
  List<int> colorPalette = [
    Colors.green.value,
    Colors.orange.value,
    Colors.deepOrange.value,
    Colors.red.value,
    Colors.redAccent.value,
    Colors.blue.value,
    Colors.blueAccent.value,
    Colors.blueGrey.value,
    Colors.purple.value,
    Colors.deepPurple.value,
    Colors.indigo[600]!.value,
  ];
  

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 25.0),
      child: Row(
        children: [
          SpaceColorPicker(spaceName : widget.spaceName),
          SizedBox(width: 15,),
          Container(
            width:MediaQuery.of(context).size.width/3,
            child: Wrap(
              children: colorPalette.map((colorInt){
                return ColorDotWidget(colorInt,);
              }).toList()
            ),
          ),
        ],
      ),
    );
  }
}


class ColorDotWidget extends StatefulWidget {
  late final Color clearerVersion;
  late final int colorInt;
  ColorDotWidget(int colorInt){
    this.colorInt = colorInt;
    this.clearerVersion = Color(colorInt).withAlpha(210);
  }

  @override
  _ColorDotWidgetState createState() => _ColorDotWidgetState();
}

class _ColorDotWidgetState extends State<ColorDotWidget> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    int colorInt = widget.colorInt;
    return MouseRegion(
      onEnter: (pointerEnterEvent){
        setState(() {
          isHovered = true;
        });
      },
      onExit: (pointerEnterEvent){
        setState(() {
          isHovered = false;
        });
      },
      child: GestureDetector(
        onTap: (){
          FocusScope.of(context).unfocus();
          setState(() {
            Shared().selectedColor.value = colorInt;
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: Colors.white
                ),
              ),
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: isHovered? widget.clearerVersion:Color(colorInt)
                ),
              ),
              ValueListenableBuilder(
                valueListenable: Shared().selectedColor,
                builder: (BuildContext context, int colorValue, Widget? widget){
                  if(colorValue==colorInt){
                    return Icon(Icons.done_rounded,size: 25,color: Colors.white,);
                  }else{
                    return SizedBox();
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
} 

class SpaceColorPicker extends StatefulWidget { 
  final String spaceName;
  SpaceColorPicker({ Key? key, required this.spaceName }) : super(key: key);

  @override
  _SpaceColorPickerState createState() => _SpaceColorPickerState();
}

class _SpaceColorPickerState extends State<SpaceColorPicker> {
  bool isHovered = false;
  @override
  Widget build(BuildContext context) {
    final String spaceName = widget.spaceName;
    return ValueListenableBuilder(
      valueListenable: Shared().selectedColor,
      builder: (BuildContext context, int colorValue, Widget? widget){
        return Padding(
          padding: const EdgeInsets.all(3.0),
          child: Container(
            width: 55,
            height: 55,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Color(colorValue)
            ),
            child: Center(
              child: Text(
                spaceName.isNotEmpty?spaceName[0].toUpperCase():"S",
                style: TextStyle(fontSize: 25,color: Colors.white,fontWeight: FontWeight.w700),
              ),
            ),
          ),
        );
      },
    );
    
  }
}