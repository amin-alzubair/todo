import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/modeuls/done_screen/done_tasks_screen.dart';
import 'package:todo/modeuls/tasks_screen/tasks_screen.dart';
import 'package:todo/shared/cubit/cubit.dart';
import 'package:todo/shared/cubit/states.dart';
import '../../modeuls/archived_tasks/archived_tasks_screen.dart';
import '../../shared/components/constans.dart';


class MainLayout extends StatelessWidget {
   MainLayout({Key? key}) : super(key: key);
Database? database;

  var keyScaffold = GlobalKey<ScaffoldState>();
  var keyForm = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (BuildContext context)=>AppCubit()..createDatabase(),
      child:BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context,AppStates state ){
          if(state is AppInsertDatabaseState){
            Navigator.pop(context);
          }
        },
        builder: (BuildContext context, AppStates state){
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: keyScaffold,
            appBar: AppBar(
              title: Text(cubit.titles[cubit.currentIdex]),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                //createDatabase();
                if (cubit.isShowBottomSheet) {
                  if (keyForm.currentState!.validate()) {
                    cubit.insertData(
                        title: titleController.text,
                        time: timeController.text,
                        date: dateController.text
                    );
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
                    cubit.changeBottomSheetState(isShow:false, icon:Icons.edit);

                  });
                  cubit.changeBottomSheetState(isShow: true, icon: Icons.add);
                }
              },
              child: Icon(cubit.faibIcon),
            ),
            body: ConditionalBuilder(
              condition:state is! AppGetDatabaseLoadingState,
              builder: (context)=> cubit.screens[cubit.currentIdex],
              fallback: (context)=>Center(child: CircularProgressIndicator()),
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: cubit.currentIdex,
              onTap: (index) {

                cubit.changeIndex(index);

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
        },
      ),
    );
  }


}
