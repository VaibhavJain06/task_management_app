
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:task_management_app/Home/Ui/view_task.dart';
import 'package:task_management_app/Home/bloc/home_bloc.dart';
import 'package:task_management_app/models/task.dart';


class TaskItem extends StatelessWidget{
  const TaskItem({super.key,required this.tasks,});

  final List<Task> tasks;
 

  @override
  Widget build(context){

    return ListView.builder(
      itemCount:tasks.length,
      
      itemBuilder: (ctx, index) {
        
        return Dismissible(
          key: ValueKey(tasks[index]),
          background: Container(       
                    color: Colors.transparent,
                     alignment: Alignment.centerRight,
                     padding: EdgeInsets.symmetric(horizontal: 20),
                     child: Container(
              width: 40, 
              height: 40, 
              decoration: BoxDecoration(
                color: Colors.red, 
                shape: BoxShape.circle, 
              ),
              child: Icon(Icons.delete, color: Colors.white),
            )
               ),
         
          onDismissed: (direction){
             context.read<HomeBloc>().add(DeleteTaskEvent(context,  tasks[index],));
             
          },
          child: Padding(
            padding: EdgeInsets.all(5.0),
            child:Center(
              child:Container(
              
              height: 75,
              width: 350,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0),color: Colors.white,),
              child:GestureDetector(
                onTap: (){
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx)=>taskDetailScreen(
                        
                        title: tasks[index].title, 
                        description: tasks[index].description,
                        dateTime: tasks[index].dueDate,
                        task: tasks[index],
                        ),),);
                },
                child: ListTile(
                title: Text(tasks[index].title),
                subtitle: Text(
                  ' ${DateFormat('d MMM').format(tasks[index].dueDate)}', 
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                leading:  Icon(Icons.circle_outlined, color: const Color.fromARGB(255, 33, 79, 243)),
            trailing: Container(
              height: 25,
              width: 80,
              decoration: BoxDecoration(color: tasks[index].isCompleted?Colors.green:Colors.red,borderRadius: BorderRadius.circular(40.0)),
              child: Center(child: Text(tasks[index].isCompleted?'Completed':'In Progress',style: TextStyle(color: Colors.white),)),
              ), 
         ),
          ),
          ),
          ),
          ),
      );
      }
    );
  }
}