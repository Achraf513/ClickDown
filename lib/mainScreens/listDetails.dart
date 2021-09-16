import 'package:click_down/Models/listModel.dart';
import 'package:click_down/Models/taskModel.dart';
import 'package:click_down/Shared/firebaseDB.dart';
import 'package:click_down/Shared/shared.dart';
import 'package:click_down/mainScreens/customizeTask.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class ListDetailsScreen extends StatefulWidget {
  const ListDetailsScreen({Key? key}) : super(key: key);

  @override
  _ListDetailsScreenState createState() => _ListDetailsScreenState();
}

class _ListDetailsScreenState extends State<ListDetailsScreen> {
  @override
  void dispose() {
    super.dispose();
  }

  Future<void> showUpdateListName() async {
  String _listName = Shared().selectedList.value.listName;
  final _formKey = GlobalKey<FormState>();
  return showDialog<void>(
    context: context,
    barrierDismissible: true, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Color(Shared().primaryBackGround),
        title: Text('Edit list title',style: TextStyle(color: Colors.white),),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Edit the List title and then press "Save"',style: TextStyle(color: Color(Shared().iconsColor)),),
              SizedBox(height: 15,),
              Form(
                key: _formKey,
                child: TextFormField(
                  initialValue: _listName,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 25,
                      color: Colors.white.withAlpha(220)),
                  decoration: InputDecoration(
                      hintText: "Enter a Task name",
                      hintStyle: TextStyle(
                          fontSize: 14, color: Colors.grey),
                      border: InputBorder.none),
                  validator: (input) => input!.trim().isEmpty
                      ? "please enter a valid Task name"
                      : null,
                  onChanged: (input) => setState(() {
                    _listName = input.toString();
                  }),
                ),
              ),
              SizedBox(height: 5,),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Cancel',style: TextStyle(color: Colors.white),),
            onPressed: () {
                Navigator.pop(context);
            },
          ),
          TextButton(
            child: Text('Save',style: TextStyle(color: Colors.white),),
            onPressed: () {
              if(_formKey.currentState!.validate()){
                print("Okay lets change this");
              }
                Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}

  Future<void> _showAreYouSure() async {
  return showDialog<void>(
    context: context,
    barrierDismissible: true, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Color(Shared().primaryBackGround),
        title: Text('Delete List ?',style: TextStyle(color: Colors.white),),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Are you sure you want to delete this list',style: TextStyle(color: Color(Shared().iconsColor)),),
              Text("Please put in mind that all tasks related to this list will also be deleted permanently",style: TextStyle(color: Color(Shared().iconsColor)),),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('No',style: TextStyle(color: Colors.white),),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('Yes',style: TextStyle(color: Colors.white),),
            onPressed: () {
              FirebaseDB().deleteList(Shared().selectedList.value.listId,
                  Shared().selectedSpace);
              Shared().selectedSpace.spaceLists.removeWhere((element) => element.listId==Shared().selectedList.value.listId);
              setState(() {
                Shared().tasksCache.remove(Shared().selectedList.value.listId);
                Shared().currentScreen.value = "Home";
                Shared().spaceList.value[Shared()
                    .spaceList
                    .value
                    .indexWhere((element) =>
                        element.spaceId ==
                        Shared().selectedSpace.spaceId)].copy(spaceLists: Shared().selectedSpace.spaceLists);
                Shared().spaceList.notifyListeners();
                Navigator.pop(context);
              });
            },
          ),
        ],
      );
    },
  );
}
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ListModel>(
        valueListenable: Shared().selectedList,
        builder: (BuildContext context, ListModel selectedList, Widget? child) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(2, 0, 0, 0),
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                height: 50,
                width: double.infinity,
                color: Color(Shared().secondaryBackGround),
                child: Container(
                  child: Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      Positioned(
                        left: 5,
                        child: Row(
                          children: [
                            Container(
                              width: 35,
                              height: 35,
                              decoration: BoxDecoration(
                                  color: Color(Shared().selectedSpace.color),
                                  borderRadius: BorderRadius.circular(5)),
                              child: Center(
                                child: Text(
                                    Shared()
                                        .selectedSpace
                                        .spaceName
                                        .toUpperCase()[0],
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.white)),
                              ),
                            ),
                            SizedBox(width: 7),
                            Text(Shared().selectedSpace.spaceName,
                                style: TextStyle(
                                    fontWeight: FontWeight.w100,
                                    fontSize: 16,
                                    color: Colors.white)),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 15),
                              width: 1.5,
                              height: 30,
                              color: Color(Shared().primaryBackGround),
                            ),
                            ViewSelectorButton(
                                viewTitle: "List", icon: Icons.list),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 15),
                              width: 1.5,
                              height: 30,
                              color: Color(Shared().primaryBackGround),
                            ),
                            ViewSelectorButton(
                                viewTitle: "Board", icon: Icons.border_all),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                margin: EdgeInsets.fromLTRB(2, 1, 0, 0),
                height: 50,
                width: double.infinity,
                color: Color(Shared().secondaryBackGround),
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    Positioned(
                      left: 0,
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
                          Text(selectedList.listName,
                              style: TextStyle(
                                  fontWeight: FontWeight.w100,
                                  fontSize: 13,
                                  color: Colors.white70)),
                        ],
                      ),
                    ),
                    Positioned(
                      right: 5,
                      child: Row(
                        children: [
                          FilterSelector(),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 15),
                            width: 1.5,
                            height: 30,
                            color: Color(Shared().primaryBackGround),
                          ),
                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: (){
                                showUpdateListName();
                              },
                              child: Icon(
                                Icons.edit_outlined,
                                size: 25,
                                color: Color(Shared().iconsColor),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () {
                                _showAreYouSure(); 
                              },
                              child: Icon(
                                Icons.delete_outline,
                                size: 25,
                                color: Colors.redAccent,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              DataMainWidget()
            ],
          );
        });
  }
}

