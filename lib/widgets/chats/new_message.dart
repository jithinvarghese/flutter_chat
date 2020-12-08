import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NewMessage extends StatefulWidget {
  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  var _enterMessage = '';
  final _controller = new TextEditingController();

  void _sendMessage() async {
    FocusScope.of(context).unfocus();
    // give current user Id
    final user = await FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    FirebaseFirestore.instance.collection('chat').add({
      'text': _enterMessage,
      'createdAt': Timestamp.now(),
      'userId': user.uid,
      'username': userData.data()['username'],
      'userImage': userData.data()['imageURL'],
    });
    setState(() {
      _enterMessage = '';
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: 'send a message..'),
              onChanged: (value) {
                setState(() {
                  _enterMessage = value;
                });
              },
            ),
          ),
          IconButton(
              color: Theme.of(context).primaryColor,
              icon: Icon(Icons.send),
              onPressed: _enterMessage.trim().isEmpty ? null : _sendMessage),
        ],
      ),
    );
  }
}
