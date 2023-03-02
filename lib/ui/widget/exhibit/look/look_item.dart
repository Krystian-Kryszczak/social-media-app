import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/extension/datetime/datetime_formatter.dart';
import 'package:frontend/io/storage/network_files.dart';
import 'package:frontend/launch/routes/app_router.dart';
import 'package:frontend/service/services.dart';
import 'package:frontend/service/user/user_service.dart';
import 'package:frontend/ui/widget/image/app_circle_avatar.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../language/language.dart';
import '../../../../model/being/user/user.dart';
import '../../../../model/exhibit/exhibit.dart';
import '../../../../model/exhibit/look/look.dart';
import '../../../style/palette/palette.dart';
import 'voting_buttons.dart';

UserService userService = Services.userService;

class LookItem extends StatelessWidget {
  final Look look;

  const LookItem({
    super.key,
    required this.look
  });

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final bool widthWiderThan800 = size.width > 800;
    return Card(
      margin: EdgeInsets.symmetric(
        vertical: 5.0,
        horizontal: widthWiderThan800 ? 5.0 : 0.0
      ),
      elevation: 1.0,
      shape: widthWiderThan800 ? RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)) : null,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          children: [
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _LookHeader(look: look),
                    const SizedBox(height: 4.0),
                    Text(
                      look.name,
                      style: const TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(look.description),
                    const SizedBox(height: 12.0),
                  ]
                )
            ),
            _LookImages(look: look),
            Padding(padding: const EdgeInsets.symmetric(horizontal: 12.0), child: _LookButtons(look: look))
          ],
        ),
      ),
    );
  }
}

class _LookImages extends StatelessWidget {
  final Look look;
  
  const _LookImages({
    super.key,
    required this.look,
  });
  
  @override
  Widget build(BuildContext context) {
    if (!look.hasImages || look.id == null) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: NetworkFiles.getNetworkImage(url: Look.getLookImageUrlById(id: look.id!)),
    );
  }
}

class _LookHeader extends StatelessWidget {
  final Look look;

  const _LookHeader({
    super.key,
    required this.look
  });

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: () => Navigator.pushNamed(
      context,
      AppRouter.profileRoute,
      arguments: look.creatorId
    ),
    child: Row(
      children: [
        AppCircleAvatar(avatar: User.getCreatorAvatarImageWidgetForUserWithId(id: look.creatorId)),
        const SizedBox(width: 8.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(look.creatorName ?? Language.getLangPhrase(Phrase.lackOfInfo), style: const TextStyle(fontWeight: FontWeight.w600)), // look.user.name
              Text(DateTime.now().formatDateTimeAgo(), style: const TextStyle(fontSize: 12.0)),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.more_horiz),
          onPressed: () => _more(context, look)
        )
      ]
    )
  );
}

class _LookButtons extends StatelessWidget {
  final Look look;

  const _LookButtons({
    super.key,
    required this.look
  });

  @override
  Widget build(BuildContext context) {
    Color color = Theme.of(context).highlightColor;
    return Column(
      children: [
        InkWell(
          onTap: () => _comments(context, look, false),
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width/1.1,
              height: 4.0,
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              decoration: BoxDecoration(
                gradient: Palette.mainGradient,
                borderRadius: BorderRadius.circular(4.0),
              ),
            ),
          ),
        ),
        const Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            VoteButtons(votable: look),
            _LookButton(
              icon: const Icon(FontAwesomeIcons.message, size: 20.0),
              label: Language.getLangPhrase(Phrase.writeComment),
              onTab: () {}// => _comments(context, post, true)
            ),
            _LookButton(
              icon: const Icon(FontAwesomeIcons.shareNodes, size: 20.0),
              label: Language.getLangPhrase(Phrase.share),
              onTab: () => share(context)
            ),
          ],
        )
      ],
    );
  }

  void share(BuildContext context) {
    String? url = look.getUrl();
    if (url!=null) {
      Share.share(url);
    } else {
      ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
      messenger.showSnackBar(SnackBar(
        content: Text(Language.getLangPhrase(Phrase.itNotHaveUrlToShare)),
        action: SnackBarAction(label: Language.getLangPhrase(Phrase.ok), onPressed: () => messenger.hideCurrentSnackBar()),
      ));
    }
  }
}

class _LookButton extends StatelessWidget {
  final Icon icon;
  final String? label;
  final void Function()? onTab;

