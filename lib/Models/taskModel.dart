class TaskModelFields {
  static final String taskId = "taskId";
  static final String spaceId = "spaceId";
  static final String listId = "listId";
  static final String done = "done";
  static final String taskName = "taskName";
  static final String taskDescription = "taskDescription";
  static final String addedDate = "addedDate";
  static final String deadline = "deadline";
}

class TaskModel {
  final String? taskId;
  final String spaceId;
  final String listId;
  final bool done;
  final String taskName;
  final String taskDescription;
  final DateTime addedDate;
  final DateTime? deadline;
  TaskModel({
    this.taskId,
    required this.spaceId,
    required this.listId,
    required this.done,
    required this.taskName,
    required this.taskDescription,
    required this.addedDate,
    this.deadline,
  });

  static TaskModel nullTask(){
    return TaskModel(spaceId: "NULL", listId: "NULL", done: false, taskName: "NULL", taskDescription: "NULL", addedDate: DateTime.now(), deadline: DateTime.now());
  }
  
  Map<String, Object?> toJSON() {
    return {
      TaskModelFields.taskId: taskId,
      TaskModelFields.spaceId: spaceId,
      TaskModelFields.listId: listId,
      TaskModelFields.done: done,
      TaskModelFields.taskName: taskName,
      TaskModelFields.taskDescription: taskDescription,
      TaskModelFields.addedDate: addedDate.toString(),
      TaskModelFields.deadline: deadline.toString(),
    };
  }

  static TaskModel fromJson(Map<String, Object?> json) => TaskModel(
    taskId: json[TaskModelFields.taskId] as String,
    spaceId: json[TaskModelFields.spaceId] as String,
    listId: json[TaskModelFields.listId] as String,
    done: json[TaskModelFields.done] as bool,
    taskName: json[TaskModelFields.taskName] as String,
    taskDescription: json[TaskModelFields.taskDescription] as String,
    addedDate: DateTime.parse(json[TaskModelFields.addedDate] as String),
    deadline: DateTime.parse(json[TaskModelFields.deadline] as String),
  );

  TaskModel copy({
    String? taskId,
    String? spaceId,
    String? listId,
    bool? done,
    String? taskName,
    String? taskDescription,
    DateTime? addedDate,
    DateTime? deadline,
  }) => TaskModel(
    taskId : taskId?? this.taskId,
    spaceId : spaceId?? this.spaceId,
    listId : listId?? this.listId,
    done : done?? this.done,
    taskName : taskName?? this.taskName,
    taskDescription : taskDescription?? this.taskDescription,
    addedDate : addedDate?? this.addedDate,
    deadline : deadline?? this.deadline,
  );

}
