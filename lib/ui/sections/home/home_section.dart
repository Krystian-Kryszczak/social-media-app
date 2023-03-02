import 'package:flutter/material.dart';

import '../../overlay/main_overlay_section.dart';

class HomeScreen extends MainOverlaySection { // News // TODO Saving, Posting, Memories, Ads, Events, Stories, Weather
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: CustomScrollView(
        slivers: [
          //
        ],
      ),
    );
  }
}
