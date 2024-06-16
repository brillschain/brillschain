import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:supplink/Backend/firebase/allUserDetails.dart';
// import 'package:supplink/Backend/firebase/allUserDetails.dart';
// import 'package:supplink/Backend/firebase/users.dart';
import 'package:supplink/Home/messages/messagecard.dart';

import 'package:supplink/Providers/firebase/firebase_providers.dart';
import 'package:supplink/models/user_model.dart';

import 'package:timeago/timeago.dart' as timeago;

class MessagesConnections extends StatefulWidget {
  const MessagesConnections({super.key});

  @override
  State<MessagesConnections> createState() => _MessagesConnectionsState();
}

class _MessagesConnectionsState extends State<MessagesConnections> {
  UserData? selectedUser;
  void selectUser(UserData user) {
    setState(() {
      selectedUser = user;
    });
    // print("Message connections: ${selectedUser!.name}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SizedBox(
            width: 370,
            child: Card(
              elevation: 2,
              child: ChatScreen(
                onChatSelected: selectUser,
              ),
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                SizedBox(
                  height: double.infinity,
                  child: Card(
                    elevation: 1,
                    child: selectedUser != null
                        ? MessageCard(
                            selectedUser: selectedUser!,
                          )
                        : const Center(
                            child: Text(
                              'Select the chat to display messages',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
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
    return Scaffold(
        body: Consumer<FirebaseProvider>(builder: (context, value, child) {
      return ListView.builder(
          itemCount: value.users.length,
          itemBuilder: (context, index) {
            return value.users[index].uid !=
                    FirebaseAuth.instance.currentUser?.uid
                ? UserItem(
                    user: value.users[index],
                    onChatSelected: (userName) {
                      widget.onChatSelected(userName);
                    },
                  )
                : const SizedBox();
          });
    }));
  }
}

class UserItem extends StatefulWidget {
  final Function(UserData) onChatSelected;
  const UserItem({super.key, required this.user, required this.onChatSelected});
  final UserData user;

  @override
  State<UserItem> createState() => _UserItemState();
}

class _UserItemState extends State<UserItem> {
  @override
  Widget build(BuildContext context) {
    return HoverButton(
      onPressed: () {
        setState(() {
          widget.onChatSelected(widget.user);
        });
        // print(widget.user.name);
      },
      child: ListTile(
        leading: Stack(
          alignment: Alignment.bottomRight,
          children: [
            CircleAvatar(
              radius: 30,
              foregroundImage: widget.user.profileUrl != ''
                  ? NetworkImage(widget.user.profileUrl)
                  : null,
              child: widget.user.profileUrl == ''
                  ? Text(widget.user.name[0])
                  : null,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8, right: 5),
              child: CircleAvatar(
                radius: 5,
                backgroundColor:
                    widget.user.isonline ? Colors.green : Colors.red,
              ),
            )
          ],
        ),
        title: Text(
          widget.user.name,
          style: const TextStyle(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          'Last seen:${timeago.format(widget.user.lastseen)}',
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

class HoverButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Widget child;

  const HoverButton({super.key, required this.onPressed, required this.child});

  @override
  State<HoverButton> createState() => _HoverButtonState();
}

class _HoverButtonState extends State<HoverButton> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => onHover(true),
      onExit: (_) => onHover(false),
      child: GestureDetector(
        onTap: () {
          widget.onPressed();
          onHover(true);
        },
        child: Container(
          decoration: BoxDecoration(
            color: isHovered ? Colors.grey[300] : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: widget.child,
        ),
      ),
    );
  }

  void onHover(bool hover) {
    setState(() {
      isHovered = hover;
    });
  }
}
