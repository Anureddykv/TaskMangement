import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_mangement_project/repositry/task_repository.dart';
import 'task_event.dart';
import 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskRepository taskRepository;

  TaskBloc(this.taskRepository) : super(TaskInitial()) {
    on<LoadTasks>((event, emit) async {
      emit(TaskLoading());
      try {
        final tasks = await taskRepository.getTasks();
        print("Tasks Loaded: $tasks");
        emit(TaskLoaded(tasks));
      } catch (e) {
        print("Error Loading Tasks: $e");
        emit(TaskError("Failed to load tasks"));
      }
    });



    on<AddTask>((event, emit) async {
      try {
        final newTask = await taskRepository.createTask(event.title);

        if (state is TaskLoaded) {
          final updatedTasks = List<Map<String, dynamic>>.from((state as TaskLoaded).tasks);
          updatedTasks.add(newTask);
          emit(TaskLoaded(updatedTasks));
        }
      } catch (e) {
        emit(TaskError("Failed to add task"));
      }
    });


    on<DeleteTask>((event, emit) async {
      try {
        await taskRepository.deleteTask(event.id);

        if (state is TaskLoaded) {
          final updatedTasks = List<Map<String, dynamic>>.from((state as TaskLoaded).tasks);
          updatedTasks.removeWhere((task) => task["id"] == event.id);
          emit(TaskLoaded(updatedTasks));
        }
      } catch (e) {
        emit(TaskError("Failed to delete task"));
      }
    });

    on<UpdateTask>((event, emit) async {
      try {
        final updatedTask = await taskRepository.updateTask(event.id, event.title,  event.completed);

        if (state is TaskLoaded) {
          final updatedTasks = (state as TaskLoaded).tasks.map((task) {
            return task["id"] == event.id
                ? {
              "id": event.id,
              "title": event.title,
              "description": event.description,
              "completed": event.completed
            }
                : task;
          }).toList();

          emit(TaskLoaded(updatedTasks));
        }
      } catch (e) {
        emit(TaskError("Error updating task"));
      }
    });


  }
}
