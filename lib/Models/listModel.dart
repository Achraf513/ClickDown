class ListModelFields {
  static final String listId = "listId";
  static final String listName = "listName";
  static final String position = "position";
}

class ListModel {
  final String listId;
  final String listName;
  final int position;
  ListModel({
    required this.listId,
    required this.listName,
    required this.position,
  });

  static ListModel nullSpace(){
    return ListModel(listId: "NULL",listName: "NULL",position:-1);
  }
  
  Map<String, Object?> toJSON() {
    return {
      ListModelFields.listId: listId,
      ListModelFields.listName: listName,
      ListModelFields.position: position,
    };
  }

  static ListModel fromJson(Map<String, Object?> json) => ListModel(
    listId: json[ListModelFields.listId] as String,
    listName: json[ListModelFields.listName] as String,
    position: json[ListModelFields.position] as int,
  );

  ListModel copy({
    String? listId,
    String? listName,
    int? position,
  }) => ListModel(
    listId : listId?? this.listId,
    listName : listName?? this.listName,
    position : position?? this.position,
  );

}
