import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:grad_project_ver_1/features/clean_you_can/center/domain/entities/center_entity.dart';
import 'package:grad_project_ver_1/features/clean_you_can/center/domain/usecases/create_centerusecase.dart';
import 'package:grad_project_ver_1/features/clean_you_can/center/domain/usecases/get_center_info_usecase.dart';
import 'package:grad_project_ver_1/features/clean_you_can/center/domain/usecases/update_center_usecase.dart';

part 'center_general_event.dart';
part 'center_general_state.dart';

class CenterGeneralBloc
    extends Bloc<CenterGeneralEvent, CenterGeneralState> {
  CreateCenterusecase createCenterusecase;
  GetCenterInfoUsecase getCenterInfoUsecase;
  UpdatedCenterInfoUsecase updatedCenterInfoUsecase;
  CenterGeneralBloc({
    required this.createCenterusecase,
    required this.getCenterInfoUsecase,
    required this.updatedCenterInfoUsecase,
  }) : super(CenterGeneralInitial()) {
    on<CreateCenterEvent>(onCreateCenter);
    on<GetCenterInfoEvent>(onGetCenterInfo);
    on<UpdateCenterInfoEvent>(onCenterInfo);
  }

  FutureOr<void> onCreateCenter(
    CreateCenterEvent event,
    Emitter<CenterGeneralState> emit,
  ) async {
    emit(CenterGeneralLoadingState());
    final result = await createCenterusecase.call(event.createCenter);
    result.fold(
      (failure) {
        emit(CenterGeneralExceptionState(message: failure.message));
      },
      (unit) {
        emit(CenterGeneralCreatedState());
      },
    );
  }

  FutureOr<void> onGetCenterInfo(
    GetCenterInfoEvent event,
    Emitter<CenterGeneralState> emit,
  ) async {
    emit(CenterGeneralLoadingState());
    final result = await getCenterInfoUsecase.call(event.centerId);
    result.fold(
      (failure) {
        emit(CenterGeneralExceptionState(message: failure.message));
      },
      (centerInfo) {
        emit(CenterGeneralGotInfoState(centerInfo: centerInfo));
      },
    );
  }

  FutureOr<void> onCenterInfo(
    UpdateCenterInfoEvent event,
    Emitter<CenterGeneralState> emit,
  ) async {
    emit(CenterGeneralLoadingState());
    final result = await updatedCenterInfoUsecase.call(
      event.updatedCenter,
    );
    result.fold(
      (failure) {
        emit(CenterGeneralExceptionState(message: failure.message));
      },
      (unit) {
        emit(CenterGeneralInitial());
      },
    );
  }
}
