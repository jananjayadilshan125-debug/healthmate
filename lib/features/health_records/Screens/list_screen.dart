import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/record_provider.dart';
import 'add_record_screen.dart';

class RecordListScreen extends StatefulWidget {
  @override
  State<RecordListScreen> createState() => _RecordListScreenState();
}

class _RecordListScreenState extends State<RecordListScreen> {
  String searchDateText = "";

  @override
  void initState() {
    super.initState();
    // load once
    Future.microtask(() =>
        Provider.of<RecordProvider>(context, listen: false).loadRecords());
  }

  // Date picker - write result into the text field state
  Future<void> pickDate() async {
    final d = await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      initialDate: DateTime.now(),
    );

    if (d != null) {
      setState(() {
        // yyyy-mm-dd
        searchDateText = d.toIso8601String().substring(0, 10);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RecordProvider>(context);

    // Filter records  (e.g. "2025-11")
    final filtered = provider.records.where((r) {
      final q = searchDateText.trim();
      if (q.isEmpty) return true;
      return r.date.contains(q);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text("Health Records"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(height: 12),

          // Search row: text input + calendar pick button + clear button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    key: Key('search_textfield'),
                    decoration: InputDecoration(
                      hintText: "Search by date (YYYY-MM or YYYY-MM-DD)",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchDateText = value;
                      });
                    },
                    controller: TextEditingController.fromValue(
                      TextEditingValue(
                        text: searchDateText,
                        selection: TextSelection.collapsed(offset: searchDateText.length),
                      ),
                    ),
                  ),
                ),

                SizedBox(width: 8),

                // Calendar button
                InkWell(
                  onTap: pickDate,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.calendar_month),
                  ),
                ),

                SizedBox(width: 8),

                // Clear button
                if (searchDateText.isNotEmpty)
                  InkWell(
                    onTap: () {
                      setState(() {
                        searchDateText = "";
                      });
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.clear),
                    ),
                  ),
              ],
            ),
          ),

          SizedBox(height: 12),

          // Records list
          Expanded(
            child: filtered.isEmpty
                ? Center(child: Text("No records found"))
                : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: filtered.length,
              itemBuilder: (_, i) {
                final r = filtered[i];

                return Card(
                  margin: EdgeInsets.only(bottom: 14),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16),
                    title: Text(
                      r.date,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "Steps: ${r.steps}\nCalories: ${r.calories}\nWater: ${r.water} ml",
                    ),

                    // Tap to edit
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AddRecordScreen(record: r),
                        ),
                      );
                      await Provider.of<RecordProvider>(context, listen: false).loadRecords();
                      setState(() {}); // refresh UI
                    },

                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        provider.deleteRecord(r.id!);
                        // refresh
                        Provider.of<RecordProvider>(context, listen: false).loadRecords();
                        setState(() {});
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
