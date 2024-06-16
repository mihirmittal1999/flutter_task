import 'package:flutter_task/base_bloc/bloc_event.dart';
import 'package:flutter_task/base_bloc/bloc_response.dart';

enum BlocState { none, loading, success, failed }

class BlocEventState {
  BlocState state;
  BlocEvent? event;
  BlocResponse? response;

  BlocEventState({required this.state, this.response, this.event});
}
