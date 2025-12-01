import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/record_provider.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RecordProvider>(context);

    int todayWater = 0;
    final today = DateTime.now().toString().substring(0, 10);

    for (var r in provider.records) {
      if (r.date == today) todayWater += r.water;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("HealthMate Dashboard"),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            // Dashboard card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Icon(Icons.local_drink, size: 50, color: Colors.blue),
                    SizedBox(height: 10),
                    Text(
                      "Today's Water Intake",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      "$todayWater ml",
                      style: TextStyle(
                        fontSize: 32,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 40),

            // Add record button
            ElevatedButton.icon(
              onPressed: () => Navigator.pushNamed(context, "/add"),
              icon: Icon(Icons.add),
              label: Text("Add New Record"),
            ),
            SizedBox(height: 20),

            // VIEW RECORDS BUTTON
            ElevatedButton.icon(
              onPressed: () => Navigator.pushNamed(context, "/list"),
              icon: Icon(Icons.list),
              label: Text("View Records"),
            ),
          ],
        ),
      ),
    );
  }
}
