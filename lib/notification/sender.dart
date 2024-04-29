import 'package:firebase_database/firebase_database.dart';

// DO NOT PLAYING AROUND WITH ATTRIBUTE NAMES
Future<void> sendNotification(String target,  String title,
    String topic, String state) async {
       String _id = DateTime.now().millisecondsSinceEpoch.toString();
  final databaseRef =
      FirebaseDatabase.instance.ref().child('notification/$target/$_id/');
  await databaseRef.set({
    "title": title,
    "r": "0",
    "id": _id,
    "topic": topic,
    "state": state
  });
}
