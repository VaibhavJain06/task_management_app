part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}

final class AddTaskEvent extends HomeEvent{
  final String title;
  final String description;
  final DateTime dueDate;
  final TaskPriority priority;
  final BuildContext context;

  AddTaskEvent( {required this.title, required this.description,required this.context,required this.dueDate, required this.priority});
}
final class getDataEvent extends HomeEvent{}
final class DeleteTaskEvent extends HomeEvent{
  final Task task;
  
  final BuildContext context;
  DeleteTaskEvent(this.context, this.task, );
}
final class ViewAndEditTaskEvent extends HomeEvent{
  final Task task;
  final String newTitle;
  final String newDescrption;

  ViewAndEditTaskEvent(this.task, {required this.newTitle, required this.newDescrption});
}

final class StatusUpdateEvent extends HomeEvent{
  final Task task;
  final bool isCompleted;

  StatusUpdateEvent({required this.task, required this.isCompleted});
}

final class LogoutEvent extends HomeEvent{}