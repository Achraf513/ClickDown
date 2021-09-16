import 'package:click_down/Models/taskModel.dart';
import 'package:click_down/Shared/firebaseDB.dart';
import 'package:click_down/Shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class CustomizeTaskBtn extends StatefulWidget {
  final Function callBack;
  const CustomizeTaskBtn({Key? key, required this.callBack}) : super(key: key);

  @override
  _CustomizeTaskBtnState createState() => _CustomizeTaskBtnState();
}

class _CustomizeTaskBtnState extends State<CustomizeTaskBtn> {
  DateTime selectedDate = DateTime.now();
  TextEditingController _deadlineController = TextEditingController();
  DateTime _deadline = DateTime.now();
  final DateFormat dateFormat = DateFormat("MMM dd, yyyy");

  _handleDatePicker() async {
    final DateTime? date = await showDatePicker(
        context: context,
        initialDate: _deadline,
        firstDate: DateTime(2000),
        lastDate: DateTime(2050),
        builder: (buildContext, widget) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: Color(
                    Shared().primaryBackGround), // header background color
                surface: Color(Shared().secondaryBackGround),
                background: Color(Shared().secondaryBackGround),
                onPrimary: Colors.white, // header text color
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                    primary:
                        Color(Shared().primaryBackGround) // button text color
                    ),
              ),
            ),
            child: widget!,
          );
        });
    if (date != null && date != _deadline) {
      setState(() {
        _deadline = date;
      });
      _deadlineController.text = dateFormat.format(_deadline);
    }
  }

  Future<void> _showCreateNewTask() async {
    final _formKey = GlobalKey<FormState>();
    String _taskName = "";
    String _taskDescription = "";

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
                    width: 80,
                    child: SvgPicture.asset("assets/addTaskIcon.svg")),
                SizedBox(
                  height: 15,
                ),
                Text(
                  'Create a new Task!',
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
            return SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width > 1000
                    ? MediaQuery.of(context).size.width / 3
                    : MediaQuery.of(context).size.width / 2,
                color: Color(Shared().secondaryBackGround),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                child: SingleChildScrollView(
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Task Description",
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w100),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      TextFormField(
                                        initialValue: Shared().taskDescription,
                                        maxLines: 7,
                                        minLines: 7,
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w100),
                                        decoration: InputDecoration(
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    width: 0.75,
                                                    color: Colors.grey)),
                                            hintText:
                                                "Enter a Task Description (Optional)",
                                            hintStyle: TextStyle(
                                                fontSize: 14, color: Colors.grey),
                                            enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    width: 0.75,
                                                    color: Colors.grey))),
                                        validator: (input) => null,
                                        onChanged: (input) => setState(() {
                                          _taskDescription = input.toString();
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
                                        "Done",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 18),
                                      ),
                                      onPressed: ()  {
                                        Shared().taskDescription = _taskDescription;
                                        Navigator.pop(context);
                                      },
                                    ),
                                  )
                                ],
                              ))
                        ],
                      ),
                    ],
                  ),
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
    return Container(
      margin: EdgeInsets.fromLTRB(7, 7, 0, 7),
      width: 75,
      height: 38,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[600],
      ),
      child: TextButton(
        child: Text(
          "Customize",
          style: TextStyle(
              color: Color(Shared().secondaryBackGround),
              fontWeight: FontWeight.w400,
              fontSize: 12),
        ),
        onPressed: () async {
          _showCreateNewTask().then((value) => widget.callBack());
        },
      ),
    );
  }
}
