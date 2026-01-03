import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class UserProfilePage extends StatefulWidget {
  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final _formKey = GlobalKey<FormState>();

  // Profile Info
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _licenseController = TextEditingController();
  final _adharController = TextEditingController();

  // Multiple vehicles
  List<TextEditingController> _vehicleControllers = [TextEditingController()];

  // ID Proof
  String idProofType = "Aadhaar Card";
  bool idProofUploaded = false;

  // Profile image
  File? profileImageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _licenseController.dispose();
    _adharController.dispose();
    for (var c in _vehicleControllers) {
      c.dispose();
    }
    super.dispose();
  }

  // Pick profile image
  void _pickProfileImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        profileImageFile = File(image.path);
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Profile photo uploaded")));
    }
  }

  void _addVehicleField() {
    setState(() {
      _vehicleControllers.add(TextEditingController());
    });
  }

  void _removeVehicleField(int index) {
    if (_vehicleControllers.length > 1) {
      _vehicleControllers[index].dispose();
      setState(() {
        _vehicleControllers.removeAt(index);
      });
    }
  }

  void _submitProfile() {
    if (!_formKey.currentState!.validate()) return;

    if (profileImageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please upload a profile photo")),
      );
      return;
    }

    if (_adharController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter Aadhaar number")),
      );
      return;
    }

    if (!idProofUploaded) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please upload ID proof")),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Profile saved successfully")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade700,
        centerTitle: true,
        title: const Text(
          "User Profile",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Profile Avatar
              CircleAvatar(
                radius: 60,
                backgroundImage:
                    profileImageFile != null ? FileImage(profileImageFile!) : null,
                child: profileImageFile == null
                    ? const Icon(Icons.person, size: 60, color: Colors.white)
                    : null,
                
              ),
              const SizedBox(height: 8),
              const Text("Upload profile photo"),
              const SizedBox(height: 6),
              ElevatedButton.icon(
                icon: const Icon(Icons.upload_file),
                label: Text(profileImageFile != null
                    ? "Change Profile Photo"
                    : "Upload Profile Photo"),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade700),
                onPressed: _pickProfileImage,
              ),
              const SizedBox(height: 20),

              _buildTextField("Name", _nameController),
              _buildTextField(
                "Email",
                _emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              _buildTextField(
                "Phone",
                _phoneController,
                keyboardType: TextInputType.phone,
              ),
              _buildTextField("Driving Licence Number", _licenseController),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Vehicle Numbers",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  ..._vehicleControllers.asMap().entries.map((entry) {
                    int idx = entry.key;
                    return Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            "Vehicle Number ${idx + 1}",
                            entry.value,
                          ),
                        ),
                        if (_vehicleControllers.length > 1)
                          IconButton(
                            icon: const Icon(Icons.remove_circle,
                                color: Colors.red),
                            onPressed: () => _removeVehicleField(idx),
                          ),
                      ],
                    );
                  }),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      icon: const Icon(Icons.add),
                      label: const Text("Add Vehicle"),
                      onPressed: _addVehicleField,
                    ),
                  ),
                ],
              ),

              _buildTextField(
                "Aadhaar Number",
                _adharController,
                keyboardType: TextInputType.number,
                isRequired: true,
              ),

              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: idProofType,
                decoration: const InputDecoration(
                  labelText: "Select ID Proof Type",
                  border: OutlineInputBorder(),
                ),
                items: const [
                  "Aadhaar Card",
                  "Driving Licence",
                  "Passport",
                  "Voter ID",
                ]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) {
                  if (v != null) {
                    setState(() {
                      idProofType = v;
                    });
                  }
                },
              ),
              const SizedBox(height: 6),
              ElevatedButton.icon(
                icon: const Icon(Icons.upload_file),
                label: Text(idProofUploaded
                    ? "$idProofType ✅"
                    : idProofType), // just show label, no image
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade700),
                onPressed: () async {
                  // pick ID proof but do nothing else with image
                  final XFile? image = await _picker.pickImage(
                      source: ImageSource.gallery);
                  if (image != null) {
                    setState(() {
                      idProofUploaded = true;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("$idProofType uploaded")));
                  }
                },
              ),

              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade700),
                  onPressed: _submitProfile,
                  child: const Text(
                    "Save Profile",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
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
    bool isRequired = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: (value) {
          if (isRequired && (value == null || value.isEmpty)) {
            return "Please enter $label";
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: isRequired ? "$label (Required)" : label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
