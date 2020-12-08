import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../chats/message_bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Message extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // return FutureBuilder(
    //   future: FirebaseAuth.instance.currentUser(),
    //   builder: (ctx, futureSnapshot) {
    //     if (futureSnapshot.connectionState == ConnectionState.waiting) {
    //       return Center(
    //         child: CircularProgressIndicator(),
    //       );
    //     }
    final user = FirebaseAuth.instance.currentUser;
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy(
            'createdAt',
            descending: true,
          )
          .snapshots(),
      builder: (ctx, chatSnapshot) {
        if (chatSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final chatDoc = chatSnapshot.data.documents;
        return ListView.builder(
          reverse: true,
          itemBuilder: (ctx, index) => MessageBubble(
            chatDoc[index].data()['text'],
            chatDoc[index].data()['userId'] == user.uid,
            chatDoc[index].data()['username'],
            chatDoc[index].data()['userImage'],
            key: ValueKey(chatDoc[index].documentID),
          ),
          itemCount: chatDoc.length,
        );
      },
    );
  }
}