class DataMainWidget extends StatefulWidget {
  const DataMainWidget({Key? key}) : super(key: key);

  @override
  _DataMainWidgetState createState() => _DataMainWidgetState();
}

class _DataMainWidgetState extends State<DataMainWidget> {
  ScrollController _dataListController = ScrollController();
  void callBackSetState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (!Shared().tasksCache.containsKey(Shared().selectedList.value.listId)) {
      return FutureBuilder(
          future: FirebaseDB().getTasks(Shared().selectedSpace.spaceId,
              Shared().selectedList.value.listId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                List<TaskModel> allTasks = snapshot.data as List<TaskModel>;

                Shared().tasksCache[Shared().selectedList.value.listId] = allTasks;
                return Container(
                  height: MediaQuery.of(context).size.height - 101,
                  child: RawScrollbar(
                    thumbColor: Color(Shared().iconsColor),
                    radius: Radius.circular(20),
                    thickness: 5,
                    isAlwaysShown: true,
                    controller: _dataListController,
                    child: ListView(
                      controller: _dataListController,
                      children: [
                        ToDoListWidget(mainParentCallBack: callBackSetState),
                        DoneListWidget(mainParentCallBack: callBackSetState),
                        SizedBox(
                          height: 50,
                        )
                      ],
                    ),
                  ),
                );
              }
            }
            return Text("LOADING!!!!");
          });
    } else {
      return Builder(builder: (context) {
        List<TaskModel> allTasks = Shared().tasksCache[Shared().selectedList.value.listId] ??
            [];
        return Container(
          height: 500,
          child: ListView(
            controller: _dataListController,
            children: [
              ToDoListWidget(mainParentCallBack: callBackSetState),
              DoneListWidget(mainParentCallBack: callBackSetState),
              SizedBox(
                height: 50,
              )
            ],
          ),
        );
      });
    }
  }
}

class TaskRowWidget extends StatefulWidget {
  final Function mainParentCallBack;
  final TaskModel taskModel;
  const TaskRowWidget(
      {Key? key, required this.taskModel, required this.mainParentCallBack})
      : super(key: key);

