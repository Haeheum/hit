import 'package:get/get.dart';

import '../models/post_item.dart';

class HomeController extends GetxController {
  RxList<PostItem> toDoItems = <PostItem>[
    // 더미 데이터
    PostItem(
      title: '제목1',
      manager: '조해흠',
      content: '우측 하단의 + 버튼을 클릭해서 신규 카드 생성이 가능합니다.',
      date: DateTime.now(),
    ),
    PostItem(
      title: '제목2',
      manager: '조해흠',
      content: '카드 클릭 시 수정 및 삭제가 가능합니다.',
      date: DateTime.now(),
    ),
    PostItem(
      title: '제목3',
      manager: '조해흠',
      content: '드래그 시 카드의 최상단 끝 (위쪽 모서리)가 위치한 칸으로 이동됩니다.',
      date: DateTime.now(),
    ),
  ].obs;
  RxList<PostItem> urgentItems = <PostItem>[].obs;
  RxList<PostItem> onProgressItems = <PostItem>[].obs;
  RxList<PostItem> doneItems = <PostItem>[].obs;

  void insertItem({
    required String title,
    required String manager,
    required String content,
    required DateTime date,
  }) {
    final newItem = PostItem(
      title: title,
      content: content,
      manager: manager,
      date: date,
    );
    toDoItems.add(newItem);
  }
}
