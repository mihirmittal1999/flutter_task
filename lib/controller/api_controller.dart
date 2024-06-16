import 'dart:convert';
import 'dart:developer';

import 'package:flutter_task/base_bloc/bloc_event.dart';
import 'package:flutter_task/base_bloc/bloc_response.dart';
import 'package:flutter_task/base_bloc/bloc_states.dart';
import 'package:flutter_task/controller/api_event.dart';
import 'package:flutter_task/locl_db/database_helper.dart';
import 'package:flutter_task/model/api_data_model.dart';
import 'package:flutter_task/services/api_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ApiController extends Bloc<BlocEvent, BlocEventState> {
  ApiController()
      : super(
          BlocEventState(
            state: BlocState.none,
            event: GetApiDataEvent(),
            response: null,
          ),
        ) {
    on<GetApiDataEvent>(getApiData);
    on<RefreshGetApiDataEvent>(getApiData);
  }

  Future<void> getApiData(event, Emitter<BlocEventState> emit) async {
    try {
      emit(BlocEventState(state: BlocState.loading, event: event));

      var responce = await ApiService().getRequest();

      if (responce.statusCode == 200) {
        var result = await localDB(responce.body);
        emit(
          BlocEventState(
            state: BlocState.success,
            event: event,
            response: BlocResponse(data: result),
          ),
        );
      } else {
        emit(
          BlocEventState(
            state: BlocState.failed,
            event: event,
            response: BlocResponse(message: responce.body),
          ),
        );
      }
    } catch (e) {
      emit(
        BlocEventState(
          state: BlocState.failed,
          event: event,
          response: BlocResponse(message: ''),
        ),
      );
      log(e.toString());
      return Future.error(e);
    }
  }

  Future<ApiDataModel> localDB(String responce) async {
    var dbInstance = DatabaseHelper.dbInstance;

    /// store data in local db
    await dbInstance.insertApiData({'ApiData': responce});

    /// fetch data in local db
    var data = await dbInstance.getApiData();

    /// convert into model

    return ApiDataModel.fromJson(
      jsonDecode((data.first as Map).values.first.toString()),
    );
  }
}
