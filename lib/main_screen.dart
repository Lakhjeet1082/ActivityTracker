import 'package:activity_tracker/addActivityScreen.dart';
import 'package:activity_tracker/weekly_summary.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/activity.dart';
import 'package:activity_tracker/remove_activity.dart';

class MainScreen extends StatelessWidget {
    final CollectionReference<Map<String, dynamic>> activitiesCollection =
      FirebaseFirestore.instance.collection('activities');

      
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
              Navigator.of(context).pop(false); // Cancel deletion
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true); // Confirm deletion
            },
            child: Text('Remove'),
          ),
        ],
      );
    },
  );

  if (confirmDelete ?? false) {
    // Remove the activity from Firestore
    await activitiesCollection.doc(activity.id).delete();
  }
}

Future<void> updateEfficiencyScore(Activity activity, int newEfficiencyScore) async {
  final CollectionReference<Map<String, dynamic>> activitiesCollection =
      FirebaseFirestore.instance.collection('activities');

  try {
    DocumentReference<Map<String, dynamic>> activityRef = activitiesCollection.doc(activity.id);

    await activityRef.update({
      'efficiencyScore': newEfficiencyScore,
    });

  } catch (e) {
    print('Error updating efficiency score: $e');

  }
}
Future<void> _editEfficiencyScore(BuildContext context, Activity activity) async {
  int? newEfficiencyScore = await showDialog<int?>(
    context: context,
    builder: (BuildContext context) {
      int? updatedScore = activity.efficiencyScore;
      return AlertDialog(
        title: Text('Edit Efficiency Score'),
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Current Score: $updatedScore'),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'New Score'),
                  onChanged: (value) {
                    
                    int? parsedValue = int.tryParse(value);
                    if (parsedValue != null) {
                      setState(() {
                        updatedScore = parsedValue;
                      });
                    }
                  },
                ),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(updatedScore);
            },
            child: Text('Save'),
          ),
        ],
      );
    },
  );

  if (newEfficiencyScore != null) {
      updateEfficiencyScore(activity, newEfficiencyScore);
  }
}

  @override
  Widget build(BuildContext context) {
    return Stack(
      children:[ Scaffold(
        appBar: AppBar(title: Text('Activity Tracker'),
        backgroundColor: Color.fromARGB(255, 127, 128, 77), 
        actions: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
             
              },
            ),
            IconButton(
              icon: Icon(Icons.notifications),
              onPressed: () {
                
              },
            ),
          ],
        ),
          drawer: Drawer(
      child: Container(
        color: Color.fromARGB(255, 98, 169, 202),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
          decoration: BoxDecoration(
        color: Color.fromARGB(255, 127, 128, 77),
          ),
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: AssetImage('assets/profile_image.png'), 
          ),
          SizedBox(height: 10),
          Text(
            'Lakhjeet', 
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          Text(
            'jeetuppal121@gmail.com', 
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ],
          ),
        )
        ,
            ListTile(
              tileColor: Color.fromARGB(255, 184, 151, 113),
              title: Text('Weekly Summary'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WeeklySummaryScreen()),
                );
              },
            ),
            ListTile(
              tileColor: Color.fromARGB(255, 184, 151, 113),
              title: Text('Add Activity'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddActivityScreen()),
                );
              },
            ),
          ],
        ),
      ),
        ),
        body:
        Container(
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
      
            return ListView.builder(
  itemCount: activities.length,
  itemBuilder: (context, index) {
    String formattedTime =
        '${activities[index].scheduledTime.hour}:${activities[index].scheduledTime.minute.toString().padLeft(2, '0')}';
    return Dismissible(
      key: Key(activities[index].id), // Unique key for each item
      onDismissed: (direction) {
        print('Item ${activities[index].id} dismissed');
        _removeActivity(context, activities[index], activitiesCollection);
      },
      background: Container(
        color: Colors.red,
        child: Icon(Icons.delete),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20.0),
      ),
      child: ListTile(
        title: Text(
          activities[index].name,
          style: TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          'Scheduled Time: $formattedTime',
          style: TextStyle(color: Colors.white),
        ),
        trailing: IconButton(
          color: Colors.black,
          icon: Icon(Icons.edit),
          onPressed: () {
            _editEfficiencyScore(context, activities[index]);
          },
        ),
      ),
    );
  },
);

          },
        ),),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddActivityScreen()),
            );
          }, 
           backgroundColor: Color.fromARGB(255, 127, 128, 77), 
          child: Icon(Icons.add),
        ),
          
      ),
      ],
    );
  }
}