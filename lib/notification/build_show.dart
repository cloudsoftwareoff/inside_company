  import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_database/firebase_database.dart';

Future<void> showNotification(Map<Object?, Object?> data,String target) async {
    data.forEach(
      (key, value) {
        try{
        final innerMap = value as Map<Object?, Object?>;
        final title = innerMap['title'];
        if (title != null && innerMap['r'] =="0") {
          AwesomeNotifications().createNotification(
            content: NotificationContent(
              
              id: key.hashCode,
              channelKey: "cloudsoftware",
              title: "${innerMap['topic']}  ${innerMap['state']}",
              body: "$title",
            ),
          );
          //Mark as read
          final databaseRef = FirebaseDatabase.instance
              .ref()
              .child('notification/$target/${innerMap['id']}/');
          databaseRef.update({
            "r": "1",
          });
        }
        }catch(e){}
      },
    );
  }