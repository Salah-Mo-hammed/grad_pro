import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grad_project_ver_1/features/clean_you_can/student/presentation/bloc/student_bloc/student_bloc.dart';
import 'package:grad_project_ver_1/features/clean_you_can/student/presentation/bloc/student_bloc/student_event.dart';
import 'package:grad_project_ver_1/features/clean_you_can/student/presentation/bloc/student_bloc/student_state.dart';

class PaymentMethodPage extends StatefulWidget {
  final String centerId;
  final String currentStudentUid;
  final String currentCourseUid;
  const PaymentMethodPage({
    super.key,
    required this.centerId,
    required this.currentCourseUid,
    required this.currentStudentUid,
  });

  @override
  State<PaymentMethodPage> createState() => _PaymentMethodPageState();
}

class _PaymentMethodPageState extends State<PaymentMethodPage> {
  @override
  void initState() {
    context.read<StudentBloc>().add(
      EnrollInCourseEvent(
        // these isnt important now ,but after solving firebase storage payment problem
        centerId: widget.centerId,
        proofImageUrl: '',
        // this is needed to complete booking
        studentUid: widget.currentStudentUid,
        courseUid: widget.currentCourseUid,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocBuilder<StudentBloc, StudentState>(
        builder: (context, state) {
          if (state is StudentLoadingState) {
            return Center(child: CircularProgressIndicator());
          } else if (state is StudentExceptionState) {
            return Center(child: Text(state.message.toString()));
          } else {
            return Center(
              child: Text(" ok i think payment is good now "),
            );
          }
        },
      ),
    );
  }
}
 



 //! this is the final page , but after solveing firebase storage payment problem 
//  import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:grad_project_ver_1/features/clean_you_can/student/presentation/bloc/student_bloc/student_bloc.dart';
// import 'package:grad_project_ver_1/features/clean_you_can/student/presentation/bloc/student_bloc/student_event.dart';
// import 'package:grad_project_ver_1/features/clean_you_can/student/presentation/bloc/student_bloc/student_state.dart';

// class PaymentMethodPage extends StatefulWidget {
//   final String centerId;
//   final String currentStudentUid;
//   final String currentCourseUid;

//   const PaymentMethodPage({
//     super.key,
//     required this.centerId,
//     required this.currentCourseUid,
//     required this.currentStudentUid,
//   });

//   @override
//   State<PaymentMethodPage> createState() => _PaymentMethodPageState();
// }

// class _PaymentMethodPageState extends State<PaymentMethodPage> {
//   File? _selectedImage;
//   bool _isUploading = false;

//   Future<void> pickImage() async {
//     final status = await Permission.photos.request();
//     if (status.isGranted) {
//       final picked = await ImagePicker().pickImage(
//         source: ImageSource.gallery,
//       );
//       if (picked != null) {
//         setState(() {
//           _selectedImage = File(picked.path);
//         });
//       }
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text("please give permission to get image"),
//         ),
//       );
//     }
//   }

//   Future<String?> uploadImage(File image) async {
//     try {
//       final storageRef = FirebaseStorage.instance
//           .ref()
//           .child('proof_images')
//           .child('${DateTime.now().millisecondsSinceEpoch}.jpg');

//       await storageRef.putFile(image);
//       return await storageRef.getDownloadURL();
//     } catch (e) {
//       print("Upload Error: $e");
//       return null;
//     }
//   }

//   void _submit() async {
//     if (_selectedImage == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text("please , upload bank transfare image"),
//         ),
//       );
//       return;
//     }

//     setState(() => _isUploading = true);
//     final url = await uploadImage(_selectedImage!);

//     if (url != null) {
//       print(url);
//       context.read<StudentBloc>().add(
//         EnrollInCourseEvent(
//           centerId: widget.centerId,
//           studentUid: widget.currentStudentUid,
//           courseUid: widget.currentCourseUid,
//           proofImageUrl: url,
//         ),
//       );
//     }

//     setState(() => _isUploading = false);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Payment Method")),
//       body: BlocBuilder<StudentBloc, StudentState>(
//         builder: (context, state) {
//           if (state is StudentLoadingState || _isUploading) {
//             print(state);
//             print(_isUploading);

//             return const Center(child: CircularProgressIndicator());
//           } else if (state is StudentExceptionState) {
//             return Center(child: Text(state.message.toString()));
//           } else if (state is StudentSuccessState) {
//             return const Center(
//               child: Text(
//                 "sent course booking successfully",
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             );
//           } else {
//             return SingleChildScrollView(
//               padding: const EdgeInsets.all(20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   ElevatedButton.icon(
//                     icon: const Icon(Icons.image),
//                     label: const Text("upload bank transfare image"),
//                     onPressed: pickImage,
//                     style: ElevatedButton.styleFrom(
//                       padding: const EdgeInsets.symmetric(
//                         vertical: 14,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   if (_selectedImage != null)
//                     Card(
//                       elevation: 4,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.all(12),
//                         child: Column(
//                           children: [
//                             const Text(
//                               "choosen image:",
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                             const SizedBox(height: 10),
//                             ClipRRect(
//                               borderRadius: BorderRadius.circular(10),
//                               child: Image.file(
//                                 _selectedImage!,
//                                 height: 220,
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   const SizedBox(height: 30),
//                   ElevatedButton.icon(
//                     icon: const Icon(Icons.send),
//                     label: const Text("send request"),
//                     onPressed: _submit,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.green,
//                       padding: const EdgeInsets.symmetric(
//                         vertical: 16,
//                       ),
//                       textStyle: const TextStyle(fontSize: 16),
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           }
//         },
//       ),
//     );
//   }
// }
