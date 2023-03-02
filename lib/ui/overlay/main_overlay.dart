import 'package:flutter/material.dart';
import 'package:frontend/launch/navigator/app_navigator.dart';
import 'package:frontend/launch/routes/app_router.dart';
import 'package:frontend/ui/overlay/overlay_tab_bar.dart';

import '../../io/storage/local_storage.dart';
import '../../model/section/section_data.dart';
import '../widget/drawer/main_drawer.dart';

class MainOverlay extends StatefulWidget {
  final String initialRoute;

  const MainOverlay({
    super.key,
    required this.initialRoute
  });

  @override
  State<MainOverlay> createState() => _MainOverlayState();
}

class _MainOverlayState extends State<MainOverlay> with SingleTickerProviderStateMixin {
  final List<SectionData> sections = AppRouter.sections;
  static const String _lastSelectedKey = 'last-selected';

  int _lastSelectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _setLastSelectedIndex();
  }

  void _setLastSelectedIndex() {
    LocalStorage.readInt(key: _lastSelectedKey).then((value) {
      _lastSelectedIndex = value ?? 0;
      //WidgetsBinding.instance.addPostFrameCallback((_) async {});
      setState(() {
        AppNavigator.of(context).setBarPosition(_lastSelectedIndex);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    List<IconData> icons = sections.map((e) => e.iconData).toList();
    List<Widget> screens_ = sections.map((e) => e.screen).toList();

    String? selectedByRouteSection = ModalRoute.of(context)?.settings.arguments as String?;
    String targetSection = selectedByRouteSection ?? (){
      Iterable<String> routes = sections.map((e) => e.route);
      return (_lastSelectedIndex < routes.length) ? routes.elementAt(_lastSelectedIndex) : routes.elementAt(0);
    }();

    return DefaultTabController(
      length: screens_.length,
      child: SafeArea(
        child: Scaffold(
          endDrawer: const MainDrawer(),
          //resizeToAvoidBottomInset: true,
          body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                const SliverAppBar(
                  title: Text('App'),
                  //automaticallyImplyLeading: false,
                  pinned: true,
                  floating: true,
                  forceElevated: true,
                )
              ];
            },
            body: IndexedStack(
              index: _lastSelectedIndex,
              children: screens_
            ),
          ),
          bottomNavigationBar: OverlayTabBar(
            icons: icons,
            selectedIndex: _lastSelectedIndex,
            onTap: onTap
          ),
          extendBody: true, // bottomNavBar is above body (z-index)
        ),
      ),
    );
  }

  void onTap(int index) =>
      LocalStorage.writeInt(key: _lastSelectedKey, value: index)
          .then((_) => setState(() => _lastSelectedIndex = index));
}
