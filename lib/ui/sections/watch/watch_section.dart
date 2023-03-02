import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:frontend/service/services.dart';
import 'package:frontend/service/watch/watch_service.dart';
import 'package:frontend/ui/overlay/main_overlay_section.dart';
import 'package:frontend/ui/widget/exhibit/watch/watch_item.dart';

import '../../../../model/exhibit/watch/watch.dart';
import '../../widget/progress/app_progress_indicator.dart';

WatchService _watchService = Services.watchService;
List<Watch> _media = [];
bool _isLoading = false;

Future<void> _fetch(void Function()? callback) async {
  if (_isLoading) return;
  _isLoading = true;

  List<Watch> result = await _watchService.propose();
  _media.addAll(result);

  if (callback != null) callback();
  _isLoading = false;
}

Future<void> _refresh(void Function()? callback) async {
  _isLoading = false;
  _media.clear();
  await _fetch(callback);
}

class WatchSection extends MainOverlaySection {
  const WatchSection({
    super.key
  });

  @override
  State<WatchSection> createState() => _WatchSectionState();
}

class _WatchSectionState extends State<WatchSection> {
  final TrackingScrollController _scrollController = TrackingScrollController();

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Theme.of(context).colorScheme.secondary,
      onRefresh: () async {
        log('Watch screen - refreshing.');
        return _refresh(() {
          log('Watch screen - refreshing ended.');
          setState(() {});
        });
      },
      child: CustomScrollView(
        //controller: _scrollController,
        slivers: [
          WatchScrollView(scrollController: _scrollController),
          const SliverPadding(
            padding: EdgeInsets.symmetric(vertical: 32.0),
            sliver: SliverToBoxAdapter(
              child: Center(
                child: AppProgressIndicator()
              ),
            ),
          )
        ],
      ),
    );
  }
}

class WatchScrollView extends StatefulWidget {
  final TrackingScrollController scrollController;

  const WatchScrollView({
    super.key,
    required this.scrollController
  });

  @override
  State<WatchScrollView> createState() => _WatchScrollViewState();
}

class _WatchScrollViewState extends State<WatchScrollView> {
  bool initiated = false;

  @override
  void initState() {
    super.initState();
    
    if (!initiated) {
      log('Watch screen - fetching proposed videos. (1st time)');
      _fetch(() {
        log('Watch screen - fetching proposed videos ended. (1st time)');
        setState(() {});
      });
      initiated = true;
    }
    
    widget.scrollController.addListener(() {
      if (widget.scrollController.position.maxScrollExtent == widget.scrollController.offset) {
        log('Watch screen - fetching proposed videos.');
        _fetch(() {
          log('Watch screen - fetching proposed videos ended.');
          setState(() {});
        });
      }
    });
  }

  @override
  void dispose() {
    widget.scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          if (index > _media.length) return const SizedBox.shrink();
          return Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: WatchItem(watch: _media[index])
          );
        },
        childCount: _media.length,
      )
    );
  }
}
