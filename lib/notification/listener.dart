import 'package:firebase_database/firebase_database.dart';
import 'package:inside_company/notification/build_show.dart';

void listenToRealtimeUpdates(String target) {
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.ref().child('notification/$target/');

  _databaseReference.onValue.listen((event) {
    final data = event.snapshot.value;
    if (data is Map<Object?, Object?>) {
      showNotification(data,target);
    } else {
      print('Unexpected data format: $data');
    }
  });
}