  const _LookButton({
    super.key,
    required this.icon,
    this.label,
    required this.onTab
  });

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTab,
    child: SizedBox(
      height: 25.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon,
          const SizedBox(width: 4.0),
          Text(
            label ?? '',
            style: const TextStyle(fontWeight: FontWeight.w600),
            maxLines: 1
          )
        ],
      ),
    ),
  );
}

class _SelectItem extends StatefulWidget {
  final List<String> items;
  final void Function(String) onChanged;

  const _SelectItem({
    super.key,
    required this.items,
    required this.onChanged
  });

  @override
  State<_SelectItem> createState() => _SelectItemState();
}

class _SelectItemState extends State<_SelectItem> {
  late String selectedValue = widget.items.isNotEmpty ? widget.items[0] : '';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0),
      child: DropdownButton(
        hint: Text(selectedValue, style: TextStyle(fontSize: 14, color: Colors.grey[800])),
        items: widget.items.map((item) => DropdownMenuItem<String>(value: item, child: Text(item, style: const TextStyle(overflow: TextOverflow.clip),))).toList(),
        value: selectedValue,
        onChanged: (value) {
          setState(() {
            selectedValue = value as String;
          });
          widget.onChanged(value as String);
        },
        itemHeight: 40,
      ),
    );
  }
}

class _ChatInputField extends StatefulWidget {
  final bool autofocus;
  final Look look;

  const _ChatInputField({
    super.key,
    required this.autofocus,
    required this.look
  });

  @override
  State<_ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<_ChatInputField> {
  TextEditingController controller = TextEditingController();
  String comment = '';
  
  @override
  Widget build(BuildContext context) {
    Color color = Theme.of(context).cardColor;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 4), blurRadius: 32,
            color: color.withOpacity(0.08),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const SizedBox(width: 5.0),
                        Expanded(
                          child: TextField(
                            controller: controller,
                            autofocus: widget.autofocus, autocorrect: true,
                            decoration: InputDecoration(hintText: Language.getLangPhrase(Phrase.writeComment), border: InputBorder.none),
                            enableSuggestions: true,
                            onChanged: (value) => comment = value,
                            onSubmitted: (value) => _addComment(value, widget.look),
                          ),
                        ),
                        const SizedBox(width: 5.0),
                        IconButton(icon: const Icon(FontAwesomeIcons.paperPlane, color: Colors.blue), onPressed: ()=>_addComment(comment, widget.look)),
                        const SizedBox(width: 5.0),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Future<void> _addComment(String comment, Look look) async {
    look.addComment(comment);
    controller.clear();
  }
}

class _Comment extends StatelessWidget {
  final Look look;
  final User? user;
  final String comment;

  const _Comment({
    super.key,
    required this.look,
    required this.user,
    required this.comment
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (user != null) CircleAvatar(backgroundImage: user!.avatarImage),
        const SizedBox(width: 4.0),
        Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width-64,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0)),
              padding: const EdgeInsets.all(4.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user?.name ?? Language.getLangPhrase(Phrase.lackOfInfo), style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                  Text(comment, textAlign: TextAlign.left, style: const TextStyle(color: Colors.black))
                ],
              ),
            ),
          ],
        )
      ],
    );
  }
}

class _SingleThumbUpButton extends StatefulWidget {
  final void Function() onPressed;
  final bool isPressed;

  const _SingleThumbUpButton({
    super.key,
    required this.onPressed,
    required this.isPressed
  });

  @override
  State<_SingleThumbUpButton> createState() => _SingleThumbUpButtonState();
}

class _SingleThumbUpButtonState extends State<_SingleThumbUpButton> {
  late bool isLiked = widget.isPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(FontAwesomeIcons.thumbsUp, color: isLiked ? Palette.primaryColor : Colors.black),
      onPressed: (){widget.onPressed; setState(()=>isLiked=!isLiked);},
    );
  }
}

class _SingleSearchUserButton extends StatelessWidget {
  final void Function() onPressed;

  const _SingleSearchUserButton({
    super.key,
    required this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.search, color: Colors.black),
      onPressed: onPressed,
    );
  }
}

class _Comments extends StatefulWidget {
  final Look look;
  final bool autofocus;
  final CommentsSort sortBy;

  const _Comments({
    super.key,
    required this.look,
    this.autofocus = false,
    required this.sortBy
  });

  @override
  State<_Comments> createState() => _CommentsState();
}
class _CommentsState extends State<_Comments> {
  int rate = 0;
  List<String> comments = [];
  CommentsSort sortBy = CommentsSort.mostRelevant;
  
