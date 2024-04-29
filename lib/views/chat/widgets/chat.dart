import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:inside_company/model/user_model.dart';
import 'package:inside_company/providers/users_list.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final DatabaseReference _messagesRef =
      FirebaseDatabase.instance.ref().child('messages');
  TextEditingController _messageController = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _messageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userList = Provider.of<UserListProvider>(context).users;

    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: _messagesRef.orderByChild('time').onValue,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  var messagesData =
                      (snapshot.data!.snapshot.value ?? {}) as Map;
                  var messages = messagesData.entries.toList();
                  messages.sort((a, b) => int.parse(b.value['time'])
                      .compareTo(int.parse(a.value['time'])));

                  print(messages);
                  return ListView.builder(
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      var message = messages[index].value;
                      //  print(message);
                      UserModel user = userList.firstWhere(
                        (element) => element.uid == message['sender'],
                      );
                      return _buildChatBubble(
                          user, message['message'], message['time']);
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                          hintText: 'Enter message',
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black))),
                      onSubmitted: (value) {
                        _sendMessage(value);
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () {
                      _sendMessage(_messageController.text);
                    },
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  void _sendMessage(String text) {
   
    _messagesRef.push().set({
      'message': _messageController.text,
      'sender': FirebaseAuth.instance.currentUser!.uid,
      'time': Timestamp.now().millisecondsSinceEpoch.toString()
    });
    _messageController.clear();
  }
}

Widget _buildChatBubble(UserModel user, String message, String time) {
  bool sendByMe = user.uid == FirebaseAuth.instance.currentUser!.uid;
  return Align(
    alignment: sendByMe ? Alignment.centerRight : Alignment.centerRight,
    child: Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        mainAxisAlignment:
            sendByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: CircleAvatar(
              backgroundImage: NetworkImage(user.picture),
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.username,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                DateFormat('MMM-dd HH:mm:ss').format(
                    DateTime.fromMillisecondsSinceEpoch(int.parse(time))),
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: sendByMe ? Colors.blue : Colors.grey[300],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  message,
                  style:
                      TextStyle(color: sendByMe ? Colors.white : Colors.black),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
