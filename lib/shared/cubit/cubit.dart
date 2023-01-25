
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/shared/cubit/states.dart';
import 'package:path/path.dart';
import '../../modeuls/archived_tasks/archived_tasks_screen.dart';
import '../../modeuls/done_screen/done_tasks_screen.dart';
import '../../modeuls/tasks_screen/tasks_screen.dart';
import '../components/constans.dart';


class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialStates());

  static AppCubit get(context)=>BlocProvider.of(context);
  int currentIdex = 0;

  List<Widget> screens = [
    TasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen(),
  ];

  List<String> titles = [
    'New tasks',
    'Done Tasks',
    'Archived Tasks'
  ];

  List<Map> newTasks =[];
  List<Map> doneTasks =[];
  List<Map> archiveTasks =[];

  void changeIndex(int index) {
    currentIdex = index;
    emit(AppChangeBottomNavBarState());
  }

  Database? database;
  void createDatabase(){
    var databasesPath=  getDatabasesPath();
    String path =  join( 'todo.db');
    openDatabase(
        path,
        version: 1,
        onCreate: (database, version) {
          database.execute('CREATE TABLE tasks (id INTEGER PRIMARY KEY,title TEXT, time TEXT,date TEXT,status TEXT)').then((value){
            print('created ==========================================');
          });

        },
        onOpen: (database) async {
          getData(database);
          print('is opened');
        }
    ).then((value) {
      database= value;
      emit(AppCreateDatabaseState());
    });

  }

   insertData({required String title, required String time, required String date}) async {
    Database database = await openDatabase('todo.db');
    return await database.transaction((txn) async {
      int id = await txn.rawInsert(
          'INSERT INTO tasks(title, time, date, status) VALUES("$title", "$time", "$date","new")');
    }).then((value) {
      print('insert sucessful ${title}');
      emit(AppInsertDatabaseState());

      getData(database);
    }).catchError((onError) {
      print(onError.toString());
    });
  }

 void getData(database)  {
    newTasks =[];
    doneTasks=[];
    archiveTasks=[];
    emit(AppGetDatabaseLoadingState());
     database.rawQuery('SELECT * FROM tasks').then((value) {
      
      value.forEach((element)  {
        if (element['status'] =='new')
          {newTasks.add(element);}
        else if (element['status']=='done')
          {doneTasks.add(element);}
        else {archiveTasks.add(element);}

      });
      emit(AppGetDatabaseState());
    });

  }
  void update({
    required String status,
    required int id
}){
    database!.rawUpdate("UPDATE tasks SET status= ? WHERE id= ? ",['$status',id]).then((value){
      getData(database);
      emit(AppUpdateDatabaseState());

    });
  }

  void deleteData({required int id}){
    database!.rawDelete('DELETE FROM tasks WHERE id=?',[id]).then((value){
      getData(database);

      emit(AppDeleteDatabaseState());
      print('DELETE');
    });
  }
  bool isShowBottomSheet = false;
  IconData faibIcon = Icons.edit;

  void changeBottomSheetState({required bool isShow, required IconData icon,})
  {
    isShowBottomSheet= isShow;
    faibIcon = icon;
    emit(AppChangeBottomSheetState());
  }
}