  @override
  void initState() {
    super.initState();
    widget.look.getRating().then((value) => setState(()=>rate = value));
    sortBy = widget.sortBy;
    _loadComments(sortBy);
  }
  
  bool _loadComments(CommentsSort sortBy){
    bool result = true;
    // widget.look.comments(sortBy)
    //   .then(
    //     (value) => comments = value,
    //     onError: (_) => result = false
    //   );
    return result;
  }
  
  @override
  Widget build(BuildContext context) {
    String theMostRelevant = Language.getLangPhrase(Phrase.theMostRelevant),
           theLatest = Language.getLangPhrase(Phrase.theLatest),
           allComments = Language.getLangPhrase(Phrase.allComments);
    return Container(
      height: MediaQuery.of(context).size.height-80,
      margin: const EdgeInsets.only(top: 2.0),
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width/2.85, height: 8.0,
                decoration: BoxDecoration(gradient: Palette.mainGradient, borderRadius: BorderRadius.circular(8.0)),
                margin: const EdgeInsets.symmetric(vertical: 4.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Text(rate.toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(width: 8.0), if (rate>0) ...[const Icon(Icons.keyboard_arrow_up, color: Palette.upVoteColor, size: 30)]
                        else if (rate<0) ...[const Icon(Icons.keyboard_arrow_down, color: Palette.downVoteColor, size: 30)],
                      ],
                    ),
                  ),
                  _SingleSearchUserButton(onPressed: () async => debugPrint('Search user in comment reactions.')),
                ],
              ),
            ),
            const Divider(color: Colors.grey, height: 1.0),
            // _SelectItem(
            //     items: <String>[theMostRelevant, theLatest, allComments],
            //     onChanged: (String value) {
            //       if (value==theMostRelevant) {
            //         setState((){
            //           sortBy=CommentsSort.mostRelevant;
            //           _loadComments(sortBy);
            //         });
            //       } else if (value==theLatest) {
            //         setState((){
            //           sortBy=CommentsSort.latest;
            //           _loadComments(sortBy);
            //         });
            //       } else if (value==allComments) {
            //         setState((){
            //           sortBy=CommentsSort.all;
            //           _loadComments(sortBy);
            //         });
            //       } else {
            //         setState((){
            //           sortBy=CommentsSort.mostRelevant;
            //           _loadComments(sortBy);
            //         });
            //       }
            //     }
            // ),
            const SizedBox(height: 16.0),
            Expanded(
                child: LimitedBox(
                  maxWidth: MediaQuery.of(context).size.width-64,
                  child: ListView.separated(
                    controller: ScrollController(),
                    itemBuilder: (context, index) => _Comment(look: widget.look, user: userService.currentUserUnsafe, comment: comments[index]),
                    separatorBuilder: (context, index) => const SizedBox(height: 8.0),
                    itemCount: comments.length,
                  ),
                )
            ),
            _ChatInputField(autofocus: widget.autofocus, look: widget.look)
          ],
        ),
      ),
    );
  }
}

void _comments(BuildContext context, Look look, bool autofocus) {
  showModalBottomSheet(
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16.0))),
    context: context, isScrollControlled: true,
    builder: (BuildContext context) => _Comments(look: look, autofocus: autofocus, sortBy: CommentsSort.all),
  );
}

void _more(BuildContext context, Look look) {
  int reactionsCount = 100;
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      List<String> comments = [];
      return Container(
        height: MediaQuery.of(context).size.height-80,
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                child: Row(
                  children: [
                    Row(
                      children: [
                        if (reactionsCount > 0) ...[ const Icon(Icons.thumb_up_outlined), const SizedBox(width: 4.0)],
                        Text(reactionsCount.toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
                        const Icon(Icons.arrow_forward_ios_rounded),
                      ],
                    ),
                    Expanded(child: Container()),
                    _SingleSearchUserButton(onPressed: () async => debugPrint('Search user in comment reactions.')),
                  ],
                ),
              ),
              const Divider(color: Colors.grey, height: 1.0),
              const SizedBox(height: 16.0),
              Expanded(
                  child: LimitedBox(
                    maxWidth: MediaQuery.of(context).size.width-64,
                    child: ListView.separated(
                      controller: ScrollController(),
                      itemBuilder: (context, index) => _Comment(look: look, user: Services.userService.currentUserUnsafe, comment: comments[index]),
                      separatorBuilder: (context, index) => const SizedBox(height: 8.0),
                      itemCount: comments.length,
                    ),
                  )
              ),
            ],
          ),
        ),
      );
    },
  );
}
