import '../item.dart';

abstract class Being extends Item {
  final String name;
  Being({super.id, required this.name});
}
