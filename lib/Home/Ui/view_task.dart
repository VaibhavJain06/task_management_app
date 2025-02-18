import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:task_management_app/Home/bloc/home_bloc.dart';
import 'package:task_management_app/models/task.dart';

class taskDetailScreen extends StatefulWidget {
  const taskDetailScreen({super.key, required this.title, required this.description, required this.dateTime, required this.task});
  final String title;
  final String description;
  final DateTime dateTime;
  final Task task;
  
  @override
  _taskDetailScreenState createState() => _taskDetailScreenState();
}

class _taskDetailScreenState extends State<taskDetailScreen> {
   bool isCompleted = false;
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  @override
  void initState(){
    super.initState();
    _titleController = TextEditingController(text: widget.title);
    _descriptionController = TextEditingController(text: widget.description);
     isCompleted = widget.task.isCompleted;
  }

  @override
  void dispose(){
    super.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
             
              children: [
                _buildHeader(),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 6,
                          offset: Offset(0, -5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildStatusSection(),
                        SizedBox(height: 30),
                        _buildTitleSection(),
                        SizedBox(height: 20),
                        _buildDescriptionSection(),
                         SizedBox(height: 50),
                        _buildActionButton(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pop(context),
          ),
         
        ],
      ),
    );
  }

  Widget _buildStatusSection() {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isCompleted ? Colors.green[50] : Colors.orange[50],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isCompleted ? Colors.green : Colors.orange,
                ),
              ),
              SizedBox(width: 8),
              Text(
                isCompleted ? 'Completed' : 'In Progress',
                style: TextStyle(
                  color: isCompleted ? Colors.green : Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Spacer(),
        Text(
          DateFormat('d MMM').format(widget.dateTime).toString(),
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildTitleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Task Title',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            IconButton(
              onPressed: (){}, 
              icon:  Icon(Icons.edit),
              ),
          ],
        ),
        SizedBox(height: 8),
        Container(
          width: 350,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.grey[200]!),
          ),
           child: TextField(
            decoration: InputDecoration(border: InputBorder.none),
            controller: _titleController),
          
        ),
      ],
    );
  }

  Widget _buildDescriptionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Description',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            IconButton(
              onPressed: (){},
              icon: Icon(Icons.edit)),
          ],
        ),
        SizedBox(height: 8),
        Container(
          height: 220,
          width: 350,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: TextField(
            
            decoration: InputDecoration(border: InputBorder.none),
            controller: _descriptionController),
        ),
      ],
    );
  }

  Widget _buildActionButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: 150.0,
          height: 60.0,
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                isCompleted = !isCompleted;
               
              });
               context.read<HomeBloc>().add(StatusUpdateEvent(task: widget.task, isCompleted: isCompleted));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    isCompleted
                        ? 'Task marked as completed!'
                        : 'Task marked as incomplete!',
                  ),
                  backgroundColor: isCompleted ? Colors.green : Colors.orange,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
             
            
             
             context.read<HomeBloc>().add(getDataEvent());
             Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isCompleted ? const Color.fromARGB(201, 244, 67, 54) : Colors.blue[600],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 2,
            ),
            child: Row(
             mainAxisAlignment: MainAxisAlignment.center,
              children: [
              
                Text(
                  isCompleted ? 'Incomplete' : 'Completed',
                  style: TextStyle(
                    color: const Color.fromARGB(137, 0, 0, 0),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          width: 150.0,
          height: 60.0,
          child: ElevatedButton(
            onPressed: () {
            context.read<HomeBloc>().add(ViewAndEditTaskEvent(
              widget.task,
              newTitle:_titleController.text,
               newDescrption: _descriptionController.text, ));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    
                        'Updated successfully',
                  ),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
              context.read<HomeBloc>().add(getDataEvent());
               Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 2,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
               
                Text(
                  'Update',
                  style: TextStyle(
                    color: const Color.fromARGB(151, 0, 0, 0),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

