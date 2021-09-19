import 'package:msf/models/items.dart';

class Msf {
  final String category;
  final List<Items> items;

  Msf(this.category, this.items);

  Msf.fromJson({
    required String category,
    required List<Items> items,
  })  : category = category,
        items = items;
}
