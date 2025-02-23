part of 'home_bloc.dart';

@immutable
sealed class HomeState {}
abstract class HomeActionState extends HomeState{}
final class HomeInitial extends HomeState {}

final class TaskState extends HomeState{
  final TaskPriority selectedCategory;

  TaskState({required this.selectedCategory});
  TaskState copyWith({TaskPriority? selectedCategory}) {
    return TaskState(
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }
}


final class HomeErrorState extends HomeActionState{
  final String error;

  HomeErrorState({required this.error});
}

class HomeDataLoadedState extends HomeState{
  final List<Task> todayTask;
  final List<Task> tommorowTask;
  final List<Task> thisweekTask;

  HomeDataLoadedState({required this.todayTask, required this.tommorowTask, required this.thisweekTask});
}

class LogoutState extends HomeActionState{}