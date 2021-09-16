import 'package:click_down/Models/listModel.dart';
import 'package:click_down/Models/spaceModel.dart';
import 'package:click_down/Models/taskModel.dart';
import 'package:click_down/Models/userModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseDB {
  static final FirebaseDB _dataBase = new FirebaseDB._internal();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  factory FirebaseDB() {
    return _dataBase;
  }
  FirebaseDB._internal();

  // Create a CollectionReference called users that references the firestore collection
  CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('Users');
  CollectionReference spacesCollection =
      FirebaseFirestore.instance.collection('Spaces'); 
  CollectionReference tasksCollection =
      FirebaseFirestore.instance.collection('Tasks');

  ////////////////////////////////////////////////////////////
  //-------------------Users Collection---------------------//
  ////////////////////////////////////////////////////////////

  Future<CustomUser?> getUserData(String? userId) async {
    QuerySnapshot querySnapshot;
    try {
      querySnapshot = await usersCollection
          .where(CustomUserFields.id, isEqualTo: userId)
          .get();
      if (querySnapshot.docs.toList().isNotEmpty) {
        QueryDocumentSnapshot<Object?> userData =
            querySnapshot.docs.toList()[0];
        return CustomUser(
            id: userData.get(CustomUserFields.id),
            username: userData.get(CustomUserFields.username),
            email: userData.get(CustomUserFields.email),
            picUrl: userData.get(CustomUserFields.picUrl));
      }
      return null;
    } catch (error) {
      print(error);
      return null;
    }
  }

  Future<bool> updateUser(CustomUser user) async {
    QuerySnapshot querySnapshot;
    try {
      querySnapshot = await usersCollection
          .where(CustomUserFields.id, isEqualTo: user.id)
          .get();
      if (querySnapshot.docs.toList().isNotEmpty) {
        QueryDocumentSnapshot<Object?> userDoc = querySnapshot.docs.toList()[0];
        print(userDoc.id);
        await usersCollection.doc(userDoc.id).update(user.toJSON());
        return true;
      }
      return false;
    } catch (error) {
      print(error);
      return false;
    }
  }

  Future<bool> createUser(CustomUser user) async {
    try {
      await usersCollection
          .add(user.toJSON()); //add as many fields as u want in the map
      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }

  Future<bool> deleteUser(CustomUser user) async {
    QuerySnapshot querySnapshot;
    try {
      querySnapshot = await usersCollection
          .where(CustomUserFields.id, isEqualTo: user.id) 
          .get();
      if (querySnapshot.docs.toList().isNotEmpty) {
        QueryDocumentSnapshot<Object?> userDoc =
            querySnapshot.docs.toList()[0];
        await usersCollection.doc(userDoc.id).delete();
        return true;
      }
      return false;
    } catch (error) {
      print(error);
      return false;
    }
  }

  ////////////////////////////////////////////////////////////
  //-------------------Spaces Collection---------------------//
  ////////////////////////////////////////////////////////////

  Future<List<SpaceModel>> getSpaces(String? userId) async {
    QuerySnapshot querySnapshot;
    try {
      querySnapshot = await spacesCollection
          .where(SpaceModelFields.userId, isEqualTo: userId)
          .get();
      if (querySnapshot.docs.toList().isNotEmpty) {
        List<QueryDocumentSnapshot<Object?>> queryResults =
            querySnapshot.docs.toList();
        List<SpaceModel> returnedList = queryResults
            .map((space){ 
              List<dynamic> spaceListsdynamic = space.get(SpaceModelFields.spaceLists) as List<dynamic>;
              List<ListModel> spaceLists = spaceListsdynamic.map((e) => ListModel.fromJson(e)).toList();
              return SpaceModel(
                  userId: space.get(SpaceModelFields.userId) as String,
                  spaceId: space.get(SpaceModelFields.spaceId) as String,
                  spaceName: space.get(SpaceModelFields.spaceName) as String,
                  spaceLists: spaceLists,
                  timeStamp: DateTime.parse( space.get(SpaceModelFields.timeStamp) as String),
                  color: space.get(SpaceModelFields.color) as int,
                );})
            .toList();
        return returnedList;
      }
      return [];
    } catch (error) {
      print(error);
      return [];
    }
  }

  Future<bool> updateSpace(SpaceModel spaceModel) async {
    try {
      await spacesCollection
          .doc(spaceModel.spaceId)
          .update(spaceModel.toJSON());
        return true;
    } catch (error) {
      print(error);
      return false;
    }
  }

  Future<bool> createSpace(SpaceModel spaceModel) async {
    try {
      DocumentReference<Object?> spaceRef = await spacesCollection
          .add(spaceModel.toJSON()); //add as many fields as u want in the map
      spacesCollection.doc(spaceRef.id).update(spaceModel.copy(spaceId: spaceRef.id).toJSON());
      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }

  Future<bool> deleteSpace(SpaceModel spaceModel) async {
    try {
      await spacesCollection.doc(spaceModel.spaceId).delete();
      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }

  
  ////////////////////////////////////////////////////////////
  //-------------------Task Collection---------------------//
  ////////////////////////////////////////////////////////////

  Future<List<TaskModel>> getTasks(String? spaceId, String listId) async {
    QuerySnapshot querySnapshot;
    try {
      querySnapshot = await tasksCollection
          .where(TaskModelFields.spaceId, isEqualTo: spaceId)
          .where(TaskModelFields.listId, isEqualTo: listId)
          .get();
      if (querySnapshot.docs.toList().isNotEmpty) {
        List<QueryDocumentSnapshot<Object?>> queryResults =
            querySnapshot.docs.toList();
        List<TaskModel> returnedList = queryResults
            .map((task){ 
              String? dd = task.get(TaskModelFields.deadline);
              DateTime? deadline;
              if(dd!="null"){
                deadline = DateTime.parse( dd as String );
              }else{
                deadline = null;
              }
              return TaskModel(
              spaceId: task.get(TaskModelFields.spaceId) as String ,
              listId: task.get(TaskModelFields.listId) as String ,
              taskDescription: task.get(TaskModelFields.taskDescription) as String ,
              taskName: task.get(TaskModelFields.taskName) as String ,
              taskId: task.get(TaskModelFields.taskId) as String ,
              deadline: deadline,
              done: task.get(TaskModelFields.done) as bool,
              addedDate:  DateTime.parse( task.get(TaskModelFields.addedDate) as String ));
            }).toList();
        return returnedList;
      }
      return [];
    } catch (error) {
      print(error);
      return [];
    }
  }

  Future<bool> updateTask(TaskModel taskModel) async {
    try {
      await tasksCollection
          .doc(taskModel.taskId)
          .update(taskModel.toJSON());
        return true;
    } catch (error) {
      print(error);
      return false;
    }
  }

  Future<TaskModel?> createTask(TaskModel taskModel) async {
    try {
      DocumentReference<Object?> taskRef = await tasksCollection
          .add(taskModel.toJSON()); //add as many fields as u want in the map
      tasksCollection.doc(taskRef.id).update(taskModel.copy(taskId: taskRef.id).toJSON());
      return taskModel.copy(taskId: taskRef.id);
    } catch (error) {
      print(error);
      return null;
    }
  }

  Future<bool> deleteTask(TaskModel taskModel) async {
    try {
      await tasksCollection.doc(taskModel.taskId).delete();
      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }


  Future<bool> deleteList(String listId,SpaceModel spaceModel) async {
    try {
      List<TaskModel> tasks = await getTasks(spaceModel.spaceId, listId);
      for (var task in tasks) {
        await deleteTask(task);
      }
      spaceModel.spaceLists.removeWhere((element) => element.listId==listId);
      updateSpace(spaceModel);
      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }
  

}