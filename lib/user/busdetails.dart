import 'package:flutter/material.dart';

// Dummy Map Screen to show current bus location
class BusMapScreen extends StatelessWidget {
  final String busLocation;

  const BusMapScreen({super.key, required this.busLocation});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bus Location"),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Text(
          "Bus is currently at: $busLocation",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}

class BusDetailsPage extends StatefulWidget {
  const BusDetailsPage({super.key});

  @override
  State<BusDetailsPage> createState() => _BusDetailsPageState();
}

class _BusDetailsPageState extends State<BusDetailsPage> {
  TextEditingController pickup = TextEditingController();
  TextEditingController drop = TextEditingController();

  // Selected Bus Type for filter
  String selectedBusType = "All";

  // Sample bus data with status
  final List<Map<String, String>> buses = [
    {
      "name": "KSRTC Express",
      "type": "AC",
      "pickup": "Kochi",
      "drop": "Thrissur",
      "currentLocation": "Angamaly",
      "status": "On Route"
    },
    {
      "name": "Fast Travels",
      "type": "Non-AC",
      "pickup": "Kochi",
      "drop": "Aluva",
      "currentLocation": "Aluva",
      "status": "Delayed"
    },
    {
      "name": "Metro Bus",
      "type": "AC",
      "pickup": "Kakkanad",
      "drop": "Ernakulam",
      "currentLocation": "Edappally",
      "status": "Arrived"
    },
  ];

  // Controller for report dialog
  TextEditingController reportController = TextEditingController();

  void showReportDialog(String busName) {
    reportController.clear();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Report a Problem"),
          content: TextField(
            controller: reportController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: "Describe the problem...",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                String report = reportController.text.trim();
                if (report.isNotEmpty) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Report submitted for $busName"),
                    ),
                  );
                }
              },
              child: Text("Submit"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Filtered buses based on type
    final filteredBuses = selectedBusType == "All"
        ? buses
        : buses.where((bus) => bus["type"] == selectedBusType).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Bus Details", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Pickup & Drop Fields + Bus Type Dropdown
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Column(
                children: [
                  TextField(
                    controller: pickup,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.my_location, color: Colors.blue),
                      hintText: "Pickup Location",
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: drop,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.location_on, color: Colors.red),
                      hintText: "Drop Location",
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: selectedBusType,
                    decoration: InputDecoration(
                      labelText: "Select Bus Type",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade200,
                    ),
                    items: ["All", "AC", "Non-AC"].map((type) {
                      return DropdownMenuItem(value: type, child: Text(type));
                    }).toList(),
                    onChanged: (val) => setState(() => selectedBusType = val!),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),

            // Bus List
            Expanded(
              child: ListView.builder(
                itemCount: filteredBuses.length,
                itemBuilder: (context, index) {
                  final bus = filteredBuses[index];

                  Color statusColor;
                  switch (bus["status"]) {
                    case "On Route":
                      statusColor = Colors.green;
                      break;
                    case "Delayed":
                      statusColor = Colors.orange;
                      break;
                    case "Arrived":
                    default:
                      statusColor = Colors.grey;
                  }

                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 4,
                    child: ListTile(
                      contentPadding: EdgeInsets.all(12),
                      leading: Icon(Icons.directions_bus, color: Colors.blue, size: 40),
                      title: Text(
                        bus["name"]!,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${bus["pickup"]} → ${bus["drop"]} • ${bus["type"]}",
                            style: TextStyle(fontSize: 14, color: Colors.black87),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Status: ${bus["status"]}",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: statusColor,
                            ),
                          ),
                           IconButton(
                            icon: Icon(Icons.report_problem),
                            onPressed: () => showReportDialog(bus["name"]!),
                            color: Colors.red,
                          ),
                        ],
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(Icons.location_on),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BusMapScreen(
                                    busLocation: bus["currentLocation"]!,
                                  ),
                                ),
                              );
                            },
                            color: Colors.blue,
                          ),
                         
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
