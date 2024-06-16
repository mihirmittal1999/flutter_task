import 'package:flutter_task/base_bloc/bloc_builder.dart';
import 'package:flutter_task/base_bloc/bloc_states.dart';
import 'package:flutter_task/controller/api_controller.dart';
import 'package:flutter_task/controller/api_event.dart';
import 'package:flutter_task/model/api_data_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ApiDataModel? apiDataModel;
  final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
    context.read<ApiController>().add(GetApiDataEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: BlocBuilderNew<ApiController>(
        loadingView: (_) {
          return Container(
            color: Colors.white,
            alignment: Alignment.center,
            child: const CircularProgressIndicator(),
          );
        },
        onSuccess: (state) {
          if (state.event is GetApiDataEvent) {
            apiDataModel = (state.response?.data as ApiDataModel);
          } else if (state.event is RefreshGetApiDataEvent) {
            apiDataModel = (state.response?.data as ApiDataModel);
            snackbar('Data updated success');
          }
        },
        onFailed: (_) {
          snackbar(_.response?.message ?? 'Something wen\'t wrong');
        },
        defaultView: defaultView,
      ),
    );
  }

  Widget defaultView(BlocEventState? response) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<ApiController>().add(RefreshGetApiDataEvent());
      },
      child: ListView.separated(
        itemCount: apiDataModel?.items?.length ?? 0,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          return ListTile(
            leading: Image.network(
              apiDataModel?.items?[index].owner?.avatarUrl ?? '',
            ),
            title: Text(apiDataModel?.items?[index].name ?? ''),
          );
        },
      ),
    );
  }

  snackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      elevation: 10,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(5),
    ));
  }
}
