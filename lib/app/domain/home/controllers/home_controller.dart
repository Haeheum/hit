import 'package:get/get.dart';

import '../../../../core/utils/constants.dart';
import '../models/post_item.dart';

class HomeController extends GetxController {
  List<PostItem> toDoItems = <PostItem>[].obs;
  List<PostItem> urgentItems = <PostItem>[].obs;
  List<PostItem> onProgressItems = <PostItem>[].obs;
  List<PostItem> doneItems = <PostItem>[].obs;

  void insertItem({
    required String title,
    required String manager,
    required String content,
    required DateTime date,
    int insertAt = kToDo,
  }) {
    final newItem = PostItem(
      title: title,
      content: content,
      manager: manager,
      date: date,
    );
    switch (insertAt) {
      case 0:
        toDoItems.add(newItem);
        break;
      case 1:
        urgentItems.add(newItem);
        break;
      case 2:
        onProgressItems.add(newItem);
        break;
      case 3:
        doneItems.add(newItem);
      default:
        break;
    }
  }
}
