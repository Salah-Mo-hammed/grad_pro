import 'package:dartz/dartz.dart';
import 'package:grad_project_ver_1/core/errors/failure.dart';
import 'package:grad_project_ver_1/features/clean_you_can/course/domain/entities/course_entity.dart';
import 'package:grad_project_ver_1/features/clean_you_can/trainer/domain/repo/trianer_repo.dart';

class GetTrienerCoursesUsecase {
  TrianerRepo trianerRepo;
  GetTrienerCoursesUsecase({required this.trianerRepo});
  Future<Either<Failure,List<CourseEntity>>> call(String trainerId){
    return trianerRepo.getTraienrCourses(trainerId);
  }
}