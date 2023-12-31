import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddActivityScreen extends StatefulWidget {
  @override
  _AddActivityScreenState createState() => _AddActivityScreenState();
}

class _AddActivityScreenState extends State<AddActivityScreen> {
  final CollectionReference activitiesCollection =
  FirebaseFirestore.instance.collection('activities');
  final TextEditingController nameController = TextEditingController();
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  int efficiency = 0; // Default efficiency score

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }
    void showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void saveActivityToFirestore() {
  String name = nameController.text;

  // Check if both date and time are selected before saving
  if (selectedDate != null && selectedTime != null) {
    DateTime selectedDateTime = DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
      selectedTime!.hour,
      selectedTime!.minute,
    );

    Timestamp scheduledTime = Timestamp.fromDate(selectedDateTime);

    activitiesCollection
        .add({
          'name': name,
          'scheduledTime': scheduledTime,
          'efficiencyScore': efficiency,
        })
        .then((value) {
          print("Activity added with ID: ${value.id}");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Activity added successfully')),
          );
        })
        .catchError((error) {
          print("Failed to add activity: $error");
        });
  } else {
    showSnackBar(context, 'Please select both date and time');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Activity'),
     backgroundColor: Color.fromARGB(255, 127, 128, 77), ),
      
      body:  Container(
        decoration: const BoxDecoration(
           gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color.fromARGB(255, 92, 131, 162), Color.fromARGB(255, 79, 177, 181)],
            ),
        ),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Activity Name',),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(selectedDate != null
                    ? 'Date: ${DateFormat.yMMMd().format(selectedDate!)}'
                    : 'Select Date'),
                ElevatedButton(
                  onPressed: () => _selectDate(context),
                   style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  ),
                  child: Text('Pick Date',style: TextStyle(color: Colors.white),),
                  
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(selectedTime != null
                    ? 'Time: ${selectedTime!.format(context)}'
                    : 'Select Time'),
                ElevatedButton(
                  onPressed: () => _selectTime(context),
                   style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  ),
                  child: Text('Pick Time',style: TextStyle(color: Colors.white),),
                  
                ),
                
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                saveActivityToFirestore();
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  ),
                  child: Text('Save',style: TextStyle(color: Colors.white),),
                  
            ),
          ],
        ),
      ),
    ),
    );
  }
}
