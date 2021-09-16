import 'package:click_down/Models/listModel.dart';

class SpaceModelFields {
  static final String spaceId = "spaceId";
  static final String userId = "userId";
  static final String spaceName = "spaceName";
  static final String spaceLists = "spaceLists";
  static final String timeStamp = "timeStamp";
  static final String color = "color";
}

class SpaceModel {
  final String? spaceId;
  final String userId;
  final String spaceName;
  final List<ListModel> spaceLists;
  final DateTime timeStamp;
  final int color;
  SpaceModel({
    this.spaceId = "Null",
    required this.userId,
    required this.spaceName,
    required this.timeStamp,
    required this.spaceLists,
    required this.color,
  });
  
  static SpaceModel nullSpace(){
    return SpaceModel(userId: "NULL", spaceName: "NULL", timeStamp: DateTime.now(), spaceLists: [], color: 0);
  }

  Map<String, Object?> toJSON() {
    return {
      SpaceModelFields.spaceId: spaceId,
      SpaceModelFields.userId: userId,
      SpaceModelFields.spaceName: spaceName,
      SpaceModelFields.timeStamp: timeStamp.toString(),
      SpaceModelFields.spaceLists: spaceLists.map((e) => e.toJSON()),
      SpaceModelFields.color: color,
    };
  }

  static SpaceModel fromJson(Map<String, Object?> json) => SpaceModel(
    spaceId: json[SpaceModelFields.spaceId] as String,
    userId: json[SpaceModelFields.userId] as String,
    spaceName: json[SpaceModelFields.spaceName] as String,
    timeStamp: json[SpaceModelFields.timeStamp] as DateTime,
    spaceLists: json[SpaceModelFields.spaceLists] as List<ListModel> ,
    color: json[SpaceModelFields.color] as int,
  );

  SpaceModel copy({
    String? spaceId,
    String? userId,
    String? spaceName,
    DateTime? timeStamp,
    List<ListModel>? spaceLists,
    int? color,
  }) => SpaceModel(
    spaceId : spaceId?? this.spaceId,
    userId : userId?? this.userId,
    spaceName : spaceName?? this.spaceName,
    timeStamp : timeStamp?? this.timeStamp,
    spaceLists : spaceLists?? this.spaceLists,
    color : color?? this.color,
  );
}
