import 'package:click_down/Models/listModel.dart';
import 'package:click_down/Models/spaceModel.dart';
import 'package:click_down/Shared/firebaseDB.dart';
import 'package:click_down/Shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SpaceTitleWidget extends StatefulWidget {
  final SpaceModel spaceModel;
  final bool expanded;
  const SpaceTitleWidget(
      {Key? key, required this.spaceModel, required this.expanded})
      : super(key: key);
  @override
  _SpaceTitleWidgetState createState() => _SpaceTitleWidgetState();
}

class _SpaceTitleWidgetState extends State<SpaceTitleWidget> {
  Color color = Color(Shared().secondaryBackGround);
  bool isHovered = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (pointerEnterEvent) {
        setState(() {
          color = Colors.black26;
          isHovered = true;
        });
      },
      onExit: (pointerEnterEvent) {
        setState(() {
          color = Color(Shared().secondaryBackGround);
          isHovered = false;
        });
      },
      child: Container(
        color: color,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
        child: Column(
          //when expanded
          children: [
            Row(
              children: [
                Expanded(
                  flex: 9,
                  child: Container(
                    child: Row(
                      children: [
                        Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                              color: Color(widget.spaceModel.color),
                              borderRadius: BorderRadius.circular(3)),
                          child: Center(
                            child: Text(
                                widget.spaceModel.spaceName.toUpperCase()[0],
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.white)),
                          ),
                        ),
                        SizedBox(width: 7),
                        Text(widget.spaceModel.spaceName,
                            style: TextStyle(
                                fontWeight: FontWeight.w100,
                                fontSize: 13,
                                color: Colors.white)),
                      ],
                    ),
                  ),
                ),
                Expanded(
                    flex: 2,
                    child: Container(
                      width: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          isHovered
                              ? GestureDetector(
                                  onTap: () {
                                    FocusScope.of(context).unfocus();
                                    _showCreateNewSpaceModel();
                                  },
                                  child: Icon(
                                    Icons.add,
                                    size: 20,
                                    color: Color(Shared().iconsColor),
                                  ),
                                )
                              : SizedBox(),
                          widget.spaceModel.spaceLists.isEmpty?SizedBox():Column(
                            children: [
                              SizedBox(
                                width: 2,
                              ),
                              Container(
                                  height: !widget.expanded ? 10 : 7,
                                  width: 15,
                                  child: SvgPicture.asset(!widget.expanded
                                      ? "assets/arrowRightIcon.svg"
                                      : "assets/arrowDownIcon.svg")),
                            ],
                          ),
                          SizedBox(
                            width: 5,
                          ),
                        ],
                      ),
                    ))
              ],
            ),
          ],
        ),
      ),
    );
  }

  bool alreadyExist(String listname) {
    for (ListModel list in widget.spaceModel.spaceLists) {
      if (listname == list.listName) {
        return true;
      }
    }
    return false;
  }

  Future<void> _showCreateNewSpaceModel() async {
    final _formKey = GlobalKey<FormState>();
    TextEditingController _listNameController = TextEditingController();
    String _listName = "";

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
            width: MediaQuery.of(context).size.width / 3,
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
                    child: SvgPicture.asset("assets/addListIcon.svg")),
                Text(
                  'Create a new List!',
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
              width: MediaQuery.of(context).size.width / 2.5,
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
                              "List name",
                              style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w100),
                            ),
                            Stack(
                              children: [
                                Container(
                                  height: 45,
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              width: 0.5, color: Colors.grey))),
                                ),
                                TextFormField(
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w100),
                                  decoration: InputDecoration(
                                      hintText: "Enter List name",
                                      hintStyle: TextStyle(
                                          fontSize: 14, color: Colors.grey),
                                      border: InputBorder.none),
                                  validator: (input) => input!.trim().isEmpty
                                      ? "please enter a valid List name"
                                      : alreadyExist(_listName)
                                          ? "List name already used"
                                          : null,
                                  onChanged: (input) => setState(() {
                                    _listName = input.toString();
                                  }),
                                ),
                              ],
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
                                  "Add List",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 18),
                                ),
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    List<ListModel> spaceLists =
                                        widget.spaceModel.spaceLists;
                                    spaceLists.add(ListModel(
                                        listId: widget.spaceModel.spaceId!+DateTime.now().toString(),
                                        listName: _listName,
                                        position: widget
                                            .spaceModel.spaceLists.length));
                                    await FirebaseDB().updateSpace(widget
                                        .spaceModel
                                        .copy(spaceLists: spaceLists));
                                    Shared().spaceList.value =
                                        await FirebaseDB()
                                            .getSpaces("UserIdHere");
                                    Navigator.pop(context);
                                  }
                                },
                              ),
                            )
                          ],
                        )),
                  ],
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
