import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../core/utils/constants.dart';
import '../controllers/home_controller.dart';
import '../models/draggable_item.dart';
import '../models/post_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeController homeController = Get.put(HomeController());
  late double _cardWidth;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _cardWidth = (MediaQuery.sizeOf(context).width - 30) / 4;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        spacing: 10,
        children: [
          _buildList(items: homeController.toDoItems, name: 'To Do'),
          _buildList(items: homeController.urgentItems, name: 'Urgent'),
          _buildList(items: homeController.onProgressItems, name: 'On Progress'),
          _buildList(items: homeController.doneItems, name: 'Done'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddItemDialog(context, homeController),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildList({required RxList<PostItem> items, required String name}) {
    return Expanded(
      child: Column(
        children: [
          Text(
            name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: DragTarget<DraggableItem>(
                onAcceptWithDetails: (dragTargetDetails) {
                  dragTargetDetails.data.originalList
                      .remove(dragTargetDetails.data.item);
                  items.insert(
                      min(dragTargetDetails.offset.dy ~/ kCardHeight, items.length),
                      dragTargetDetails.data.item);
                },
                builder: (context, candidateData, rejectedData) {
                  return Obx(() => ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        return _buildDraggableItem(item: items[index], list: items);
                      }));
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDraggableItem({
    required PostItem item,
    required RxList<PostItem> list,
  }) {
    return Draggable<DraggableItem>(
      key: ValueKey(item),
      data: DraggableItem(item, list),
      feedback: _buildFeedback(item),
      childWhenDragging: SizedBox(
        height: kCardHeight,
        width: _cardWidth,
        child: Card(
          color: Colors.grey[200],
          child: const Opacity(opacity: 0),
        ),
      ),
      child: SizedBox(
        height: kCardHeight,
        width: _cardWidth,
        child: Card(
          child: ListTile(
            leading: Text(item.manager),
            title: Text(item.title),
            subtitle: Text(item.content),
            trailing: Text(DateFormat.yMd().format(item.date)),
            onTap: () => _showItemDetailDialog(item: item, list: list),
          ),
        ),
      ),
    );
  }

  Widget _buildFeedback(PostItem item) {
    return SizedBox(
      height: kCardHeight,
      width: _cardWidth,
      child: Card(
        child: ListTile(
          leading: Text(item.manager),
          title: Text(item.title),
          subtitle: Text(item.content),
          trailing: Text(DateFormat.yMd().format(item.date)),
        ),
      ),
    );
  }

  void _showAddItemDialog(BuildContext context, HomeController homeController) {
    final titleController = TextEditingController();
    final managerController = TextEditingController();
    final contentController = TextEditingController();
    DateTime selectedDate = DateTime.now();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Insert Post'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 10,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
              ),
              TextField(
                controller: managerController,
                decoration: const InputDecoration(
                  labelText: 'Manager',
                  border: OutlineInputBorder(),
                ),
              ),
              TextField(
                controller: contentController,
                decoration: const InputDecoration(
                  labelText: 'Content',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(
                height: 300,
                width: 500,
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  onDateTimeChanged: (newDate) {
                    selectedDate = newDate;
                  },
                  initialDateTime: selectedDate,
                  dateOrder: DatePickerDateOrder.ymd,
                ),
              )
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final title = titleController.text.trim();
                final manager = managerController.text.trim();
                final content = contentController.text.trim();

                if (title.isNotEmpty &&
                    manager.isNotEmpty &&
                    content.isNotEmpty) {
                  homeController.insertItem(
                    title: title,
                    manager: manager,
                    content: content,
                    date: selectedDate,
                  );
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _showItemDetailDialog({
    required PostItem item,
    required RxList<PostItem> list,
  }) {
    final titleController = TextEditingController(text: item.title);
    final managerController = TextEditingController(text: item.manager);
    final contentController = TextEditingController(text: item.content);
    DateTime selectedDate = item.date;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 10.0,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
              ),
              TextField(
                controller: managerController,
                decoration: const InputDecoration(
                  labelText: 'Manager',
                  border: OutlineInputBorder(),
                ),
              ),
              TextField(
                controller: contentController,
                decoration: const InputDecoration(
                  labelText: 'Content',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(
                height: 300,
                width: 500,
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  onDateTimeChanged: (newDate) {
                    selectedDate = newDate;
                  },
                  initialDateTime: selectedDate,
                  dateOrder: DatePickerDateOrder.ymd,
                ),
              )
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                list.remove(item);
                Navigator.pop(context);
              },
              child: const Text('Delete'),
            ),
            ElevatedButton(
              onPressed: () {
                final newItem = PostItem(
                  title: titleController.text,
                  manager: managerController.text,
                  content: contentController.text,
                  date: selectedDate,
                );
                final index = list.indexOf(item);
                if (index != -1) {
                  list[index] = newItem;
                }
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
