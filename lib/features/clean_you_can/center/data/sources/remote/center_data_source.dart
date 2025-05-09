// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:grad_project_ver_1/core/errors/failure.dart';
import 'package:grad_project_ver_1/features/auth/data/source/remote/auth_data_source.dart';
import 'package:grad_project_ver_1/features/clean_you_can/center/data/models/center_model.dart';
import 'package:grad_project_ver_1/features/clean_you_can/center/domain/entities/center_entity.dart';
import 'package:grad_project_ver_1/features/clean_you_can/course/data/models/course_model.dart';
import 'package:grad_project_ver_1/features/clean_you_can/student/data/models/student_model.dart';
import 'package:grad_project_ver_1/features/clean_you_can/trainer/data/models/trainer_model.dart';
import 'package:grad_project_ver_1/features/clean_you_can/trainer/domain/entities/trainer_entity.dart';

class CenterDataSource {
  // final _firebaseAuth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  //! center_trainer_bloc deal with this
  Future<Either<Failure, String>> createTrainer(
    TrainerModel newTrainer,
    String password,
  ) async {
    try {
      final doneCreating = await AuthDataSource().registerUser(
        newTrainer.email,
        password,
        "Trainer",
      );
      print(
        "*********************************** doneCreating happend",
      );
      if (doneCreating.isLeft()) {
        final failure = doneCreating.fold(
          (isLeft) => isLeft.message,
          (r) => null,
        );
        return Left(AuthFailure(failure!));
      }
      final user = doneCreating.fold(
        (ifLeft) => null,
        (isRight) => isRight,
      );
      final uid = user!.uid;
      await _firestore
          .collection("Trainers")
          .doc(uid)
          .set(newTrainer.toJson(uid));
      // await _firestore.collection("Users").doc(uid).update({
      //   "isCompletedInfo": true,
      // });
      return Right(uid);
    } on FirebaseException catch (e) {
      return Left(
        AuthFailure(
          "${e.code}: ${e.message} from trainer FirebaseException",
        ),
      );
    } catch (e) {
      return Left(
        AuthFailure('An unexpected error occurred from trainer: $e'),
      );
    }
  }

  /*
 old createtrainer
   Future<Either<Failure, String>> createTrainer(
    TrainerModel newTrainer,
    String password,
  ) async {
    try {
      // Create user with email and password in Firebase Authentication
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(
            email: newTrainer.email,
            password: password,
          );

      // Get the generated UID
      String generetedId = userCredential.user!.uid;

      // Save trainer info in Firestore under the "Trainers" collection
      await _firestore
          .collection('Trainers')
          .doc(generetedId)
          .set(newTrainer.toJson(generetedId));

      return Right(generetedId);
    } on FirebaseAuthException catch (e) {
      return Left(
        AuthFailure(
          "${e.code}: ${e.message} from trainer FirebaseAuthException",
        ),
      );
    } on FirebaseException catch (e) {
      return Left(
        AuthFailure(
          "${e.code}: ${e.message} from trainer FirebaseException",
        ),
      );
    } catch (e) {
      return Left(
        AuthFailure('An unexpected error occurred from trainer: $e'),
      );
    }
  }

  */

  Future<Either<Failure, List<TrainerEntity>>> fetchCenterTrainers(
    String centerId,
  ) async {
    try {
      final querySnapshot =
          await _firestore
              .collection('Trainers')
              .where('centerId', isEqualTo: centerId)
              .get();

      if (querySnapshot.docs.isEmpty) {
        return Right(
          [],
        ); // لو مفيش مدربين، رجّع ليست فاضية بدل ما ترجع خطأ
      }

      final trainers =
          querySnapshot.docs
              .map((doc) {
                final data = doc.data();

                if (data.containsKey('centerId')) {
                  return TrainerModel.fromJson(data);
                } else {
                  return null; // استبعاد أي بيانات ناقصة
                }
              })
              .whereType<
                TrainerModel
              >() // إزالة القيم null وتحويل الليستة تلقائيًا إلى List<TrainerModel>
              .toList();

      return Right(trainers);
    } catch (e) {
      return Left(
        ServerFailure("Faild to get trainers: ${e.toString()}"),
      );
    }
  }

  //! center_general_bloc deal with this
  Future<Either<Failure, void>> updateCenterInfo(
    CenterModel updatedCenter,
  ) async {
    try {
      print(
        "****************************************************************************************************************** image url is  ${updatedCenter.imageUrl}",
      );
      await _firestore
          .collection("Centers")
          .doc(updatedCenter.centerId)
          .update({
            'name': updatedCenter.name,
            'address': updatedCenter.address,
            'description': updatedCenter.description,
            'phoneNumber': updatedCenter.phoneNumber,
            'imageUrl': updatedCenter.imageUrl,
          });
      return Right(unit);
    } catch (e) {
      return Left(
        ServerFailure(
          "couldnt update the info of center : ${e.toString()}",
        ),
      );
    }
  }

  Future<Either<Failure, CenterModel>> getCenterInfo(
    String centerId,
  ) async {
    try {
      final centerDoc =
          await _firestore.collection("Centers").doc(centerId).get();
      if (!centerDoc.exists) {
        return Left(ServerFailure("Center data not found!!"));
      }
      final centerData = centerDoc.data() as Map<String, dynamic>;
      final centerModel = CenterModel.fromJson(centerData);
      print(
        "****************************************************************************************************************** image url in centermodel in getcenter info  is  ${centerModel.imageUrl}",
      );

      return Right(centerModel);
    } catch (e) {
      return Left(
        ServerFailure(
          "problem in fetching center data :  ${e.toString()}",
        ),
      );
    }
  }

