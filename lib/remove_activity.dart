import 'package:activity_tracker/activity.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> _removeActivity(
  BuildContext context,
  Activity activity,
  CollectionReference<Map<String, dynamic>> activitiesCollection,
) async {
  bool? confirmDelete = await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Remove Activity'),
        content: Text('Are you sure you want to remove this activity?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true); 
            },
            child: Text('Remove'),
          ),
        ],
      );
    },
  );

  if (confirmDelete ?? false) {
    await activitiesCollection.doc(activity.id).delete();
  }
}
