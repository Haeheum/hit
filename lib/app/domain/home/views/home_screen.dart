import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/home_controller.dart';
import '../models/post_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          _buildList(
            context,
            title: "To Do",
            items: homeController.toDoItems,
            color: Colors.blue[100],
          ),
          _buildList(
            context,
            title: "Urgent",
            items: homeController.urgentItems,
            color: Colors.red[100],
          ),
          _buildList(
            context,
            title: "On Progress",
            items: homeController.onProgressItems,
            color: Colors.yellow[100],
          ),
          _buildList(
            context,
            title: "Done",
            items: homeController.doneItems,
            color: Colors.green[100],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddItemDialog(context, homeController);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildList(
      BuildContext context, {
        required String title,
        required List<PostItem> items,
        required Color? color,
      }) {
    return Expanded(
      child: Obx(
            () => Container(
          margin: const EdgeInsets.all(8),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: DragTarget<PostItem>(
                  onAcceptWithDetails: (item) {
                    items.add(item);
                    homeController.toDoItems.remove(item);
                    homeController.urgentItems.remove(item);
                    homeController.onProgressItems.remove(item);
                    homeController.doneItems.remove(item);
                  },
                  builder: (context, candidateData, rejectedData) {
                    return ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return LongPressDraggable<PostItem>(
                          data: item,
                          feedback: Material(
                            color: Colors.transparent,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                item.title,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          childWhenDragging: const SizedBox.shrink(),
                          onDragCompleted: () {
                            items.removeAt(index);
                          },
                          child: Card(
                            child: ListTile(
                              title: Text(item.title),
                              subtitle: Text(
                                  '${item.manager} • ${DateFormat.yMd().format(item.date)}'),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddItemDialog(BuildContext context, HomeController controller) {
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
                  controller.insertItem(
                    title: title,
                    manager: manager,
                    content: content,
                    date: selectedDate,
                  );
                  Navigator.pop(context); // Close the dialog
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
