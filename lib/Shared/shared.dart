import 'package:click_down/Models/listModel.dart';
import 'package:click_down/Models/spaceModel.dart';
import 'package:click_down/Models/taskModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Shared{
  int primaryBackGround = 0xff1E272E;
  int secondaryBackGround = 0xff2B343B;
  int secondaryLighterBackGround = 0xff384047;
  int iconsColor = 0xff7C828D;
  String taskDescription ="";
  DateTime? deadline;

  SpaceModel selectedSpace = SpaceModel.nullSpace();
  ValueNotifier<ListModel> selectedList = ValueNotifier<ListModel>(ListModel.nullSpace());

  ValueNotifier<List<SpaceModel>> spaceList= ValueNotifier<List<SpaceModel>>([]);
  ValueNotifier<String> currentScreen = ValueNotifier<String>("Home");
  ValueNotifier<int> selectedColor =ValueNotifier<int>(Colors.green.value);

  Map<String,List<TaskModel>> tasksCache = {};
  
  static final Shared _shared = Shared._internal();
  factory Shared(){
    return _shared;
  }
  Shared._internal();
}