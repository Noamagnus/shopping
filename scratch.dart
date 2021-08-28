import 'dart:io';

void main() {
  executeTasks();
}

void executeTasks() async {
  task1();
  String stringFromTask2 = await task2();
  task3(stringFromTask2);
}

void task1() {
  String result = 'Task 1 data';
  print('task1 completed');
}

Future<String> task2() async {
  String result;
  print('$result');
  Duration threeSecond = Duration(seconds: 3);
  await Future.delayed(threeSecond, () {
    result = 'Task2 data';
    print('Task2 completed');
  });
  // sleep(threeSecond);
  return result;
}

void task3(String stringFromTask2) {
  String result = 'Task 3 data';
  print('Task3 completed with $stringFromTask2');
}
