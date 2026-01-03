import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: VehicleManagementPage(),
    ),
  );
}

class VehicleManagementPage extends StatefulWidget {
  @override
  State<VehicleManagementPage> createState() => _VehicleManagementPageState();
}

class _VehicleManagementPageState extends State<VehicleManagementPage> {
  // ---------------- Basic Info ----------------
  final _vehicleNumberController = TextEditingController();
  final _ownerNameController = TextEditingController();

  // ---------------- RC Details ----------------
  bool showRCDetails = false;
  String _vehicleClass = "MCWG";
  String fuelType = "Petrol";
  String cabType = "SUV";

  final List<String> cabTypes = ["SUV", "Hatchback", "Sedan", "MUV/MPV"];

  final _modelController = TextEditingController();
  final _seatingController = TextEditingController();
  final _rcExpiryController = TextEditingController();
  String rcFrontImage = "";
  String rcBackImage = "";

  // ---------------- Insurance Details ----------------
  bool showInsuranceDetails = false;
  final _insuranceProviderController = TextEditingController();
  final _policyNumberController = TextEditingController();
  String policyType = "Third Party";
  final _policyStartController = TextEditingController();
  final _policyExpiryController = TextEditingController();
  String insuranceDocImage = "";

  // ---------------- Helpers ----------------
  void toggleRCDetails() => setState(() => showRCDetails = !showRCDetails);
  void toggleInsuranceDetails() =>
      setState(() => showInsuranceDetails = !showInsuranceDetails);

  // ---------------- Image Picker ----------------
  void _pickImage(String type) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      setState(() {
        if (type == "rcFront") rcFrontImage = pickedFile.path;
        if (type == "rcBack") rcBackImage = pickedFile.path;
        if (type == "insurance") insuranceDocImage = pickedFile.path;
      });
    }
  }

  // ---------------- Date Picker Field ----------------
  Widget _buildDateField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      onTap: () async {
        DateTime? date = await showDatePicker(
          context: context,
          firstDate: DateTime(2000),
          lastDate: DateTime(2035),
          initialDate: DateTime.now(),
        );
        if (date != null) {
          controller.text = "${date.day}-${date.month}-${date.year}";
        }
      },
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: Icon(Icons.calendar_today),
        border: OutlineInputBorder(),
      ),
    );
  }

  // ---------------- Upload Button ----------------
  Widget _buildUploadButton(String label, String type) {
    String status = "";
    if (type == "rcFront") status = rcFrontImage;
    if (type == "rcBack") status = rcBackImage;
    if (type == "insurance") status = insuranceDocImage;

    return OutlinedButton.icon(
      icon: Icon(Icons.upload_file),
      label: Text(status.isEmpty ? label : "$label ✅"),
      onPressed: () => _pickImage(type),
    );
  }

  // ---------------- Save Vehicle ----------------
  void saveVehicle() {
    if (_vehicleNumberController.text.isEmpty ||
        _ownerNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill Vehicle Number and Owner Name")),
      );
      return;
    }

    if (showRCDetails) {
      if (_modelController.text.isEmpty ||
          _seatingController.text.isEmpty ||
          _rcExpiryController.text.isEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Please fill all RC details")));
        return;
      }

      if (_vehicleClass == "LMV-CAB" && cabType.isEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Please select Cab Type")));
        return;
      }
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Vehicle saved successfully")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade700,
        title: Center(
          child: Text(
            "Vehicle Management",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // -------- Basic Info --------
            TextFormField(
              controller: _vehicleNumberController,
              decoration: InputDecoration(
                labelText: "Vehicle Number",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _ownerNameController,
              decoration: InputDecoration(
                labelText: "Owner Name",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),

            // -------- RC Toggle --------
            TextButton.icon(
              onPressed: toggleRCDetails,
              icon: Icon(showRCDetails ? Icons.expand_less : Icons.expand_more),
              label: Text("RC Details"),
            ),

            // -------- RC Details --------
            if (showRCDetails)
              Card(
                elevation: 2,
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Column(
                    children: [
                      DropdownButtonFormField<String>(
                        value: _vehicleClass,
                        decoration: InputDecoration(
                          labelText: "Vehicle Class",
                          border: OutlineInputBorder(),
                        ),
                        items: ["MCWG", "MCWOG", "LMV-CAB", "LMV-NT"]
                            .map(
                              (e) => DropdownMenuItem(value: e, child: Text(e)),
                            )
                            .toList(),
                        onChanged: (v) {
                          setState(() => _vehicleClass = v!);
                        },
                      ),

                      // -------- Cab Type (Only LMV-CAB) --------
                      if (_vehicleClass == "LMV-CAB") ...[
                        SizedBox(height: 10),
                        DropdownButtonFormField<String>(
                          value: cabType,
                          decoration: InputDecoration(
                            labelText: "Cab Type",
                            border: OutlineInputBorder(),
                          ),
                          items: cabTypes
                              .map(
                                (e) =>
                                    DropdownMenuItem(value: e, child: Text(e)),
                              )
                              .toList(),
                          onChanged: (v) {
                            setState(() => cabType = v!);
                          },
                        ),
                      ],

                      SizedBox(height: 10),
                      DropdownButtonFormField(
                        value: fuelType,
                        decoration: InputDecoration(
                          labelText: "Fuel Type",
                          border: OutlineInputBorder(),
                        ),
                        items: ["Petrol", "Diesel", "Electric", "CNG"]
                            .map(
                              (e) => DropdownMenuItem(value: e, child: Text(e)),
                            )
                            .toList(),
                        onChanged: (v) => setState(() => fuelType = v!),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _modelController,
                        decoration: InputDecoration(
                          labelText: "Vehicle Model",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _seatingController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "Seating Capacity",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 10),
                      _buildDateField("RC Expiry Date", _rcExpiryController),
                      SizedBox(height: 10),
                      _buildUploadButton("Upload RC Front", "rcFront"),
                      _buildUploadButton("Upload RC Back", "rcBack"),
                    ],
                  ),
                ),
              ),
            TextButton.icon(
              onPressed: toggleInsuranceDetails,
              icon: Icon(
                showInsuranceDetails ? Icons.expand_less : Icons.expand_more,
              ),
              label: Text("Insurance Details"),
            ), // -------- Insurance Form --------
            if (showInsuranceDetails)
              Card(
                elevation: 2,
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _insuranceProviderController,
                        decoration: InputDecoration(
                          labelText: "Insurance Provider",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _policyNumberController,
                        decoration: InputDecoration(
                          labelText: "Policy Number",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 10),
                      DropdownButtonFormField(
                        value: policyType,
                        decoration: InputDecoration(
                          labelText: "Policy Type",
                          border: OutlineInputBorder(),
                        ),
                        items: ["Third Party", "Comprehensive"]
                            .map(
                              (e) => DropdownMenuItem(value: e, child: Text(e)),
                            )
                            .toList(),
                        onChanged: (v) => setState(() => policyType = v!),
                      ),
                      SizedBox(height: 10),
                      _buildDateField(
                        "Policy Start Date",
                        _policyStartController,
                      ),
                      SizedBox(height: 10),
                      _buildDateField(
                        "Policy Expiry Date",
                        _policyExpiryController,
                      ),
                      SizedBox(height: 10),
                      _buildUploadButton(
                        "Upload Insurance Document",
                        "insurance",
                      ),
                    ],
                  ),
                ),
              ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                ),
                onPressed: saveVehicle,
                child: Text(
                  "Save Vehicle",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
