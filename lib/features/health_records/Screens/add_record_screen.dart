import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/health_record.dart';
import '../providers/record_provider.dart';
import 'package:intl/intl.dart';

class AddRecordScreen extends StatefulWidget {
  final HealthRecord? record;   // NULL = Add, NOT NULL = Edit

  const AddRecordScreen({Key? key, this.record}) : super(key: key);

  @override
  State<AddRecordScreen> createState() => _AddRecordScreenState();
}

class _AddRecordScreenState extends State<AddRecordScreen> {
  final stepsCtrl = TextEditingController();
  final calCtrl = TextEditingController();
  final waterCtrl = TextEditingController();

  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();

    // If editing -load existing values
    if (widget.record != null) {
      stepsCtrl.text = widget.record!.steps.toString();
      calCtrl.text = widget.record!.calories.toString();
      waterCtrl.text = widget.record!.water.toString();
      selectedDate = DateTime.parse(widget.record!.date);
    }
  }

  Future<void> pickDate() async {
    final d = await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      initialDate: selectedDate ?? DateTime.now(),
    );

    if (d != null) {
      setState(() {
        selectedDate = d;
      });
    }
  }

  void saveRecord() {
    final provider = Provider.of<RecordProvider>(context, listen: false);

    final dateToSave = DateFormat("yyyy-MM-dd")
        .format(selectedDate ?? DateTime.now());

    final steps = int.tryParse(stepsCtrl.text) ?? 0;
    final cal = int.tryParse(calCtrl.text) ?? 0;
    final water = int.tryParse(waterCtrl.text) ?? 0;

    if (widget.record == null) {
      // ADD NEW RECORD
      provider.addRecord(
        HealthRecord(
          date: dateToSave,
          steps: steps,
          calories: cal,
          water: water,
        ),
      );
    } else {
      // UPDATE EXISTING RECORD
      provider.updateRecord(
        HealthRecord(
          id: widget.record!.id,
          date: dateToSave,
          steps: steps,
          calories: cal,
          water: water,
        ),
      );
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.record != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? "Edit Health Record" : "Add Health Record"),
      ),

      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // DATE PICKER
            GestureDetector(
              onTap: pickDate,
              child: Container(
                padding: EdgeInsets.all(14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey),
                ),
                child: Row(
                  children: [
                    Icon(Icons.calendar_today),
                    SizedBox(width: 10),
                    Text(
                      selectedDate == null
                          ? "Pick a date"
                          : DateFormat("yyyy-MM-dd").format(selectedDate!),
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),

            TextField(
              controller: stepsCtrl,
              decoration: InputDecoration(labelText: "Steps walked"),
              keyboardType: TextInputType.number,
            ),

            TextField(
              controller: calCtrl,
              decoration: InputDecoration(labelText: "Calories burned"),
              keyboardType: TextInputType.number,
            ),

            TextField(
              controller: waterCtrl,
              decoration: InputDecoration(labelText: "Water intake (ml)"),
              keyboardType: TextInputType.number,
            ),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: saveRecord,
              child: Text(isEdit ? "Update" : "Save"),
            ),
          ],
        ),
      ),
    );
  }
}
