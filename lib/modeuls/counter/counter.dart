import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/modeuls/counter/cubit/cubit.dart';
import 'package:todo/modeuls/counter/cubit/states.dart';

class MyCounter extends StatelessWidget {
   MyCounter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context)=>CounterCubit(),
      child: BlocConsumer<CounterCubit, CounterStates>(
        listener: (context, state){
          if(state is CounterMinusState) print('Minus state ${state.counter}');
          if(state is CounterPlusState) print('Plus state ${state.counter}');
        },
        builder: (context, state){
          return Scaffold(
            body: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MaterialButton(
                    onPressed: (){
                      CounterCubit.get(context).plus();
                    },
                    child: Icon(Icons.add, color: Colors.blue,),

                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Text('${CounterCubit.get(context).counter}'),
                  SizedBox(
                    width: 15.0,
                  ),
                  MaterialButton(
                    onPressed: (){
                     CounterCubit.get(context).minus();

                    },
                    child: Icon(Icons.minimize,color: Colors.blue,),

                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
