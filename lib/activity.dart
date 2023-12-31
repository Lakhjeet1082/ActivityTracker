import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Activity {
    final String id;
  final String name;
  final TimeOfDay scheduledTime;
  int efficiencyScore;



  Activity(this.id,this.name, this.scheduledTime, this.efficiencyScore);

  factory Activity.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    final Timestamp timestamp = data['scheduledTime'] ?? Timestamp(0, 0); // Replace Timestamp(0, 0) with your default value
    TimeOfDay scheduledTime = TimeOfDay.fromDateTime(timestamp.toDate());

    return Activity(
   snapshot.id,
      data['name'] ?? '',
      scheduledTime,
      data['efficiencyScore'] ?? 0,
    );
  }
}
