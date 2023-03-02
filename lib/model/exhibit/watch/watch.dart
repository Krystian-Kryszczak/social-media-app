import 'package:flutter/material.dart';
import 'package:frontend/io/network/endpoints.dart';
import 'package:frontend/io/storage/network_files.dart';
import 'package:frontend/model/exhibit/exhibit.dart';

class Watch extends Exhibit {
  final String description;

  Watch({
    super.id,
    required super.name,
    super.creatorId,
    super.creatorName,
    super.creatorSubscriptions,
    required this.description,
    super.views,
    super.rating,
    required super.private
  });

  Widget getMiniatureImage(BuildContext context) {
    return id != null ? NetworkFiles.getNetworkImage(
      url: Endpoints.images + id!,
      fit: BoxFit.cover,
      fallback: _fallbackMiniature(context)
    ) : _fallbackMiniature(context);
  }

  Widget _fallbackMiniature(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    Color backgroundColor = colorScheme.primary.withOpacity(.1);
    Color color = colorScheme.onPrimary.withOpacity(.1);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(
          width: 2.0,
          color: color
        )
      ),
      child: const Center(
        child: Icon(
          Icons.play_circle_outline,
          size: 72.0,
        ),
      ),
    );
  }

  @override
  String? getUrl() {
    if (id == null) return null;
    return Endpoints.video + id!;
  }

  factory Watch.fromMap(Map<String, dynamic> data) => Watch(
    id: data['id'] as String?,
    name: data['name'] as String,
    creatorId: data['creatorId'] as String?,
    creatorName: data['creatorName'] as String?,
    creatorSubscriptions: data['creatorSubscriptions'] as int? ?? 0,
    description: data['description'] as String,
    views: (data['views'] as int?) ?? 0,
    rating: (data['rating'] as int?) ?? 0,
    private: (data['private'] as bool?) ?? false
  );
}
