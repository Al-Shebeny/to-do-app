import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:to/models/task.dart';
import '../../controllers/task_controller.dart';
import '../theme.dart';
import '../widgets/button.dart';
import '../widgets/input_field.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  TaskController _taskController = Get.put(TaskController());
  TextEditingController _tittleController = TextEditingController();
  TextEditingController _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _startTime = DateFormat('hh:mm a').format(DateTime.now()).toString();
  String _endTime = DateFormat('hh:mm a')
      .format(DateTime.now().add(const Duration(minutes: 15)))
      .toString();
  int _selectedRemind = 5;
  List<int> remindList = [5, 10, 15, 20];
  String _selectedRepeat = 'None';
  List<String> repeatList = ['None', 'Daliy', 'Weekly', 'Monthly'];
  int _selectedColor = 0;
  bool selectedTimePhaze = false;
  // @override
  // void initState() {
  //   super.initState();
  //   SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
  //     _validateDate();
  //     _appBar();
  //     //getDateFromUser();
  //     _colorPalette();
  //     _addTasksToDb();
  //     //_getTimeFromUser(isStartTime: selectedTimePhaze);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: context.theme.backgroundColor,
        appBar: _appBar(),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  'Add Task',
                  style: headingStyle,
                ),
                InputField(
                  title: 'Title',
                  hint: 'Enter title here',
                  controller: _tittleController,
                ),
                InputField(
                  title: 'Note',
                  hint: 'Enter note here',
                  controller: _noteController,
                ),
                InputField(
                  title: 'Date',
                  hint: DateFormat.yMd().format(_selectedDate),
                  widget: IconButton(
                      onPressed: () => getDateFromUser(),
                      icon: const Icon(
                        Icons.calendar_today_outlined,
                        color: Colors.grey,
                      )),
                ),
                Row(
                  children: [
                    Expanded(
                      child: InputField(
                        title: 'Start Time',
                        hint: _startTime,
                        widget: IconButton(
                            onPressed: () => _getTimeFromUserStart(),
                            icon: const Icon(
                              Icons.access_time_rounded,
                              color: Colors.grey,
                            )),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: InputField(
                        title: 'End Time',
                        hint: _endTime,
                        widget: IconButton(
                            onPressed: () => _getTimeFromUserEnd(),
                            icon: const Icon(
                              Icons.access_time_rounded,
                              color: Colors.grey,
                            )),
                      ),
                    ),
                  ],
                ),
                InputField(
                  title: 'Remind',
                  hint: '$_selectedRemind minutes early',
                  widget: Row(
                    children: [
                      DropdownButton(
                          dropdownColor: Colors.blueGrey,
                          items: remindList
                              .map((value) => DropdownMenuItem(
                                    value: value,
                                    child: Text(
                                      '$value',
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ))
                              .toList(),
                          icon: const Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.grey,
                          ),
                          iconSize: 32,
                          elevation: 4,
                          underline: Container(
                            height: 0,
                          ),
                          style: subTitleStyle,
                          onChanged: (newValue) {
                            setState(() {
                              _selectedRemind = newValue ?? _selectedRemind;
                            });
                          }),
                      const SizedBox(width: 6),
                    ],
                  ),
                ),
                InputField(
                  title: 'Repeat',
                  hint: _selectedRepeat,
                  widget: Row(
                    children: [
                      DropdownButton(
                          dropdownColor: Colors.blueGrey,
                          items: repeatList
                              .map((value) => DropdownMenuItem(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ))
                              .toList(),
                          icon: const Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.grey,
                          ),
                          iconSize: 32,
                          elevation: 4,
                          underline: Container(
                            height: 0,
                          ),
                          style: subTitleStyle,
                          onChanged: (newValue) {
                            setState(() {
                              _selectedRepeat = newValue ?? _selectedRepeat;
                            });
                          }),
                      const SizedBox(width: 6),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _colorPalette(),
                    MyButton(
                        onTabe: () {
                          _validateDate();
                        },
                        label: 'Create Task')
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  AppBar _appBar() => AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 24,
            color: primaryClr,
          ),
        ),
        backgroundColor: context.theme.backgroundColor,
        elevation: 0,
        actions: const [
          CircleAvatar(
            backgroundImage: AssetImage('images/person.jpeg'),
            radius: 18,
          ),
          SizedBox(
            width: 20,
          )
        ],
      );

  _validateDate() {
    if (_tittleController.text.isNotEmpty && _noteController.text.isNotEmpty) {
      _addTasksToDb();
      Get.back();
    } else if (_tittleController.text.isEmpty || _noteController.text.isEmpty) {
      Get.snackbar('required', 'All fields are required',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.white,
          colorText: pinkClr,
          icon: const Icon(
            Icons.warning_amber_outlined,
            color: Colors.red,
          ));
    } else {
      print('########## thomthing bad happined #########');
    }
  }

  _addTasksToDb() async {
    int value = await _taskController.addTask(
        task: Task(
            title: _tittleController.text,
            note: _noteController.text,
            isCompleted: 0,
            date: DateFormat.yMd().format(_selectedDate),
            startTime: _startTime,
            endTime: _endTime,
            color: _selectedColor,
            remind: _selectedRemind,
            repeat: _selectedRepeat));
    print(value);
  }

  Column _colorPalette() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Color',
            style: titleStyle,
          ),
          const SizedBox(height: 8),
          Wrap(
            children: List.generate(
              3,
              (index) => GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedColor = index;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: CircleAvatar(
                    radius: 14,
                    backgroundColor: index == 0
                        ? primaryClr
                        : index == 1
                            ? pinkClr
                            : orangeClr,
                    child: _selectedColor == index
                        ? const Icon(
                            Icons.done,
                            color: Colors.white,
                            size: 16,
                          )
                        : null,
                  ),
                ),
              ),
            ),
          )
        ],
      );

  getDateFromUser() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2015),
      lastDate: DateTime(2040),
    );
    if (pickedDate != null)
      setState(() => _selectedDate = pickedDate);
    else
      print('it is null or something wrong');
  }

  _getTimeFromUserStart() async {
    TimeOfDay? _pickedTime = await showTimePicker(
        context: context, initialTime: TimeOfDay.fromDateTime(DateTime.now()));
    String _formatedTime = _pickedTime!.format(context);
    if (_formatedTime != null)
      setState(() => _startTime = _formatedTime);
    else
      print('it is cansel or something wrong');
  }

  _getTimeFromUserEnd() async {
    TimeOfDay? _pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(
          DateTime.now().add(const Duration(minutes: 15))),
    );
    String _formatedTime = _pickedTime!.format(context);
    if (_formatedTime != null)
      setState(() => _endTime = _formatedTime);
    else
      print('it is cansel or something wrong');
  }
}
