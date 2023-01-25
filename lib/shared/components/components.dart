
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/shared/components/constans.dart';
import 'package:todo/shared/cubit/cubit.dart';
import 'package:todo/shared/cubit/states.dart';

Widget buildTasksItem(Map model, context)=>Dismissible(
  key: Key(model['id'].toString()),
  child:   Padding(

    padding: const EdgeInsets.all(20.0),

    child: Row(

      children: [

        CircleAvatar(

          backgroundColor: Colors.blue,

          radius: 40.0,

          child: Text('${model['time']}'),

        ),

        SizedBox(

          width: 20.0,

        ),

        Expanded(

          child: Column(

            mainAxisSize: MainAxisSize.min,

            children: [

              Text(

                '${model['title']}',

                style: TextStyle(

                  fontSize: 18.0,

                  fontWeight: FontWeight.bold,

                ),

              ),

              Text(

                '${model['date']}',

                style: TextStyle(

                    color:Colors.grey

                ),

              )

            ],

          ),

        ),

        SizedBox(

          width: 20.0,

        ),

        IconButton(

            onPressed: (){

              AppCubit.get(context).update(status: 'done', id: model['id']);

            },

            icon: Icon(

                Icons.check_box,

                color: Colors.green,

            )),

        IconButton(

            onPressed: (){

              AppCubit.get(context).update(status: 'archive', id: model['id']);

            },

            icon: Icon(

                Icons.archive_outlined,

               color: Colors.black45,

            ))

      ],

    ),

  ),
  onDismissed: (direction){
    AppCubit.get(context).deleteData(id: model['id'],);
  },
);

Widget tasksBuilder({required List<Map> tasks})=>ConditionalBuilder(
  condition:tasks.length > 0 ,
  builder: (context)=>ListView.separated(
      itemBuilder: (context, index)=>buildTasksItem(tasks[index],context),
      separatorBuilder: (context,index)=>Padding(
        padding: const EdgeInsetsDirectional.only(
          start: 20.0,
        ),
        child: Container(
          width: double.infinity,
          height: 1.0,
          color:Colors.grey[300],
        ),
      ),
      itemCount: tasks.length
  ),
  fallback: (context)=>Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.menu,
          size: 100.0,
          color: Colors.grey,
        ),
        Text(
          'Not Tasks yet! please Add Some Tasks',
          style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            color: Colors.grey
          ),
        ),
      ],
    ),
  ),
);
