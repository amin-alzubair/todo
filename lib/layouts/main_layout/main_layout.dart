import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/modeuls/done_screen/done_tasks_screen.dart';
import 'package:todo/modeuls/tasks_screen/tasks_screen.dart';
import 'package:path/path.dart';
import '../../modeuls/archived_tasks/archived_tasks_screen.dart';

class MainLayout extends StatefulWidget {
   MainLayout({Key? key}) : super(key: key);

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
@override
  void initState() {

    super.initState();
    createDatabase();
    getData();
  }
  int currentIdex = 0;
  var keyScaffold = GlobalKey<ScaffoldState>();
  var keyForm = GlobalKey<FormState>();
  bool isShowBottomSheet = false;
  IconData faibIcon = Icons.edit;
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();
  Future<Database>? database;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: keyScaffold,
      appBar: AppBar(
        title: Text(titles[currentIdex]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //createDatabase();
          if (isShowBottomSheet) {
            if (keyForm.currentState!.validate()) {
               insertData(
                   title: titleController.text,
                   time: timeController.text,
                   date: dateController.text
               ).then((value) {
                 Navigator.pop(context);
                 isShowBottomSheet = false;
                 //titleController.text = '';
                 setState(() {
                   faibIcon = Icons.edit;
                 });
               });
            }
          } else {
            keyScaffold.currentState!.showBottomSheet(
                    (context) =>
                    Container(
                      padding: EdgeInsets.all(20.0),
                      color: Colors.white,
                      child: Form(
                        key: keyForm,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [

                            TextFormField(
                              controller: titleController,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                  labelText: 'Enter Title',
                                  prefixIcon: Icon(Icons.title),
                                  border: OutlineInputBorder()
                              ),
                              validator: (String? value) {
                                if (value!.isEmpty) {
                                  return 'Title is required';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 15.0,),
                            TextFormField(
                              controller: timeController,
                              keyboardType: TextInputType.datetime,
                              decoration: InputDecoration(
                                  labelText: 'time',
                                  prefixIcon: Icon(Icons.watch),
                                  border: OutlineInputBorder()
                              ),
                              validator: (String? value) {
                                if (value!.isEmpty) {
                                  return 'time is required';
                                }
                                return null;
                              },
                              onTap: () {
                                showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now()
                                ).then((value) {
                                  timeController.text =
                                      value!.format(context).toString();
                                });
                              },
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            TextFormField(
                              controller: dateController,
                              keyboardType: TextInputType.datetime,
                              decoration: InputDecoration(
                                  labelText: 'date',
                                  prefixIcon: Icon(Icons.calendar_today),
                                  border: OutlineInputBorder()
                              ),
                              validator: (String? value) {
                                if (value!.isEmpty) {
                                  return 'date is required';
                                }
                                return null;
                              },
                              onTap: () {
                                showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime.parse('2023-03-09')
                                ).then((value) {
                                  dateController.text =
                                      DateFormat.yMMMd().format(value!);
                                });
                              },
                            ),

                          ],

                        ),
                      ),
                    ),
              elevation: 20.0,
            ).closed.then((value) {
              isShowBottomSheet = false;
              //titleController.text = '';
              setState(() {
                faibIcon = Icons.edit;
              });
            });
            isShowBottomSheet = true;
            setState(() {
              faibIcon = Icons.add;
            });
          }
        },
        child: Icon(faibIcon),
      ),
      body: screens[currentIdex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIdex,
        onTap: (index) {
          setState(() {
            currentIdex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: 'Tasks',

          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_box),
            label: 'Done',

          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.archive_outlined),
            label: 'Archived',

          ),
        ],
      ),
    );
  }

  void createDatabase() async{
    var databasesPath= await getDatabasesPath();
    String path =  join( 'todo.db');
    var database = await openDatabase(
        path,
        version: 1,
        onCreate: (database, version) {
          database.execute('CREATE TABLE tasks (id INTEGER PRIMARY KEY,title TEXT, time TEXT,date TEXT,status TEXT)').then((value){
            print('created ==========================================');
          });

        },
        onOpen: (database) {
          print('is opened');
        }
    );
  }

  Future insertData({required String title, required String time, required String date}) async {
    Database database = await openDatabase('todo.db');
    return await database.transaction((txn) async {
      int id = await txn.rawInsert(
          'INSERT INTO tasks(title, time, date, status) VALUES("$title", "$time", "$date","new")');
    }).then((value) {
      print('insert sucessful ${title}');
    }).catchError((onError) {
      print(onError.toString());
    });
  }

  Future getData() async {
    Database database = await openDatabase('todo.db');
    return await database.transaction((txn) async{
      List tasks = await txn.rawQuery('SELECT * FROM tasks');
      print(tasks.first['title']);
    });

  }
}