  @override
  _TaskRowWidgetState createState() => _TaskRowWidgetState();
}

class _TaskRowWidgetState extends State<TaskRowWidget> {
  late Color doneColor;
  late Color rowBorderColor = Color(Shared().secondaryBackGround);
  bool isHovered = false;
  final DateFormat dateFormat = DateFormat("MMM dd, yyyy");
  void initState() {
    super.initState();
    if (widget.taskModel.done) {
      doneColor = Colors.lightGreen;
    } else {
      doneColor = Color(Shared().iconsColor);
    }
  }


  Future<void> _showFullDescription() async {
    final _formKey = GlobalKey<FormState>();
    String _taskName = "";
    String _taskDescription = "";
    bool edited = false;

    return showDialog<void>(
      barrierColor: Colors.black38,
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(0),
          titlePadding: EdgeInsets.all(0),
          backgroundColor: Color(Shared().secondaryLighterBackGround),
          content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width / 2,
                color: Color(Shared().secondaryBackGround),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        color: Color(Shared().primaryBackGround),
                        padding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 24),
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
                                child:
                                    SvgPicture.asset("assets/addTaskIcon.svg")),
                            SizedBox(
                              height: 15,
                            ),
                            TextFormField(
                              initialValue: widget.taskModel.taskName,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 25,
                                  color: Colors.white.withAlpha(220)),
                              decoration: InputDecoration(
                                  hintText: "Enter a Task name",
                                  hintStyle: TextStyle(
                                      fontSize: 14, color: Colors.grey),
                                  border: InputBorder.none),
                              validator: (input) => input!.trim().isEmpty
                                  ? "please enter a valid Task name"
                                  : null,
                              onChanged: (input) => setState(() {
                                _taskName = input.toString();
                                edited = true;
                              }),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                        child: Column(
                          children: [
                            Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                          initialValue:
                                              widget.taskModel.taskDescription,
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
                                                  fontSize: 14,
                                                  color: Colors.grey),
                                              enabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      width: 0.75,
                                                      color: Colors.grey))),
                                          validator: (input) => null,
                                          onChanged: (input) => setState(() {
                                            _taskDescription = input.toString();
                                            edited = true;
                                          }),
                                        ),
                                      ],
                                    ),
                                    edited
                                        ? Container(
                                            margin: EdgeInsets.fromLTRB(
                                                0, 25, 0, 10),
                                            width: double.infinity,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              color: Colors.amberAccent[700]!
                                                  .withBlue(75),
                                            ),
                                            child: TextButton(
                                              child: Text(
                                                "Save",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 18),
                                              ),
                                              onPressed: () {
                                                FirebaseDB().updateTask(
                                                    widget.taskModel.copy(
                                                  taskName: _taskName.isEmpty
                                                      ? widget
                                                          .taskModel.taskName
                                                      : _taskName,
                                                  taskDescription:
                                                      _taskDescription.isEmpty
                                                          ? widget.taskModel
                                                              .taskDescription
                                                          : _taskDescription,
                                                ));
                                                Shared().tasksCache[
                                                    widget.taskModel.spaceId +
                                                        widget.taskModel.listId]![Shared()
                                                    .tasksCache[
                                                        widget.taskModel.spaceId +
                                                            widget.taskModel
                                                                .listId]!
                                                    .indexWhere((element) =>
                                                        element.taskId ==
                                                        widget.taskModel
                                                            .taskId)] = widget.taskModel.copy(
                                                  taskName: _taskName.isEmpty
                                                      ? widget
                                                          .taskModel.taskName
                                                      : _taskName,
                                                  taskDescription:
                                                      _taskDescription.isEmpty
                                                          ? widget.taskModel
                                                              .taskDescription
                                                          : _taskDescription,
                                                );
                                                widget.mainParentCallBack();
                                                Navigator.pop(context);
                                              },
                                            ),
                                          )
                                        : SizedBox()
                                  ],
                                ))
                          ],
                        ),
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

  Color borderColorDueDate = Color(Shared().secondaryBackGround);
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (pointerEnterEvent) {
        setState(() {
          rowBorderColor = Colors.lightGreen;
          isHovered = true;
        });
      },
      onExit: (pointerExitEvent) {
        setState(() {
          rowBorderColor = Color(Shared().secondaryBackGround);
          isHovered = false;
        });
      },
      child: GestureDetector(
        onTap: () {
          _showFullDescription();
        },
        child: Padding(
          padding: EdgeInsets.fromLTRB(55, 0, 35, 1.5),
          child: Container(
            padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
            decoration: BoxDecoration(
              border: Border.all(color: rowBorderColor, width: 0.5),
              color: Color(Shared().secondaryBackGround),
            ),
            alignment: Alignment.centerLeft,
            width: double.infinity,
            child: Row(
              children: [
                SizedBox(
                  width: 20,
                ),
                MouseRegion(
                    cursor: SystemMouseCursors.click,
                    onEnter: (pointerEnterEvent) {
                      if (!widget.taskModel.done) {
                        setState(() {
                          doneColor = Colors.lightGreen;
                        });
                      }
                    },
                    onExit: (pointerExitEvent) {
                      if (!widget.taskModel.done) {
                        setState(() {
                          doneColor = Color(Shared().iconsColor);
                        });
                      }
                    },
                    child: GestureDetector(
                        onTap: () async {
                          int thisTaskIndexInCache = Shared()
                              .tasksCache[Shared().selectedList.value.listId]!
                              .indexWhere((element) =>
                                  element.taskId == widget.taskModel.taskId);
                          Shared().tasksCache[Shared().selectedList.value.listId]![thisTaskIndexInCache] = widget
                              .taskModel
                              .copy(done: !widget.taskModel.done);
                          await FirebaseDB().updateTask(widget.taskModel
                              .copy(done: !widget.taskModel.done));
                          widget.mainParentCallBack();
                        },
                        child: Icon(Icons.done, size: 20, color: doneColor))),
                SizedBox(
                  width: 10,
                ),
                Container(
                  width: MediaQuery.of(context).size.width > 1000
                      ? (MediaQuery.of(context).size.width > 1200
                          ? MediaQuery.of(context).size.width / 1.7
                          : MediaQuery.of(context).size.width / 2.4)
                      : MediaQuery.of(context).size.width / 3.7,
                  child: Text(
                    widget.taskModel.taskName,
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                        fontWeight: FontWeight.normal),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                MouseRegion(
                  onEnter: (p) {
                    setState(() {
                      borderColorDueDate = Color(Shared().primaryBackGround);
                    });
                  },
                  onExit: (p) {
                    setState(() {
                      borderColorDueDate = Color(Shared().secondaryBackGround);
                    });
                  },
                  child: GestureDetector(
                    onTap: () async {
                      final DateTime? date = await showDatePicker(
                          context: context,
                          initialDate:
                              widget.taskModel.deadline ?? DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2050),
                          builder: (buildContext, widget) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: ColorScheme.light(
                                  primary: Color(Shared()
                                      .primaryBackGround), // header background color
                                  surface: Color(Shared().secondaryBackGround),
                                  background:
                                      Color(Shared().secondaryBackGround),
                                  onPrimary: Colors.white, // header text color
                                ),
                                textButtonTheme: TextButtonThemeData(
                                  style: TextButton.styleFrom(
                                      primary: Color(Shared()
                                          .primaryBackGround) // button text color
                                      ),
                                ),
                              ),
                              child: widget!,
                            );
                          });
                      if (date != widget.taskModel.deadline) {
                        FirebaseDB().updateTask(widget.taskModel.copy(
                          deadline: date,
                        ));
                        Shared().tasksCache[widget.taskModel.spaceId +
                                    widget.taskModel.listId]![
                                Shared()
                                    .tasksCache[widget.taskModel.spaceId +
                                        widget.taskModel.listId]!
                                    .indexWhere((element) =>
                                        element.taskId ==
                                        widget.taskModel.taskId)] =
                            widget.taskModel.copy(
                          deadline: date,
                        );
                        widget.mainParentCallBack();
                      }
                    },
                    child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 2, color: borderColorDueDate)),
                        width: 100,
                        height: 30,
                        child: Center(
                          child: widget.taskModel.deadline != null
                              ? Text(
                                  showDate(widget.taskModel.deadline!),
                                  style: TextStyle(
                                      color: widget.taskModel.done
                                          ? Color(Shared().iconsColor)
                                          : getDueDateColor(
                                              widget.taskModel.deadline!),
                                      fontSize: 12),
                                )
                              : Icon(Icons.remove,
                                  color: Color(Shared().iconsColor)),
                        )),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                isHovered
                    ? GestureDetector(
                        onTap: () {
                          FirebaseDB().deleteTask(widget.taskModel);
                          Shared()
                              .tasksCache[widget.taskModel.listId]!
                              .removeAt(Shared()
                                  .tasksCache[widget.taskModel.listId]!
                                  .indexWhere((element) =>
                                      element.taskId ==
                                      widget.taskModel.taskId));
                          widget.mainParentCallBack();
                        },
                        child: Icon(Icons.delete_outline, color: Colors.red, size: 15))
                    : SizedBox(),
                SizedBox(
                  width: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String showDate(DateTime date) {
    if (dateFormat.format(date) == dateFormat.format(DateTime.now())) {
      return "Today";
    } else if (dateFormat.format(date) ==
        dateFormat.format(DateTime.now().subtract(Duration(days: 1)))) {
      return "Yesterday";
    } else if (dateFormat.format(date) ==
        dateFormat.format(DateTime.now().add(Duration(days: 1)))) {
      return "Tomorrow";
    } else {
      return dateFormat.format(date);
    }
  }

  Color getDueDateColor(DateTime date) {
    if (dateFormat.format(date) == dateFormat.format(DateTime.now())) {
      return Colors.grey;
    } else if (date.isAfter(DateTime.now())) {
      return Colors.green;
    } else {
      return Colors.red;
    }
  }
}

class ViewSelectorButton extends StatefulWidget {
  final String viewTitle;
  final IconData icon;
  const ViewSelectorButton(
      {Key? key, required this.viewTitle, required this.icon})
      : super(key: key);

  @override
  _ViewSelectorButtonState createState() => _ViewSelectorButtonState();
}

class _ViewSelectorButtonState extends State<ViewSelectorButton> {
  Color color = Color(Shared().iconsColor);
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (pointerEnterEvent) {
        setState(() {
          color = Colors.amberAccent;
        });
      },
      onExit: (pointerEnterEvent) {
        setState(() {
          color = Color(Shared().iconsColor);
        });
      },
      child: Row(
        children: [
          Icon(
            widget.icon,
            size: 20,
            color: color,
          ),
          SizedBox(
            width: 5,
          ),
          Text(widget.viewTitle,
              style: TextStyle(
                  fontWeight: FontWeight.normal, fontSize: 14, color: color))
        ],
      ),
    );
  }
}

