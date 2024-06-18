import 'package:flutter/material.dart';

class MoreOptionsDialog extends StatelessWidget {
  const MoreOptionsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.bookmark),
            title: const Text('Save'),
            onTap: () {
              //  Save action
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: const Icon(Icons.link),
            title: const Text('Copy link to post'),
            onTap: () {
              //  Copy link action
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: const Icon(Icons.visibility_off),
            title: const Text('I don\'t want to see this'),
            onTap: () {
              //  Hide post action
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: const Icon(Icons.person_add),
            title: const Text('Unfollow'),
            onTap: () {
              //  Unfollow action
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: const Icon(Icons.report),
            title: const Text('Report post'),
            onTap: () {
              //  Report post action
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
