import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grad_project_ver_1/features/clean_you_can/center/domain/entities/center_entity.dart';
import 'package:grad_project_ver_1/features/clean_you_can/center/presentation/blocs/center_general_bloc/center_general_bloc.dart';

class EditCenterProfilePage extends StatefulWidget {
  final CenterEntity centerInfo;

  const EditCenterProfilePage({super.key, required this.centerInfo});

  @override
  State<EditCenterProfilePage> createState() =>
      _EditCenterProfilePageState();
}

class _EditCenterProfilePageState
    extends State<EditCenterProfilePage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _descriptionController;
  late TextEditingController _imageUrlController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.centerInfo.name,
    );
    _addressController = TextEditingController(
      text: widget.centerInfo.address,
    );
    _phoneController = TextEditingController(
      text: widget.centerInfo.phoneNumber,
    );
    _emailController = TextEditingController(
      text: widget.centerInfo.email,
    );
    _descriptionController = TextEditingController(
      text: widget.centerInfo.description,
    );
    _imageUrlController = TextEditingController(
      text: widget.centerInfo.imageUrl ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Center Info"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField("Name", _nameController),
              _buildTextField("Address", _addressController),
              _buildTextField(
                "Phone Number",
                _phoneController,
                keyboardType: TextInputType.phone,
              ),
              _buildTextField(
                "Email",
                _emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              _buildTextField(
                "Description",
                _descriptionController,
                maxLines: 3,
              ),
              _buildTextField("Image URL", _imageUrlController),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  CenterEntity updatedCenterInfo = CenterEntity(
                    centerId: widget.centerInfo.centerId,
                    name:
                        _nameController.text.isEmpty
                            ? widget.centerInfo.name
                            : _nameController.text,
                    email: widget.centerInfo.email,
                    phoneNumber:
                        _phoneController.text.isEmpty
                            ? widget.centerInfo.phoneNumber
                            : _phoneController.text,
                    address:
                        _addressController.text.isEmpty
                            ? widget.centerInfo.address
                            : _addressController.text,
                    description:
                        _descriptionController.text.isEmpty
                            ? widget.centerInfo.description
                            : _descriptionController.text,
                 imageUrl: _imageUrlController.text
                  );
                  context.read<CenterGeneralBloc>().add(
                    UpdateCenterInfoEvent(
                      updatedCenter: updatedCenterInfo,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: const Text("Save Changes"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        validator:
            (value) =>
                value == null || value.trim().isEmpty
                    ? "Please enter $label"
                    : null,
      ),
    );
  }
}
