import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:task_management_app/models/task.dart';

part 'home_event.dart';
part 'home_state.dart';



class HomeBloc extends Bloc<HomeEvent, HomeState> {


  HomeBloc() : super(HomeInitial()) {
    on<AddTaskEvent>((event, emit) {
      final user = FirebaseAuth.instance.currentUser;
    try{
      FirebaseFirestore.instance.collection('Users').doc(user!.uid).collection('Tasks').add({
      'Title':event.title,
      'Description':event.description,
      'Due date':event.dueDate,
      'Priority':event.priority.name,
      'isCompleted':false,
     });
     add(getDataEvent());
    }catch(e){
      emit(HomeErrorState(error: 'Something went wrong'));
    }
      
    
    });
    
    on<DeleteTaskEvent>((event, emit) {
      final user = FirebaseAuth.instance.currentUser;
      final task = event.task;
      
   if (state is HomeDataLoadedState) {
    final loadedState = state as HomeDataLoadedState;

   
    if (loadedState.todayTask.contains(task)) {
      loadedState.todayTask.remove(task);
    } else if (loadedState.tommorowTask.contains(task)) {
      loadedState.tommorowTask.remove(task);
    } else if (loadedState.thisweekTask.contains(task)) {
      loadedState.thisweekTask.remove(task);
    }
     
      emit(HomeDataLoadedState(
      todayTask: loadedState.todayTask,
      tommorowTask: loadedState.tommorowTask,
      thisweekTask: loadedState.thisweekTask,
    ));

      
  
       FirebaseFirestore.instance.collection('Users').doc(user!.uid).collection('Tasks').doc(event.task.id).delete();
       add(getDataEvent());
   }
    
    }
    );

    
    on<getDataEvent>((event, emit) async{
      final user = FirebaseAuth.instance.currentUser;

      List<Task> todayTask = [];

      List<Task> tommorowTask = [];

      List<Task> thisweekTask = [];
      QuerySnapshot taskData = await FirebaseFirestore.instance.collection('Users').doc(user!.uid).collection('Tasks').get();
      
      DateTime today = DateTime.now();
      DateTime tomorrow = today.add(Duration(days: 1));
      DateTime startOfWeek = today.subtract(Duration(days: today.weekday - 1)); 
      DateTime endOfWeek = startOfWeek.add(Duration(days: 6)); 

      List<Task> tasks = taskData.docs.map((doc){
        DateTime dueDate = (doc['Due date'] as Timestamp).toDate();
      //  String priorityValue = doc['Priority']; 
          Task task = Task(
          id:doc.id,
          title: doc['Title'], 
          description: doc['Description'], 
          dueDate: (doc['Due date'] as Timestamp).toDate(), 
          priority: getPriorityFromString(doc['Priority']),
          isCompleted: doc['isCompleted'],
          );
          
          
        if (_isSameDay(dueDate, today)) {
          todayTask.add(task);
        } else if (_isSameDay(dueDate, tomorrow)) {
          tommorowTask.add(task);
        } else if (dueDate.isAfter(startOfWeek) && dueDate.isBefore(endOfWeek)) {
          thisweekTask.add(task);
        }


        return task;
      }).toList();

        todayTask.sort((a, b) => b.priority.index.compareTo(a.priority.index));
        tommorowTask.sort((a, b) => b.priority.index.compareTo(a.priority.index));
        thisweekTask.sort((a, b) => b.priority.index.compareTo(a.priority.index));

      emit(HomeDataLoadedState(
        todayTask: todayTask, 
        tommorowTask: tommorowTask, 
        thisweekTask: thisweekTask,
        ));
     },
   
    
  );
   on<ViewAndEditTaskEvent>((event, emit) {
      final user = FirebaseAuth.instance.currentUser;
      FirebaseFirestore.instance.collection('Users').doc(user!.uid).collection('Tasks').doc(event.task.id).update({
        'Title':event.newTitle,
        'Description':event.newDescrption,
      });
      add(getDataEvent());
   },);

   on<StatusUpdateEvent>((event, emit) {
      final user = FirebaseAuth.instance.currentUser;
      FirebaseFirestore.instance.collection('Users').doc(user!.uid).collection('Tasks').doc(event.task.id).update({
        'isCompleted':event.isCompleted,
      });
      
   },);

   on<LogoutEvent>((event, emit) {
     FirebaseAuth.instance.signOut();
     emit(LogoutState());
   },);

  }
}



bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  TaskPriority getPriorityFromString(String priority) {
  switch (priority.toLowerCase()) {
    case 'low':
      return TaskPriority.low;
    case 'medium':
      return TaskPriority.medium;
    case 'high':
      return TaskPriority.high;
    default:
      return TaskPriority.low; // Default fallback
  }
}
