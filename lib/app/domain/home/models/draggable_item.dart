import 'package:get/get_rx/src/rx_types/rx_types.dart';

import 'post_item.dart';

class DraggableItem {
  final PostItem item;
  final RxList<PostItem> originalList;

  DraggableItem(this.item, this.originalList);
}