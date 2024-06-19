import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

enum Reaction { like, love, support, insightful, none }

class ReactionButton extends StatefulWidget {
  const ReactionButton({super.key});

  @override
  State<ReactionButton> createState() => _ReactionButtonState();
}

class _ReactionButtonState extends State<ReactionButton> {
  Reaction reaction = Reaction.none;
  bool reactionView = false;
  List<ReactionData> reactionlist = [
    ReactionData(
      reaction: Reaction.like,
      icon: const Icon(
        Icons.thumb_up_alt,
        color: Colors.blue,
      ),
    ),
    ReactionData(
      reaction: Reaction.love,
      icon: const Icon(
        Icons.favorite,
        color: Colors.red,
      ),
    ),
    ReactionData(
      reaction: Reaction.insightful,
      icon: const Icon(
        Icons.lightbulb_outline,
        color: Colors.yellow,
      ),
    )
  ];
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          reactionView
              ? Container(
                  height: 40,
                  width: 120,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(25)),
                  child: AnimationLimiter(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: reactionlist.length,
                      itemBuilder: (BuildContext context, int index) {
                        return AnimationConfiguration.staggeredList(
                          position: index,
                          duration: const Duration(milliseconds: 375),
                          child: SlideAnimation(
                            verticalOffset: 20 + index * 10,
                            child: FadeInAnimation(
                              child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      reaction = reactionlist[index].reaction;
                                      reactionView = false;
                                    });
                                  },
                                  icon: reactionlist[index].icon),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                )
              : const SizedBox(),
          InkWell(
            onTap: () {
              setState(() {
                if (reactionView) {
                  reactionView = false;
                } else {
                  if (reaction == Reaction.none) {
                    reaction = Reaction.like;
                  } else {
                    reaction = Reaction.none;
                  }
                }
              });
            },
            onLongPress: () {
              setState(() {
                reactionView = true;
              });
            },
            child: getReaction(reaction),
          )
        ],
      ),
    );
  }

  Widget getReaction(Reaction rec) {
    switch (rec) {
      case Reaction.like:
        return const Row(
          children: [
            Icon(
              Icons.thumb_up_alt,
              color: Colors.blue,
            ),
            SizedBox(
              width: 10,
            ),
            Text('like')
          ],
        );
      case Reaction.love:
        return const Row(
          children: [
            Icon(
              Icons.favorite,
              color: Colors.red,
            ),
            SizedBox(
              width: 10,
            ),
            Text('love')
          ],
        );
      case Reaction.insightful:
        return const Row(
          children: [
            Icon(
              Icons.lightbulb_outline,
              color: Colors.yellow,
            ),
            SizedBox(
              width: 10,
            ),
            Text('insightful')
          ],
        );

      default:
        return const Row(
          children: [
            Icon(Icons.thumb_up_alt),
            SizedBox(
              width: 10,
            ),
            Text('like')
          ],
        );
    }
  }
}

class ReactionData {
  final Reaction reaction;
  final Icon icon;

  ReactionData({required this.reaction, required this.icon});
}
