import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/activity.dart';

class WeeklySummaryScreen extends StatelessWidget {
  final CollectionReference activitiesCollection =
      FirebaseFirestore.instance.collection('activities');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Weekly Performance Summary'),
        backgroundColor: Color.fromARGB(255, 127, 128, 77),),
      body: Container(
        decoration: const BoxDecoration(
           gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color.fromARGB(255, 92, 131, 162), Color.fromARGB(255, 79, 177, 181)],
            ),
        ),
        child: StreamBuilder<QuerySnapshot>(
        stream: activitiesCollection.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          List<Activity> activities = snapshot.data!.docs
              .map((DocumentSnapshot document) => Activity.fromSnapshot(document))
              .toList();

          if (activities.isEmpty) {
            return Center(child: Text('No activities available'));
          }

          // Calculate average scores
          Map<String, List<int>> scoresMap = {};

          activities.forEach((activity) {
            if (scoresMap.containsKey(activity.name)) {
              scoresMap[activity.name]!.add(activity.efficiencyScore);
            } else {
              scoresMap[activity.name] = [activity.efficiencyScore];
            }
          });

          List<Widget> averageScoreWidgets = [];

          scoresMap.forEach((activityName, scores) {
            int averageScore = scores.reduce((a, b) => a + b) ~/ scores.length;
            averageScoreWidgets.add(
              ListTile(
                title: Text(activityName),
                subtitle: Text('Average Score: $averageScore%'),
              ),
            );
          });

          return ListView(children: averageScoreWidgets);
        },
      ),
    ));
  }
}
