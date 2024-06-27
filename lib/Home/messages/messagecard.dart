// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:supplink/Backend/firebase/firebase_firestore_services_msg.dart';
import 'package:supplink/Home/messages/chattextfield.dart';
import 'package:supplink/Home/messages/messagebubble.dart';

import 'package:supplink/Providers/firebase/firebase_providers.dart';
import 'package:supplink/models/message_model.dart';
import 'package:supplink/models/user_model.dart';

// import 'package:timeago/timeago.dart' as timeago;

class MessageCard extends StatefulWidget {
  final UserData selectedUser;
  // final String userId;
  const MessageCard({
    super.key,
    required this.selectedUser,
  });

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    fetchMessages(widget.selectedUser.uid);
  }

  @override
  void didUpdateWidget(MessageCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedUser != widget.selectedUser) {
      WidgetsBinding.instance.addObserver(this);
      fetchMessages(widget.selectedUser.uid);
    }
  }

  void fetchMessages(String userId) {
    Provider.of<FirebaseProvider>(context, listen: false)
      ..getUserById(userId)
      ..getMessages(userId);
    print("message card: ${widget.selectedUser.name}");
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        FirebaseFirestoreServiceMessages.updateUserData({
          'lastseen': DateTime.now(),
          'isonline': true,
        });
        break;

      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        FirebaseFirestoreServiceMessages.updateUserData({'isonline': false});
        break;
      case AppLifecycleState.hidden:
      // TODO: Handle this case.
    }
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: messageCardAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: ChatMessages(
                receiverId: widget.selectedUser.uid,
              ),
            ),
            // const Spacer(),
            // ChatTextField(),
          ],
        ),
      ),
      bottomNavigationBar: ChatTextField(
        receiverId: widget.selectedUser.uid,
      ),
    );
  }

  AppBar messageCardAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0,
      foregroundColor: Colors.black,
      backgroundColor: Colors.transparent,
      title: Consumer<FirebaseProvider>(builder: (context, value, child) {
        return value.user != null
            ? Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    foregroundImage: value.user!.profileUrl != ''
                        ? NetworkImage(value.user!.profileUrl)
                        : null,
                    child: value.user!.profileUrl == ''
                        ? Text(value.user!.name[0])
                        : null,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    children: [
                      Text(
                        value.user!.name,
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      Text(
                        value.user!.isonline ? 'Online' : 'Offline',
                        style: TextStyle(
                          color:
                              value.user!.isonline ? Colors.green : Colors.grey,
                          fontSize: 14,
                        ),
                      )
                    ],
                  )
                ],
              )
            : const SizedBox();
      }),
    );
  }
}

class ChatMessages extends StatefulWidget {
  final String receiverId;
  const ChatMessages({super.key, required this.receiverId});

  @override
  State<ChatMessages> createState() => _ChatMessagesState();
}

class _ChatMessagesState extends State<ChatMessages> {
  // final messages = [
  //   Message(
  //       senderId: '2',
  //       receiverId: '8RWgrfKTDBWVOc5Kn5vuGzQGV3z1',
  //       content: 'Hello',
  //       sentTime: DateTime.now(),
  //       messageType: MessageType.text),
  //   Message(
  //       senderId: '8RWgrfKTDBWVOc5Kn5vuGzQGV3z1',
  //       receiverId: '2',
  //       content: 'How are you?',
  //       sentTime: DateTime.now(),
  //       messageType: MessageType.text),
  //   Message(
  //       senderId: '2',
  //       receiverId: '8RWgrfKTDBWVOc5Kn5vuGzQGV3z1',
  //       content: 'Fine',
  //       sentTime: DateTime.now(),
  //       messageType: MessageType.text),
  //   Message(
  //       senderId: '8RWgrfKTDBWVOc5Kn5vuGzQGV3z1',
  //       receiverId: '2',
  //       content: 'What are you doing?',
  //       sentTime: DateTime.now(),
  //       messageType: MessageType.text),
  //   Message(
  //       senderId: '2',
  //       receiverId: '8RWgrfKTDBWVOc5Kn5vuGzQGV3z1',
  //       content: 'Nothing',
  //       sentTime: DateTime.now(),
  //       messageType: MessageType.text),
  //   Message(
  //       senderId: '8RWgrfKTDBWVOc5Kn5vuGzQGV3z1',
  //       receiverId: '2',
  //       content: 'Can you help me?',
  //       sentTime: DateTime.now(),
  //       messageType: MessageType.text),
  //   Message(
  //       senderId: '2',
  //       receiverId: '8RWgrfKTDBWVOc5Kn5vuGzQGV3z1',
  //       content:
  //           'https://images.unsplash.com/photo-1669992755631-3c46eccbeb7d?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHwxMHx8fGVufDB8fHx8&auto=format&fit=crop&w=500&q=60',
  //       sentTime: DateTime.now(),
  //       messageType: MessageType.image),
  //   Message(
  //       senderId: '8RWgrfKTDBWVOc5Kn5vuGzQGV3z1',
  //       receiverId: '2',
  //       content: 'Thank you',
  //       sentTime: DateTime.now(),
  //       messageType: MessageType.text),
  //   Message(
  //     senderId: '2',
  //     receiverId: '8RWgrfKTDBWVOc5Kn5vuGzQGV3z1',
  //     content: 'You are welcome',
  //     sentTime: DateTime.now(),
  //     messageType: MessageType.text,
  //   ),
  //   Message(
  //       senderId: '8RWgrfKTDBWVOc5Kn5vuGzQGV3z1',
  //       receiverId: '2',
  //       content: 'Bye',
  //       sentTime: DateTime.now(),
  //       messageType: MessageType.text),
  //   Message(
  //       senderId: '2',
  //       receiverId: '8RWgrfKTDBWVOc5Kn5vuGzQGV3z1',
  //       content: 'Bye',
  //       sentTime: DateTime.now(),
  //       messageType: MessageType.text),
  //   Message(
  //       senderId: '8RWgrfKTDBWVOc5Kn5vuGzQGV3z1',
  //       receiverId: '2',
  //       content: 'See you later',
  //       sentTime: DateTime.now(),
  //       messageType: MessageType.text),
  //   Message(
  //       senderId: '2',
  //       receiverId: '8RWgrfKTDBWVOc5Kn5vuGzQGV3z1',
  //       content: 'See you later',
  //       sentTime: DateTime.now(),
  //       messageType: MessageType.text)
  // ];

  @override
  Widget build(BuildContext context) {
    return Consumer<FirebaseProvider>(builder: (context, value, child) {
      return value.messages.isEmpty
          ? const EmptyWidget(icon: Icons.waving_hand, text: 'Say Hello!')
          : ListView.builder(
              controller: Provider.of<FirebaseProvider>(context, listen: false)
                  .scrollController,
              itemCount: value.messages.length,
              itemBuilder: (context, index) {
                final isTextMessaage =
                    value.messages[index].messageType == MessageType.text;
                final isMe =
                    widget.receiverId != value.messages[index].senderId;
                // final isMe = value.messages[index].senderId ==
                //     FirebaseAuth.instance.currentUser!.uid;
                return isTextMessaage
                    ? MessageBubble(
                        message: value.messages[index],
                        isMe: isMe,
                        isImage: false,
                      )
                    : MessageBubble(
                        message: value.messages[index],
                        isMe: isMe,
                        isImage: true,
                      );
              });
    });
  }
}

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({super.key, required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, size: 100),
            Text(
              text,
              style: const TextStyle(fontSize: 30),
            ),
          ],
        ),
      );
}
