import 'package:flutter_task/base_bloc/bloc_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlocBuilderNew<T extends StateStreamable<BlocEventState>>
    extends StatelessWidget {
  //widgets for different state
  final Widget Function(BlocEventState) defaultView;
  final Widget Function(BlocEventState)? loadingView;

  //callbacks for different state
  final Function(BlocEventState)? onSuccess;
  final Function(BlocEventState)? onFailed;
  final Function(BlocEventState)? onLoading;

  const BlocBuilderNew({
    super.key,
    required this.defaultView,
    this.loadingView,
    this.onFailed,
    this.onSuccess,
    this.onLoading,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<T, BlocEventState>(
      builder: (context, state) {
        switch (state.state) {
          case BlocState.loading:
            return (loadingView == null)
                ? defaultView(state)
                : loadingView!(state);
          default:
            return defaultView(state);
        }
      },
      listener: (context, state) => _callback(state),
    );
  }

  Future<void> _callback(BlocEventState state) async {
    if (state.state == state.response?.prevState &&
        state.event == state.response?.prevEvent) {
      return;
    }
    switch (state.state) {
      case BlocState.failed:
        if (onFailed != null) onFailed!(state);
        break;
      case BlocState.success:
        if (onSuccess != null) onSuccess!(state);
        break;
      case BlocState.loading:
        if (onLoading != null) onLoading!(state);
        break;
      default:
    }
  }
}