  Future<Either<Failure, void>> createCenter(
    CenterModel newCenter,
  ) async {
    try {
      await _firestore
          .collection('Centers')
          .doc(newCenter.centerId)
          .set(newCenter.toJson());
      await _firestore
          .collection("Users")
          .doc(newCenter.centerId)
          .update({'isCompletedInfo': true});

      // ignore: void_checks
      return Right(unit);
    } on FirebaseException catch (e) {
      return Left(DatabaseFailure(e.toString()));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  //! center_course_bloc deal with those
  Future<Either<Failure, CourseModel>> addCourse(
    CourseModel courseModel,
  ) async {
    try {
      // إنشاء doc جديد للحصول على id
      final docRef = _firestore.collection('Courses').doc();
      print(
        "**********************************************************************************************${docRef.id}",
      );

      final newCourseModel = courseModel.copyWith(
        courseId: docRef.id,
      );
      // تحديث المدرب بإضافة الكورس الجديد
      await _firestore
          .collection("Trainers")
          .doc(newCourseModel.trainerId)
          .update({
            'coursesId': FieldValue.arrayUnion([
              newCourseModel.courseId,
            ]),
          });

      // إضافة الكورس في الـ collection
      await docRef.set(newCourseModel.toJson());

      return Right(newCourseModel);
    } catch (e) {
      return Left(
        ServerFailure("Failed to create course: ${e.toString()}"),
      );
    }
  }

  Future<Either<Failure, String>> deleteCourse(
    String courseId,
  ) async {
    try {
      final courseDoc =
          await _firestore.collection('Courses').doc(courseId).get();
      if (!courseDoc.exists) {
        return Left(ServerFailure("Course Not found "));
      }
      final courseData = courseDoc.data() as Map<String, dynamic>;
      final courseTrainerId = courseData['trainerId'];
      final enrolledStudents = List<String>.from(
        courseData['enrolledStudents'] ?? [],
      );
      if (enrolledStudents.isNotEmpty) {
        return Left(
          ServerFailure(
            "cant delete this course , there is enroled students",
          ),
        );
      }
      await _firestore.collection('Courses').doc(courseId).delete();
      await _firestore
          .collection('Trainers')
          .doc(courseTrainerId)
          .update({
            'coursesId': FieldValue.arrayRemove([courseId]),
          });
      return Right(
        "success deleting the course  feom center and the trainer too",
      );
    } catch (e) {
      return Left(
        ServerFailure(
          "******************************************Faild to delete course : ${e.toString()}",
        ),
      );
    }
  }

  Future<Either<Failure, String>> updateCourse(
    CourseModel courseModel,
  ) async {
    try {
      //* isnt used
      // final preData =
      //     await _firestore
      //         .collection('Courses')
      //         .doc(courseModel.courseId)
      //         .get();

      await _firestore
          .collection('Courses')
          .doc(courseModel.courseId.toString())
          .update({
            'centerId': courseModel.centerId,
            'trainerId': courseModel.trainerId,
            'courseId': courseModel.courseId,
            'description': courseModel.description,
            'endDate': courseModel.endDate,
            'startDate': courseModel.startDate,
            'enrolledStudents': courseModel.enrolledStudents,
            'imageUrl': courseModel.imageUrl,
            'maxStudents': courseModel.maxStudents,
            'price': courseModel.price,
            'title': courseModel.title,
            'topics': courseModel.topics,
          });
      // final postData =
      //     await _firestore
      //         .collection('Courses')
      //         .doc(courseModel.courseId.toString())
      //         .get();
      // print(
      //   "*********************************************************************************************************************************************after fire store the updated course is${postData.data()} ",
      // );

      return const Right("Course update successfully");
    } catch (e) {
      return Left(
        ServerFailure("Faild to update course : ${e.toString()}"),
      );
    }
  }

  Future<Either<Failure, List<CourseModel>>> getCenterCourses(
    String centerId,
  ) async {
    try {
      final querySnapshot =
          await _firestore
              .collection('Courses')
              .where('centerId', isEqualTo: centerId)
              .get();

      if (querySnapshot.docs.isEmpty) {
        return Right(
          [],
        ); // لو مفيش كورسات، رجّع ليست فاضية بدل ما ترجع خطأ
      }

      final courses =
          querySnapshot.docs
              .map((doc) {
                final data = doc.data();

                if (data.containsKey('centerId')) {
                  return CourseModel.fromJson(data);
                } else {
                  return null; // استبعاد أي بيانات ناقصة
                }
              })
              .whereType<
                CourseModel
              >() // إزالة القيم null وتحويل الليستة تلقائيًا إلى List<CourseModel>
              .toList();

      return Right(courses);
    } catch (e) {
      return Left(
        ServerFailure("Faild to get center courses: ${e.toString()}"),
      );
    }
  }

  Future<Either<Failure, List<StudentModel>>> getCourseStudents(
    int courseId,
  ) async {
    try {
      final courseDoc =
          await _firestore
              .collection('Courses')
              .doc(courseId.toString())
              .get();
      if (!courseDoc.exists) {
        return Left(ServerFailure("course not found"));
      }
      final Set<String> enrolledStudents = Set<String>.from(
        courseDoc.data()?['enrolledStudents'] ?? {},
      );
      if (enrolledStudents.isEmpty) {
        return Right([]);
      }
      final studentsQuery =
          await _firestore
              .collection('Users')
              .where('role', isEqualTo: 'student')
              .where(
                FieldPath.documentId,
                whereIn: enrolledStudents.toList(),
              )
              .get();
      final students =
          studentsQuery.docs
              .map((doc) => StudentModel.fromJson(doc.data()))
              .toList();
      return Right(students);
    } catch (e) {
      return Left(
        ServerFailure(
          "Faild to get course students : ${e.toString()}",
        ),
      );
    }
  }
}
