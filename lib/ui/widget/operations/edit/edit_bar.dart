import 'package:flutter/material.dart';
import 'package:photofilters/filters/filters.dart';
import 'package:photofilters/filters/preset_filters.dart';

import '../../../../language/language.dart';

class EditBar extends StatefulWidget {
  final Image image;

  const EditBar({
    super.key,
    required this.image
  });

  List<String> get editSections => [Language.getLangPhrase(Phrase.filter), Language.getLangPhrase(Phrase.edit)];
  @override
  State<EditBar> createState() => _EditBarState();
}
class _EditBarState extends State<EditBar> with SingleTickerProviderStateMixin {
  late TabController controller;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: widget.editSections.length, vsync: this);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
  int selected = 0;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return SafeArea(
      child: FractionallySizedBox(
        heightFactor: .275,
        child: Container(
          color: theme.colorScheme.surface,
          child: Column(
            children: [
              Expanded(
                child: IndexedStack(
                  index: selected,
                  children: [
                    _Filters(image: widget.image),
                    const _EditToolBox(),
                  ],
                ),
              ),
              TabBar(
                tabs: widget.editSections.map((label) => Tab(text: label)).toList(), controller: controller,
                indicator: BoxDecoration(border: Border(bottom: BorderSide(color: theme.colorScheme.secondary, width: 3.0))),
                onTap: (i) => setState(() => selected=i),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class _Filters extends StatefulWidget {
  final Image image;

  const _Filters({
    super.key,
    required this.image
  });

  @override
  State<_Filters> createState() => _FiltersState();
}
class _FiltersState extends State<_Filters> {
  int selected = 0;
  @override
  Widget build(BuildContext context) {
    List<Filter> filters = presetFiltersList;
    Size size = MediaQuery.of(context).size;
    ThemeData theme = Theme.of(context);
    Color selectedColor = theme.colorScheme.secondary;
    Color color = theme.cardColor;
    return ListView.builder(
      itemCount: filters.length,
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
      itemBuilder: (context, index) => AspectRatio(aspectRatio: 1,
        child: InkWell(
          onTap: () => setState(() => selected=index),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(filters[index].name, style: TextStyle(color: selected==index ? selectedColor : null)),
                Container(
                  height: size.height*.1,
                  color: color,
                  child: widget.image
                )
              ],
            ),
          ),
        ),
      )
    );
  }
}

class _EditToolBox extends StatelessWidget {
  const _EditToolBox({
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 0,
      itemBuilder: (context, index) => Container(),
    );
  }
}
