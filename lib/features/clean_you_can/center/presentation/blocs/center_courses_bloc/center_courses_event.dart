part of 'center_courses_bloc.dart';

sealed class CenterCoursesEvent  {
  const CenterCoursesEvent();
}
class AddCourseEvent extends CenterCoursesEvent {
  CourseEntity addCourseEntity;
  AddCourseEvent({required this.addCourseEntity});
  
}
class DeleteCourseEvent extends CenterCoursesEvent {
  String courseId;
  DeleteCourseEvent({required this.courseId});
}
class UpdateCourseEvent extends CenterCoursesEvent {
  CourseEntity updateCourseEntity;
  UpdateCourseEvent({required this.updateCourseEntity});
}

class GetCenterCoursesEvent extends CenterCoursesEvent {
  String centerId;
  GetCenterCoursesEvent({required this.centerId});
}