class FilterSelector extends StatefulWidget {
  const FilterSelector({Key? key}) : super(key: key);

  @override
  _FilterSelectorState createState() => _FilterSelectorState();
}

class _FilterSelectorState extends State<FilterSelector> {
  @override
  Color color = Color(Shared().iconsColor);
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (pointerEnterEvent) {
        setState(() {
          color = Colors.amberAccent;
        });
      },
      onExit: (pointerEnterEvent) {
        setState(() {
          color = Color(Shared().iconsColor);
        });
      },
      child: Row(
        children: [
          Icon(
            Icons.filter_list,
            size: 20,
            color: color,
          ),
          SizedBox(
            width: 5,
          ),
          Text("Filter",
              style: TextStyle(
                  fontWeight: FontWeight.normal, fontSize: 14, color: color))
        ],
      ),
    );
  }
}

class DoneListWidget extends StatefulWidget {
  final Function mainParentCallBack;
  const DoneListWidget({Key? key, required this.mainParentCallBack})
      : super(key: key);

  @override
  _DoneListWidgetState createState() => _DoneListWidgetState();
}

class _DoneListWidgetState extends State<DoneListWidget> {
  bool expanded = true;
  @override
  Widget build(BuildContext context) {
    List<TaskModel> doneTasks = Shared()
        .tasksCache[Shared().selectedList.value.listId]!
        .where((element) => element.done)
        .toList();

    return doneTasks.isNotEmpty
        ? Container(
            margin: EdgeInsets.fromLTRB(0, 45, 0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(35, 0, 0, 0),
                  child: Row(
                    children: [
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              FocusScope.of(context).unfocus();
                              expanded = !expanded;
                            });
                          },
                          child: Container(
                            width: 10,
                            height: 10,
                            child: SvgPicture.asset(expanded
                                ? "assets/arrowDownIcon.svg"
                                : "assets/arrowRightIcon.svg"),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        width: expanded ? 70 : 140,
                        height: 25,
                        child: Center(
                            child: Row(
                          children: [
                            SizedBox(
                              width: 15,
                            ),
                            Text("Done",
                                style: TextStyle(
                                  fontSize: 14,
                                )),
                            !expanded
                                ? Row(
                                    children: [
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Text(
                                          doneTasks.length.toString() +
                                              " Tasks",
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600)),
                                    ],
                                  )
                                : SizedBox(),
                          ],
                        )),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5),
                              topRight: Radius.circular(5)),
                          color: Colors.lightGreen,
                        ),
                      ),
                    ],
                  ),
                ),
                expanded
                    ? Column(
                        children: doneTasks
                            .map((task) => TaskRowWidget(
                                  mainParentCallBack: widget.mainParentCallBack,
                                  taskModel: task,
                                ))
                            .toList())
                    : SizedBox()
              ],
            ),
          )
        : SizedBox();
  }
}

