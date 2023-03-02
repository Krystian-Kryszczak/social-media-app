import 'package:frontend/io/network/endpoints.dart';
import 'package:frontend/model/exhibit/exhibit.dart';

class Look extends Exhibit {
  final String description;
  final bool hasImages;

  Look({
    super.id,
    required super.name,
    super.creatorId,
    super.creatorName,
    super.creatorSubscriptions,
    required this.description,
    required this.hasImages,
    super.views,
    super.rating,
    required super.private
  });

  @override
  String? getUrl() {
    if (id == null) return null;
    return Endpoints.video + id!;
  }

  static String getLookImageUrlById({required String id}) => Endpoints.images + id;

  factory Look.fromMap(Map<String, dynamic> data) => Look(
    id: data['id'] as String?,
    name: data['name'] as String,
    creatorId: data['creatorId'] as String?,
    creatorName: data['creatorName'] as String?,
    creatorSubscriptions: data['creatorSubscriptions'] as int? ?? 0,
    description: data['description'] as String,
    hasImages: data['hasImages'] as bool? ?? false,
    views: (data['views'] as int?) ?? 0,
    rating: (data['rating'] as int?) ?? 0,
    private: (data['private'] as bool?) ?? false
  );
}
