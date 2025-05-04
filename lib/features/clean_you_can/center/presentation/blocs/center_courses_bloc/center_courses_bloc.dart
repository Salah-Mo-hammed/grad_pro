import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:grad_project_ver_1/features/clean_you_can/center/domain/usecases/create_course_usecase.dart';
import 'package:grad_project_ver_1/features/clean_you_can/center/domain/usecases/delete_course_usecase.dart';
import 'package:grad_project_ver_1/features/clean_you_can/center/domain/usecases/get_center_courses_usecase.dart';
import 'package:grad_project_ver_1/features/clean_you_can/center/domain/usecases/update_course_usecase.dart';
import 'package:grad_project_ver_1/features/clean_you_can/course/domain/entities/course_entity.dart';

part 'center_courses_event.dart';
part 'center_courses_state.dart';

class CenterCoursesBloc
    extends Bloc<CenterCoursesEvent, CenterCoursesState> {
  AddCourseUsecase addCourseUsecase;
  UpdateCourseUsecase updateCourseUsecase;
  GetCenterCoursesUsecase getCenterCoursesUsecase;
  DeleteCourseUsecase deleteCourseUsecase;
  CenterCoursesBloc({
    required this.deleteCourseUsecase,
    required this.updateCourseUsecase,
    required this.addCourseUsecase,
    required this.getCenterCoursesUsecase,
  }) : super(CenterCoursesInitial()) {
    on<AddCourseEvent>(onAddCourse);
    on<GetCenterCoursesEvent>(onGetCenterCourses);
    on<UpdateCourseEvent>(onUpdateCourse);
    on<DeleteCourseEvent>(onDeleteCourse);
  }

  FutureOr<void> onAddCourse(
    AddCourseEvent event,
    Emitter<CenterCoursesState> emit,
  ) async {
    emit(CenterCoursesLoadingState());
    final result = await addCourseUsecase.call(event.addCourseEntity);
    result.fold(
      (failure) {
        emit(CenterCoursesExceptionState(message: failure.message));
      },
      (addedCourse) {
        emit(CenterAddedCourseState(courseEntity: addedCourse));
      },
    );
  }

  FutureOr<void> onGetCenterCourses(
    GetCenterCoursesEvent event,
    Emitter<CenterCoursesState> emit,
  ) async {
    emit(CenterCoursesLoadingState());

    final result = await getCenterCoursesUsecase.call(event.centerId);
    result.fold(
      (failure) {
        emit(CenterCoursesExceptionState(message: failure.message));
      },
      (courses) {
        emit(CenterGotCoursesState(courses: courses));
      },
    );
  }

  FutureOr<void> onUpdateCourse(
    UpdateCourseEvent event,
    Emitter<CenterCoursesState> emit,
  ) async {
    emit(CenterCoursesLoadingState());
    final result = await updateCourseUsecase.call(
      event.updateCourseEntity,
    );
    result.fold(
      (failure) {
        emit(CenterCoursesExceptionState(message: failure.message));
      },
      (successMessage) {
        emit(CenterUpdatedCourseState(updated: successMessage));
      },
    );
  }

  FutureOr<void> onDeleteCourse(
    DeleteCourseEvent event,
    Emitter<CenterCoursesState> emit,
  ) async {
    emit(CenterCoursesLoadingState());
    final result = await deleteCourseUsecase.call(event.courseId);
    result.fold(
      (failure) {
        emit(CenterCoursesExceptionState(message: failure.message));
      },
      (success) {
        emit(CenterCoursesInitial());
      },
    );
  }
}
