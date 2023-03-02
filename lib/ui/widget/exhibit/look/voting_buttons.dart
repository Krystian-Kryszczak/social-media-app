import 'package:flutter/material.dart';

import '../../../../model/exhibit/votable.dart';
import '../../../style/palette/palette.dart';

class VoteButtons extends StatefulWidget {
  final Votable votable;

  const VoteButtons({
    super.key,
    required this.votable
  });

  @override
  State<VoteButtons> createState() => _VoteButtonsState();
}

class _VoteButtonsState extends State<VoteButtons> {
  @override
  Widget build(BuildContext context) {
    void onVote(bool voteUp) {
      if (widget.votable.isVoted()) {
        widget.votable.cancelVote();
      } else if (voteUp) {
        widget.votable.voteUp();
      } else {
        widget.votable.voteDown();
      }
      setState(() {});
    }
    return Container(
      margin: const EdgeInsets.only(left: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // InkWell(
          //   child: SizedBox(height: 25.0,
          //     child: Icon(FontAwesomeIcons.angleUp, color: vote_!=null && (vote_??false) ? Palette.upVoteColor : widget.color, size: 20.0)),
          //   onTap: () async {
          //     bool? vote = vote_!=null && (vote_??false) ? null : true;
          //     debugPrint(vote.toString());
          //     setState(()=>vote=vote);
          //     await widget.post.vote(vote);
          //   },
          // ),
          VoteButton(voteUp: true, onPressed: onVote),
          const SizedBox(width: 12.0),
          Text(widget.votable.rating.toString()),
          const SizedBox(width: 12.0),
          VoteButton(voteUp: false, onPressed: onVote)
        ],
      ),
    );
  }
}
class VoteButton extends StatefulWidget {
  final bool initialValue;
  final bool voteUp;
  final void Function(bool checked) onPressed;

  const VoteButton({
    super.key,
    this.initialValue = false,
    required this.voteUp,
    required this.onPressed
  });

  @override
  State<VoteButton> createState() => _VoteButtonState();
}

class _VoteButtonState extends State<VoteButton> {
  @override
  Widget build(BuildContext context) {
    bool checked = widget.initialValue;
    Color voteColor = widget.voteUp ? Palette.upVoteColor : Palette.downVoteColor;
    return InkWell(
      onTap: () {
        setState(()=>checked = !checked);
        widget.onPressed(checked);
      },
      child: SizedBox(
        height: 25.0,
        child: Icon(
            widget.voteUp ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
            color: checked ? voteColor : null, size: 20.0
        ),
      ),
    );
  }
}
