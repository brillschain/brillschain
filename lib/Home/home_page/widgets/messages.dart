import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:supplink/Providers/firebase/firebase_providers.dart';
import 'package:supplink/Providers/user_provider.dart';
// import 'package:supplink/Providers/user_provider.dart';
import 'package:supplink/models/user_model.dart';
import 'package:supplink/utils/hover_button.dart';
// import 'package:supplink/Home/drawer_pages/connectionsFolder/my_connections.dart';
// import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'chat_messages.dart';

class MessagesFloatingAction extends StatefulWidget {
  const MessagesFloatingAction({
    super.key,
  });

  @override
  State<MessagesFloatingAction> createState() => _MessagesFloatingActionState();
}

class _MessagesFloatingActionState extends State<MessagesFloatingAction> {
  bool showMessages = false;
  bool showchat = false;
  TextEditingController searchController = TextEditingController();
  UserData? userData;
  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, data, _) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: 400,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: const [
                BoxShadow(
                    offset: Offset(0, 2),
                    blurRadius: 2,
                    spreadRadius: 2,
                    color: Colors.black12)
              ]),
          // height: 600,
          child: showchat
              ? SizedBox(
                  height: 550,
                  child: MessageCard(
                    onBack: (bool val) {
                      setState(() {
                        showchat = !showchat;
                      });
                    },
                    selectedUser: userData!,
                  ),
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      child: HoverButton(
                        onPressed: () {
                          // print('ontap');
                          setState(() {
                            if (!showchat) {
                              showMessages = !showMessages;
                            }
                            if (showchat) {
                              showchat = false;
                            }
                          });
                        },
                        hoverColor: Colors.blue.withOpacity(0.1),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 2, horizontal: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Stack(
                                      alignment: Alignment.bottomRight,
                                      children: [
                                        CircleAvatar(
                                          radius: 24,
                                          backgroundImage: NetworkImage(
                                              data.getUser.profileUrl),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 6, right: 1),
                                          child: CircleAvatar(
                                              radius: 5,
                                              backgroundColor:
                                                  data.getUser.isonline
                                                      ? Colors.green
                                                      : Colors.red),
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    const Text(
                                      'Messaging',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                showMessages
                                    ? Icons.arrow_drop_up
                                    : Icons.arrow_drop_down,
                                size: 32,
                                color: Colors.black,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    if (showMessages) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 15),
                        child: Consumer<FirebaseProvider>(
                            builder: (context, value, _) {
                          return TextFormField(
                            onChanged: value.onSearch,
                            controller: searchController,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.only(left: 10),
                              hintText: 'Search...',
                              hintStyle: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                              suffixIcon: const Icon(
                                Icons.search,
                                size: 24,
                                color: Colors.blue,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor:
                                  const Color.fromARGB(117, 192, 223, 251),
                              // contentPadding: const EdgeInsets.all(0),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 420,
                        child: ChatScreen(
                          onChatSelected: (UserData data) {
                            setState(() {
                              showchat = !showchat;
                              // showMessages = !showMessages;
                              userData = data;
                              // print(data.name);
                            });
                          },
                        ),
                      ),
                    ],
                    // if (showchat) ...[
                    //   SizedBox(
                    //     height: 450,
                    //     child: MessageCard(
                    //       selectedUser: userData!,
                    //     ),
                    //   ),
                    // Container(
                    //   height: 500,
                    //   color: Colors.red,
                    // )
                    // ]
                  ],
                ),
        ),
      );
    });
  }
}

class ChatScreen extends StatefulWidget {
  final Function(UserData) onChatSelected;
  const ChatScreen({super.key, required this.onChatSelected});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<FirebaseProvider>(context, listen: false).getAllUsers();
  }

// final UserDetails
  @override
  Widget build(BuildContext context) {
    return Consumer<FirebaseProvider>(builder: (context, value, child) {
      return ListView.builder(
        shrinkWrap: true,
        // physics: const NeverScrollableScrollPhysics(),
        itemCount: value.users.length,
        itemBuilder: (context, index) {
          return value.users[index].uid !=
                  FirebaseAuth.instance.currentUser?.uid
              ? UserItem(
                  user: value.users[index],
                  onChatSelected: (value) {
                    widget.onChatSelected(value);
                  },
                )
              : const SizedBox();
        },
      );
    });
  }
}

class UserItem extends StatelessWidget {
  final Function(UserData) onChatSelected;
  const UserItem({
    super.key,
    required this.user,
    required this.onChatSelected,
  });
  final UserData user;

  @override
  Widget build(BuildContext context) {
    return HoverButton(
      onPressed: () {
        onChatSelected(user);

        // print(widget.user.name);
      },
      child: ListTile(
        leading: Stack(
          alignment: Alignment.bottomRight,
          children: [
            CircleAvatar(
              radius: 25,
              foregroundImage:
                  user.profileUrl != '' ? NetworkImage(user.profileUrl) : null,
              child: user.profileUrl == '' ? Text(user.name[0]) : null,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 4, right: 3),
              child: CircleAvatar(
                radius: 5,
                backgroundColor: user.isonline ? Colors.green : Colors.red,
              ),
            )
          ],
        ),
        title: Text(
          user.name,
          style: const TextStyle(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          'Last seen: ${timeago.format(user.lastseen)}',
          maxLines: 2,
          style: const TextStyle(
              color: Colors.black87,
              fontSize: 12,
              overflow: TextOverflow.ellipsis),
        ),
      ),
    );
  }
}