class ToDoListWidget extends StatefulWidget {
  final Function mainParentCallBack;
  const ToDoListWidget({Key? key, required this.mainParentCallBack})
      : super(key: key);

  @override
  _ToDoListWidgetState createState() => _ToDoListWidgetState();
}

class _ToDoListWidgetState extends State<ToDoListWidget> {
  bool expanded = true;
  late List<TaskModel> toDoList_;

  void callBackResetState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    toDoList_ = Shared()
        .tasksCache[Shared().selectedList.value.listId]!
        .where((element) => !element.done)
        .toList();
    List<TaskModel> toDoList_withDD =
        toDoList_.where((element) => element.deadline != null).toList();
    toDoList_withDD.sort((a, b) => a.deadline!.difference(b.deadline!).inDays);
    List<TaskModel> toDoList =
        toDoList_.where((element) => element.deadline == null).toList();
    return Container(
      margin: EdgeInsets.fromLTRB(0, 45, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(35, 0, 0, 0),
            child: Row(
              children: [
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        FocusScope.of(context).unfocus();
                        expanded = !expanded;
                      });
                    },
                    child: Container(
                      width: 10,
                      height: 10,
                      child: SvgPicture.asset(expanded
                          ? "assets/arrowDownIcon.svg"
                          : "assets/arrowRightIcon.svg"),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  width: expanded ? 70 : 140,
                  height: 25,
                  child: Center(
                      child: Row(
                    children: [
                      SizedBox(
                        width: 15,
                      ),
                      Text("To-Do",
                          style: TextStyle(
                            fontSize: 14,
                          )),
                      !expanded
                          ? Row(
                              children: [
                                SizedBox(
                                  width: 15,
                                ),
                                Text(toDoList_.length.toString() + " Tasks",
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600)),
                              ],
                            )
                          : SizedBox(),
                    ],
                  )),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5),
                        topRight: Radius.circular(5)),
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          expanded
              ? Column(
                  children: [
                    Column(
                        children: toDoList_withDD
                            .map((task) => TaskRowWidget(
                                  mainParentCallBack: widget.mainParentCallBack,
                                  taskModel: task,
                                ))
                            .toList()),
                    Column(
                        children: toDoList
                            .map((task) => TaskRowWidget(
                                  mainParentCallBack: widget.mainParentCallBack,
                                  taskModel: task,
                                ))
                            .toList()),
                    NewTaskWidget(callBack: callBackResetState),
                  ],
                )
              : SizedBox()
        ],
      ),
    );
  }
}

