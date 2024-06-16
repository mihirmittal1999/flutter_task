import 'package:flutter_task/base_bloc/bloc_event.dart';
import 'package:flutter_task/base_bloc/bloc_states.dart';

class BlocResponse<T> {
  final BlocState? state;
  final BlocEvent? event;
  final T? data;
  final String? message;
  BlocState? prevState;
  BlocEvent? prevEvent;

  BlocResponse({
    this.state,
    this.event,
    this.data,
    this.message,
    this.prevState,
    this.prevEvent,
  });
}
