import 'package:flutter/material.dart';
import '/activity.dart'; 

class EditEfficiencyScreen extends StatefulWidget {
  final Activity activity;

  EditEfficiencyScreen({required this.activity});

  @override
  _EditEfficiencyScreenState createState() => _EditEfficiencyScreenState();
}

class _EditEfficiencyScreenState extends State<EditEfficiencyScreen> {
  late TextEditingController efficiencyController;

  @override
  void initState() {
    super.initState();
    efficiencyController = TextEditingController(text: widget.activity.efficiencyScore.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Efficiency Score'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Activity: ${widget.activity.name}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextField(
              controller: efficiencyController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Efficiency Score',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Update the efficiency score for the activity
                int newEfficiency = int.tryParse(efficiencyController.text) ?? 0;
                // Perform any necessary validation on newEfficiency

                setState(() {
                  widget.activity.efficiencyScore = newEfficiency;
                  // Update the efficiency score in Firestore or wherever you store your data
                  // Call a function to update the efficiency score in the database
                  // updateEfficiencyScore(widget.activity);
                });

                Navigator.pop(context); // Go back to the previous screen
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    efficiencyController.dispose();
    super.dispose();
  }
}