class NewTaskWidget extends StatefulWidget {
  final Function callBack;
  const NewTaskWidget({Key? key, required this.callBack}) : super(key: key);

  @override
  _NewTaskWidgetState createState() => _NewTaskWidgetState();
}

class _NewTaskWidgetState extends State<NewTaskWidget> {
  String _taskName = "";
  Color color = Colors.grey;
  bool focused = false;
  FocusNode newTaskFocuseNode = FocusNode();
  void initState() {
    super.initState();
    newTaskFocuseNode.addListener(() {
      if (newTaskFocuseNode.hasFocus) {
        setState(() {
          focused = true;
          color = Colors.amberAccent;
        });
      } else {
        setState(() {
          focused = false;
          color = Colors.grey;
        });
      }
    });
  }

  void addSimpleTask() async {
    TaskModel? newTask = await FirebaseDB().createTask(TaskModel(
        spaceId: Shared().selectedSpace.spaceId!,
        listId: Shared().selectedList.value.listId,
        done: false,
        taskName: _taskName,
        taskDescription: Shared().taskDescription,
        addedDate: DateTime.now(),
        deadline: Shared().deadline));
    if (newTask != null) {
      Shared()
          .tasksCache[Shared().selectedList.value.listId]!
          .add(newTask);
      Shared().deadline = null;
      Shared().taskDescription = "";
      widget.callBack();
    }
  }

