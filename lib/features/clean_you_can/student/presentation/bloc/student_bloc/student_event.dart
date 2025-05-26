
abstract class StudentEvent {}



class GetAvailableAndMineCoursesEvent extends StudentEvent {
  String studentId;
  GetAvailableAndMineCoursesEvent({required this.studentId});
}

class EnrollInCourseEvent extends StudentEvent {
  String proofImageUrl;
  String centerId;
  String studentUid;
  String courseUid;

  EnrollInCourseEvent({
    required this.proofImageUrl,
    required this.centerId,
    required this.studentUid,
    required this.courseUid,
  });
}
