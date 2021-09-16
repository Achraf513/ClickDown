import 'package:click_down/Models/spaceModel.dart';
import 'package:click_down/Shared/firebaseDB.dart';
import 'package:click_down/Shared/shared.dart';
import 'package:click_down/customWidgets/ColorPicker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class NewSpaceBtn extends StatefulWidget {
  const NewSpaceBtn({Key? key}) : super(key: key);

  @override
  _NewSpaceBtnState createState() => _NewSpaceBtnState();
}

class _NewSpaceBtnState extends State<NewSpaceBtn> {
  Color color = Color(Shared().secondaryLighterBackGround);

  bool alreadyExist(String spaceName){
    for (SpaceModel space in Shared().spaceList.value) {
      if(spaceName == space.spaceName){
        return true;
      }
    }
    return false;
  }
  Future<void> _showCreateNewSpaceModel() async {
    final _formKey = GlobalKey<FormState>();
    String _spaceName = "";

    return showDialog<void>(
      barrierColor: Colors.black38,
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(0),
          titlePadding: EdgeInsets.all(0),
          backgroundColor: Color(Shared().secondaryLighterBackGround),
          title: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          child: Icon(
                            Icons.close_rounded,
                            size: 40,
                            color: Color(Shared().iconsColor),
                          ),
                          onTap: () {
                            FocusScope.of(context).unfocus();
                            Navigator.pop(context);
                          },
                        ))
                  ],
                ),
                Container(
                    height: 150,
                    child: SvgPicture.asset("assets/addSpaceIcon.svg")),
                Text(
                  'Create new Space!',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 25,
                      color: Colors.white.withAlpha(220)),
                ),
                SizedBox(
                  height: 15,
                ),
              ],
            ),
          ),
          content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Container(
              color: Color(Shared().secondaryBackGround),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Space name",
                              style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w100),
                            ),
                            Stack(
                              children: [
                                Container(
                                  height:45,
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              width: 0.5, color: Colors.grey))
                                  ),
                                ),
                                TextFormField(
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w100),
                                  decoration: InputDecoration(
                                      hintText: "Enter Space name",
                                      hintStyle: TextStyle(
                                          fontSize: 14, color: Colors.grey),
                                      border: InputBorder.none),
                                  validator: (input) => input!.trim().isEmpty
                                      ? "please enter a valid Space name"
                                      : alreadyExist(_spaceName)?"Space name already in use":null,
                                  onChanged: (input) => setState(() {
                                    _spaceName = input.toString();
                                  }),
                                ),
                              ],
                            ),
                            ColorPickerWidget(
                              spaceName: _spaceName,
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(0, 25, 0, 10),
                              width: double.infinity,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.amberAccent[700]!.withBlue(75),
                              ),
                              child: TextButton(
                                child: Text(
                                  "Add Space",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 18),
                                ),
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    await FirebaseDB().createSpace(SpaceModel(
                                        color: Shared().selectedColor.value,
                                        timeStamp: DateTime.now(),
                                        spaceLists: [],
                                        userId: "UserIdHere",
                                        spaceName: _spaceName));
                                    Shared().spaceList.value = await FirebaseDB().getSpaces("UserIdHere");
                                    Navigator.pop(context);
                                  }
                                },
                              ),
                            )
                          ],
                        ))
                  ],
                ),
              ),
            );
          }),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (pointerEnterEvent) {
          setState(() {
            color = Colors.black26;
          });
        },
        onExit: (pointerEnterEvent) {
          setState(() {
            color = Color(Shared().secondaryLighterBackGround);
          });
        },
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            _showCreateNewSpaceModel();
          },
          child: Container(
            height: 30,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: color,
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_rounded, size: 20, color: Colors.white70),
                  SizedBox(
                    width: 5,
                  ),
                  Text("New space",
                      style: TextStyle(
                          fontWeight: FontWeight.w100,
                          fontSize: 13,
                          color: Colors.white70)),
                  SizedBox(
                    width: 5,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