  final _formKey = GlobalKey<FormState>();
  double height = 45;
  TextEditingController newTaskTextFieldController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(55, 0, 35, 1),
      child: MouseRegion(
        onEnter: (pointerEnterEvent) {
          if (!focused) {
            setState(() {
              color = Colors.amberAccent;
            });
          }
        },
        onExit: (pointerEnterEvent) {
          if (!focused) {
            setState(() {
              color = Colors.grey;
            });
          }
        },
        child: Container(
          decoration: focused
              ? BoxDecoration(
                  color: Color(Shared().secondaryBackGround),
                  border: Border.all(color: Colors.amberAccent, width: 0.5))
              : BoxDecoration(
                  color: Color(Shared().secondaryBackGround),
                ),
          width: double.infinity,
          height: height,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 10,
              ),
              Expanded(
                flex: 10,
                child: Container(
                  height: 50,
                  child: Form(
                    key: _formKey,
                    child: TextFormField(
                      onFieldSubmitted: (s) {
                        if (_formKey.currentState!.validate()) {
                          addSimpleTask();
                          newTaskTextFieldController.text = "";
                          height = 45;
                        } else {
                          setState(() {
                            height = 65;
                          });
                        }
                      },
                      controller: newTaskTextFieldController,
                      focusNode: newTaskFocuseNode,
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey,
                          fontWeight: FontWeight.w100),
                      decoration: InputDecoration(
                          prefixIcon: Container(
                              margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
                              child: Icon(
                                Icons.add,
                                size: 25,
                                color: color,
                              )),
                          hintText: "New task ?",
                          hintStyle:
                              TextStyle(fontSize: 15, color: Colors.grey),
                          border: InputBorder.none),
                      validator: (input) => input!.trim().isEmpty
                          ? "please enter a valid Task title"
                          : null,
                      onChanged: (input) => setState(() {
                        _taskName = input.toString();
                      }),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 15,
              ),
              focused
                  ? Row(
                      children: [
                        DatePickerIconWidget(
                          callBackParent: widget.callBack,
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 7, 0, 7),
                          width: 60,
                          height: 38,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.amberAccent[700]!.withBlue(75),
                          ),
                          child: TextButton(
                            child: Text(
                              "Save",
                              style: TextStyle(
                                  color: Color(Shared().secondaryBackGround),
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                addSimpleTask();
                                newTaskTextFieldController.text = "";
                                FocusScope.of(context).unfocus();
                                height = 45;
                              } else {
                                setState(() {
                                  height = 65;
                                });
                              }
                              /* if (_formKey.currentState!.validate()) {
                          await firebaseDB().createSpace(SpaceModel(
                              color: Shared().selectedColor.value,
                              timeStamp: DateTime.now(),
                              spaceLists: [],
                              userId: "UserIdHere",
                              spaceName: _spaceName));
                          Shared().spaceList.value = await firebaseDB().getSpaces("UserIdHere");
                          Navigator.pop(context);
                        } */
                            },
                          ),
                        ),
                        CustomizeTaskBtn(callBack: widget.callBack),
                        SizedBox(
                          width: 20,
                        ),
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () {
                              Shared().taskDescription = "";
                              FocusScope.of(context).unfocus();
                            },
                            child: Icon(
                              Icons.close,
                              size: 16,
                              color: Color(Shared().iconsColor),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        )
                      ],
                    )
                  : SizedBox()
            ],
          ),
        ),
      ),
    );
  }
}

