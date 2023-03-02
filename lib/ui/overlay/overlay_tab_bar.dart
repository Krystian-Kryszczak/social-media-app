import 'package:flutter/material.dart';

import '../widget/button/expandable/expandable_bar_button.dart';

class OverlayTabBar extends StatefulWidget {
  final List<IconData> icons;
  final int selectedIndex;
  final Function(int) onTap;
  final bool isBottomIndicator;
  
  const OverlayTabBar({
    super.key,
    required this.icons,
    required this.selectedIndex,
    required this.onTap,
    this.isBottomIndicator = false
  });
  
  @override
  State<OverlayTabBar> createState() => OverlayTabBarState();
}

late TabController controller;
class OverlayTabBarState extends State<OverlayTabBar> with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
    controller = TabController(length: widget.icons.length, vsync: this);
  }
  
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
  
  // -------------------------------------------------- //
  @override Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    const double height = 50; final double width = mediaQuery.size.width-height;
    final Color color = theme.colorScheme.primary;
    return SafeArea(
      child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomRight,
          children: [
            Row(
                children: [
                  Container(
                      width: width,
                      height: height,
                      color: theme.colorScheme.surface,
                      child: TabBar(
                        indicatorPadding: EdgeInsets.zero,
                        indicator: BoxDecoration(
                            border: widget.isBottomIndicator 
                              ? Border(
                                  bottom: BorderSide(
                                      color: color,
                                      width: 3.0
                                  )
                                )
                              : Border(
                                  top: BorderSide(
                                      color: color,
                                      width: 3.0
                                  )
                                )
                        ),
                        isScrollable: widget.icons.length > 4, controller: controller,
                        tabs: widget.icons.asMap().map((i, icon) => MapEntry(i, Tab(
                            icon: Icon(icon, color: i == widget.selectedIndex ? color : theme.highlightColor, size: 30.0)
                        ))).values.toList(),
                        onTap: widget.onTap,
                      )
                  ),
                ]
            ),
            const ExpandableBarButton(size: height),
          ]
      ),
    );
  }
}
