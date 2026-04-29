import 'package:flutter/material.dart';
import 'package:flutter_todo_list_app/config/theme/theme.dart';
import 'package:flutter_todo_list_app/modules/home/controllers/home_controller.dart';
import 'package:flutter_todo_list_app/modules/home/models/home_model.dart';
import 'package:get/get.dart';

class EditView extends StatefulWidget {
  final int index;
  const EditView({super.key, required this.index});

  @override
  State<EditView> createState() => _EditViewState();
}

class _EditViewState extends State<EditView> {
  final controller = Get.find<HomeController>();
  late TextEditingController titleController;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  String selectedPriority = 'Low';
  final List<String> priorityLists = ['Low', 'Medium', 'High'];

  @override
  void initState() {
    super.initState();
    final task = controller.tasks[widget.index];
    titleController = TextEditingController(text: task.title);
    selectedPriority = task.priority ?? 'Low';
  }

  Future<void> pickDate() async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      initialDate: selectedDate,
    );
    if (date != null) {
      //* Check if a date was selected
      setState(() {
        selectedDate = date;
      });
    }
  }

  Future<void> pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (time != null) {
      //* Check if a time was selected
      setState(() {
        selectedTime = time;
      });
    }
  }

  String formatDate(DateTime date) {
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  Color getPriorityColor(String priority) {
    if (priority == 'High') {
      return AppTheme.warningColor;
    }
    if (priority == 'Medium') {
      return AppTheme.primaryColor;
    } else {
      return AppTheme.successColor;
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dateText = formatDate(selectedDate);
    final timeText = selectedTime.format(context);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Edit Task',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 5,
            children: [
              Text(
                'Task Title',
                style: TextStyle(fontSize: 16.5, fontWeight: FontWeight.bold),
              ),
              TextFormField(
                controller: titleController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: 'Enter task title',
                  filled: true,
                  fillColor: controller.isDarkMode.value
                      ? Colors.black.withOpacity(0.5)
                      : Colors.white.withOpacity(0.8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.grey, width: 0.5),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.grey, width: 0.5),
                  ),
                ),
              ),
              SizedBox(height: 15),
              Text(
                'Date',
                style: TextStyle(fontSize: 16.5, fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: pickDate,
                child: Container(
                  width: double.infinity,
                  height: 55,
                  decoration: BoxDecoration(
                    color: controller.isDarkMode.value
                        ? Colors.black.withOpacity(0.5)
                        : Colors.white.withOpacity(0.8),
                    border: Border.all(color: Colors.grey, width: 0.3),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_today_rounded,
                            color: controller.isDarkMode.value
                                ? Colors.white
                                : Colors.grey[600],
                          ),
                          SizedBox(width: 8),
                          Text(dateText, style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15),
              Text(
                'Time',
                style: TextStyle(fontSize: 16.5, fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: pickTime,
                child: Container(
                  width: double.infinity,
                  height: 55,
                  decoration: BoxDecoration(
                    color: controller.isDarkMode.value
                        ? Colors.black.withOpacity(0.5)
                        : Colors.white.withOpacity(0.8),
                    border: Border.all(color: Colors.grey, width: 0.3),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Icon(
                            Icons.schedule_rounded,
                            color: controller.isDarkMode.value
                                ? Colors.white
                                : Colors.grey[600],
                          ),
                          SizedBox(width: 8),
                          Text(timeText, style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15),
              Text(
                'Priority',
                style: TextStyle(fontSize: 16.5, fontWeight: FontWeight.bold),
              ),
              Container(
                width: double.infinity,
                height: 55,
                padding: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: controller.isDarkMode.value
                      ? Colors.black.withOpacity(0.5)
                      : Colors.white.withOpacity(0.8),
                  border: Border.all(color: Colors.grey, width: 0.3),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedPriority,
                    items: priorityLists.map((priority) {
                      return DropdownMenuItem<String>(
                        value: priority,
                        child: Row(
                          children: [
                            Icon(
                              Icons.flag_outlined,
                              size: 25,
                              color: getPriorityColor(priority),
                            ),
                            SizedBox(width: 8),
                            Text(priority, style: TextStyle(fontSize: 16)),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedPriority = value!;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  final oldTask = controller.tasks[widget.index];
                  controller.editTask(
                    widget.index,
                    HomeModel(
                      title: titleController.text,
                      date: dateText,
                      time: timeText,
                      status: oldTask.isDone
                          ? 'Completed'
                          : 'Pending', //* Preserve the status based on isDone
                      priority: selectedPriority,
                      isDone: oldTask.isDone, //* Preserve the isDone status
                    ),
                  );
                  Get.back();
                  Get.back();
                  controller.update();
                  Get.snackbar(
                    'Success',
                    'The task has been successfully edited.',
                    snackPosition: SnackPosition.BOTTOM,
                    margin: EdgeInsets.all(14),
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                ),
                child: Text('Save Edit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