class DatePickerIconWidget extends StatefulWidget {
  final Function callBackParent;
  const DatePickerIconWidget({Key? key, required this.callBackParent})
      : super(key: key);

  @override
  _DatePickerIconWidgetState createState() => _DatePickerIconWidgetState();
}

class _DatePickerIconWidgetState extends State<DatePickerIconWidget> {
  Color color = Color(Shared().iconsColor);
  DateTime selectedDate = DateTime.now();
  TextEditingController _deadlineController = TextEditingController();
  final DateFormat dateFormat = DateFormat("MMM dd, yyyy");

  Future<DateTime?> _handleDatePicker() async {
    final DateTime? date = await showDatePicker(
        context: context,
        initialDate: Shared().deadline ?? DateTime.now(),
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
    return date;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
      height: 35,
      child: MouseRegion(
          onEnter: (pointerEnterEvent) {
            setState(() {
              color = Colors.amberAccent;
            });
          },
          onExit: (pointerExitEvent) {
            setState(() {
              color = Color(Shared().iconsColor);
            });
          },
          child: GestureDetector(
            onTap: () async {
              Shared().deadline = await _handleDatePicker();
              widget.callBackParent();
            },
            child: Shared().deadline == null
                ? Icon(
                    Icons.calendar_today_rounded,
                    size: 20,
                    color: color,
                  )
                : Center(
                    child: Row(
                    children: [
                      RemoveDeadLineBtn(
                        callBackParent: widget.callBackParent,
                      ),
                      Text(
                        dateFormat.format(Shared().deadline!),
                        style: TextStyle(color: color, fontSize: 14),
                      ),
                    ],
                  )),
          )),
    );
  }
}

class RemoveDeadLineBtn extends StatefulWidget {
  final Function callBackParent;
  const RemoveDeadLineBtn({Key? key, required this.callBackParent})
      : super(key: key);

  @override
  _RemoveDeadLineBtnState createState() => _RemoveDeadLineBtnState();
}

class _RemoveDeadLineBtnState extends State<RemoveDeadLineBtn> {
  Color color = Color(Shared().iconsColor);
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
        child: MouseRegion(
            onEnter: (pointerEnterEvent) {
              setState(() {
                color = Colors.red;
              });
            },
            onExit: (pointerExitEvent) {
              setState(() {
                color = Color(Shared().iconsColor);
              });
            },
            child: GestureDetector(
              onTap: () async {
                Shared().deadline = null;
                widget.callBackParent();
              },
              child: Icon(
                Icons.close,
                color: color,
                size: 15,
              ),
            )));
  }
}
