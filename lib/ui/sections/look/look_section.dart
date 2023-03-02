import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:frontend/ui/overlay/main_overlay_section.dart';

import '../../../model/exhibit/look/look.dart';
import '../../../service/look/look_service.dart';
import '../../../service/services.dart';
import '../../widget/exhibit/look/look_item.dart';
import '../../widget/progress/app_progress_indicator.dart';

LookService _lookService = Services.lookService;
List<Look> _media = [];
bool _isLoading = false;

Future<void> _fetch(void Function()? callback) async {
  if (_isLoading) return;
  _isLoading = true;

  List<Look> result = await _lookService.propose();
  _media.addAll(result);

  if (callback != null) callback();
  _isLoading = false;
}

Future<void> _refresh(void Function()? callback) async {
  _isLoading = false;
  _media.clear();
  await _fetch(callback);
}

class LookSection extends MainOverlaySection {
  const LookSection({
    super.key
  });

  @override
  State<LookSection> createState() => _LookSectionState();
}

class _LookSectionState extends State<LookSection> {
  final TrackingScrollController _scrollController = TrackingScrollController();

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Theme.of(context).colorScheme.secondary,
      onRefresh: () async {
        log('Look screen - refreshing.');
        return _refresh(() {
          log('Look screen - refreshing ended.');
          setState(() {});
        });
      },
      child: CustomScrollView(
        //controller: _scrollController,
        slivers: [
          LookScrollView(scrollController: _scrollController),
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

class LookScrollView extends StatefulWidget {
  final TrackingScrollController scrollController;

  const LookScrollView({
    super.key,
    required this.scrollController
  });

  @override
  State<LookScrollView> createState() => _LookScrollViewState();
}

class _LookScrollViewState extends State<LookScrollView> {
  bool initiated = false;

  @override
  void initState() {
    super.initState();

    if (!initiated) {
      log('Look screen - fetching proposed videos. (1st time)');
      _fetch(() {
        log('Look screen - fetching proposed videos ended. (1st time)');
        setState(() {});
      });
      initiated = true;
    }

    widget.scrollController.addListener(() {
      if (widget.scrollController.position.maxScrollExtent == widget.scrollController.offset) {
        log('Look screen - fetching proposed videos.');
        _fetch(() {
          log('Look screen - fetching proposed videos ended.');
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
            child: LookItem(look: _media[index])
          );
        },
        childCount: _media.length,
      )
    );
  }
}
