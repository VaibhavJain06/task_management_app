import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_management_app/Home/Ui/task_item.dart';
import 'package:task_management_app/Home/bloc/home_bloc.dart';


import 'package:flutter/material.dart';

import 'package:task_management_app/Home/Ui/new_task.dart';

import 'package:task_management_app/models/task.dart'; 


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
 
  

 @override
  void initState(){
   super.initState();
   context.read<HomeBloc>().add(getDataEvent());
 }


  void _openAddTaskOverlay(){
    showModalBottomSheet(
        useSafeArea: true,
        isScrollControlled: true,
        context: context,
        builder: (ctx) => NewTask(),
    );
  }


  @override
  Widget build(context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      backgroundColor: const Color.fromARGB(246, 255, 255, 255),
      body: BlocConsumer<HomeBloc, HomeState>(
        
        listenWhen: (previous, current) => current is HomeActionState,
        buildWhen: (previous, current) => current is !HomeActionState,
        listener: (context, state) {
        },
        builder: (context, state) {
         if(state is HomeDataLoadedState){
             return SingleChildScrollView(
              child:  Column(
             
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
             
              _buildHeader(),
              
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Today',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),)),
            _buildTaskItem(state.todayTask),
            SizedBox(height: 15),
             Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Tommorow',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),)),
            _buildTaskItem(state.tommorowTask),
            SizedBox(height: 15),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('This week',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),)),
            _buildTaskItem(state.thisweekTask),
          ],
             
        ),
             
             );
         }
         return Center(child: CircularProgressIndicator());
        }
      ),
      floatingActionButton: FloatingActionButton(
        
        onPressed: () {
          _openAddTaskOverlay();
        },
        shape: CircleBorder(),
        backgroundColor: Color.fromARGB(255, 108, 99, 255),
         child: Icon(Icons.add,color: Colors.white),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildHeader() {
    return Container( 
        color: Colors.blue,
        height:168,
        width: MediaQuery.of(context).size.width,
        child:
       Padding(padding: EdgeInsets.only(top: 40.0,left: 10.0,right: 10.0),child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
           
            children: [
              Icon(Icons.grid_view, color: Colors.white),
            Container(
                width: 220,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search, color: Colors.black),
                    border: InputBorder.none,
                    
                  ),
                ),
              ),
              
              GestureDetector(
                onTap: (){
                  context.read<HomeBloc>().add(LogoutEvent());
                },
                child: Icon(Icons.logout, color: Colors.white),
                ),

            ],

          ),
        
          SizedBox(height: 20),
          Text(
            'Today, ${DateTime.now().day} May',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'My tasks',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
       ),
    );
  }


 
  
  Widget _buildTaskItem(List<Task> tasks) {
    if (tasks.isEmpty) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Text(
          "No tasks available",
          style: TextStyle(fontSize: 20, color: Colors.grey),
        ),
      ),
    );
  }
    return SizedBox(
      height: 200,
      child: TaskItem(tasks: tasks),
   
    );
  }

  Widget _buildBottomBar() {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Icon(Icons.list, color: Color(0xFF6C63FF)),
          Icon(Icons.calendar_today, color: Colors.grey),
        ],
      ),
    );
  }
}