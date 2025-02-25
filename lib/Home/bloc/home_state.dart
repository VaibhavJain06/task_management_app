part of 'home_bloc.dart';

@immutable
sealed class HomeState {}
abstract class HomeActionState extends HomeState{}
final class HomeInitial extends HomeState {}

final class TaskState extends HomeState{
  final TaskPriority selectedCategory;

  TaskState({required this.selectedCategory});
  
}


final class HomeErrorState extends HomeActionState{
  final String error;

  HomeErrorState({required this.error});
}

class HomeDataLoadedState extends HomeState{
  final List<Task> todayTask;
  final List<Task> tommorowTask;
  final List<Task> thisweekTask;
  final TaskPriority selectedCategory;
  
  HomeDataLoadedState(
    
    {required this.todayTask, 
    required this.tommorowTask, 
    required this.thisweekTask,
    this.selectedCategory = TaskPriority.low,
    });

     HomeDataLoadedState copyWith({
    List<Task>? todayTask,
    List<Task>? tommorowTask,
    List<Task>? thisweekTask,
    TaskPriority? selectedCategory,
  }) {
    return HomeDataLoadedState(
      todayTask: todayTask ?? this.todayTask,
      tommorowTask: tommorowTask ?? this.tommorowTask,
      thisweekTask: thisweekTask ?? this.thisweekTask,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
}
}

class LogoutState extends HomeActionState{}